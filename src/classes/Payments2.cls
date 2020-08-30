/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: Payments2.cls
	Purpose: Implementation of IPayments2 interface that will be used as an FFLIB domain object.
 */
public class Payments2 extends fflib_SObjectDomain implements IPayments2 {

	public static fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();

	public static IPayments2 newInstance(List<Payment2__c> records){
		return (IPayments2) fflibext_Application.Domain.newInstance(records);
	}

	public static IPayments2 newInstance(Set<Id> recordIds){
		return (IPayments2) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Payments2(List<Payment2__c> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Payment2__c> sObjectList) {
			return new Payments2(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		updateSystemSearchString(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateSystemSearchString(Trigger.New);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		sendEmailReceipt((Map<Id,Payment2__c>)existingRecords,(List<Payment2__c>)Trigger.New);
	}

	public override void onAfterInsert() {
		sendEmailReceipt((Map<Id,Payment2__c>)Trigger.oldMap,(List<Payment2__c>)Trigger.New);
	}

	public void updateSystemSearchString(List<Payment2__c> payment2List) {
		try {
			Payments2Service.updateSystemSearchStringList(payment2List);
		} catch (Payments2Service.Payments2ServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void sendEmailReceipt(Map<Id,Payment2__c> existingRecords, List<Payment2__c> payment2List) {
		try {
			Payments2Service.sendEmailReceipt(existingRecords, payment2List);
		} catch (Payments2Service.Payments2ServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

}