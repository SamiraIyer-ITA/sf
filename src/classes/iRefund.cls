public interface iRefund {

	Payment2__c issueRefund(Payment2__c payment, List<Order> reductionOrders, Decimal refundAmount);

}