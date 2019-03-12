public without sharing class PaymentController {

	@TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
	@TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
	@TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
	@TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
	public String oppIdParam {get; set;}
	public String amount {get; set;}
	public String agencyTrackingId {get;set;}
	public boolean paymentCancelled {get;set;}  //The user clicked on the Cancel link on pay.gov
	public boolean paymentError {get;set;}      //The user attempted payment but it was declined
	public Id paymentId {get;set;}

	public PaymentController() {
		//Note that agencyTrackingId will only be populated when returning to this page FROM cancelling payment at pay.gov
		this.agencyTrackingId = System.currentPageReference().getParameters().get('id');
		if (String.isNotEmpty(System.currentPageReference().getParameters().get('cancel'))) {
			this.paymentCancelled  = true;
		}
		if (String.isNotEmpty(System.currentPageReference().getParameters().get('error'))) {
			this.paymentError  = true;
		}
		if(ApexPages.currentPage().getParameters().get('opp') != null){
			oppIdParam = ApexPages.currentPage().getParameters().get('opp');
			List<Order> orderList = [SELECT id, TotalAmount FROM order WHERE id = :oppIdParam LIMIT 1];
			if(!orderList.isEmpty()) {
				Amount = String.ValueOf(orderList[0].TotalAmount);
			}
		}
	}

	public PageReference privacyShieldPayment() {
		if (agencyTrackingId != null && ! agencyTrackingId.trim().equals('')) {
				return payment(PRIVACY_SHIELD_APP_ID, PRIVACY_SHIELD_APP);
		} else {
				//ERROR -- Agency Tracking Id must be populated first
				return null;
		}
	}

	public PageReference eventServicePayment() {
		if (agencyTrackingId != null && ! agencyTrackingId.trim().equals('')) {
				return payment(EVENTS_SERVICES_APP_ID, EVENTS_SERVICES_APP);
		} else {
				//ERROR -- Agency Tracking Id must be populated first
				return null;
		}
	}

	@TestVisible private String getBaseUrl() {
		return 'https://' + ApexPages.currentPage().getHeaders().get('Host');
	}

	public PageReference getAgencyTrackingId() {
		if (String.isNotEmpty(this.agencyTrackingId)) {
			//A tracking id was already created.  Use that one.  Do nothing here.
			return null;
		} else {
			//Get a tracking id
			Payment payment = new Payment();
			String opp = ApexPages.currentPage().getParameters().get('opp');
			//if(ApexPages.currentPage().getParameters().get('opp') != null){
			if (opp != null && opp != 'null') {
				payment.PaymentValueObject pvo = payment.getAgencyTrackingId(ApexPages.currentPage().getParameters().get('opp'));
				agencyTrackingId = pvo.agencyTrackingId;
				paymentId = pvo.paymentId;
			}else{
				payment.PaymentValueObject pvo = payment.getAgencyTrackingId();
				agencyTrackingId = pvo.agencyTrackingId;
				paymentId = pvo.paymentId;
			}
			return null;
		}
	}

	@TestVisible private PageReference payment(String tcs_app_id, String application) {
		Payment payment = new Payment();
		String transaction_type = 'Sale';
		//this.Amount = getOrderAmount();
		String url_success = getBaseUrl() + '/apex/PaymentConfirmation?id=' + agencyTrackingId + '&app=' + application + '&opp=' +oppIdParam;
		System.debug('url_success = ' + url_success);
		String url_cancel = getBaseUrl() + '/apex/Payment?id=' + agencyTrackingId + '&opp=' +oppIdParam + '&app=' + application + '&cancel=true';
		System.debug('Amount = ' + amount);
		System.debug('Agency Tracking Id = ' + agencyTrackingId);
		String token = payment.getToken(paymentId, agencyTrackingId, tcs_app_id, transaction_type, amount, url_success, url_cancel );
		System.debug('Pay.gov token = ' + token);

		//Redirect to Pay.gov
		PageReference pageRef = payment.redirectToPayGov(paymentId, token, tcs_app_id);
		pageRef.setRedirect(true);
		return pageRef;
	}

}