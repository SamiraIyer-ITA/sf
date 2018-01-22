public class PetitionsSelector extends fflib_SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Petition__c.Id, 
            Petition__c.Percent_of_Domestic_Industry__c,
            Petition__c.Total_Imports_Domestic_Consumption__c ,
		    Petition__c.Actual_Initiation_Concurrence_to_DAS__c,
	        Petition__c.Actual_Initiation_Issues_to_DAS__c,
            Petition__c.Actual_Initiation_Signature__c,
			Petition__c.ADCVD_Case_Number__c,
		    Petition__c.ADCVD_Case_Type__c,
	        Petition__c.Calculated_Initiation_Signature__c,
//            Petition__c.Case_Number__c,
//			Petition__c.Case_Type__c,
			Petition__c.CBP_Case_Number__c,
		    Petition__c.Commodity__c,
	        Petition__c.Country__c,
            Petition__c.External_Id__c,
			Petition__c.Initiation_Announcement_Date__c,
		    Petition__c.Initiation_Concurrence_Due_to_DAS__c,
	        Petition__c.Initiation_Extension_of_days__c,
            Petition__c.Initiation_Extension_Remaining__c,
			Petition__c.Initiation_Issues_Due_to_DAS__c,
		    Petition__c.Link__c,
	        Petition__c.Litigation_YesNo__c,
            Petition__c.Litigation_Resolved__c,
			Petition__c.Litigation_Status__c,
		    Petition__c.Lotus_Notes_History_Data__c,
	        Petition__c.Lotus_Notes_Litigation_ID__c,
            Petition__c.Next_Announcement_Date__c,
			Petition__c.Next_Due_to_DAS_Deadline__c,
		    Petition__c.Next_Major_Deadline__c,
	        Petition__c.Next_Office_PM_Deadline__c,
            Petition__c.Next_Office_Deadline__c,
			Petition__c.Office__c,
		    Petition__c.Period_for_Trade_Data__c,
	        Petition__c.Petition_Filed__c,
            Petition__c.Petition_Name__c,
			Petition__c.Petition_Outcome__c,
		    Petition__c.Product__c,
	        Petition__c.Product_Short_Name__c,
            Petition__c.Locked__c,
			Petition__c.Schedule_Refresh__c,
		    Petition__c.Status__c,
	        Petition__c.Tolling_Update__c 
		};
	}
    
    public Schema.SObjectType getSObjectType() {
        return Related_Organization__c.sObjectType;
    }
    
    public List<Petition__c> selectById(Set<Id> ids) {
        return (List<Petition__c>) selectSObjectsById(ids);
    }
    
    public List<Petition__c> selectAll() {
        return (List<Petition__c>) 
            Database.query(
                newQueryFactory().toSOQL());        
    }
    
}
