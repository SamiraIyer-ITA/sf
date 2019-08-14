/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: RefundsService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Refund object or as
		a result of the Refund object being updated. Which implementation is used is determined by custom
		metadata. See RefundsServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class RefundsService {

	private static IRefundsService service(){
		return (IRefundsService) fflibext_Application.Service.newInstance(IRefundsService.class);
	}

	public static void updateRefundContactAndOfficer(List<Refund__c> refundsToUpdate) {
		service().updateRefundContactAndOfficer(refundsToUpdate);
	}

	public class RefundsServiceException extends Exception {}

}