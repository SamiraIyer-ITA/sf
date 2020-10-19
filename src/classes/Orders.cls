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

	public List<Order> nonLegacyOrders {
		get {
			if (nonLegacyOrders == null) {
				nonLegacyOrders = new List<Order>();
				for (Order order: (List<Order>)Records) {
					if (order.RecordTypeId != legacyRecordTypeId) {
						nonLegacyOrders.add(order);
					}
				}
			}
			return nonLegacyOrders;
		}
		private set;
	}

	public override void onBeforeInsert() {
		updateOrderContactAndOfficer(legacyOrders);
		updateSystemSearchString(nonLegacyOrders);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateOrderContactAndOfficer(legacyOrders);
		updateSystemSearchString(nonLegacyOrders);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updatePayments(legacyOrders);
		emailsForNewPayments(existingRecords);
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

	public void updateSystemSearchString(List<Order> ordersToUpdate){
		Set<Id> accountIds = new Set<Id>();
		for(Order obj : ordersToUpdate){
			accountIds.add(obj.AccountId);
		}

		Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,Name FROM Account WHERE Id IN :accountIds]);
		for(Order obj : ordersToUpdate){
			String accountName = '';
			if(accMap.containsKey(obj.AccountId)){
				accountName = accMap.get(obj.AccountId).Name;
			}
			obj.System_Search_String__c = ''+ accountName+' | $'+obj.TotalAmount+' | $'+obj.Refunded_Amount__c;
		}
	}

	public void emailsForNewPayments(Map<Id, SObject> existingRecords) {
		Set<Id> paymentIds = new Set<Id>();
		for (Order nlOrder : nonLegacyOrders) {
			Order oldMapOrder = (Order) existingRecords.get(nlOrder.Id);
			if (nlOrder.Payment2__c != null && oldMapOrder.Payment2__c == null) {
				//A payment has been inserted - send the email
				paymentIds.add(nlOrder.Payment2__c);
			}
		}
		try {
			Map<Id, Payment2__c> nullMap = new Map<Id, Payment2__c>();
			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(paymentIds);
			if(payments.size() > 0) {
				Payments2ServiceImpl.sendEmailReceipt(nullMap, payments);
			}
		} catch (Exception e) {
			system.debug((e.getMessage()));
		}
	}
}
