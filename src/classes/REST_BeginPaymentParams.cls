/**
 * Parameters used in REST_BeginPayment and REST_CreatePayment.
 *
 * confirmationPage Required.  The page to which pay.gov returns to in Salesforce if the payment was authorized.
 * failurePage Required.  Canceled or failed payments get redirected back here.
 * orderId Optional.  An Id for an Order.  Either orderId are all are required: accountType, transactionAmount, projectCode, collectionPost, fulfillmentPost.
 * userId Optional. If you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
 * accountType Required if orderId is null.  The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
 * transactionAmount Required if orderId is null.  The payment amount.
 * projectCode Required if orderId is null.  The Project Code to which to attribute a payment.  eg '1GKY231'.
 * collectionPost Required if orderId is null.  The name of the collection office to which to attribute a payment.
 * fulfillmentPost Required if orderId is null.  The name of the fulfillment office to which to attribute a payment.
 * organizationName Required if orderId is null.  The name of the company to which to attribute the payment.
 * accountHolderName Optional.  Defaults the Name field at pay.gov.
 * billingAddress Optional.  Defaults the Address field at pay.gov.
 * billingCity Optional.  Defaults the City field at pay.gov.
 * billingStateCode Optional.  Defaults the State field at pay.gov.
 * billingZip Optional.  Defaults the Zip Code field at pay.gov.
 * billingCountryCode Optional.  Defaults the Country field at pay.gov.
 */

global class REST_BeginPaymentParams {
	global String confirmationPage;
	global String failurePage;
	global String orderId;
	global String userId;
	global String accountType;
	global String transactionAmount;
	global String projectCode;
	global String collectionPost;
	global String fulfillmentPost;
	global String organizationName;
	global String accountHolderName;
	global String billingAddress;
	global String billingCity;
	global String billingStateCode;
	global String billingZip;
	global String billingCountryCode;
	global String taskCode;
	global String objectClass;
	global String organizationCode;
	global String originatingOffice;
	global String receiptEmailAddresses;
	global Boolean receiptAllowed;

}