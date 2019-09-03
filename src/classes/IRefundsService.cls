/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IRefundsService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Refund object or as a result of the Refund object being updated.
 */
public interface IRefundsService {

	void updateRefundContactAndOfficer(List<Refund__c> refundsToUpdate);

}