/**
 * Created by Mark Keckeis - MIL Corporation on 7/28/2020.
 */

public without sharing class Payment2ConfirmationController {

	@TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
	@TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
	@TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
	@TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;

	public boolean paymentCancelled {get;set;}  //The user clicked on the Cancel link on pay.gov
	public boolean paymentError {get;set;}      //The user attempted payment but it was declined
	public String acctType {get;set;}
	public String orderId {get;set;}
	public String paymentId {get;set;}
	public String token {get;set;}
	public String response {get;set;}
	public String completionMessage {get; set;}

	public Payment2ConfirmationController() {
		//Note that agencyTrackingId will only be populated when returning to this page FROM cancelling payment at pay.gov
		token = System.currentPageReference().getParameters().get('token');
		orderId = System.currentPageReference().getParameters().get('orderId');
		acctType = System.currentPageReference().getParameters().get('acctType');
		paymentId = System.currentPageReference().getParameters().get('paymentId');
		paymentCancelled = false;
		paymentError = false;
		if (String.isNotEmpty(System.currentPageReference().getParameters().get('cancel'))) {
			// The user cancelled the transation and Paygov returned cancel indicating the action
			this.paymentCancelled  = true;
		}
		/*
		if (String.isNotEmpty(System.currentPageReference().getParameters().get('error'))) {
			//There was a problem with the payment at Paygov. The user might have cancelled OR
			// the card may have been declined.
			this.paymentError  = true;
		}
		 */
	}
	public void restDoPost(){
		Map<String, Object> responseMap = new Map<String, Object>();
		if(!this.paymentCancelled) {
			response = REST_ConfirmPayment.doPost(acctType, paymentId, token, orderId);
			responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		}

		if(paymentCancelled){
			completionMessage = 'The payment was canceled by the user before submitting to Paygov.';
		} else if(!Boolean.valueOf(responseMap.get('paymentConfirmed'))){
			completionMessage = String.valueOf(responseMap.get('errorMessage'));
		} else{
			completionMessage = 'The payment has been successfully processed.'; //In the future - use Account type for different completion messages.
		}
	}
}