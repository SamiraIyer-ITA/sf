@isTest
public with sharing class ADCVD_ConstantMetadataSelectorTest {

    private static Map<Id, Constant__mdt> constants{
        get{
            if(constants == null){
                constants = new Map<Id, Constant__mdt>([Select Id, MasterLabel, DeveloperName,
                        ADCVD_Objects__c,
                        ADCVD_Order_Calculation_Offset__c,
                        Investigation_Calculation_Offset__c,
                        Issue_Calculation_Offset__c,
                        Litigation_Calculation_Offset__c,
                        Number_Value__c,
                        Petition_Calculation_Offset__c,
                        Record_Description__c,
                        Segment_Calculation_Offset__c,
                        Staffing_Assignment_Default__c,
                        Staffing_Role__c,
                        String_Value__c,
                        Suspension_Agreement_Calculation_Offset__c,
                        Used_with_Field_Named__c From Constant__mdt]);
            }
            return constants;
        }
        set;
    }

    @isTest static void testConstantMetadataSelector(){
        Set<Id> selectedRecordIds = new Set<Id>{constants.values().get(0).Id,constants.values().get(1).Id,constants.values().get(2).Id,constants.values().get(3).Id,constants.values().get(4).Id};
        Test.startTest();
        ADCVD_ConstantMetadataSelector constantMetadataSelector = new ADCVD_ConstantMetadataSelector();
        Schema.SObjectType customMDT = constantMetadataSelector.getSObjectType();
        List<Constant__mdt> expectedConstantsList = constantMetadataSelector.selectById(selectedRecordIds);

        //Create new instance for coverage
        ADCVD_IConstantMetadataSelector newinstance = ADCVD_ConstantMetadataSelector.newInstance();
        Test.stopTest();

        System.assertEquals(customMDT, constants.values().get(0).getSObjectType());
        for(Constant__mdt aConstant: expectedConstantsList){
            //Assert that all the fields are retrieved by the selector
            System.assertEquals(aConstant.MasterLabel, constants.get(aConstant.Id).MasterLabel);
            System.assertEquals(aConstant.DeveloperName, constants.get(aConstant.Id).DeveloperName);
            System.assertEquals(aConstant.ADCVD_Objects__c, constants.get(aConstant.Id).ADCVD_Objects__c);
            System.assertEquals(aConstant.ADCVD_Order_Calculation_Offset__c, constants.get(aConstant.Id).ADCVD_Order_Calculation_Offset__c);
            System.assertEquals(aConstant.Investigation_Calculation_Offset__c, constants.get(aConstant.Id).Investigation_Calculation_Offset__c);
            System.assertEquals(aConstant.Issue_Calculation_Offset__c, constants.get(aConstant.Id).Issue_Calculation_Offset__c);
            System.assertEquals(aConstant.Litigation_Calculation_Offset__c, constants.get(aConstant.Id).Litigation_Calculation_Offset__c);
            System.assertEquals(aConstant.Number_Value__c, constants.get(aConstant.Id).Number_Value__c);
            System.assertEquals(aConstant.Petition_Calculation_Offset__c, constants.get(aConstant.Id).Petition_Calculation_Offset__c);
            System.assertEquals(aConstant.Record_Description__c, constants.get(aConstant.Id).Record_Description__c);
            System.assertEquals(aConstant.Segment_Calculation_Offset__c, constants.get(aConstant.Id).Segment_Calculation_Offset__c);
            System.assertEquals(aConstant.Staffing_Assignment_Default__c, constants.get(aConstant.Id).Staffing_Assignment_Default__c);
            System.assertEquals(aConstant.Staffing_Role__c, constants.get(aConstant.Id).Staffing_Role__c);
            System.assertEquals(aConstant.String_Value__c, constants.get(aConstant.Id).String_Value__c);
            System.assertEquals(aConstant.Suspension_Agreement_Calculation_Offset__c, constants.get(aConstant.Id).Suspension_Agreement_Calculation_Offset__c);
            System.assertEquals(aConstant.Used_with_Field_Named__c, constants.get(aConstant.Id).Used_with_Field_Named__c);
        }
    }
}