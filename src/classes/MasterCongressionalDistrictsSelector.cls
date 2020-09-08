/**
 * Master_CongressionalDistrict__c fflib Selector
 *
 * @author Mark Keckeis
 */
public class MasterCongressionalDistrictsSelector extends fflib_SObjectSelector implements IMasterCongressionalDistrictsSelector {

	public static IMasterCongressionalDistrictsSelector newInstance()  {
		return (IMasterCongressionalDistrictsSelector) fflibext_Application.Selector.newInstance(Master_CongressionalDistrict__c.SObjectType);
	}

	public List<Master_CongressionalDistrict__c> selectById(Set<Id> idSet) {
		return (List<Master_CongressionalDistrict__c>) selectSObjectsById(idSet);
	}

	public List<Master_CongressionalDistrict__c> selectByMin4Max4AndZipPlus4(Set<String> zip4, Set<String> zip5) {
		return (List<Master_CongressionalDistrict__c>)
				Database.query(
					newQueryFactory()
						.setCondition('Min4__c <= :zip4 AND Max4__c >= :zip4 AND Zip_Plus4__c = :zip5')
						.toSOQL()
				);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Master_CongressionalDistrict__c.Id,
			Master_CongressionalDistrict__c.State_Code__c,
			Master_CongressionalDistrict__c.County_Name__c,
			Master_CongressionalDistrict__c.Zip_Plus4__c,
			Master_CongressionalDistrict__c.Max9Zip__c,
			Master_CongressionalDistrict__c.Min9Zip__c,
			Master_CongressionalDistrict__c.Congressional_Dist__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Master_CongressionalDistrict__c.SObjectType;
	}
}