public class Participation extends fflib_SObjectDomain implements IParticipation {

	public static fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();

	public static IParticipation newInstance(List<Participation__c> records){
		return (IParticipation) fflibext_Application.Domain.newInstance(records);
	}

	public static IParticipation newInstance(Set<Id> recordIds){
		return (IParticipation) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Participation(List<Participation__c> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Participation__c> sObjectList) {
			return new Participation(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		manageApplicationData(Trigger.New);
		updateContactAndOfficer(Trigger.New);

	}

	public override void onAfterInsert() {
		updateAccountAddresses();
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		manageApplicationData(Trigger.New);
		updateContactAndOfficer(Trigger.New);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updateAccountAddresses();
		updateOrders(Trigger.New);
	}

	public void updateAccountAddresses() {
		List<Account> accountsToUpdate = new List<Account>();
		try {
			accountsToUpdate = AccountService.updateAccountAddresses(Records);
		} catch (AccountService.AccountServiceException e){
			Records.get(0).addError(e.getMessage());
		}
		uow.registerDirty(accountsToUpdate);
		uow.commitWork();
	}

	public void updateOrders(List<Participation__c> applicationList) {
		try {
			ParticipationService.updateOrders(applicationList);
		} catch (ParticipationService.ParticipationServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void updateContactAndOfficer(List<Participation__c> applicationList) {
		try {
			ParticipationService.updateContactAndOfficer(applicationList);
		} catch (ParticipationService.ParticipationServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void manageApplicationData(List<Participation__c> applicationList) {
		try {
			ParticipationService.manageApplicationData(applicationList);
		} catch (ParticipationService.ParticipationServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

}