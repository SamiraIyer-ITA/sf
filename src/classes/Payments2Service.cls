/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: Payments2Service.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Payment2 object or as
		a result of the Payment2 object being updated. Which implementation is used is determined by custom
		metadata. See Payments2ServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class Payments2Service {

	private static IPayments2Service service(){
		return (IPayments2Service) fflibext_Application.Service.newInstance(IPayments2Service.class);
	}

	public static void updateSystemSearchStringList(List<Payment2__c> payments2List){
		service().updateSystemSearchStringList(payments2List);
	}

	public class Payments2ServiceException extends Exception {}

}