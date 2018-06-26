public with sharing class ADCVD_ConstantSelector
    extends fflibext_SObjectSelector
    implements ADCVD_IConstantSelector
{
    public static ADCVD_IConstantSelector newInstance()
    {
        return (ADCVD_IConstantSelector) fflibext_Application.Selector.newInstance(Constant__mdt.SObjectType);
    }

    private Schema.sObjectType getSObjectType()
    {
        return Constant__mdt.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Constant__mdt.ADCVD_Objects__c,
            Constant__mdt.ADCVD_Order_Calculation_Offset__c,
            Constant__mdt.Investigation_Calculation_Offset__c,
            Constant__mdt.Issue_Calculation_Offset__c,
            Constant__mdt.Litigation_Calculation_Offset__c,
            Constant__mdt.Number_Value__c,
            Constant__mdt.Petition_Calculation_Offset__c,
            Constant__mdt.Record_Description__c,
            Constant__mdt.Segment_Calculation_Offset__c,
            Constant__mdt.Staffing_Assignment_Default__c,
            Constant__mdt.Staffing_Role__c,
            Constant__mdt.String_Value__c,
            Constant__mdt.Suspension_Agreement_Calculation_Offset__c,
            Constant__mdt.Used_with_Field_Named__c
        };
    }

    public List<ADCVD_ConstantsMetadataWrapper> selectDefault()
    {
        return
            ADCVD_ConstantsMetadataWrapper.construct(
                Database.query(
                    newQueryFactory()
                        .setCondition(Constant__mdt.Staffing_Assignment_Default__c + ' = true')
                        .toSOQL()));
    }
}