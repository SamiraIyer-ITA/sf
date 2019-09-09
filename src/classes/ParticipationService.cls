/*
	Author: Jeff Weyhrauch
	Date: 3-20-19
	Name: ParticipationService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Participation object or as
		a result of the Participation object being updated. Which implementation is used is determined by custom
		metadata. See ParticipationServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class ParticipationService {

	private static IParticipationService service(){
		return (IParticipationService) fflibext_Application.Service.newInstance(IParticipationService.class);
	}

	public static void updateContactAndOfficer(List<Participation__c> participationsToUpdate) {
		service().updateContactAndOfficer(participationsToUpdate);
	}

	public static void manageApplicationData(List<Participation__c> participationsToUpdate) {
		service().manageApplicationData(participationsToUpdate);
	}

	public static void updateOrders(List<Participation__c> participationsToUpdate) {
		service().updateOrders(participationsToUpdate);
	}

	public class ParticipationServiceException extends Exception {}

}