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
            setDefaultProgramManager(newList);
            validateOneProgramManager(buildStaffListByParentInsertUpdate(newList),newList,false);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            setDefaultProgramManager(newList);
            validateOneProgramManager(buildStaffListByParentInsertUpdate(newList),newList,false);
        }
        if (isBefore && isDelete) {
            newList = new LockedRecordHandler().removeLockedRecords(oldList);
            initialize(oldList, oldMap);
            validateOneProgramManager(buildStaffListByParentForDelete(oldList),oldList,true);
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
    
    public class StaffingException extends Exception {}

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
            } else if(sa.Suspension_Agreement__c != null) {
                parentName = 'Suspension_Agreement__c';
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
    //used to set the default user for User__c on a Staffing Assignment on insert when Title__c is "Program Manager"
    @TestVisible private static void setDefaultProgramManager (List<Staffing_Assignment__c> newList) {
        //"Please Assign" user
        User pleaseAssignUser = new User();
        for (User u : [SELECT Id FROM User WHERE LastName = 'Please Assign']) {
            pleaseAssignUser = u;
        }
        if (pleaseAssignUser == null) {return;}
        for (Staffing_Assignment__c sa : newList) {
            if (sa.Title__c == 'Program Manager' && sa.User__c == null) {
                sa.User__c = pleaseAssignUser.Id;
            }
        }
    }
    
    @TestVisible private static Map<Id, List<Staffing_Assignment__c>> buildStaffListByParentInsertUpdate (List<Staffing_Assignment__c> newList) {
        staffMapper = (StaffingAssignmentMapper) caseMapper.getMapper('Staffing_Assignment__c');
        Map <Id, List<Staffing_Assignment__c>> returnMap = new Map<Id, List<Staffing_Assignment__c>>();
        Set<Id> existingStaffRecords = new Set<Id>();
        //add new Staff to Map
        for (Staffing_Assignment__c sa : newList) {
            if(sa.User__c == null) {continue;}
            if(sa.Id != null) {existingStaffRecords.add(sa.Id);}
            List<Staffing_Assignment__c> tempList = new List<Staffing_Assignment__c>();
            Id parentId = (Id)sa.get(sa.Staff_Parent__c);
            if (parentId != null && !returnMap.isEmpty() && returnMap.get(parentId) != null && !returnMap.get(parentId).isEmpty()) {
                tempList.addAll(returnMap.get(parentId));
            }
            tempList.add(sa);
            returnMap.put(parentId, tempList);
        }
        if (staffMapper.getParentIdToStaffMap().isEmpty()) {return returnMap;}
        
        //add existing Staff to Map if not already in map (keep the newest version)
        //separate iteration over newlist needed to confirm newest version is kept
        for (Id parentId : returnMap.keySet()) {
            if (!staffMapper.getParentIdToStaffMap().containsKey(parentId) || staffMapper.getParentIdToStaffMap().get(parentId).isEmpty()) {continue;}
            for (Staffing_Assignment__c sa : staffMapper.getParentIdToStaffMap().get(parentId).values()) {
                if (existingStaffRecords.contains(sa.Id)) {continue;}//skip if already in the returnMap
                List<Staffing_Assignment__c> tempList = new List<Staffing_Assignment__c>();
                if (!returnMap.isEmpty() && returnMap.get(parentId) != null && !returnMap.get(parentId).isEmpty()) {
                    tempList.addAll(returnMap.get(parentId));
                }
                tempList.add(sa);
                returnMap.put(parentId, tempList);
            }
        }
        return returnMap;
    }
    
    @TestVisible private static Map<Id, List<Staffing_Assignment__c>> buildStaffListByParentForDelete (List<Staffing_Assignment__c> newList) {
        staffMapper = (StaffingAssignmentMapper) caseMapper.getMapper('Staffing_Assignment__c');
        Map <Id, List<Staffing_Assignment__c>> returnMap = new Map<Id, List<Staffing_Assignment__c>>();
        Set<Id> staffToBeDeleted = new Set<Id>();
        Set<Id> parentIdsInScope = new Set<Id>();
        //add new Staff to Map
        for (Staffing_Assignment__c sa : newList) {
            if(sa.Id != null) {staffToBeDeleted.add(sa.Id);}
            parentIdsInScope.add((Id)sa.get(sa.Staff_Parent__c));
        }
     
        //add existing Staff to Map if not already in map (keep the newest version)
        //separate iteration over newlist needed to confirm newest version is kept
        for (Id parentId : parentIdsInScope) {
            if (staffMapper.getParentIdToStaffMap().get(parentId).isEmpty()) {continue;}
            for (Staffing_Assignment__c sa : staffMapper.getParentIdToStaffMap().get(parentId).values()) {
                if (staffToBeDeleted.contains(sa.Id)) {continue;}//not already in a returnMap
                List<Staffing_Assignment__c> tempList = new List<Staffing_Assignment__c>();
                if (!returnMap.isEmpty() && returnMap.get(parentId) != null && !returnMap.get(parentId).isEmpty()) {
                    tempList.addAll(returnMap.get(parentId));
                }
                tempList.add(sa);
                returnMap.put(parentId, tempList);
            }
        }
        return returnMap;
    }
    //Validates there is only one Staffing Assignment with Title__c == to "Program Manager" per parent
    //Iterates through staffing assignments by parent ensuring there is one and only one Program Manager per parent
    @TestVisible private static void validateOneProgramManager (Map <Id, List<Staffing_Assignment__c>> staffListByParentMap,List<Staffing_Assignment__c> newList,Boolean isDelete) {
        
        List<Staffing_Assignment__c> staffingAssignments = [SELECT Id,Suspension_Agreement__c,Title__c,User__c,Petition__c,Investigation__c,Segment__c,ADCVD_Order__c,Related_Organization__c 
                                                            FROM Staffing_Assignment__c WHERE Petition__c IN: staffListByParentMap.keySet() 
                                                            OR Investigation__c IN: staffListByParentMap.keySet()
                                                            OR Segment__c IN: staffListByParentMap.keySet()
                                                            OR ADCVD_Order__c IN: staffListByParentMap.keySet()
                                                            OR Related_Organization__c IN: staffListByParentMap.keySet()
                                                            OR Suspension_Agreement__c IN: staffListByParentMap.keySet()
                                                             ];
        
        Map<Id,Integer> programMangerByParent = new Map<Id,Integer>();
        set<String> staffIdProgramManager = new set<String>();
        
        for(Staffing_Assignment__c sa : staffingAssignments){
            
            if(sa.Title__c=='Program Manager'){
                
                String parentId;
                                
                if(sa.Petition__c != null) {
                    parentId = sa.Petition__c;
                } else if(sa.Investigation__c != null) {
                    parentId = sa.Investigation__c;
                } else if(sa.Segment__c != null) {
                    parentId = sa.Segment__c;
                } else if(sa.ADCVD_Order__c != null) {
                    parentId = sa.ADCVD_Order__c;
                } else if(sa.Related_Organization__c != null) {
                    parentId = sa.Related_Organization__c;
                } else if(sa.Suspension_Agreement__c != null) {
                    parentId = sa.Suspension_Agreement__c;
                }
                
                staffIdProgramManager.add(sa.Id);
                
                if(programMangerByParent.containsKey(parentId)){
                   
                   Integer i = programMangerByParent.get(parentId);
                   i=i+1;
                   programMangerByParent.put(parentId,i);
                    
                } else {
                   programMangerByParent.put(parentId,1); 
                }
                
                
                
            }
            
        } 
                   
        for(Staffing_Assignment__c sa : newList){
            
            if(sa.Id != null){
                
                String parentId;
                                    
                if(sa.Petition__c != null) {
                    parentId = sa.Petition__c;
                } else if(sa.Investigation__c != null) {
                    parentId = sa.Investigation__c;
                } else if(sa.Segment__c != null) {
                    parentId = sa.Segment__c;
                } else if(sa.ADCVD_Order__c != null) {
                    parentId = sa.ADCVD_Order__c;
                } else if(sa.Related_Organization__c != null) {
                    parentId = sa.Related_Organization__c;
                } else if(sa.Suspension_Agreement__c != null) {
                    parentId = sa.Suspension_Agreement__c;
                }
                
                if(programMangerByParent.containsKey(parentId)){
                       
                   Integer i = programMangerByParent.get(parentId);
                   
                   if(i==1 && staffIdProgramManager.contains(sa.Id) && sa.Title__c != 'Program Manager'){
                      
                       sa.addError('At least one Program Manager needs to be assigned to a record.');
                   
                   } else if(isDelete && i==1 && staffIdProgramManager.contains(sa.Id) && sa.Title__c == 'Program Manager'){
                       sa.addError('At least one Program Manager needs to be assigned to a record.');
                       
                   }
                   
                } else {
                    
                    sa.addError('At least one Program Manager needs to be assigned to a record.');
                    
                }    
            }
                        
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