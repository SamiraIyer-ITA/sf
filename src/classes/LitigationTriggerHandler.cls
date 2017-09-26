public without sharing class LitigationTriggerHandler {

    private static Map<String,Constant__mdt> litigationCalcOffsets = litigationCalcOffsets();
    //FINAL Litigation Record Types
    private static FINAL String INT_LITIGATION = litigationCalcOffsets.get('Int_Lit_Calc_Initiation_Sig').ADCVD_Objects__r.Record_Type_Name__c;
    private static FINAL String REMAND = litigationCalcOffsets.get('Remand_Calc_Draft_Remand_Release').ADCVD_Objects__r.Record_Type_Name__c;

    public static void mainEntry(List<Litigation__c> newList, List<Litigation__c> oldList, Map<Id, Litigation__c> newMap, 
        Map<Id, Litigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            initialize(newList);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
    }


    /****************************************
    * Class Level Variables
    ****************************************/

    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Litigation__c> newList) {
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
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