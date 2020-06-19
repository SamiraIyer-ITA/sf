/**
 * Implementation of IOpportunities interface that will be used as an fflib domain object.
 *
 * @author Andrew La Russa
 */
public class Opportunities extends fflib_SObjectDomain implements IOpportunities {

	public static IOpportunities newInstance(List<Opportunity> records)  {
		return (IOpportunities) fflibext_Application.Domain.newInstance(records);
	}

	public static IOpportunities newInstance(Set<Id> recordIds) {
		return (IOpportunities) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Opportunities(List<Opportunity> sObjectList) {
		super(sObjectList);
	}

	public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		OpportunitiesService.handleBeforeUpdate(Records, existingRecords);
	}

	public override void onAfterInsert() {
		OpportunitiesService.handleAfterInsert(Records);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Opportunities(sObjectList);
		}
	}
}