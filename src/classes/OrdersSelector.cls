public class OrdersSelector extends fflib_SObjectSelector implements IOrdersSelector {

	public static IOrdersSelector newInstance(){
		return (IOrdersSelector) fflibext_Application.Selector.newInstance(Order.SObjectType);
	}

	public List<Order> selectById(Set<Id> idSet) {
		return (List<Order>) selectSObjectsById(idSet);
	}

	public List<Order> selectByPaidNonPaidOnly(Set<Id> idSet, Boolean nonPaidOnly, Boolean paidOnly) {
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'Payment2__r.Payment_Type__c',
			'Payment2__r.Transaction_Status__c', 'Payment2__r.Name',
			'Payment2__r.Remote_Tracking_Id__c' });
		String condition = 'Id IN :idSet ';
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = false AND Payment2__c = null';
		}
		if (paidOnly) {
			condition += ' AND Order_Paid__c = true';
		}
		System.debug(ordersQueryFactory.setCondition(condition).toSOQL());
		return (List<Order>) Database.query(ordersQueryFactory.setCondition(condition).toSOQL());
	}

	public List<Order> selectByContractId(Set<Id> idSet, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly) {
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'Payment2__r.Payment_Type__c',
		'Payment2__r.Transaction_Status__c', 'Payment2__r.Name', 'Payment2__r.Remote_Tracking_Id__c',
		'Contract.Name', 'Contract.ContractNumber' });
		String condition = 'ContractId IN :idSet  AND TotalAmount > 0';
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = false AND Payment2__c = null';
		}
		if (paidOnly) {
			condition += ' AND Order_Paid__c = true';
		}
		if (onlyCreditCardPayments) {
			condition += ' AND Payment2__r.Payment_Type__c = \'PLASTIC_CARD\'';
		}
		return (List<Order>) Database.query(ordersQueryFactory.setCondition(condition).toSOQL());
	}

	public List<Order> selectWithOrderItemDetails(Set<Id> idSet, Boolean primaryItemOnly) {
		if (idSet.isEmpty()) return new List<Order>();  //Avoid unnecessary SOQL
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'Opportunity.Account.Name',
			'Opportunity.Owner.Name', 'Opportunity.CreatedDate', 'Opportunity.Collection_Post__r.Name',
			'Opportunity.Collection_Post__r.Org_Code__c', 'Opportunity.Fulfillment_Post__r.Name',
			'Opportunity.Fulfillment_Post__r.Org_Code__c', 'Opportunity.Collection_Post__r.Acronym__c', 'Opportunity.Fulfillment_Post__r.Acronym__c'});
		ordersQueryFactory.setCondition('Id IN :idSet');
		fflib_QueryFactory orderItemsQueryFactory = ordersQueryFactory.subselectQuery('OrderItems');
		if (primaryItemOnly) {
			orderItemsQueryFactory.setCondition('IsPrimary__c = true');
		}
		orderItemsQueryFactory.selectFields(new OrderItemsSelector().getSObjectFieldList());
		return Database.query(ordersQueryFactory.toSOQL());
	}

	public List<Order> selectByPaymentId(Set<Id> idSet) {
		if (idSet.isEmpty()) return new List<Order>();  //Avoid unnecessary SOQL
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'Account.Name'});
		ordersQueryFactory.setCondition('Payment2__c IN :idSet');
		fflib_QueryFactory orderItemsQueryFactory = ordersQueryFactory.subselectQuery('OrderItems');
		orderItemsQueryFactory.selectFields(new OrderItemsSelector().getSObjectFieldList());
		return Database.query(ordersQueryFactory.toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		//add more fields as appropriate
		return new List<Schema.SObjectField>{
			Order.Id,
			Order.Name,
			Order.TotalAmount,
			Order.Type,
			Order.Status,
			Order.ContractId,
			Order.Payment2__c,
			Order.Order_Paid__c,
			Order.Refunded_Amount__c,
			Order.OrderNumber,
			Order.AccountId
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Order.SObjectType;
	}
}
