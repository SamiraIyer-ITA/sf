public class OrderItemsSelector extends fflib_SObjectSelector implements IOrderItemsSelector {

    public static IOrderItemsSelector newInstance() {
        return (IOrderItemsSelector) fflibext_Application.Selector.newInstance(OrderItem.SObjectType);
    }

    public List<OrderItem> selectById(Set<Id> idSet) {
        return (List<OrderItem>) selectSObjectsById(idSet);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                OrderItem.Id,
                OrderItem.OrderId,
                OrderItem.Product2Id,
                OrderItem.isPrimary__c,
                OrderItem.Accounting_Code__c,
                OrderItem.QuoteLineItemId,
                OrderItem.TotalPrice,
                OrderItem.UnitPrice
        };
    }

    private Schema.SObjectType getSObjectType() {
        return OrderItem.SObjectType;
    }

}
