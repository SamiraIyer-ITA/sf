/**
 * 
 *    Created by Joshua Moody
 *    on Apr 17 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class RelatedOrganizationTriggerHandler {
    /***********************************************************
   * This class handles all trigger contexts for the Related_Organization__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Call services classes to do get values from parent records
   ***********************************************************/
   
    public static boolean preventRecursion = false;
    public static void mainEntry(List<Related_Organization__c> newList, List<Related_Organization__c> oldList, Map<Id, Related_Organization__c> newMap, 
        Map<Id, Related_Organization__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if(isBefore && isInsert) {
        	newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, null);
            setCaseValues(newList);
        }
        if(isAfter && isInsert) {
        	newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
       //     new StaffingAssignmentService().createStaffFromDefaults(newList, 'Related_Organization__c');
        }
    }

    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    //Mapper declared that will be initialized after caseMapper is initiatlized
    @TestVisible private static RelatedOrganizationMapper ioMapper;
    //Mapper declared that will be initialized in the initialize method
    @TestVisible private static ADCVD_CaseMapper caseMapper;

    //method to initialize the caseMapper and if newMap is passed (after insert/update) it will add the new Interested Orgs to the Mappers
    @TestVisible private static void initialize(List<Related_Organization__c> newList, Map<Id,Related_Organization__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper = caseMapper.getInstance(caseIdSet);
        if (newMap != null) {
            addNewIOsToMappers(newMap);
        }
    }
    //method to get the case Ids from the parents.  If a list of Interested Orgs is added that have parents from all 5 potential
    //parents, all 5 queries will run.  This should only be called in the initialize method.
    @TestVisible private static Set<Id> getCaseIdSet (List<Related_Organization__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> petitionIdSet = new Set<Id>();
        Set<Id> investigationIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> litigationIdSet = new Set<Id>();
        Set<Id> segmentIdSet = new Set<Id>();
        for (Related_Organization__c io : newList) {
            if(io.Petition__c != null) {
                setIoParent(io, 'Petition__c');
                petitionIdSet.add(io.Petition__c);
            } else if(io.Investigation__c != null) {
                setIoParent(io, 'Investigation__c');
                investigationIdSet.add(io.Investigation__c);
            } else if(io.Segment__c != null) {
                setIoParent(io, 'Segment__c');
                segmentIdSet.add(io.Segment__c);
            } else if(io.ADCVD_Order__c != null) {
                setIoParent(io, 'ADCVD_Order__c');
                orderIdSet.add(io.ADCVD_Order__c);
            } else if(io.Litigation__c != null) {
                setIoParent(io, 'Litigation__c');
                litigationIdSet.add(io.Litigation__c);
            }
        }
        for (Petition__c p : [SELECT ADCVD_Case__c FROM Petition__c WHERE Id IN: petitionIdSet]) {
            caseIdSet.add(p.ADCVD_Case__c);
        }
        for (Investigation__c i : [SELECT ADCVD_Case__c FROM Investigation__c WHERE Id IN: investigationIdSet]) {
            caseIdSet.add(i.ADCVD_Case__c);
        }
        for (Segment__c s : [SELECT ADCVD_Case__c FROM Segment__c WHERE Id IN: segmentIdSet]) {
            caseIdSet.add(s.ADCVD_Case__c);
        }
        for (ADCVD_Order__c ao : [SELECT ADCVD_Case__c FROM ADCVD_Order__c WHERE Id IN: orderIdSet]) {
            caseIdSet.add(ao.ADCVD_Case__c);
        }
        for (Litigation__c sa : [SELECT ADCVD_Case__c FROM Litigation__c WHERE Id IN: litigationIdSet]) {
            caseIdSet.add(sa.ADCVD_Case__c);
        }
        return caseIdSet;
    }
    //used to set the ADCVD_Case__c field on the Interested Orgss based on the value in the parents
    @TestVisible private static void setCaseValues(List<Related_Organization__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Related_Organization__c io : newList) {
            Id parentId = (Id) io.get(io.IO_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(io.IO_Parent__c).getInstance();
            ADCVD_Case__c currentCase = (ADCVD_Case__c) caseMapper.getMap(true).get((Id)adcvdMapper.getMap(true).get(parentId).get('ADCVD_Case__c'));
            io.ADCVD_Case__c = currentCase.Id;
            io = (Related_Organization__c) pvs.setCaseValuesFromParent(currentCase, io);
        }
    }
    //Sets IO_Parent__c to the DeveloperName of the field of the parent (allows .get(IO_Parent__c) to retrieve the Id of the parent)
    @TestVisible private static void setIoParent (Related_Organization__c io, String parentName) {
        if (String.isBlank(io.IO_Parent__c)) {
            io.IO_Parent__c = parentName;
        }
    }
    //method to add the Interested Orgss from the recent insert/update to the ioMapper, the caseMapper,
    //and update the FederalRegisterMapper instance in the map of selectors with the new Interested Orgss
    @TestVisible private static void addNewIOsToMappers(Map<Id,Related_Organization__c> newMap) {
        Map<Id,List<Related_Organization__c>> caseToIOsMap = new Map<Id,List<Related_Organization__c>>();
        //get the FederalRegisterMapper instance from the caseMapper
        ioMapper = (RelatedOrganizationMapper) caseMapper.getMapper('Related_Organization__c').getInstance();
        for (Related_Organization__c io : newMap.values()) {
            //update FederalRegisterMapper instance
            ioMapper.addRelOrgToMap(io);
            List<Related_Organization__c> tempList = caseToIOsMap.get(io.ADCVD_Case__c) != null ?
                                                   caseToIOsMap.get(io.ADCVD_Case__c) : new List<Related_Organization__c>();
            tempList.add(io);
            caseToIOsMap.put(io.ADCVD_Case__c, tempList);
        }
        //add the FRs to the case Maps
        for (Id caseId : caseToIOsMap.keySet()) {
            caseMapper.setCaseIdToRelOrgMap(caseId, caseToIOsMap.get(caseId));
        }
        //replace the FederalRegisterMapper in the caseMapper map with the new updated one
        caseMapper.putMapper('Related_Organization__c', ioMapper);
    }
}