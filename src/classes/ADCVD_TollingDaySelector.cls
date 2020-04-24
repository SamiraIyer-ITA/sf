public with sharing class ADCVD_TollingDaySelector extends fflibext_SObjectSelector implements ADCVD_ITollingDaySelector {

    public static ADCVD_ITollingDaySelector newInstance() {
        return (ADCVD_ITollingDaySelector) fflibext_Application.Selector.newInstance(Tolling_Day__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType() {
        return Tolling_Day__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Tolling_Day__c.CreatedById,
                Tolling_Day__c.End_Date__c,
                Tolling_Day__c.External_Id__c,
                Tolling_Day__c.Investigation__c,
                Tolling_Day__c.LastModifiedById,
                Tolling_Day__c.Locked__c,
                Tolling_Day__c.Name,
                Tolling_Day__c.Object_Type_To_Be_Tolled__c,
                Tolling_Day__c.OwnerId,
                Tolling_Day__c.Petition__c,
                Tolling_Day__c.Reacord_Type_To_Be_Tolled__c,
                Tolling_Day__c.Reason__c,
                Tolling_Day__c.RecordTypeId,
                Tolling_Day__c.Segment__c,
                Tolling_Day__c.Start_Date__c
        };
    }
    public List<Tolling_Day__c> selectById(Set<Id> idSet) {
        return (List<Tolling_Day__c>) selectSObjectsById(idSet);
    }

    public List<Tolling_Day__c> selectByWhereClause(String wc) {
        return (List<Tolling_Day__c>) selectSObjectsWhere(wc);
    }

    public List<Tolling_Day__c> selectAllToLimit() {
        return (List<Tolling_Day__c>)Database.query(newQueryFactory().setLimit(Limits.getLimitQueryRows()).toSOQL());
    }
}