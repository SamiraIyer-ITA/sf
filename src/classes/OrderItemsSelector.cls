public class OrderItemsSelector extends fflib_SObjectSelector implements IOrderItemsSelector {

    public static IOrderItemsSelector newInstance() {
        return (IOrderItemsSelector) fflibext_Application.Selector.newInstance(OrderItem.SObjectType);
    }

    public List<OrderItem> selectById(Set<Id> idSet) {
        return (List<OrderItem>) selectSObjectsById(idSet);
    }

    public List<OrderItem> selectRelatedRecords(Set<Id> idSet) {
        fflib_QueryFactory OrderItemQueryFactory = newQueryFactory();
        String condition = '';
        OrderItemQueryFactory.selectFields(new Set<String>{'Id','OrderId', 'Order.Payment2__c', 'TotalPrice'});
        condition += '(Order.Payment2__c IN :idSet)';
        return (List<OrderItem>) Database.query(OrderItemQueryFactory.setCondition(condition).toSOQL());
    }
    // Set<Id> PaymentIds = new Set<Id>();
    //List<OrderItem> oi = new List<OrderItem>();
    //List<OrderItem> oi = OrderItemsSelector.newInstance().selectRelatedRecords(PaymentIds);

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                OrderItem.Id,
                OrderItem.OrderId,
                OrderItem.Product2Id,
                OrderItem.isPrimary__c,
                OrderItem.Accounting_Code__c,
                OrderItem.QuoteLineItemId,
                OrderItem.TotalPrice,
                OrderItem.UnitPrice,
                OrderItem.OrderID
        };
    }

    private Schema.SObjectType getSObjectType() {
        return OrderItem.SObjectType;
    }

}
