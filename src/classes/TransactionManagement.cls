public without sharing class TransactionManagement {

	/**
	* Get the transaction (payment/refund) data that will be saved as a file and imported into CBS by NIST.
	*
	* @param paymentIds An array of Payment.Ids.
	*
	* @return A CBSData object containing the batch number and String for the file.
	*/
	@AuraEnabled(cacheable=false)
	public static CBSData getCBSdata(String[] paymentIds) {

		CBSData objCBSData = new CBSData();

		try {
			Decimal totalAmt = 0;
			Map<Id,Payment2__c> paymentMap = new Map<Id,Payment2__c>();
			Map<Id,List<Order>> paymentOrderMap = new Map<Id,List<Order>>();

			for(Payment2__c pay : [SELECT Id, Transaction_Amount__c, Account_Type__c, Payment_Type__c, Account_Holder_Name__c, Fulfillment_Post_Org_Code__c,
					Project_Code__c
			FROM Payment2__c WHERE Id IN : paymentIds]) {
				pay.Transmitted__c = true;
				paymentMap.put(pay.id,pay);
				totalAmt += pay.Transaction_Amount__c;
			}
			for(Order ord: [SELECT Id, Payment2__c, AccountId, Account.Name, OpportunityId, Opportunity.AccountId,
					Opportunity.Account.Name FROM Order WHERE Payment2__c IN: paymentMap.keySet()]) {
				if(paymentOrderMap.containsKey(ord.Payment2__c)){
					List<Order> ordList = new List<Order>();
					ordList = paymentOrderMap.get(ord.Payment2__c);
					ordList.add(ord);
					paymentOrderMap.put(ord.Payment2__c,ordList);
				} else {
					List<Order> ordList = new List<Order>();
					ordList.add(ord);
					paymentOrderMap.put(ord.Payment2__c,ordList);
				}
			}

			String body = '';
			String datetoday = getDtFormat(Datetime.now());

			List<CBSBatchCount__c> listCodes = CBSBatchCount__c.getAll().values();
			CBSBatchCount__c currentActiveObj = new CBSBatchCount__c();

			for(CBSBatchCount__c obj:listCodes){
				currentActiveObj=obj;
			}

			//TRANS#6052 - JJW
			//Reset fiscal year & batch counters if last recorded fiscal year is different from current
			String currentFiscalYear = Payment2.getCurrentFiscalYear();
			if(currentActiveObj.LastRecordedFiscalYear__c != currentFiscalYear) {
				currentActiveObj.EventsACHBatchCount__c = 0;
				currentActiveObj.EventsCreditBatchCount__c = 0;
				currentActiveObj.EventsRefundBatchCount__c = 0;
				currentActiveObj.PrivacyShieldACHBatchCount__c = 0;
				currentActiveObj.PrivacyShieldCreditBatchCount__c = 0;
				currentActiveObj.PrivacyShieldRefundBatchCount__c = 0;
				currentActiveObj.ServicesACHBatchCount__c = 0;
				currentActiveObj.ServicesCreditBatchCount__c = 0;
				currentActiveObj.ServicesRefundBatchCount__c = 0;
				currentActiveObj.LastRecordedFiscalYear__c = currentFiscalYear;
			}
			String batchNumber = '';
			if(!paymentMap.values().isEmpty()) {
				String accountType = '';
				String payment2Type = '';
				Payment2__c firstPayment = paymentMap.values()[0];
				//Get account type info & year & add to batch number
				if(firstPayment.Account_Type__c == 'Privacy Shield') {
					accountType = '9';
				} else if(firstPayment.Account_Type__c == 'Events') {
					accountType = 'V';
				} else {
					accountType = 'S';
				}
				batchNumber = accountType + getYearDigit(currentFiscalYear);
				//Get payment type info & add to batch number
				switch on firstPayment.Payment_Type__c {
					when 'PLASTIC_CARD' {
						payment2Type = 'C';
					}
					when 'ACH' {
						payment2Type = 'A';
					}
					when 'Credit Card Refund' {
						payment2Type = 'R';
					}
				}

				batchNumber += payment2Type;
				//Get actual number counter for each type by fiscal year & add to batch number
				if(accountType == 'V') {
					//Events
					if(payment2Type == 'A') {
						currentActiveObj.EventsACHBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.EventsACHBatchCount__c, 3);
					} else if(payment2Type == 'C') {
						currentActiveObj.EventsCreditBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.EventsCreditBatchCount__c, 3);
					} else if(payment2Type == 'R') {
						currentActiveObj.EventsRefundBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.EventsRefundBatchCount__c, 3);
					}
				} else if(accountType == '9') {
					//Privacy Shield
					if(payment2Type == 'A') {
						currentActiveObj.PrivacyShieldACHBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.PrivacyShieldACHBatchCount__c, 3);
					} else if(payment2Type == 'C') {
						currentActiveObj.PrivacyShieldCreditBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.PrivacyShieldCreditBatchCount__c, 3);
					} else if(payment2Type == 'R') {
						currentActiveObj.PrivacyShieldRefundBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.PrivacyShieldRefundBatchCount__c, 3);
					}
				} else if(accountType == 'S') {
					//Services
					if(payment2Type == 'A') {
						currentActiveObj.ServicesACHBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.ServicesACHBatchCount__c, 3);
					} else if(payment2Type == 'C') {
						currentActiveObj.ServicesCreditBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.ServicesCreditBatchCount__c, 3);
					} else if(payment2Type == 'R') {
						currentActiveObj.ServicesRefundBatchCount__c += 1;
						batchNumber += getNumberLeftChar((Integer)currentActiveObj.ServicesRefundBatchCount__c, 3);
					}
				}
			}
			//END TRANS#6052

			body += 'UCL00,ITACOLL,' +datetoday + ',' + getNumberLeftChar(paymentMap.size(),8) + ',' + getDecimal17Char(totalAmt) + ',N\n';
			Integer i = 1;
			for (Payment2__c objpay : paymentMap.values()) {
				String businessName='';
				if (paymentOrderMap.containsKey(objpay.Id)) {
					for (Order ordObj: paymentOrderMap.get(objpay.Id)) {
						if (ordObj.AccountId != null && ordObj.Account.Name != null && businessName == '') {
							businessName = ordObj.Account.Name;
							break;
						}
					}
				}

				String paymentType= 'CCARD';  //Default value.  Will be either CCARD or ACH/

				if (objpay.Payment_Type__c == 'ACH') {
					paymentType = 'ACH';
				}
				// Get the list of orders associated with this Payment2
				List<Order> ordersForPayment = new List<Order>();
				ordersForPayment = paymentOrderMap.get(objPay.Id);
				Decimal amt = objpay.Transaction_Amount__c.SetScale(2);
				body += 'UCL01~55~' + batchNumber +'~' + getNumberLeftChar(i,8) + '~~'+getDecimal17Char(amt) + '~' + datetoday + '~' + paymentType + '~1~' + objpay.Account_Holder_Name__c + '~' + businessName + '~15397~1~MELLON~ITA~~~~~~~~~~~~~~XXXXXX~71744~~~\n';
				body += 'UCL02~55~' + batchNumber +'~' + getNumberLeftChar(i,8) + '~00000001~ITAREV\n';
				// Project_code__c can be up to 12 comma separated strings - Loop through those and create one line for each of the items in that list
				List<String> projectCodesForPayment = objpay.Project_Code__c.split(',');
				system.debug('***' + projectCodesForPayment.size());
				for(string  aProjectCode : projectCodesForPayment) {
					// MGK Cary to confirm the format of UCL03
					body += 'UCL03~55~' + batchNumber + '~' + getNumberLeftChar(i, 8) + '~00000001~00000001~' + aProjectCode + '~000~~~~~~~' + objpay.Fulfillment_Post_Org_Code__c + '~05~20~00~00~000000~' + getDecimal17Char(amt) + '\n';
				}
				i = i+1;
			}

			if (!paymentMap.isEmpty()) {
				update paymentMap.values();
				update currentActiveObj;
			}

			objCBSData.csvString = body;
			return objCBSData;

		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	public static String getYearDigit(String x) {
		return x.Substring(x.length()-1,x.length());
	}

	public static String getDtFormat(DateTime dt) {
		Map<Integer,String> monthMap = new Map<Integer,String>();
		monthMap.put(1,'JAN');
		monthMap.put(2,'FEB');
		monthMap.put(3,'MAR');
		monthMap.put(4,'APR');
		monthMap.put(5,'MAY');
		monthMap.put(6,'JUN');
		monthMap.put(7,'JUL');
		monthMap.put(8,'AUG');
		monthMap.put(9,'SEP');
		monthMap.put(10,'OCT');
		monthMap.put(11,'NOV');
		monthMap.put(12,'DEC');
		String dd = String.valueOf(dt.day()).leftPad(2, '0');
		return dd + '-' + monthMap.get(dt.month()) + '-' + dt.year();
	}

	public static String getNumberLeftChar(Integer i,Integer val) {
		return String.valueOf(i).leftPad(val, '0');
	}

	public static String getDecimal17Char(Decimal val) {
		return String.valueOf(val).leftPad(17, '0');
	}

	public class CBSData {
		@AuraEnabled public String csvString;
	}

}
