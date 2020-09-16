/**
 * Implementation of IAccounts interface that will be used as an fflib domain object.
 *
 * @author Mark Keckeis
 */
public class Accounts extends fflib_SObjectDomain implements IAccounts {

	public static IAccounts newInstance(List<Account> records)  {
		return (IAccounts) fflibext_Application.Domain.newInstance(records);
	}

	public static IAccounts newInstance(Set<Id> recordIds) {
		return (IAccounts) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Accounts(List<Account> sObjectList) {
		super(sObjectList);
	}

    public override void onBeforeInsert() {
		updateCD((List<Account>) Records);
    }
    
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateCD((List<Account>) Records);
    }
    
    public void updateCD(List<Account> accounts) {
        try {
			AccountService.updateCD(accounts);
		} catch (AssetsService.AssetsServiceException e){
			accounts.get(0).addError(e.getMessage());
		}
    }

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Accounts(sObjectList);
		}
	}
}