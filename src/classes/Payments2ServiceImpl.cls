/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: Payments2ServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Payment2 object or as a result of the
		Payment2 object being updated. Which implementation is used is determined by custom metadata.
 */
public class Payments2ServiceImpl implements IPayments2Service{

    /**Update SystemSearchString Field with Transaction Amount,Transaction Date,
    *  and Payment Date.
    */
    public static void updateSystemSearchStringList(List<Payment2__c> paymentList){
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

	public static void sendEmailReceipt(Map<Id,Payment2__c> existingRecords, List<Payment2__c> newRecords) {
		for(Payment2__c payment2 : newRecords) {
			if(payment2.Receipt_Ready__c == true && existingRecords.get(payment2.Id).Receipt_Ready__c == false) {
				//receipt ready flag was just checked
				REST_EmailTransactionReceipt.doPost(payment2.Receipt_Sent_To__c, payment2.Id, UserInfo.getUserId());
			}
		}
	}

	public static String beginPayment(Id orderId) {
		REST_BeginPaymentParams params = populateBeginPaymentParams(orderId);
		return REST_BeginPayment.doPost(params);
	}

	private static REST_BeginPaymentParams populateBeginPaymentParams(Id orderId) {
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();
		//params.confirmationPage = getBaseUrl() + '/apex/InternalPayment';
		//params.failurePage = getBaseUrl() + '/apex/InternalPayment';
		params.confirmationPage = 'https://trade--cdf4.lightning.force.com/lightning/n/Payment_Confirmation';
		params.failurePage = 'https://trade--cdf4.lightning.force.com/lightning/n/Payment_Confirmation';
		params.userId = UserInfo.getUserId();
		params.orderId = orderId;
		params.internalCaller = true;
		return params;
	}

	private static String getBaseUrl() {
		return URL.getSalesforceBaseUrl().toExternalForm();
	}

	public static String confirmPayment(String accountType, String paymentId, String token, String orderId) {
		return REST_ConfirmPayment.doPost(accountType, paymentId, token, orderId);
	}
}
