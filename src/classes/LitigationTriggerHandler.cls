/**
 * 
 *    Created by Joshua Moody
 *    on Mar 14 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class LitigationTriggerHandler {
     /***********************************************************
   * This class handles all trigger contexts for the Litigation__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Call services classes to do date calculations
   * 5. Retrieve constant values saved in custom metadata
   * 6. Performs status calculations
   ***********************************************************/ 

    private static Map<String,Constant__mdt> litigationCalcOffsets = litigationCalcOffsets();
    //FINAL Litigation Record Types
    private static FINAL String INT_LITIGATION = litigationCalcOffsets.get('Int_Lit_Calc_Initiation_Sig').ADCVD_Objects__r.Record_Type_Name__c;
    private static FINAL String REMAND = litigationCalcOffsets.get('Remand_Calc_Draft_Remand_Release').ADCVD_Objects__r.Record_Type_Name__c;

    public static void mainEntry(List<Litigation__c> newList, List<Litigation__c> oldList, Map<Id, Litigation__c> newMap, 
        Map<Id, Litigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
        if(isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            setCaseValuesFromParent(newList);
        }
    }


    /****************************************
    * Class Level Variables
    ****************************************/

    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    @TestVisible private static List<Litigation__c> clonedList = new List<Litigation__c>();


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Litigation__c> newList) {
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap('Litigation__c');
    }

    @TestVisible private static void calculateLitigationDates(List<Litigation__c> newList) {
        Map<String,List<Litigation__c>> recordTypeNametoLitigationListMap = new Map<String,List<Litigation__c>>();
        for (Litigation__c l : newList) {
            if (recordTypeNametoLitigationListMap.get(recordTypeNameMap.get(l.RecordTypeId)) != null) {
                recordTypeNametoLitigationListMap.get(recordTypeNameMap.get(l.RecordTypeId)).add(l);
            } else {
                recordTypeNametoLitigationListMap.put(recordTypeNameMap.get(l.RecordTypeId), new List<Litigation__c>{l});
            }
        }
        for (String recordTypeName : recordTypeNametoLitigationListMap.keySet()) {
            DateCalculationService dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance(recordTypeName);
            dcs.getCalculatedDates(recordTypeNametoLitigationListMap.get(recordTypeName), 'Litigation__c', recordTypeName);
        }
    }

    @TestVisible private static void calculateLitigationStatuses(List<Litigation__c> newList) {
        setStatus(newList);
    }

    @TestVisible private static void setCaseValuesFromParent (List<Litigation__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        Map<String,Map<Id,SObject>> parentTypeToChildToParentMap = getParentSObjects(newList);
        for (Litigation__c l : newList) {
            Litigation__c newLit = l.clone(true, false,false,true);
            for (String parentType : parentTypeToChildToParentMap.keySet()) {
                if (newLit.get(parentType) == null) {
                    continue;
                } else {
                    pvs.setCaseValuesFromParent(parentTypeToChildToParentMap.get(parentType).get(newLit.Id), newLit);
                }
            }
        clonedList.add(newLit);
        }
        update clonedList;
    }


    /***********************************
    * Helper Methods
    ***********************************/

    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> litigationCalcOffsets() {
        Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
        List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
                                                ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
                                        FROM Constant__mdt 
                                        WHERE Litigation_Calculation_Offset__c =: true];
        for(Constant__mdt lc : tempList) {
            returnMap.put(lc.QualifiedAPIName, lc);
        }
        return returnMap;
    }

    //TODO: Move to Selector
    @TestVisible private static List<Litigation__c> getLitWithParentCaseValues(List<Litigation__c> newList) {
        List<Litigation__c> returnList = new List<Litigation__c>();
        for (Litigation__c l : [SELECT Id, Petition__c, Investigation__c, Segment__c, ADCVD_Case__c, ADCVD_Case_Number__c, ADCVD_Case_Type__c, Country__c, Product__c, Product_Short_Name__c, 
                                        Petition__r.ADCVD_Case_Number__c, Petition__r.ADCVD_Case__c, Petition__r.ADCVD_Case_Type__c, Petition__r.Country__c, Petition__r.Product__c, Petition__r.Product_Short_Name__c, Petition__r.Commodity__c, 
                                        Investigation__r.ADCVD_Case_Number__c, Investigation__r.ADCVD_Case__c, Investigation__r.ADCVD_Case_Type__c, Investigation__r.Country__c, Investigation__r.Product__c, Investigation__r.Product_Short_Name__c, 
                                        Investigation__r.Period_Covered_Start_Date__c, Investigation__r.Period_Covered_End_Date__c, Investigation__r.Commodity__c, 
                                        Segment__r.ADCVD_Order__c, Segment__r.Suspension_Agreement__c, Segment__r.ADCVD_Case_Number__c, Segment__r.ADCVD_Case__c, Segment__r.ADCVD_Case_Type__c, Segment__r.Country__c, Segment__r.Product_Short_Name__c, 
                                        Segment__r.Product__c, Segment__r.Period_Covered_Start_Date__c, Segment__r.Period_Covered_End_Date__c, Segment__r.Requestor__c, Segment__r.Product_Description__c, Segment__r.Commodity__c 
                                        FROM Litigation__c WHERE Id IN: newList]) {
            returnList.add(l);
        }
        return returnList;
    }

    @TestVisible private static Map<String,Map<Id,SObject>> getParentSObjects(List<Litigation__c> newList) {
        List<Litigation__c> litWithParentCaseValues = getLitWithParentCaseValues(newList);
        Map<String,Map<Id,SObject>> returnMap = new Map<String,Map<Id,SObject>>();
        for (Litigation__c l : litWithParentCaseValues) {
            Map<Id,SObject> childIdToParentMap = new Map<Id,SObject>();
            SObject parent = null;
            String parentType = '';
            String parentRelationshipField = '';
            ParentSortingService pss = new ParentSortingService();
            parentType = pss.getParentSObjectType(l, 'Litigation__c');
            System.debug('parentType: ' + parentType);
            parentRelationshipField = parentType.replace('__c', '__r');
            parent = l.getSObject(parentRelationshipField);
            parent.put('Id', l.get(parentType));
            if (parentRelationshipField == 'Segment__r') {
                parent.put('ADCVD_Order__c', parent.get('ADCVD_Order__c'));
                parent.put('Suspension_Agreement__c', parent.get('Suspension_Agreement__c'));
            }
            ParentValuesService pvs = new ParentValuesService();
            pvs.setCaseValuesFromParent(parent, parent);
            childIdToParentMap.put((Id)l.get('Id'),parent);
            Map<Id,SObject> tempMap = new Map<Id,SObject>();
            if (returnMap.get(parentType) != null) {
                tempMap = returnMap.get(parentType);
            }
            for (Id childId : childIdToParentMap.keySet()) {
                tempMap.put(childId, childIdToParentMap.get(childId));
            }
            returnMap.put(parentType,tempMap);
        }
        return returnMap;
    }

    /****************************
    * Status Calculations
    ****************************/
    //calls the setPreliminaryStatus, setFinalStatus, setClosedStatus methods
    @TestVisible private static void setStatus(List<Litigation__c> newList) {
        for(Litigation__c l : newList) {
            setPreliminaryStatus(l);
            setFinalStatus(l);
            setClosedStatus(l);
        }
    }
    //sets Litigation Status to Preliminary if  both Actual_Preliminary_Signature__c and Actual_Final_Signature__c are null
    @TestVisible private static void setPreliminaryStatus(Litigation__c l){
        if (recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if(l.Actual_Preliminary_Signature__c == null && l.Actual_Final_Signature__c == null ) {
                l.Status__c = 'Preliminary';
            }
        } else if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if(l.Actual_Draft_Remand_released_to_party__c == null && l.Actual_Final_Signature__c == null) {
                l.Status__c = 'Preliminary';
            }
        }   
    }
    //sets Litigation Status to Final if Actual_Final_Signature__c is null and Actual_Preliminary_Signature__c is not null
    @TestVisible private static void setFinalStatus(Litigation__c l){
        if (recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if(l.Actual_Preliminary_Signature__c != null && l.Actual_Final_Signature__c == null){
                l.Status__c = 'Final';
            } 
        } else if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if(l.Actual_Draft_Remand_released_to_party__c != null && l.Actual_Final_Signature__c == null){
                l.Status__c = 'Final';
            }  
        }
    }    
    //sets Litigation Status to Completed if both Actual_Preliminary_Signature__c and Actual_Final_Signature__c are not null
    @TestVisible private static void setClosedStatus(Litigation__c l) {
        if (recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if(l.Actual_Final_Signature__c != null && l.Actual_Preliminary_Signature__c != null) {
                l.Status__c = 'Closed';
            }
        } else if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if(l.Actual_Final_Signature__c != null && l.Actual_Draft_Remand_released_to_party__c != null) {
                l.Status__c = 'Closed';
            }
        }
    }
}