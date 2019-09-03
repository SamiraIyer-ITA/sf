/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: Refunds.cls
	Purpose: Implementation of IRefunds interface that will be used as an FFLIB domain object.
 */
public class Refunds extends fflib_SObjectDomain implements IRefunds {

	public static fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();

	public static IRefunds newInstance(List<Refund__c> records){
		return (IRefunds) fflibext_Application.Domain.newInstance(records);
	}

	public static IRefunds newInstance(Set<Id> recordIds){
		return (IRefunds) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Refunds(List<Refund__c> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Refund__c> sObjectList) {
			return new Refunds(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		updateRefundContactAndOfficer(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateRefundContactAndOfficer(Trigger.New);
	}

	public void updateRefundContactAndOfficer(List<Refund__c> refundsToUpdate) {
		try {
			RefundsService.updateRefundContactAndOfficer(refundsToUpdate);
		} catch (RefundsService.RefundsServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}
}
