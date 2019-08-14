/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: CasesService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Case object or as
		a result of the Case object being updated. Which implementation is used is determined by custom
		metadata. See CasesServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class CasesService {

	private static ICasesService service(){
		return (ICasesService) fflibext_Application.Service.newInstance(ICasesService.class);
	}

	public static void updateCaseContactAndOfficer(List<Case> casesList){
		service().updateCaseContactAndOfficer(casesList);
	}

	public static void updateAssets(Map<Id,Case> existingMap, List<Case> newList) {
		service().updateAssets(existingMap,newList);
	}

	public static void sendToEximBank(List<Case> newList) {
		service().sendToEximBank(newList);
	}

	public class CasesServiceException extends Exception {}

}