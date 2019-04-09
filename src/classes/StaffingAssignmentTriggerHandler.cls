/**
*
*    Created by Joshua Moody
*    on Jan 4 2019
*    MIL Corporation
*
**/
public without sharing class StaffingAssignmentTriggerHandler {
    /***********************************************************
    * This class handles all trigger contexts for the Staffing_Assignment__c
    * object.  It provides methods that:
    * 1. Organize the flow of logic for each trigger context
    * 2. Initialize class variables
    * 3. Help in the mapping of related objects
    * 4. Call services classes
    * 5. Retrieve constant values saved in custom metadata
    ***********************************************************/
    
    public static void mainEntry (List<Staffing_Assignment__c> newList, List<Staffing_Assignment__c> oldList, Map<Id, Staffing_Assignment__c> newMap,
        Map<Id, Staffing_Assignment__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete,
        Boolean isBefore, Boolean isAfter) {

        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            setCaseValues(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
        }
        if (isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
        }
        if (isAfter && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
        }

    }
    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    //Mapper declared that will be initialized after caseMapper is initialized
    @TestVisible private static StaffingAssignmentMapper staffMapper;
    //Mapper declared that will be initialized in the initialize method
    @TestVisible private static ADCVD_CaseMapper caseMapper;

    //method to initialize the caseMapper and if newMap is passed (after insert/update) it will add the new staff to the Mappers
    @TestVisible private static void initialize(List<Staffing_Assignment__c> newList, Map<Id,Staffing_Assignment__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper = caseMapper.getInstance(caseIdSet);
        if (newMap != null) {
            addNewStaffToMappers(newMap);
        }
    }
    //method to get the case Ids from the parents.  If a list of Staff is added that have parents from all 5 potential
    //parents, all 5 queries will run.  This should only be called in the initialize method.
    @TestVisible private static Set<Id> getCaseIdSet (List<Staffing_Assignment__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        String parentName = '';
        for (Staffing_Assignment__c sa : newList) {
            if (sa.ADCVD_Case__c != null) {
                caseIdSet.add(sa.ADCVD_Case__c);
            }
            if(sa.Petition__c != null) {
                parentName = 'Petition__c';
            } else if(sa.Investigation__c != null) {
                parentName = 'Investigation__c';
            } else if(sa.Segment__c != null) {
                parentName = 'Segment__c';
            } else if(sa.ADCVD_Order__c != null) {
                parentName = 'ADCVD_Order__c';
            } else if(sa.Related_Organization__c != null) {
                parentName = 'Related_Organization__c';
            }
            setSaParent(sa, parentName);
        }
        return caseIdSet;
    }
    //used to set the ADCVD_Case__c field on the Staffing Assignments based on the value in the parents
    @TestVisible private static void setCaseValues(List<Staffing_Assignment__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Staffing_Assignment__c sa : newList) {
            Id parentId = (Id) sa.get(sa.Staff_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(sa.Staff_Parent__c).getInstance();
            sa = (Staffing_Assignment__c) pvs.setCaseValuesFromParent(adcvdMapper.getMap(true).get(parentId), sa);
        }
    }
    //Sets Staff_Parent__c to the DeveloperName of the field of the parent (allows .get(Staff_Parent__c) to retrieve the Id of the parent)
    @TestVisible private static void setSaParent (Staffing_Assignment__c sa, String parentName) {
        if (String.isBlank(sa.Staff_Parent__c)) {
            sa.Staff_Parent__c = parentName;
        }
    }
    //method to add the Staff from the recent insert/update to the staffMapper, the caseMapper,
    //and update the StaffingAssignmentMapper instance in the map of selectors with the new Staff
    @TestVisible private static void addNewStaffToMappers(Map<Id,Staffing_Assignment__c> newMap) {
        Map<Id,List<Staffing_Assignment__c>> caseToStaffMap = new Map<Id,List<Staffing_Assignment__c>>();
        //get the StaffingAssignmentMapper instance from the caseMapper
        staffMapper = (StaffingAssignmentMapper) caseMapper.getMapper('Staffing_Assignment__c').getInstance();
        for (Staffing_Assignment__c sa : newMap.values()) {
            //update StaffingAssignmentMapper instance
            staffMapper.addStaffToMap(sa);
            List<Staffing_Assignment__c> tempList = caseToStaffMap.get(sa.ADCVD_Case__c) != null ?
                caseToStaffMap.get(sa.ADCVD_Case__c) : new List<Staffing_Assignment__c>();
            tempList.add(sa);
            caseToStaffMap.put(sa.ADCVD_Case__c, tempList);
        }
        //add the Staff to the case Maps
        for (Id caseId : caseToStaffMap.keySet()) {
            caseMapper.setCaseIdToStaffingMap(caseId, caseToStaffMap.get(caseId));
        }
        //replace the StaffingAssignmentMapper in the caseMapper map with the new updated one
        caseMapper.putMapper('Staffing_Assignment__c', staffMapper);
    }
}