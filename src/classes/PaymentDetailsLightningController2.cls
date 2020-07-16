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
				if (payments[0].RecordTypeId == rtMap.get('Credit_Card_or_ACH_Payment')) {
					if (payments[0].Payment_Type__c == 'PLASTIC_CARD' || payments[0].Payment_Type__c == 'ACH') {
						String remoteAccountName = Payment2.getRemoteAccountName(payments[0].Account_Type__c);
						String paymentDetailsMetaName = 'PaymentDetailsFor' + payments[0].Payment_Processor__c;
						IPaymentDetails paymentDetails = (IPaymentDetails) di_Injector.Org.getInstance(paymentDetailsMetaName);
						return paymentDetails.getPaymentDetails(payments[0].Name, remoteAccountName, payments[0].Remote_Tracking_Id__c);
					}
				}
			}
			return '';  //return null is not allowed by the lightning component
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

}