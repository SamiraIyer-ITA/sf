/**
 * Implementation of ILeads interface that will be used as an fflib domain object.
 *
 * @author Daniel Haro
 */
public class Leads extends fflib_SObjectDomain implements ILeads {

	public static ILeads newInstance(List<Lead> records)  {
		return (ILeads) fflibext_Application.Domain.newInstance(records);
	}

	public static ILeads newInstance(Set<Id> recordIds) {
		return (ILeads) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Leads(List<Lead> sObjectList) {
		super(sObjectList);
	}

    public override void onBeforeInsert() {
		LeadsService.handleBeforeInsert(Records);
	}

	public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		LeadsService.handleBeforeUpdate(Records, existingRecords);
	}

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
    	LeadsService.handleAfterUpdate(Records, existingRecords);

    }

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Leads(sObjectList);
		}
	}
}
