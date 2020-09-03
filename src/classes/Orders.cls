/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: Orders.cls
	Purpose: Implementation of IOrders interface that will be used as an FFLIB domain object.
 */
public class Orders extends fflib_SObjectDomain implements IOrders {

	public static IOrders newInstance(List<Order> records){
		return (IOrders) fflibext_Application.Domain.newInstance(records);
	}

	public static IOrders newInstance(Set<Id> recordIds){
		return (IOrders) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Orders(List<Order> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Order> sObjectList) {
			return new Orders(sObjectList);
		}
	}

	private static Id legacyRecordTypeId = Schema.SObjectType.Order
		.getRecordTypeInfosByDeveloperName().get('Legacy').getRecordTypeId();
	/*
     * SM-133: Order: Update Triggers by Record Type
     *
     * Legacy functionality. Triggers that use legacy functionality can pass this list.
     */
	public List<Order> legacyOrders {
		get {
			if (legacyOrders == null) {
				legacyOrders = new List<Order>();
				for (Order order: (List<Order>)Records) {
					if (order.RecordTypeId == legacyRecordTypeId) {
						legacyOrders.add(order);
					}
				}
			}
			return legacyOrders;
		}
		private set;
	}

	public override void onBeforeInsert() {
		updateOrderContactAndOfficer(legacyOrders);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateOrderContactAndOfficer(legacyOrders);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updatePayments(legacyOrders);
	}

	public void updateOrderContactAndOfficer(List<Order> ordersToUpdate) {
		try {
			OrdersService.updateOrderContactAndOfficer(ordersToUpdate);
		} catch (OrdersService.OrdersServiceException e){
			ordersToUpdate.get(0).addError(e.getMessage());
		}
	}

	public void updatePayments(List<Order> newOrders) {
		try {
			OrdersService.updatePayments(newOrders);
		} catch (OrdersService.OrdersServiceException e){
			newOrders.get(0).addError(e.getMessage());
		}
	}

}
