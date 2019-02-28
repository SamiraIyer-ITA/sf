/**
 * 
 *    Created by Joshua Moody
 *    on Sep 19 2017
 *    MIL Corporation
 * 
 **/

public without sharing class ParentValuesService {

	/***********************************************************
    * This class populates Case Information from one parent
    * sObject to a child sObject in the ADCVD app.  Since 
    * each field may or may not exist on the child, sObjectExceptions
    * are caught and debugged rather than stopping the execution.
    * This class provides methods to:
    * 1. Get the value of a specific set of repeated fields from
    * a parent record and populate it to the child record.
    ***********************************************************/

	public SObject setCaseValuesFromParent (SObject parent, SObject child) {
        //map used for all objects except adcvd case
        Map<String,String> childFieldToParentFieldMap = new Map<String,String>{
            'ADCVD_Case__c' => 'ADCVD_Case__c',
            'ADCVD_Case_Number_Text__c' => 'ADCVD_Case_Number_Text__c',
            'ADCVD_Case_Type_Text__c' => 'ADCVD_Case_Type_Text__c',
            'CBP_Case_Number_Text__c' => 'CBP_Case_Number_Text__c',
            'Commodity_Text__c' => 'Commodity_Text__c',
            'Country_Text__c' => 'Country_Text__c',
            'Product_Text__c' => 'Product_Text__c',
            'Product_Short_Name_Text__c' => 'Product_Short_Name_Text__c',
            'Period_Covered_Start_Date__c' => 'Period_Covered_Start_Date__c',
			'Period_Covered_End_Date__c' => 'Period_Covered_End_Date__c',
			'Requestor__c' => 'Requestor__c',
			'Product_Description__c' => 'Product_Description__c'
        };
        //map used when values are copied from an adcvd case
		Map<String,String> childFieldToCaseFieldMap  = new Map<String,String>{
			'ADCVD_Case__c' => 'Id',
            'ADCVD_Case_Number_Text__c' => 'ADCVD_Case_Number__c',
            'ADCVD_Case_Type_Text__c' => 'ADCVD_Case_Type__c',
            'CBP_Case_Number_Text__c' => 'CBP_Case_Number__c',
			'Commodity_Text__c' => 'Commodity__c',
            'Country_Text__c' => 'Country__c',
			'Product_Text__c' => 'Product__c',
			'Product_Short_Name_Text__c' => 'Product_Short_Name__c'
		};
        Map<String,String> fieldsMap;
        if (parent.getSObjectType() == ADCVD_Case__c.SObjectType) {
            fieldsMap = new Map<String,String>(childFieldToCaseFieldMap);
        } else {
            fieldsMap = new Map<String,String>(childFieldToParentFieldMap);
        }
		for (String field : fieldsMap.keySet()) {
			try {
				if (parent.get(fieldsMap.get(field)) instanceof String) {
					child.put(field, String.valueOf(parent.get(fieldsMap.get(field))));
				} else if (parent.get(fieldsMap.get(field)) instanceof Date) {
					child.put(field, Date.valueOf(parent.get(fieldsMap.get(field))));
				} else if (parent.get(fieldsMap.get(field)) instanceof Id) {
					child.put(field, (Id)parent.get(fieldsMap.get(field)));
				}
			} catch (SObjectException e) {
				System.debug(loggingLevel.Error, '*** e: ' + e);
				continue;
				//Only write to debug logs as most parents will only have some of the fields
				//This covers non-editable fields and when the SObject is retrieved with that 
				//field being queried, presumably because it does not have it.
			}
		}
		return child;
	}
}