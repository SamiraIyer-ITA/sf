/**
 * Created by Mark Keckeis - MIL Corporation on 7/28/2020.
 */

public without sharing class Payment2ConfirmationController {

	private Boolean paymentCanceled = false;  //The user clicked on the Cancel link on pay.gov
	private String acctType;
	private String orderId;
	private String paymentId;
	private String token;
	public String completionMessage {get; private set;}

	public Payment2ConfirmationController() {
		token = System.currentPageReference().getParameters().get('token');
		orderId = System.currentPageReference().getParameters().get('orderId');
		acctType = System.currentPageReference().getParameters().get('acctType');
		paymentId = System.currentPageReference().getParameters().get('paymentId');
		if (String.isNotEmpty(System.currentPageReference().getParameters().get('cancel'))) {
			//The user canceled the transaction at Pay.gov
			this.paymentCanceled = true;
		}
	}

	public void restDoPost(){
		if (this.paymentCanceled) {
			completionMessage = 'The payment was canceled.';
			return;
		}

		if (! hasData()) {
			completionMessage = 'Missing URL parameter.';
			return;
		}

		String response = REST_ConfirmPayment.beginConfirmPayment(acctType, paymentId, token, orderId);
		if (response != null) {
			Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
			if (responseMap != null && ! responseMap.isEmpty()) {
				if (responseMap.get('error') != null) {
					completionMessage = 'Error: ' + responseMap.get('error').toString();
					return;
				}

				if (responseMap.get('paymentConfirmed') != null) {
					if (Boolean.valueOf(responseMap.get('paymentConfirmed').toString())) {
						completionMessage = 'The payment has processed successfully.'; //In the future - use Account type for different completion messages.
						return;
					}
				}
			}
		}
		completionMessage = 'Error: unable to confirm whether the payment was processed.';

	}

	private Boolean hasData() {
		if (String.isBlank(acctType) || String.isBlank(paymentId) || String.isBlank(token)) {
			return false;
		}
		return true;
	}
}
