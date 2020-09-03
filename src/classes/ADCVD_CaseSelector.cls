public with sharing class ADCVD_CaseSelector
    extends fflibext_SObjectSelector
        implements ADCVD_ICaseSelector {

    public static ADCVD_ICaseSelector newInstance() {
        return (ADCVD_ICaseSelector) fflibext_Application.Selector.newInstance(ADCVD_Case__c.SObjectType);
    }

    @TestVisible
    private Schema.sObjectType getSObjectType() {
        return ADCVD_Case__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField>{
            ADCVD_Case__c.ADCVD_Case_Number__c,
            ADCVD_Case__c.ADCVD_Case_Type__c,
            ADCVD_Case__c.Case_Concat_Text_Values__c,
            ADCVD_Case__c.CBP_Case_Number__c,
            ADCVD_Case__c.Commodity__c,
            ADCVD_Case__c.Country__c,
            ADCVD_Case__c.Country_Text__c,
            ADCVD_Case__c.Product__c,
            ADCVD_Case__c.Product_Short_Name__c,
            ADCVD_Case__c.Locked__c,
            ADCVD_Case__c.Program_Manager__c
        };
    }

    public List<ADCVD_Case__c> selectById(Set<Id> idSet) {
        return (List<ADCVD_Case__c>) selectSObjectsById(idSet);
    }

    public List<ADCVD_Case__c> selectByIdWithRelations(Set<Id> idSet) {
        fflib_QueryFactory qf = newQueryFactory();
        qf.subselectQuery(Petition__c.SObjectType, true)
            .selectField(Petition__c.Id)
            .selectField(Petition__c.ADCVD_Case__c);
        qf.subselectQuery(Investigation__c.SObjectType, true)
            .selectField(Investigation__c.Id)
            .selectField(Investigation__c.ADCVD_Case__c)
            .selectField(Investigation__c.Petition__c);
        qf.subselectQuery(ADCVD_Order__c.SObjectType, true)
            .selectField(ADCVD_Order__c.Id)
            .selectField(ADCVD_Order__c.ADCVD_Case__c)
            .selectField(ADCVD_Order__c.Investigation__c);
        qf.subselectQuery(Suspension_Agreement__c.SObjectType, true)
            .selectField(Suspension_Agreement__c.Id)
            .selectField(Suspension_Agreement__c.ADCVD_Case__c)
            .selectField(Suspension_Agreement__c.Investigation__c);
        qf.subselectQuery(Segment__c.SObjectType, true)
            .selectField(Segment__c.Id)
            .selectField(Segment__c.ADCVD_Case__c)
            .selectField(Segment__c.ADCVD_Order__c)
            .selectField(Segment__c.Suspension_Agreement__c);
        qf.subselectQuery(Litigation__c.SObjectType, true)
            .selectField(Litigation__c.Id)
            .selectField(Litigation__c.ADCVD_Case__c)
            .selectField(Litigation__c.Petition__c)
            .selectField(Litigation__c.Investigation__c)
            .selectField(Litigation__c.Segment__c);
        qf.subselectQuery(Federal_Register__c.SObjectType, true)
            .selectField(Federal_Register__c.Id)
            .selectField(Federal_Register__c.ADCVD_Case__c)
            .selectField(Federal_Register__c.Petition__c)
            .selectField(Federal_Register__c.Investigation__c)
            .selectField(Federal_Register__c.ADCVD_Order__c)
            .selectField(Federal_Register__c.Suspension_Agreement__c)
            .selectField(Federal_Register__c.Segment__c);
        qf.subselectQuery(Staffing_Assignment__c.SObjectType, true)
            .selectField(Staffing_Assignment__c.Id)
            .selectField(Staffing_Assignment__c.ADCVD_Case__c)
            .selectField(Staffing_Assignment__c.Petition__c)
            .selectField(Staffing_Assignment__c.Investigation__c)
            .selectField(Staffing_Assignment__c.ADCVD_Order__c)
            .selectField(Staffing_Assignment__c.Related_Organization__c)
            .selectField(Staffing_Assignment__c.Segment__c);
        qf.subselectQuery(Related_Organization__c.SObjectType, true)
            .selectField(Related_Organization__c.Id)
            .selectField(Related_Organization__c.ADCVD_Case__c)
            .selectField(Related_Organization__c.Petition__c)
            .selectField(Related_Organization__c.Investigation__c)
            .selectField(Related_Organization__c.ADCVD_Order__c)
            .selectField(Related_Organization__c.Litigation__c)
            .selectField(Related_Organization__c.Segment__c);
        qf.subselectQuery(Custom_Instruction__c.SObjectType, true)
            .selectField(Custom_Instruction__c.Id)
            .selectField(Custom_Instruction__c.ADCVD_Case__c)
            .selectField(Custom_Instruction__c.Petition__c)
            .selectField(Custom_Instruction__c.Investigation__c)
            .selectField(Custom_Instruction__c.ADCVD_Order__c)
            .selectField(Custom_Instruction__c.Suspension_Agreement__c)
            .selectField(Custom_Instruction__c.Segment__c);
        qf.subselectQuery(Harmonized_Tariff_Schedule__c.SObjectType, true)
            .selectField(Harmonized_Tariff_Schedule__c.Id)
            .selectField(Harmonized_Tariff_Schedule__c.ADCVD_Case__c)
            .selectField(Harmonized_Tariff_Schedule__c.ADCVD_Order__c)
            .selectField(Harmonized_Tariff_Schedule__c.Suspension_Agreement__c);
        qf.subselectQuery(Recusal__c.SObjectType, true)
            .selectField(Recusal__c.Id)
            .selectField(Recusal__c.ADCVD_Case__c)
            .selectField(Recusal__c.Related_Organization__c);
        qf.setCondition(ADCVD_Case__c.Id + ' in :idSet');
        return Database.query(qf.toSOQL());
    }
}