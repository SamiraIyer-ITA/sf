public class OrdersSelector extends fflib_SObjectSelector implements IOrdersSelector {

	public static IOrdersSelector newInstance(){
		return (IOrdersSelector) fflibext_Application.Selector.newInstance(Order.SObjectType);
	}

	public List<Order> selectById(Set<Id> idSet) {
		return (List<Order>) selectSObjectsById(idSet);
	}

	public List<Order> selectWithReductionOrderDetails(Set<Id> idSet, Boolean normalOrders, Boolean reductionOrders, Boolean nonPaidOnly, Boolean paidOnly) {
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'OriginalOrder.Payment2__r.Payment_Type__c',
			'OriginalOrder.Payment2__r.Transaction_Status__c'});
		new OrdersSelector().configureQueryFactoryFields(ordersQueryFactory, 'OriginalOrder');
		String condition = 'Id IN :idSet ';
		if (reductionOrders && !normalOrders) {
			condition += 'AND IsReductionOrder = true';
		} else if (normalOrders && !reductionOrders) {
			condition += 'AND IsReductionOrder = false';
		}
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = false';
		}
		if (paidOnly) {
			condition += ' AND Order_Paid__c = true';
		}
		System.debug(ordersQueryFactory.setCondition(condition).toSOQL());
		return (List<Order>) Database.query(ordersQueryFactory.setCondition(condition).toSOQL());
	}

	public List<Order> selectReductionOrdersByContractId(Set<Id> idSet, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly) {
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		ordersQueryFactory.selectFields(new Set<String>{'OriginalOrder.Payment2__r.Payment_Type__c',
		'OriginalOrder.Payment2__r.Transaction_Status__c'});
		new OrdersSelector().configureQueryFactoryFields(ordersQueryFactory, 'OriginalOrder');
		String condition = 'ContractId IN :idSet AND IsReductionOrder = true AND OriginalOrder.Order_Paid__c = true';
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = false';
		}
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = true';
		}
		if (onlyCreditCardPayments) {
			condition += ' AND OriginalOrder.Payment2__r.Payment_Type__c = \'PLASTIC_CARD\'';
		}
		return (List<Order>) Database.query(ordersQueryFactory.setCondition(condition).toSOQL());
	}

	public List<Order> selectByContractId(Set<Id> contractIds, Boolean normalOrders, Boolean reductionOrders, Boolean nonPaidOnly, Boolean paidOnly) {
		fflib_QueryFactory ordersQueryFactory = newQueryFactory();
		new ContractsSelector().
			configureQueryFactoryFields(ordersQueryFactory, 'Contract');
		String condition = 'ContractId IN :contractIds ';
		if (reductionOrders && !normalOrders) {
			condition += 'AND IsReductionOrder = true';
		} else if (normalOrders && !reductionOrders) {
			condition += 'AND IsReductionOrder = false';
		}
		if (nonPaidOnly) {
			condition += ' AND Order_Paid__c = false';
		}
		if (paidOnly) {
			condition += ' AND Order_Paid__c = true';
		}
		return (List<Order>) Database.query(
			ordersQueryFactory.setCondition(condition).toSOQL());
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
			Order.IsReductionOrder,
			Order.OriginalOrderId,
			Order.Payment2__c,
			Order.Order_Paid__c,
			Order.Refunded_Amount__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Order.SObjectType;
	}
}