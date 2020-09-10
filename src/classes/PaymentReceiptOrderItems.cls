public without sharing class PaymentReceiptOrderItems {

	public String paymentId {get;set;}

	public String getOrderItems()
	{
		//Determine if this is for a Refund.
		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id>{paymentId});
		if (payments!= null && payments.size() > 0) {
			Payment2__c payment = payments[0];
			if (payment.Payment_Type__c == 'NIST-Handled Refund' || payment.Payment_Type__c == 'Credit Card Refund') {
				//This is a refund record.  Get the parent payment Id and use it to get order item details.
				paymentId = payment.Payment_2__c;
			}
		}

		String returnString = '';
		List<Order> orders = OrdersSelector.newInstance().selectByPaymentId(new Set<Id>{paymentId});

		if (orders.size() > 0 && orders[0].OrderItems != null) {

			returnString += '<ul>';
			Set<Id> productIds = new Set<Id>();
			for (OrderItem orderItem : orders[0].OrderItems) {
				productIds.add(orderItem.Product2Id);
			}

			for (Product2 product : ProductsSelector.newInstance().selectById(productIds)) {
				returnString += '<li>' + product.Name + '</li>';
			}
			returnString += '</ul>';
		}

		return returnString;
	}

}
