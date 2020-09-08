public interface iRefund {

	Payment2__c issueRefund(Payment2__c payment, List<Order> orders, Decimal refundAmount, Map<Id, Decimal> orderRefundMap);

}
