public interface IOrdersSelector extends fflib_ISObjectSelector{

	List<Order> selectById(Set<Id> idSet);
	List<Order> selectByPaidNonPaidOnly(Set<Id> idSet, Boolean nonPaidOnly, Boolean paidOnly);
	List<Order> selectByContractId(Set<Id> idSet, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly);
	List<Order> selectWithOrderItemDetails(Set<Id> idSet);
}
