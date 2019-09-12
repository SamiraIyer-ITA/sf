/*
	Author: Jeff Weyhrauch
	Date: 3-20-19
	Name: IParticipationService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Participation object or as a result of the Participation object being updated.
 */
public interface IParticipationService {

	void updateContactAndOfficer(List<Participation__c> participationsToUpdate);
	void updateOrders(List<Participation__c> participationsToUpdate);
	void updateCases(List<Participation__c> participationsToUpdate);
	void ManageApplicationData(List<Participation__c> participationsToUpdate);

}