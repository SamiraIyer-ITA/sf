public interface IOrderItemsSelector {
	List<OrderItem> selectById(Set<Id> idSet);
	List<OrderItem> selectRelatedRecords(Set<Id> idSet);
}