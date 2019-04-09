/**
 *
 *    Created by Joshua Moody
 *    on 1/4/2019
 *    MIL Corporation
 *
 **/
public without sharing class StaffingAssignmentMapper implements ADCVD_IMapper{

    //get the instance from the ADCVD_CaseMapper
    public static StaffingAssignmentMapper instance = (StaffingAssignmentMapper)ADCVD_CaseMapper.mapperMap.get('Staffing_Assignment__c');
    //Maps of unlocked and of all staffing assignments.  The unlocked map is primarily used when updating staffing assignments, the unlocked
    //map is sometimes used to retrieve values when updating other related objects
    public static Map<Id,Staffing_Assignment__c> idToUnlockedStaffingMap = new Map<Id,Staffing_Assignment__c>();
    public static Map<Id,Staffing_Assignment__c> idToAllStaffingMap = new Map<Id,Staffing_Assignment__c>();
    /**
    * The first Id in the parentIdToStaffMap is the Id of the Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment
    * The inner map is the Id of the Staffing Assignment and then the Staffing Assignment itself.  This map contains all Staffing Assignments - this can
    * be reviewed at a later date once we have a archiving/locking solution
    */
    public static Map<Id, Map<Id, Staffing_Assignment__c>> parentIdToStaffMap = new Map<Id, Map<Id, Staffing_Assignment__c>>();

    private static List<Staffing_Assignment__c> orphanedStaffing = new List<Staffing_Assignment__c>();

    //no param constructor used in the ADCVD_CaseMapper on initialization
    public StaffingAssignmentMapper() {}

    //private contructor used via the getNewInstance method
    @TestVisible
    private StaffingAssignmentMapper(Set<Id> staffingIdSet) {
        if(idToUnlockedStaffingMap.isEmpty()) {
            for (Staffing_Assignment__c sa : StaffingAssignmentSelector.newInstance().selectById(staffingIdSet)) {
                addStaffToMap(sa);
            }
            if (!orphanedStaffing.isEmpty()) {deleteOrphanedStaffing();}//delete orphaned staffing
        }
    }

    //primary method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
    public static StaffingAssignmentMapper getInstance () {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }

    //exposed method for getting a new instance of this selector. will overwrite the existing instance in the ADCVD_CaseMapper
    public static StaffingAssignmentMapper getNewInstance() {
        Set<Id> staffingIdSet = new Set<Id>();
        for (Id caseId : ADCVD_CaseMapper.caseIdToStaffingIdMap.keySet()) {
            staffingIdSet.addAll(ADCVD_CaseMapper.caseIdToStaffingIdMap.get(caseId));
        }
        instance = new StaffingAssignmentMapper(staffingIdSet);
        ADCVD_CaseMapper.mapperMap.put('Staffing_Assignment__c', instance);
        return instance;
    }

    //gets the unlocked staffing assignment map
    public Map<Id,Staffing_Assignment__c> getMap() {
        return idToUnlockedStaffingMap;
    }

    //accepts a param to specify the return of either all staffing assignments or only unlocked ones
    public Map<Id,Staffing_Assignment__c> getMap(Boolean includeLocked) {
        if (includeLocked) {
            return idToAllStaffingMap;
        } else {
            return idToUnlockedStaffingMap;
        }
    }

    //method to add new or updated staffing assignments to the maps, called in this class and in the staffing assignment trigger handler
    public void addStaffToMap(Staffing_Assignment__c sa) {
        if (sa.Staff_Parent__c == null || sa.get(sa.Staff_Parent__c) == null) {
            orphanedStaffing.add(sa);
        } else {
            if (!sa.Locked__c) {
                idToUnlockedStaffingMap.put(sa.Id, sa);
            }
            idToAllStaffingMap.put(sa.Id, sa);
            setParentIdToStaffMap(sa);
        }
    }

    //method to return the parentIdToStaffMap
    public Map<Id, Map<Id,Staffing_Assignment__c>> getParentIdToStaffMap() {
        return parentIdToStaffMap;
    }

    @Future
    private static void deleteOrphanedStaffing() {
        delete orphanedStaffing;
    }

    //method to update the parentIdToStaffMap
    private void setParentIdToStaffMap(Staffing_Assignment__c sa) {
        //Create a temporary map
        Map<Id, Staffing_Assignment__c> tempMap;
        //Populate the maps with each Staffing Assignment returned
        Id parentId = (Id)sa.get(sa.Staff_Parent__c);
        tempMap = parentIdToStaffMap.containsKey(parentId) ?
            parentIdToStaffMap.get(parentId) : new Map<Id, Staffing_Assignment__c>();
        tempMap.put(sa.Id, sa);
        parentIdToStaffMap.put(parentId, tempMap);
    }
}