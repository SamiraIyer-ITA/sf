/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: Payments.cls
	Purpose: Implementation of IPayments interface that will be used as an FFLIB domain object.
 */
public class Payments extends fflib_SObjectDomain implements IPayments {

	public static fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();

	public static IPayments newInstance(List<Payment__c> records){
		return (IPayments) fflibext_Application.Domain.newInstance(records);
	}

	public static IPayments newInstance(Set<Id> recordIds){
		return (IPayments) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Payments(List<Payment__c> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Payment__c> sObjectList) {
			return new Payments(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		updatePaymentContactAndOfficer(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updatePaymentContactAndOfficer(Trigger.New);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updateRefunds(Trigger.New);
	}

	public void updatePaymentContactAndOfficer(List<Payment__c> paymentsToUpdate) {
		try {
			PaymentsService.updatePaymentContactAndOfficer(paymentsToUpdate);
		} catch (PaymentsService.PaymentsServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void updateRefunds(List<Payment__c> newPayments) {
		try {
			PaymentsService.updateRefunds(newPayments);
		} catch (PaymentsService.PaymentsServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

}