/**
 * Created by Mark Keckeis on 8/11/2020.
 */

public class OpportunityContactRolesSelector extends fflib_SObjectSelector implements IOpportunityContactRolesSelector {

	public static IOpportunityContactRolesSelector newInstance(){
		return (IOpportunityContactRolesSelector) fflibext_Application.Selector.newInstance(OpportunityContactRole.SObjectType);
	}

	public List<OpportunityContactRole> selectById(Set<Id> idSet) {
		return (List<OpportunityContactRole>) selectSObjectsById(idSet);
	}
	public List<OpportunityContactRole> selectByOpportunityId(Set<Id> opportunityIdSet, Boolean isPrimary) {

		fflib_QueryFactory OpportunityContactRoleQueryFactory = newQueryFactory();

		OpportunityContactRoleQueryFactory.selectFields(new Set<String>{
				'Id',
				'Contact.Email',
				'OpportunityId',
				'isPrimary'
		});
		String condition = 'OpportunityId IN :opportunityIdSet ';
		condition += 'AND isPrimary = ' + isPrimary;

		return (List<OpportunityContactRole>) Database.query(OpportunityContactRoleQueryFactory.setCondition(condition).toSOQL());


	}
	private Schema.SObjectType getSObjectType() {
		return OpportunityContactRole.SObjectType;
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		//add more fields as appropriate
		return new List<Schema.SObjectField>{
				OpportunityContactRole.Id,
				OpportunityContactRole.ContactId,
				OpportunityContactRole.Lead__c,
				OpportunityContactRole.OpportunityId,
				OpportunityContactRole.IsPrimary,
				OpportunityContactRole.Role
		};
	}
}