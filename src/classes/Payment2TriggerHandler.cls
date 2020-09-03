public class Payment2TriggerHandler{

	/**Update SystemSearchString Field with Transaction Amount,Transaction Date,
	*  and Payment Date.
	*/
	public static void updateSystemSearchString(List<Payment2__c> paymentList){

		for(Payment2__c payment : paymentList){
			String systemSearchString = '$'+payment.Transaction_Amount__c;
			if (payment.Transaction_Date__c != null) {
				Date transactionDate = Date.newInstance(payment.Transaction_Date__c.year(), payment.Transaction_Date__c.month(), payment.Transaction_Date__c.day());
				systemSearchString += ' | ' + transactionDate.format();
			}
			if (payment.Payment_Date__c != null) {
				systemSearchString += ' | ' + payment.Payment_Date__c.format();
			}
			payment.System_Search_String__c = systemSearchString;
		}
	}
}