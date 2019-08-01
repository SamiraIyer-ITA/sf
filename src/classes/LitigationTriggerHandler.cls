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
            initialize(newList, newMap);
            setCaseValues(newList);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            calculateLitigationDates(newList);
            calculateLitigationStatuses(newList);
        }
    }

    /****************************************
    * Class Level Variables
    ****************************************/

    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    @TestVisible private static List<Litigation__c> clonedList = new List<Litigation__c>();

    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    //Mapper declared that will be initialized after caseMapper is initialized
    @TestVisible private static LitigationMapper litMapper;
    //Mapper declared that will be initialized in the initialize method
    @TestVisible private static ADCVD_CaseMapper caseMapper;

    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Litigation__c> newList, Map<Id, Litigation__c> newMap) {
        recordTypeNameMap = Utils.getRecordTypeDeveloperNameMap('Litigation__c');
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper = caseMapper.getInstance(caseIdSet);
        if (newMap != null) {
            addNewLitsToMappers(newMap);
        }
    }

    //method to get the case Ids from the parents.  If a list of Litigations is added that have parents from all 3 potential
    //parents, all 3 queries will run.  This should only be called in the initialize method.
    @TestVisible private static Set<Id> getCaseIdSet (List<Litigation__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> petitionIdSet = new Set<Id>();
        Set<Id> investigationIdSet = new Set<Id>();
        Set<Id> segmentIdSet = new Set<Id>();

        for (Litigation__c l : newList) {
            if(l.Petition__c != null) {
                setLitParent(l, 'Petition__c');
                petitionIdSet.add(l.Petition__c);
            } else if(l.Investigation__c != null) {
                setLitParent(l, 'Investigation__c');
                investigationIdSet.add(l.Investigation__c);
            } else if(l.Segment__c != null) {
                setLitParent(l, 'Segment__c');
                segmentIdSet.add(l.Segment__c);
            }
        }

        //Gets all Petitions that are linked to the Litigation and adds the associated case to the casIdSet
        for (Petition__c p : PetitionSelector.newInstance().selectById(petitionIdSet)) {
            caseIdSet.add(p.ADCVD_Case__c);
        }

        for (Investigation__c i : InvestigationSelector.newInstance().selectById(investigationIdSet)) {
            caseIdSet.add(i.ADCVD_Case__c);
        }

        for (Segment__c s : SegmentSelector.newInstance().selectById(segmentIdSet)) {
            caseIdSet.add(s.ADCVD_Case__c);
        }

        return caseIdSet;
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

    //used to set the ADCVD_Case__c field on the Litigations based on the value in the parents
    @TestVisible private static void setCaseValues(List<Litigation__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Litigation__c l : newList) {
            Id parentId = (Id) l.get(l.Litigation_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(l.Litigation_Parent__c).getInstance();
            l = (Litigation__c) pvs.setCaseValuesFromParent(adcvdMapper.getMap(true).get(parentId), l);
        }
    }

     //Sets Litigation_Parent__c to the DeveloperName of the field of the parent (allows .get(Litigation_Parent__c) to retrieve the Id of the parent)
    @TestVisible private static void setLitParent (Litigation__c l, String parentName) {
        if (String.isBlank(l.Litigation_Parent__c)) {
            l.Litigation_Parent__c = parentName;
        }
    }

    //method to add the Litigations from the recent insert/update to the litMapper, the caseMapper,
    //and update the LitigationMapper instance in the map of selectors with the new Litigations
    @TestVisible private static void addNewLitsToMappers(Map<Id,Litigation__c> newMap) {
        Map<Id,List<Litigation__c>> caseToLitsMap = new Map<Id,List<Litigation__c>>();
        //get the LitigationMapper instance from the caseMapper
        litMapper = (LitigationMapper) caseMapper.getMapper('Litigation__c').getInstance();
        for (Litigation__c l : newMap.values()) {
            //update LitigationMapper instance
            litMapper.addLitigationToMap(l);
            List<Litigation__c> tempList = caseToLitsMap.get(l.ADCVD_Case__c) != null ?
            caseToLitsMap.get(l.ADCVD_Case__c) : new List<Litigation__c>();
            tempList.add(l);
            caseToLitsMap.put(l.ADCVD_Case__c, tempList);
        }
        //add the Lits to the case Maps
        for (Id caseId : caseToLitsMap.keySet()) {
            caseMapper.setCaseIdToLitigationMap(caseId, caseToLitsMap.get(caseId));
        }
        //replace the LitigationMapper in the caseMapper map with the new updated one
        caseMapper.putMapper('Litigation__c', litMapper);
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
    //sets Litigation Status to Preliminary if both Actual_Preliminary_Signature__c and Actual_Final_Signature__c are null
    @TestVisible private static void setPreliminaryStatus(Litigation__c l) {
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