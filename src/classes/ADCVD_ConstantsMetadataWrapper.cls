public class ADCVD_ConstantsMetadataWrapper
{
    public ID ID = null;
    public String DeveloperName = null;
    public ID ADCVD_Objects = null;
    public Boolean ADCVD_Order_Calculation_Offset = null;
    public Boolean Investigation_Calculation_Offset = null;
    public Boolean Issue_Calculation_Offset = null;
    public Boolean Litigation_Calculation_Offset = null;
    public Decimal Number_Value = null;
    public Boolean Petition_Calculation_Offset = null;
    public String Record_Description = null;
    public Boolean Segment_Calculation_Offset = null;
    public Boolean Staffing_Assignment_Default = null;
    public String Staffing_Role = null;
    public String String_Value = null;
    public Boolean Suspension_Agreement_Calculation_Offset = null;
    public String Used_with_Field_Named = null;

    public ADCVD_ConstantsMetadataWrapper(Constant__mdt constant)
    {
        if (constant == null) return;

        this.ID = constant.Id;
        DeveloperName = constant.DeveloperName;
        ADCVD_Objects = constant.ADCVD_Objects__c;
        ADCVD_Order_Calculation_Offset = constant.ADCVD_Order_Calculation_Offset__c;
        Investigation_Calculation_Offset = constant.Investigation_Calculation_Offset__c;
        Issue_Calculation_Offset = constant.Issue_Calculation_Offset__c;
        Litigation_Calculation_Offset = constant.Litigation_Calculation_Offset__c;
        Number_Value = constant.Number_Value__c;
        Petition_Calculation_Offset = constant.Petition_Calculation_Offset__c;
        Record_Description = constant.Record_Description__c;
        Segment_Calculation_Offset = constant.Segment_Calculation_Offset__c;
        Staffing_Assignment_Default = constant.Staffing_Assignment_Default__c;
        Staffing_Role = constant.Staffing_Role__c;
        String_Value = constant.String_Value__c;
        Suspension_Agreement_Calculation_Offset = constant.Suspension_Agreement_Calculation_Offset__c;
        Used_with_Field_Named = constant.Used_with_Field_Named__c;
    }

    public static List<ADCVD_ConstantsMetadataWrapper> construct(List<Constant__mdt> constantMdtList)
    {
        List<ADCVD_ConstantsMetadataWrapper> result = new List<ADCVD_ConstantsMetadataWrapper>();

        if (constantMdtList == null || constantMdtList.isEmpty()) return result;

        for (Constant__mdt c : constantMdtList)
        {
            result.add(new ADCVD_ConstantsMetadataWrapper(c));
        }

        return result;
    }
}