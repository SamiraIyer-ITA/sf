/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IRefunds.cls
	Purpose: Refund__c interface that will be used as an FFLIB domain object.
 */
public interface IRefunds extends fflib_ISObjectDomain {

	void updateRefundContactAndOfficer(List<Refund__c> refundsToUpdate);

}