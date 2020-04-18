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
			Set<String> paymentIdsSet = new Set<String>();

			for(string payId : paymentIds){
				paymentIdsSet.add(payId);
			}

			Decimal totalAmt = 0;
			Map<Id,Payment2__c> paymentMap = new Map<Id,Payment2__c>();
			Map<Id,List<Order>> paymentOrderMap = new Map<Id,List<Order>>();

			for(Payment2__c pay : [SELECT Id, Transaction_Amount__c, Payment_Type__c, Account_Holder_Name__c
				FROM Payment2__c WHERE Id IN : paymentIdsSet]) {
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
			String datetoday = getDtFormat(Datetime.now()); //Need to change date format

			List<CBSBatchCount__c> listCodes = CBSBatchCount__c.getAll().values();
			CBSBatchCount__c currentActiveObj = new CBSBatchCount__c();

			for(CBSBatchCount__c obj:listCodes){
				currentActiveObj=obj;
			}

			currentActiveObj.BatchFileCount__c += 1;
			objCBSData.batchNumber = Integer.valueOf(currentActiveObj.BatchFileCount__c);
			String currentFY =  Payment2.getCurrentFiscalYear() + getNumberLeftChar(Integer.valueOf(currentActiveObj.BatchFileCount__c),4);
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

				Decimal amt = objpay.Transaction_Amount__c.SetScale(2);
				body += 'UCL01~55~' + currentFY+'~' + getNumberLeftChar(i,8) + '~~'+getDecimal17Char(amt) + '~' + datetoday + '~' + paymentType + '~1~' + objpay.Account_Holder_Name__c + '~' + businessName + '~15397~1~MELLON~ITA~~~~~~~~~~~~~~XXXXXX~71744~~~\n';
				body += 'UCL02~55~' + currentFY+'~' + getNumberLeftChar(i,8) + '~00000001~ITAREV\n';
				body += 'UCL03~55~' + currentFY+'~' + getNumberLeftChar(i,8) + '~00000001~00000001~1BFS231~000~~~~~~~50~07~0003~04~00~00~00~05~20~00~00~000000~' + getDecimal17Char(amt) + '\n';

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
		@AuraEnabled public Integer batchNumber;
	}

}