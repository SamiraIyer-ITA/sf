public with sharing class PaymentDetailsLightningController2 {

	@AuraEnabled(cacheable=true)
	public static String getPaymentDetails(Id paymentId) {
		try {
			PaymentDetailsLightningController2 PaymentDetailsLightningController2 = new PaymentDetailsLightningController2();
			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id>{
				paymentId
			});

			//Get the Record Type Id for Credit Card or ACH Payment
			Map<String, Id> rtMap = Utils.getRecordTypeIdMap('Payment2__c');
			if (payments.size() > 0) {
				Payment2__c payment = payments[0];

				if (payment.RecordTypeId == rtMap.get('Credit_Card_or_ACH_Payment') ||
					payment.RecordTypeId == rtMap.get('External_Credit_Card_or_ACH_Payment')) {
					if (payment.Payment_Type__c == 'PLASTIC_CARD' || payment.Payment_Type__c == 'ACH') {
						String remoteAccountName = Payment2Utils.getRemoteAccountName(payment.Account_Type__c);
						String paymentDetailsMetaName = 'PaymentDetailsFor' + payment.Payment_Processor__c;
						IPaymentDetails paymentDetails = (IPaymentDetails) di_Injector.Org.getInstance(paymentDetailsMetaName);
						return paymentDetails.getPaymentDetails(payment.Name, remoteAccountName, payment.Remote_Tracking_Id__c);
					}
				}
			}
			return '';  //return null is not allowed by the lightning component
		} catch (Exception e) {
			AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
			auraHandledException.setMessage(e.getMessage());
			throw auraHandledException;
		}
	}

}
