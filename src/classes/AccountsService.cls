/*
	Author: Mark Keckeis
	Date: 9-2-2020
	Name: Accounts.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Account object or as
		a result of the Account object being updated. Which implementation is used is determined by custom
		metadata. See AccountsServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class AccountsService {

	private static IAccountsService service(){
		return (IAccountsService) fflibext_Application.Service.newInstance(IAccountsService.class);
	}

	public class AssetsServiceException extends Exception {}

}