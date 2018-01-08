/*Related Organizations Selector class, used to query Related_Organization__c records
 * Selector class uses the Financial Force Enterprise trigger framework
 */
public class RelatedOrganizationsSelector extends fflib_SObjectSelector {
    
    //This method specifies the fields that are returend by the query methods below. SelectAll and selectById
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Related_Organization__c.Id , 
                Related_Organization__c.Petition__c, 
                Related_Organization__c.Investigation__c, 
                Related_Organization__c.ADCVD_Order__c, 
                Related_Organization__c.Segment__c, 
                Related_Organization__c.Litigation__c, 
                Related_Organization__c.Legal_Representation__c, 
                Related_Organization__c.ADCVD_Case_Number__c, 
                Related_Organization__c.ADCVD_Case_Type__c, 
                Related_Organization__c.Country__c, 
                Related_Organization__c.Product__c, 
                Related_Organization__c.CBP_Case_Number__c,
                Related_Organization__c.Account__c,
                Related_Organization__c.Custom_Instruction__c,
                Related_Organization__c.Exporter__c,
                Related_Organization__c.Link__c,
                Related_Organization__c.Parent_Id__c,
                Related_Organization__c.Producer__c,
                Related_Organization__c.Product_Short_Name__c,
                Related_Organization__c.Locked__c,
                Related_Organization__c.Related_Organization_Name__c,
                Related_Organization__c.Status__c,
                Related_Organization__c.Type__c ,
                Related_Organization__c.Petition__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Petition__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Petition__r.Country__c, 
				Related_Organization__c.Petition__r.Product__c, 
				Related_Organization__c.Petition__r.CBP_Case_Number__c,
				Related_Organization__c.Investigation__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Investigation__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Investigation__r.Country__c, 
				Related_Organization__c.Investigation__r.Product__c, 
				Related_Organization__c.Investigation__r.CBP_Case_Number__c,
				Related_Organization__c.ADCVD_Order__r.ADCVD_Case_Number__c, 
				Related_Organization__c.ADCVD_Order__r.ADCVD_Case_Type__c, 
				Related_Organization__c.ADCVD_Order__r.Country__c, 
				Related_Organization__c.ADCVD_Order__r.Product__c, 
				Related_Organization__c.ADCVD_Order__r.CBP_Case_Number__c,
				Related_Organization__c.Segment__r.ADCVD_Order__c, 
				Related_Organization__c.Segment__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Segment__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Segment__r.Country__c, 
				Related_Organization__c.Segment__r.Product__c, 
                //Related_Organization__c.Segment__r.Suspension_Agreement__c, 
				Related_Organization__c.Litigation__r.Petition__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Litigation__r.Petition__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Litigation__r.Petition__r.Country__c, 
				Related_Organization__c.Litigation__r.Petition__r.Product__c, 
				Related_Organization__c.Litigation__r.Petition__r.CBP_Case_Number__c,
				Related_Organization__c.Litigation__r.Investigation__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Litigation__r.Investigation__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Litigation__r.Investigation__r.Country__c, 
				Related_Organization__c.Litigation__r.Investigation__r.Product__c, 
				Related_Organization__c.Litigation__r.Investigation__r.CBP_Case_Number__c,
				Related_Organization__c.Litigation__r.Segment__r.ADCVD_Order__c, 
				//Related_Organization__c.Litigation__r.Segment__r.Suspension_Agreement__c, 
				Related_Organization__c.Litigation__r.Segment__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Litigation__r.Segment__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Litigation__r.Segment__r.Country__c, 
				Related_Organization__c.Litigation__r.Segment__r.Product__c, 
				Related_Organization__c.Legal_Representation__r.ADCVD_Case_Number__c, 
				Related_Organization__c.Legal_Representation__r.ADCVD_Case_Type__c, 
				Related_Organization__c.Legal_Representation__r.Country__c, 
				Related_Organization__c.Legal_Representation__r.Product__c, 
				Related_Organization__c.Legal_Representation__r.CBP_Case_Number__c 
                };
                    }
    
    public Schema.SObjectType getSObjectType() {
        return Related_Organization__c.sObjectType;
    }
    //Returns a list of records specified with specified set of ids 
    public List<Related_Organization__c> selectById(Set<Id> ids) {
        return (List<Related_Organization__c>) selectSObjectsById(ids);
    }
    
    public List<Related_Organization__c> selectAll() {
        return (List<Related_Organization__c>) 
            Database.query(
                newQueryFactory().toSOQL());        
    }
    //This method returns a list of records with fields that could not have been included in the getSObjectFieldList above.
    //The fields in the getSObjectFieldList method do not affect the fields returned by this method. 
    public List<Related_Organization__c> getRecordsFromStringQuery(Set<Id> recordIds){
        String queryString = 'SELECT Id, Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Litigation__c, Legal_Representation__c, ADCVD_Case_Number__c, ADCVD_Case_Type__c, Country__c, Product__c, CBP_Case_Number__c, Petition__r.ADCVD_Case_Number__c, Petition__r.ADCVD_Case_Type__c, Petition__r.Country__c, Petition__r.Product__c, Petition__r.CBP_Case_Number__c,Investigation__r.ADCVD_Case_Number__c, Investigation__r.ADCVD_Case_Type__c, Investigation__r.Country__c, Investigation__r.Product__c, Investigation__r.CBP_Case_Number__c,ADCVD_Order__r.ADCVD_Case_Number__c, ADCVD_Order__r.ADCVD_Case_Type__c, ADCVD_Order__r.Country__c, ADCVD_Order__r.Product__c, ADCVD_Order__r.CBP_Case_Number__c,Segment__r.ADCVD_Order__c, Segment__r.Suspension_Agreement__c, Segment__r.ADCVD_Case_Number__c, Segment__r.ADCVD_Case_Type__c, Segment__r.Country__c, Segment__r.Product__c, Litigation__r.Petition__r.ADCVD_Case_Number__c, Litigation__r.Petition__r.ADCVD_Case_Type__c, Litigation__r.Petition__r.Country__c, Litigation__r.Petition__r.Product__c, Litigation__r.Petition__r.CBP_Case_Number__c,Litigation__r.Investigation__r.ADCVD_Case_Number__c, Litigation__r.Investigation__r.ADCVD_Case_Type__c, Litigation__r.Investigation__r.Country__c, Litigation__r.Investigation__r.Product__c, Litigation__r.Investigation__r.CBP_Case_Number__c,Litigation__r.Segment__r.ADCVD_Order__c, Litigation__r.Segment__r.Suspension_Agreement__c, Litigation__r.Segment__r.ADCVD_Case_Number__c, Litigation__r.Segment__r.ADCVD_Case_Type__c, Litigation__r.Segment__r.Country__c, Litigation__r.Segment__r.Product__c, Legal_Representation__r.ADCVD_Case_Number__c, Legal_Representation__r.ADCVD_Case_Type__c, Legal_Representation__r.Country__c, Legal_Representation__r.Product__c, Legal_Representation__r.CBP_Case_Number__c FROM Related_Organization__c' ;
        return (List<Related_Organization__c>) Database.query(queryString + ' Where Id IN: recordIds');
        
    }
}