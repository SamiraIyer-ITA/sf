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

	public override void onBeforeInsert() {
		updateOrderContactAndOfficer(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateOrderContactAndOfficer(Trigger.New);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updatePayments(Trigger.New);
	}

	public void updateOrderContactAndOfficer(List<Order> ordersToUpdate) {
		try {
			OrdersService.updateOrderContactAndOfficer(ordersToUpdate);
		} catch (OrdersService.OrdersServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void updatePayments(List<Order> newOrders) {
		try {
			OrdersService.updatePayments(newOrders);
		} catch (OrdersService.OrdersServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

}
