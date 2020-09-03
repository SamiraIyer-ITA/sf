public class ContractsSelector extends fflib_SObjectSelector implements IContractsSelector {

	public static IContractsSelector newInstance(){
		return (IContractsSelector) fflibext_Application.Selector.newInstance(Contract.SObjectType);
	}

	public List<Contract> selectById(Set<Id> idSet) {
		return (List<Contract>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		//add more fields as appropriate
		return new List<Schema.SObjectField>{
			Contract.Id,
			Contract.Name,
			Contract.ContractNumber
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Contract.SObjectType;
	}
}