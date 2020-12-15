/**
 *
 *    Created by Joshua Moody
 *    on Feb 21 2017
 *    MIL Corporation
 *
 **/
 public without sharing class FederalRegisterTriggerHandler {
     /***********************************************************
   * This class handles all trigger contexts for the Federal_Register__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Query and map parents that are affected by the new
   * or updated Federal Register records
   * 5. Update the parents in scope
   ***********************************************************/

    public static void mainEntry(List<Federal_Register__c> newList, List<Federal_Register__c> oldList, Map<Id, Federal_Register__c> newMap,
        Map<Id, Federal_Register__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete,
        Boolean isBefore, Boolean isAfter){

        if (!AppConfigService.triggerEnabled) {return;}

        if(isBefore && isInsert) {
            initialize(newList, null);
            setCaseValues(newList);
        }
        if(isAfter && isInsert) {
            initialize(newList, newMap);
            recalculateParentsOfFederalRegister(newList);
            //new ChatterPostWriter('Federal_Register__c', newMap, oldMap);
        }
        if(isBefore && isUpdate) {
            updateFrParent(newList);
        }
        if(isAfter && isUpdate) {
            initialize(newList, newMap);
            recalculateParentsOfFederalRegister(newList);
            //new ChatterPostWriter('Federal_Register__c', newMap, oldMap);
        }
        if(isAfter && isDelete) {
            initialize(oldMap.values(), null);
            recalculateParentsOfFederalRegister(oldMap.values());
        }
    }

    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    //Mapper declared that will be initialized after caseMapper is initiatlized
    @TestVisible private static FederalRegisterMapper frMapper;
    //Mapper declared that will be initialized in the initialize method
    @TestVisible private static ADCVD_CaseMapper caseMapper;

    //method to initialize the caseMapper and if newMap is passed (after insert/update) it will add the new FRs to the Mappers
    @TestVisible private static void initialize(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper = caseMapper.getInstance(caseIdSet);
        if (newMap != null) {
            addNewFrsToMappers(newMap);
        }
    }
    //method to get the case Ids from the parents.  If a list of FRs is added that have parents from all 5 potential
    //parents, all 5 queries will run.  This should only be called in the initialize method.
     @TestVisible private static void updateFrParent (List<Federal_Register__c> newList) {
         for (Federal_Register__c fr : newList) {
             if (fr.Petition__c != null) {
                 fr.FR_Parent__c = 'Petition__c';
             } else if (fr.Investigation__c != null) {
                 fr.FR_Parent__c = 'Investigation__c';
             } else if (fr.Segment__c != null) {
                 fr.FR_Parent__c = 'Segment__c';
             } else if (fr.ADCVD_Order__c != null) {
                 fr.FR_Parent__c = 'ADCVD_Order__c';
             } else if (fr.Suspension_Agreement__c != null) {
                 fr.FR_Parent__c = 'Suspension_Agreement__c';
             }
         }
     }
     @TestVisible private static Set<Id> getCaseIdSet(List<Federal_Register__c> newList) {
         Set<Id> caseIdSet = new Set<Id>();
         Set<Id> petitionIdSet = new Set<Id>();
         Set<Id> investigationIdSet = new Set<Id>();
         Set<Id> orderIdSet = new Set<Id>();
         Set<Id> suspAgrmtIdSet = new Set<Id>();
         Set<Id> segmentIdSet = new Set<Id>();
         for (Federal_Register__c fr : newList) {
             if (fr.Petition__c != null) {
                 setFrParent(fr, 'Petition__c');
                 petitionIdSet.add(fr.Petition__c);
             } else if (fr.Investigation__c != null) {
                 setFrParent(fr, 'Investigation__c');
                 investigationIdSet.add(fr.Investigation__c);
             } else if (fr.Segment__c != null) {
                 setFrParent(fr, 'Segment__c');
                 segmentIdSet.add(fr.Segment__c);
             } else if (fr.ADCVD_Order__c != null) {
                 setFrParent(fr, 'ADCVD_Order__c');
                 orderIdSet.add(fr.ADCVD_Order__c);
             } else if (fr.Suspension_Agreement__c != null) {
                 setFrParent(fr, 'Suspension_Agreement__c');
                 suspAgrmtIdSet.add(fr.Suspension_Agreement__c);
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
        for (Suspension_Agreement__c sa : [SELECT ADCVD_Case__c FROM Suspension_Agreement__c WHERE Id IN: suspAgrmtIdSet]) {
            caseIdSet.add(sa.ADCVD_Case__c);
        }
        return caseIdSet;
    }
    //used to set the ADCVD_Case__c field on the FRs based on the value in the parents
    @TestVisible private static void setCaseValues(List<Federal_Register__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Federal_Register__c fr : newList) {
            Id parentId = (Id) fr.get(fr.FR_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(fr.FR_Parent__c).getInstance();
            fr = (Federal_Register__c) pvs.setCaseValuesFromParent(adcvdMapper.getMap(true).get(parentId), fr);
        }
    }
    //Sets FR_Parent__c to the DeveloperName of the field of the parent (allows .get(FR_Parent__c) to retrieve the Id of the parent)
    @TestVisible private static void setFrParent (Federal_Register__c fr, String parentName) {
        if (String.isBlank(fr.FR_Parent__c)) {
            fr.FR_Parent__c = parentName;
        }
    }
    //method to add the FRs from the recent insert/update to the frMapper, the caseMapper,
    //and update the FederalRegisterMapper instance in the map of selectors with the new FRs
    @TestVisible private static void addNewFrsToMappers(Map<Id,Federal_Register__c> newMap) {
        Map<Id,List<Federal_Register__c>> caseToFrsMap = new Map<Id,List<Federal_Register__c>>();
        //get the FederalRegisterMapper instance from the caseMapper
        frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
        for (Federal_Register__c fr : newMap.values()) {
            //update FederalRegisterMapper instance
            frMapper.addFrToMap(fr);
            List<Federal_Register__c> tempList = caseToFrsMap.get(fr.ADCVD_Case__c) != null ?
                                                   caseToFrsMap.get(fr.ADCVD_Case__c) : new List<Federal_Register__c>();
            tempList.add(fr);
            caseToFrsMap.put(fr.ADCVD_Case__c, tempList);
        }
        //add the FRs to the case Maps
        for (Id caseId : caseToFrsMap.keySet()) {
            caseMapper.setCaseIdToFrMap(caseId, caseToFrsMap.get(caseId));
        }
        //replace the FederalRegisterMapper in the caseMapper map with the new updated one
        caseMapper.putMapper('Federal_Register__c', frMapper);
    }

    /**
     * Method for getting the parents of FRs and adding FRs to a list to instantiate FRUtility instances for
     * @param  newList new FRs in scope
     * @param  oldMap  the version of new FRs prior to update, used for updating parents on delete
     * @return         Set of Ids from Investigations, Segments, ADCVD Orders or FRs
     */
    @TestVisible private static Set<Id> findParentsInScope(List<Federal_Register__c> newList) {
        Set<Id> parentIdSet = new Set<Id>();
        for(Federal_Register__c fr : newList) {
            //add this FRs parent Id to the parents that need an update
            parentIdSet.add((Id)fr.get(fr.FR_Parent__c));
            //add related parent Ids to the parents that need an update
            parentIdSet.addAll(findRelatedInScope(fr));
        }
        return parentIdSet;
    }

    @TestVisible private static Set<Id> findRelatedInScope(Federal_Register__c fr) {
        Set<Id> returnIdSet = new Set<Id>();
        //FRs with the type "Order" can affect the investigation
        if (fr.Type__c == 'Order') {
            returnIdSet.addAll(caseMapper.getIdSet(fr.ADCVD_Case__c, 'Investigation__c'));
        }
        return returnIdSet;
    }

    /**
     * Gets parents in scope, then updates them based on new FR values.  In most cases only one update will run, except Segments and ADCVD Orders which will both run when either is updated.
     * @param  newList new FRs in scope
     * @param  oldMap  the version of new FRs prior to update, used for updating parents on delete
     * @return         void
     */
    @TestVisible private static void recalculateParentsOfFederalRegister(List<Federal_Register__c> newList) {
        Set<Id> parentIdSet = findParentsInScope(newList);
        calculatePetitions(parentIdSet);
        calculateInvestigations(parentIdSet);
        calculateOrders(parentIdSet);
        calculateSuspensionAgreements(parentIdSet);
        calculateSegments(parentIdSet);
    }

    @TestVisible private static List<SObject> getUpdateList(Set<Id> parentIdSet, String objectName) {
        ADCVD_IMapper tempMapper = caseMapper.getMapper(objectName).getInstance();
        Map<Id,SObject> masterMap = (Map<Id,SObject>) tempMapper.getMap(false);
        List<SObject> updateList = new List<SObject>();
        for (Id soId : masterMap.keySet()) {
            if (parentIdSet.contains(soId)) {
                updateList.add(masterMap.get(soId));
            }
        }
        return updateList;
    }

    /**
     * Updates the Petitions after FRs have been updated
     * @param  parentIdSet Set of Ids from Petitions, Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculatePetitions(Set<Id> parentIdSet) {
        database.update(getUpdateList(parentIdSet, 'Petition__c'), false);
    }

    /**
     * Updates the Investigations after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateInvestigations(Set<Id> parentIdSet) {
        database.update(getUpdateList(parentIdSet, 'Investigation__c'), false);
    }

    /**
     * Updates the Suspension Agreements after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateSuspensionAgreements(Set<Id> parentIdSet) {
        database.update(getUpdateList(parentIdSet, 'Suspension_Agreement__c'), false);
    }

    /**
     * Updates the ADCVD Orders after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateOrders(Set<Id> parentIdSet) {
        database.update(getUpdateList(parentIdSet, 'ADCVD_Order__c'), false);
    }

    /**
     * Updates the Segments after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateSegments(Set<Id> parentIdSet) {
        database.update(getUpdateList(parentIdSet, 'Segment__c'), false);
    }
}
