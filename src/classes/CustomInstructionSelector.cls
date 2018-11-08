public class CustomInstructionSelector
    extends fflibext_SObjectSelector
    implements ICustomInstructionSelector
{
    public static ICustomInstructionSelector newInstance()
    {
        return (ICustomInstructionSelector) fflibext_Application.Selector.newInstance(Custom_Instruction__c.SObjectType);
    }
    @TestVisible
    private Schema.sObjectType getSObjectType()
    {
        return Custom_Instruction__c.SObjectType;
    }
    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Custom_Instruction__c.ADCVD_Case_Number_Text__c,
            Custom_Instruction__c.ADCVD_Case_Type_Text__c,
            Custom_Instruction__c.ADCVD_Case__c,
            Custom_Instruction__c.ADCVD_Order__c,
            Custom_Instruction__c.AD_CVD_Module_Number__c,
            Custom_Instruction__c.Applicable_Rate__c,
            Custom_Instruction__c.Basis_for_Rate__c,
            Custom_Instruction__c.CBP_Case_Number_Text__c,
            Custom_Instruction__c.CBP_Instructions_Category__c,
            Custom_Instruction__c.CBP_Instructions_Sub_Category__c,
            Custom_Instruction__c.Commodity_Text__c,
            Custom_Instruction__c.Countervailed_Programs__c,
            Custom_Instruction__c.Country_Text__c,
            Custom_Instruction__c.Country_in_which_factors_were_valued__c,
            Custom_Instruction__c.Date_Message_Loaded_in_ACE__c,
            Custom_Instruction__c.IMN_NO__c,
            Custom_Instruction__c.Investigation__c,
            Custom_Instruction__c.Locked__c,
            Custom_Instruction__c.Message_Date__c,
            Custom_Instruction__c.Message_No__c,
            Custom_Instruction__c.Petition__c,
            Custom_Instruction__c.Product_Short_Name_Text__c,
            Custom_Instruction__c.Product_Text__c,
            Custom_Instruction__c.Segment__c,
            Custom_Instruction__c.Suspension_Agreement__c
        };
    }
    public List<Custom_Instruction__c> selectById(Set<Id> idSet)
    {
        return (List<Custom_Instruction__c>) selectSObjectsById(idSet);
    }
    public List<Custom_Instruction__c> selectAllToLimit()
    {
        return
            (List<Custom_Instruction__c>)
            Database.query(
                newQueryFactory()
                .setLimit(Limits.getLimitQueryRows())
                .toSOQL());
    }
}