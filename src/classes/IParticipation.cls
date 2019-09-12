public interface IParticipation extends fflib_ISObjectDomain {

	void updateAccountAddresses();
	void updateContactAndOfficer(List<Participation__c> applicationList);
	void ManageApplicationData(List<Participation__c> applicationList);
}