public class RecusalSelector extends fflibext_SObjectSelector implements IRecusalSelector {

    public static IRecusalSelector newInstance() {
        return (IRecusalSelector) fflibext_Application.Selector.newInstance(Recusal__c.SObjectType);
    }

    @TestVisible private Schema.sObjectType getSObjectType() {
        return Recusal__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField>
        {
            Recusal__c.Actor__c,
            Recusal__c.Actor_End_Date__c,
            Recusal__c.Actor_Start_Date__c,
            Recusal__c.ADCVD_Case__c,
            Recusal__c.ADCVD_Case_Number_Text__c,
            Recusal__c.ADCVD_Case_Type_Text__c,
            Recusal__c.CBP_Case_Number_Text__c,
            Recusal__c.Commodity_Text__c,
            Recusal__c.Country_Text__c,
            Recusal__c.End_Date__c,
            Recusal__c.Product_Text__c,
            Recusal__c.Product_Short_Name_Text__c,
            Recusal__c.Reason_for_Recusal__c,
            Recusal__c.Locked__c,
            Recusal__c.Recusal_Parent__c,
            Recusal__c.Related_Organization__c,
            Recusal__c.Start_Date__c,
            Recusal__c.User__c
        };
    }
    public List<Recusal__c> selectById(Set<Id> idSet) {
        return (List<Recusal__c>) selectSObjectsById(idSet);
    }

    public List<Recusal__c> selectByUserAndNoCase(Set<Id> userIdSet) {
        return (List<Recusal__c>) Database.query(
            newQueryFactory()
            .selectField('ADCVD_Case__c')
            .selectField('Related_Organization__r.Account__c')
            .setCondition(Recusal__c.ADCVD_Case__c + ' = null AND ' + Recusal__c.User__c + ' in :userIdSet')
            .toSOQL()
        );
    }
}