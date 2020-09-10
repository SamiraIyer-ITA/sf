public without sharing class PaymentReceiptOrderItems {

	public String paymentId {get;set;}

	public String getOrderItems()
	{
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