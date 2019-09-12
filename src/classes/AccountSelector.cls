public class AccountSelector extends fflib_SObjectSelector implements IAccountSelector {

	public static IAccountSelector newInstance(){
		return (IAccountSelector) fflibext_Application.Selector.newInstance(Account.SObjectType);
	}

	public List<Account> selectById(Set<Id> idSet) {
		return (List<Account>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Account.Id,
			Account.Name,
			Account.BillingStreet,
			Account.BillingCity,
			Account.BillingState,
			Account.BillingPostalCode,
			Account.Phone,
			Account.Fax,
			Account.BillingCountry
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Account.SObjectType;
	}

}