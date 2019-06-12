public class FederalRegisterSelector extends fflibext_SObjectSelector implements IFederalRegisterSelector {
    
    public static IFederalRegisterSelector newInstance() {
        return (IFederalRegisterSelector) fflibext_Application.Selector.newInstance(Federal_Register__c.SObjectType);
    }

    @TestVisible
    private Schema.sObjectType getSObjectType() {
        return Federal_Register__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Federal_Register__c.ADCVD_Case__c,
            Federal_Register__c.ADCVD_Case_Number_Text__c,
            Federal_Register__c.ADCVD_Case_Type_Text__c,
            Federal_Register__c.ADCVD_Case_Type__c,
            Federal_Register__c.ADCVD_Order__c,
            Federal_Register__c.Case_Concat_Text_Values__c,
            Federal_Register__c.CBP_Case_Number_Text__c,
            Federal_Register__c.Cite_Number__c,
            Federal_Register__c.Commodity_Text__c,
            Federal_Register__c.Commodity__c,
            Federal_Register__c.Country_Text__c,
            Federal_Register__c.Country__c,
            Federal_Register__c.Do_Delete__c,
            Federal_Register__c.External_Id__c,
            Federal_Register__c.FR_Parent__c,
            Federal_Register__c.FR_URL__c,
            Federal_Register__c.IDM_URL__c,
            Federal_Register__c.Investigation__c,
            Federal_Register__c.Litigation__c,
            Federal_Register__c.Petition__c,
            Federal_Register__c.Product_Text__c,
            Federal_Register__c.Product__c,
            Federal_Register__c.Product_Short_Name_Text__c,
            Federal_Register__c.Product_Short_Name__c,
            Federal_Register__c.Product_Short_Name_Text_Value__c,
            Federal_Register__c.Product_Text_Value__c,
            Federal_Register__c.Published_Date__c,
            Federal_Register__c.Locked__c,
            Federal_Register__c.Segment__c,
            Federal_Register__c.Suspension_Agreement__c,
            Federal_Register__c.Type__c
        };
    }

    public List<Federal_Register__c> selectById(Set<Id> idSet) {
        return (List<Federal_Register__c>) selectSObjectsById(idSet);
    }

    public List<Federal_Register__c> selectAllToLimit() {
        return (List<Federal_Register__c>)Database.query(newQueryFactory().setLimit(Limits.getLimitQueryRows()).toSOQL());
    }

    // ========== Legacy Functionality ===================================

    public static List<Federal_Register__c> allFederalRegisters {
        get {
            if (allFederalRegisters == null) {
                allFederalRegisters = FederalRegisterSelector.newInstance().selectAllToLimit();
            }
            return allFederalRegisters;
        }

        set;
    }
}