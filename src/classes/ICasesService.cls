/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: ICasesService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Case object or as a result of the Case object being updated.
 */
public interface ICasesService {

	void updateCaseContactAndOfficer(List<Case> casesList);
	void updateAssets(Map<Id,Case> existingMap, List<Case> newList);
	void sendToEximBank(List<Case> newList);

}