public interface IAccountService {

	List<Account> updateAccountAddresses(List<Participation__c> participationList);
	void updateCCDLookupId(List<Account> accounts);
}