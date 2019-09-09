/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: ICases.cls
	Purpose: Case interface that will be used as an FFLIB domain object.
 */
public interface ICases extends fflib_ISObjectDomain {

	void updateCaseContactAndOfficer(List<Case> existingCases);
    void updateAssets(Map<Id,Case> existingRecords, List<Case> newCases);
    void sendToEximBank(List<Case> newCases);

}