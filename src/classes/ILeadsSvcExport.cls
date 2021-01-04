/**
 * Leads Export service interface.
 *
 * @author Daniel Haro
 */
public interface ILeadsSvcExport extends ILeadsSvcBase {

   void updateAssignmentFieldsOnAssignmentChange(List<SObject> records,Map<Id, SObject> existingRecords);
   void postToChatterWhenLeadAssigned(List<SObject> records,Map<Id, SObject> existingRecords);
}
