/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: Cases.cls
	Purpose: Implementation of ICases interface that will be used as an FFLIB domain object.
 */
public class Cases extends fflib_SObjectDomain implements ICases {

	public static ICases newInstance(List<Case> records){
		return (ICases) fflibext_Application.Domain.newInstance(records);
	}

	public static ICases newInstance(Set<Id> recordIds){
		return (ICases) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Cases(List<Case> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Case> sObjectList) {
			return new Cases(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		updateCaseContactAndOfficer(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		//TODO: Remove hardcoded trigger.newMap and find way to refer in fflib's intended structure
		updateCaseContactAndOfficer(Trigger.New);
	}

	public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
		updateAssets((Map<Id,Case>)existingRecords,Trigger.New);
		sendToEximBank(Trigger.New);
	}

	public void updateCaseContactAndOfficer(List<Case> casesToUpdate) {
		try {
			CasesService.updateCaseContactAndOfficer(casesToUpdate);
		} catch (CasesService.CasesServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void updateAssets(Map<Id,Case> existingRecords, List<Case> newCases) {
		try {
			CasesService.updateAssets(existingRecords, newCases);
		} catch (CasesService.CasesServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

	public void sendToEximBank(List<Case> newCases) {
		try {
			CasesService.sendToEximBank(newCases);
		} catch (CasesService.CasesServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}
}