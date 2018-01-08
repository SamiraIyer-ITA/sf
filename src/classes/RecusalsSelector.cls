/*Recusals Selector class, used to query Recusal__c records
 * Selector class uses the Financial Force Enterprise trigger framework
 */
public class RecusalsSelector extends fflib_SObjectSelector {

    //This method specifies the fields that are returend by the query methods below. SelectAll and selectById
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	Recusal__c.Id , 
                Recusal__c.Petition__c, 
                Recusal__c.Investigation__c, 
                Recusal__c.ADCVD_Order__c, 
                Recusal__c.Segment__c, 
                Recusal__c.Litigation__c, 
                Recusal__c.Actor__c, 
                Recusal__c.Actor_End_Date__c, 
                Recusal__c.Actor_Start_Date__c, 
                Recusal__c.Primary_Recusal_Aligned_To__c, 
                Recusal__c.Reason_for_Recusal__c, 
                Recusal__c.Related_Organization__c,
                Recusal__c.Start_Date__c,
                Recusal__c.End_Date__c,
                Recusal__c.Locked__c,
                Recusal__c.User__c 
                };
                    }
    
    public Schema.SObjectType getSObjectType() {
        return Recusal__c.sObjectType;
    }
    //Returns a list of records specified with specified set of ids 
    public List<Recusal__c> selectById(Set<Id> idSet) {
        //return (List<Recusal__c>) selectSObjectsById(ids);
        return Database.query(buildQueryStringByPrimaryRecusalAndUnlocked());
    }
    
    public List<Recusal__c> selectAll() {
        return (List<Recusal__c>) 
            Database.query(
                newQueryFactory().toSOQL());        
    }
    
    public String buildQueryStringByPrimaryRecusalAndUnlocked(){
        //TODO: add a second condition where Locked__c = false
        //Locked condition isnt added, locked records are removed in the RecusalService class where this method is called. 
        return newQueryFactory().setCondition('Primary_Recusal_Aligned_To__c in :idSet').toSOQl();
    }
}