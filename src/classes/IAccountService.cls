public interface IAccountService {

	List<Account> updateAccountAddresses(List<Participation__c> participationList);
	void updateCD(List<Account> accounts);
}