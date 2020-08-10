@RestResource(urlMapping='/EmailReceipt/*')
global without sharing class REST_EmailTransactionReceipt {

	private static String jsonReturnValue;
	private static EmailResult emailResult = new EmailResult();

	/**
	 * Email a receipt for a payment or refund.
	 *
	 * @param recipientEmails A comma-separated list of email addresses.
	 * @param recordId A Payment2 record Id or an Order record Id.
	 */
	@HttpPost
	global static String doPost(String recipientEmails, String recordId) {

		try {
			String objectName;
			Payment2__c payment;
			if (String.isNotBlank(recordId)) {
				//Determine the object of the recordId
				objectName = Utils.findObjectNameFromRecordIdPrefix(recordId);

				//Get the Payment record
				payment = getPaymentRecord(recordId, objectName);

				//If the receipt shouldn't be sent, don't send it
				if (! receiptCanBeSent(payment)) {
					return getReturnValue('This receipt should not be sent to the client.');
				}

				//If the Receipt is not yet ready, don't send it
				if (! receiptReady(payment)) {
					return getReturnValue('Receipt does not yet have fields necessary to send the receipt.');
				}
			}

			RequiredFields requiredFields = checkRequiredFields(recipientEmails, recordId, objectName, payment);
			if (requiredFields != null) {
				return getReturnValue(requiredFields.errorMessage);
			}

			//Get the list of email addresses
			List<String> emailList = recipientEmails.split(',');

			//Send the payment receipt
			//UserId isn't used on any payment receipt, but is required for sending email
			emailResult = sendEmail(emailList, payment, UserInfo.getUserId(), recipientEmails);
			jsonReturnValue = JSON.serialize(emailResult);
			setResponse(jsonReturnValue);
			return jsonReturnValue;
		} catch (Exception e) {
			return getReturnValue(e.getMessage());
		}
	}

	/**
	 * Set the REST response, if this was called from a REST callout.
	 *
	 * @param responseString The RestContext response.
	 */
	private static void setResponse(String responseString) {
		if (RestContext.response != null) {
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.responseBody = Blob.valueOf(responseString);
		}
	}

	private class RequiredFields {
		Boolean hasRequiredFields = true;
		String errorMessage;
	}

	/**
	 * Check that all required data is available for the receipt.
	 *
	 * @param recipientEmails The comma-delimited string of email addresses that will receive the receipt.
	 * @param recordId A Payment2 record Id or an Order record Id.
	 * @param objectName The name of the object for the passed-in recordId.
	 * @param payment The Payment2__c record for which the receipt is being sent.
	 *
	 * @return The RequiredFields class.
	 */
	private static RequiredFields checkRequiredFields(String recipientEmails, String recordId, String objectName, Payment2__c payment) {

		//Create a list of fields that are required
		Map<String, Object> requiredFieldMap = new Map<String, Object>();  //Map of field name and field value
		requiredFieldMap.put('recipientEmails', recipientEmails);
		requiredFieldMap.put('recordId', recordId);

		//Check that each required field is populated
		RequiredFields requiredFields = checkIndividuallyRequiredFields(requiredFieldMap);
		if (requiredFields != null) {
			//A required field is missing
			return requiredFields;
		}

		//Check that recordId is an Id for a Payment2 or Order object
		if (objectName != 'Payment2__c' && objectName != 'Order') {
			//Throw error.  recordId must be for a Payment2 or Order object
			requiredFields = new RequiredFields();
			requiredFields.hasRequiredFields = false;
			requiredFields.errorMessage = 'Invalid recordId: it must be for a Payment or Order record.';
			return requiredFields;
		}

		//Whether the email addresses are valid will be checked when the email is sent

		return null;
	}

	/**
	 * @param errorMessage The error message to return.
	 *
	 * @return A JSON string value to be returned to the caller.
	 */
	private static String getReturnValue(String errorMessage) {
		emailResult.errorMessage = errorMessage;
		jsonReturnValue = JSON.serialize(emailResult);
		setResponse(jsonReturnValue);
		return jsonReturnValue;
	}

	/**
	 * @param payment A Payment2__c record.
	 *
	 * @return A Boolean of whether the payment receipt has all fields necessary to populate a receipt.
	 */
	private static Boolean receiptReady(Payment2__c payment) {
		//Check that the payment is ready to have its receipt sent
		if (! payment.Receipt_Ready__c) {
			return false;
		}
		return true;
	}

	/**
	 * @param payment A Payment2__c record.
	 *
	 * @return A Boolean of whether the payment receipt has all fields necessary to populate a receipt.
	 */
	private static Boolean receiptCanBeSent(Payment2__c payment) {
		//Check that the receipt should be sent to the client
		if (! payment.Receipt_Allowed__c) {
			return false;
		}
		return true;
	}

	/**
	 * Check that each required field is populated
	 * @param requiredFieldList An Object list of fields that are required.
	 *
	 * @return RequiredFields.
	 */
	private static RequiredFields checkIndividuallyRequiredFields(Map<String, Object> requiredFieldMap) {

		for (String fieldName : requiredFieldMap.keySet()) {
			Object fieldValue = requiredFieldMap.get(fieldName);
			if (String.isBlank(fieldValue.toString())) {
				RequiredFields requiredFields = new RequiredFields();
				requiredFields.hasRequiredFields = false;
				requiredFields.errorMessage = '{"error": "Required field is missing: ' + fieldName + '."}';
				return requiredFields;
			}
		}

		return null;
	}

	/**
	 * Get the Payment record for which the receipt is desired.
	 *
	 * @param recordId A Payment2 record Id or an Order record Id.
	 * @param objectName The name of the object for the passed-in recordId.
	 *
	 * @return A Payment2 record.
	 */
	private static Payment2__c getPaymentRecord(String recordId, String objectName) {
		String paymentId;
		if (objectName == 'Payment2__c') {
			paymentId = recordId;
		} else {
			//objectName == 'Order'
			List<Order> orders = OrdersSelector.newInstance().selectById(new Set<Id>{recordId});
			if (orders.size() > 0) {
				paymentId = orders[0].Payment2__c;
			}
		}

		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id>{paymentId});
		return (payments.isEmpty() ? null : payments[0]);
	}

	/**
	 * Send the email receipt.
	 *
	 * @param emailList String List of email addresses to receive the email receipt.
	 * @param payment The Payment2__c record for which the receipt is being sent.
	 * @param currentUserId The Id of the current User.
	 * @param recipientEmails The comma-delimited string of email addresses that will receive the receipt.
	 *
	 * @return The EmailResult class.
	 */
	private static EmailResult sendEmail(List<String> emailList, Payment2__c payment, String currentUserId, String recipientEmails) {

		EmailResult emailResult = new EmailResult();
		String templateApiName;
		Map<String,Id> paymentRecordTypeMap = Utils.getRecordTypeIdMap('Payment2__c');

		if (payment.RecordTypeId == paymentRecordTypeMap.get('External_Credit_Card_or_ACH_Payment')) {
			templateApiName = 'Transactions_External_Payment_Receipt';
		}
		else if (payment.RecordTypeId == paymentRecordTypeMap.get('Bank_Transfer_Payment')
			|| payment.RecordTypeId == paymentRecordTypeMap.get('Cash_Payment')
			|| payment.RecordTypeId == paymentRecordTypeMap.get('Check_Payment')
			|| payment.RecordTypeId == paymentRecordTypeMap.get('Credit_Card_or_ACH_Payment')) {
			templateApiName = 'Transactions_Payment_Receipt';
		} else {
			//This must be for a refund receipt (Credit_Card_Refund or NIST-Issued_Refund)
			templateApiName = 'Transactions_Refund_Receipt';
		}

		Id orgWideEmailId;
		for(OrgWideEmailAddress owa : [SELECT Id, DisplayName FROM OrgWideEmailAddress]) {
			if (owa.DisplayName == 'ITA Community') {
				orgWideEmailId = owa.Id;
			}
		}

		try {
			EmailUtils.sendTemplatedEmail(emailList, null, templateApiName, currentUserId, true, payment.Id, orgWideEmailId, false, null);
			emailResult.receiptSent = true;

			//Update the Payment Record to show who and when the receipt was sent to
			String errorMessage = updatePaymentRecord(payment, recipientEmails);
			if (String.isNotBlank(errorMessage)) {
				emailResult.errorMessage = 'Receipt was emailed but payment record couldn\'t be updated.  ' + errorMessage;
			}

		} catch (Exception e) {
			emailResult.errorMessage = e.getMessage();
		}

		return emailResult;
	}

	/**
	 * Update the Receipt_Sent_To__c field on the Payment record.
	 *
	 * @param payment The Payment2__c record for which the receipt was sent.
	 * @param recipientEmails The comma-delimited string of email addresses that received the receipt.
	 *
	 * @return Null if successful.  An error message if not.
	 */
	public static String updatePaymentRecord(Payment2__c payment, String recipientEmails) {
		String returnMessage;

		try {
			Datetime currentDatetime = Datetime.now();
			String currentDatetimeString = currentDatetime.format('MM/dd/yyyy h:mm a','America/New_York') + ' EST';

			if (String.isNotBlank(payment.Receipt_Sent_To__c)) {
				payment.Receipt_Sent_To__c += '\n' + recipientEmails + ' at ' + currentDatetimeString;
			} else {
				payment.Receipt_Sent_To__c = recipientEmails + ' at ' + currentDatetimeString;
			}
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType});
			uow.registerDirty(payment);
			uow.commitWork();
		} catch (Exception e) {
			returnMessage = e.getMessage();
		}
		return returnMessage;
	}

	public class EmailResult {
		public Boolean receiptSent = false;  //Whether the receipt was successfully sent
		public String errorMessage = '';  //A message about why the email wasn't sent
	}
}