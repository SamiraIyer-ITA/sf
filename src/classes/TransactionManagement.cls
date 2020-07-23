public without sharing class TransactionManagement {

	static String batchNumber;
	static String currentFiscalYear;
	static Map<Id,Payment2__c> paymentMap;
	static Decimal totalAmt;
	static String dateToday;
	static String body;
	static CBSBatchCount__c currentActiveObj;

	/**
	* Get the transaction (payment/refund) data that will be saved as a file and imported into CBS by NIST.
	*
	* @param paymentIds A String list of Payment Ids.
	*
	* @return A CBSData object containing the file string.
	*/
	@AuraEnabled(cacheable=false)
	public static CBSData getCBSdata(List<String> paymentIds) {

		CBSData objCBSData = new CBSData();  //The return value

		try {
			initializeStaticVariables(paymentIds);

			//Write the first line of the body
			writeBodyHeader();

			Integer i = 1;
			for (Payment2__c paymentRecord : paymentMap.values()) {
				writePaymentBody(paymentRecord, i);
				i += 1;
			}

			if (!paymentMap.isEmpty()) {
				update paymentMap.values();
				update currentActiveObj;
			}

			objCBSData.csvString = body;
			return objCBSData;

		} catch (Exception e) {
			AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
			auraHandledException.setMessage(e.getMessage());
			throw auraHandledException;
		}
	}

	private static void initializeStaticVariables(List<String> paymentIds) {
		currentFiscalYear = Payment2.getCurrentFiscalYear();
		paymentMap = new Map<Id,Payment2__c>();
		totalAmt = populatePaymentMap(paymentIds);
		dateToday = getDtFormat(Datetime.now());

		List<CBSBatchCount__c> listCodes = CBSBatchCount__c.getAll().values();
		currentActiveObj = listCodes[0];  //There should be only 1 metadata record

		checkBatchCountersForReset();
		batchNumber = determineBatchNumber();
	}

	private static void writeBodyHeader() {
		body = 'UCL00~ITACOLL~' + dateToday + '~' + getNumberLeftChar(paymentMap.size(),8) + '~' + getDecimal17Char(totalAmt) + '~N\n';
	}

	private static void writePaymentBody(Payment2__c paymentRecord, Integer i) {

		String paymentType= 'CCARD';  //Default value.  Will be either 'CCARD' or 'ACH';

		if (paymentRecord.Payment_Type__c == 'ACH') {
			paymentType = 'ACH';
		}

		Decimal amt = paymentRecord.Transaction_Amount__c.SetScale(2);
		body += 'UCL01~55~' + batchNumber +'~' + getNumberLeftChar(i,8) + '~~'+ getDecimal16Char(amt) + '~' + dateToday + '~' + paymentType + '~1~' + paymentRecord.Account_Holder_Name__c + '~' + paymentRecord.Organization_Name__c + '~15397~1~PAYGOV~ITA~~~~~~~~~~~~~~' + paymentRecord.Fulfillment_Post_Acronym__c + '~71744~~ITADEP~~~\n';
		body += 'UCL02~55~' + batchNumber +'~' + getNumberLeftChar(i,8) + '~00000001~ITAREV\n';
		// Project_code__c can be up to 12 comma separated strings - Loop through those and create one line for each of the items in that list
		List<String> projectCodesForPayment = paymentRecord.Project_Code__c.split(',');
		for(String aProjectCode : projectCodesForPayment) {
			String fulfillmentCodeTilde = paymentRecord.Fulfillment_Post_Org_Code__c.replace('-', '~'); /// need method for objpay.Fulfillment_Post_Org_Code__c and objpay.Object_Class__c
			String objectClassTilde = paymentRecord.Object_Class__c .replace('-', '~');
			body += 'UCL03~55~' + batchNumber + '~' + getNumberLeftChar(i, 8) + '~00000001~00000001~' + aProjectCode + '~' + paymentRecord.Task_Code__c + '~~' + currentFiscalYear + '~~~~~' + fulfillmentCodeTilde + '~' + objectClassTilde + '~000000~' + getDecimal16Char(amt) + '\n';
		}
	}

	private static String determineBatchNumber() {
		String batchNumber = '';
		if(!paymentMap.values().isEmpty()) {
			Payment2__c firstPayment = paymentMap.values()[0];
			String accountType = getAccountTypeInfo(firstPayment);
			String payment2Type = getPayment2TypeInfo(firstPayment);
			batchNumber = accountType + getYearDigit(currentFiscalYear) + payment2Type;
			batchNumber += incrementAppropriateBatchNumbers(accountType, payment2Type, currentActiveObj);
		}
		return batchNumber;
	}

	private static String getYearDigit(String x) {
		return x.Substring(x.length()-1,x.length());
	}

	private static String getDtFormat(DateTime dt) {
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

	private static String getNumberLeftChar(Integer i,Integer val) {
		return String.valueOf(i).leftPad(val, '0');
	}

	private static String getDecimal16Char(Decimal val) {
		return String.valueOf(val).leftPad(16, '0');
	}
	private static String getDecimal17Char(Decimal val) {
		return String.valueOf(val).leftPad(17, '0');
	}

	public class CBSData {
		@AuraEnabled public String csvString;
	}

	private static Decimal populatePaymentMap(List<String> paymentIds) {
		Set<Id> paymentIdSet = (Set<Id>) JSON.deserialize(JSON.serialize(paymentIds), Set<Id>.class);
		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(paymentIdSet);

		Decimal totalAmt = 0;
		for(Payment2__c payment : payments) {
			payment.Transmitted__c = true;
			paymentMap.put(payment.Id,payment);
			totalAmt += payment.Transaction_Amount__c;
		}

		return totalAmt;
	}

	private static void checkBatchCountersForReset() {
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
	}

	private static String getAccountTypeInfo(Payment2__c firstPayment) {
		//Get account type info & add to batch number
		if(firstPayment.Account_Type__c == 'Privacy Shield') {
			return '9';
		} else if(firstPayment.Account_Type__c == 'Events') {
			return 'V';
		} else {
			return 'S';
		}
	}

	private static String getPayment2TypeInfo(Payment2__c firstPayment) {
		//Get payment type info & add to batch number
		switch on firstPayment.Payment_Type__c {
			when 'PLASTIC_CARD' {
				return 'C';
			}
			when 'ACH' {
				return 'A';
			}
			when 'Credit Card Refund' {
				return 'R';
			}
			when else {
				return 'C';
			}
		}
	}

	private static String incrementAppropriateBatchNumbers(String accountType, String payment2Type, CBSBatchCount__c currentActiveObj) {
		//TRANS#6052
		//Get actual number counter for each type by fiscal year & add to batch number
		String batchNumber = '';
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
		return batchNumber;
	}

}