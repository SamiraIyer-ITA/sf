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

	public static boolean preventRecursion = false;
    public static void mainEntry(List<Federal_Register__c> newList, List<Federal_Register__c> oldList, Map<Id, Federal_Register__c> newMap, 
        Map<Id, Federal_Register__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        
        if (!AppConfigService.triggerEnabled) {return;}

        if(isAfter && isInsert) {
            recalculateParentsOfFederalRegister(newList,oldMap);
        }
        if(isAfter && isUpdate) {
            recalculateParentsOfFederalRegister(newList,oldMap);
        }
        if(isBefore && isDelete) {
            calculateParentsOnDelete(oldMap);
        }
        if(isAfter && isDelete) {
            recalculateParentsOfFederalRegister(newlist, oldMap);
        }
    }

    //Map to Federal Register Utility instances
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    

    /**
     * Method for getting the parents of FRs and adding FRs to a list to instantiate FRUtility instances for
     * @param  newList new FRs in scope
     * @param  oldMap  the version of new FRs prior to update, used for updating parents on delete
     * @return         Set of Ids from Investigations, Segments, ADCVD Orders or FRs
     */
    @TestVisible private static Set<Id> findParentsInScope(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        Set<Id> parentIdSet = new Set<Id>();
        Set<Id> frIdSet = new Set<Id>();
        Set<Id> tempSet = new Set<Id>();
        for(Federal_Register__c fr : newList) {
            if(fr.Investigation__c != null) {
                parentIdSet.add(fr.Investigation__c);
            } else if (oldMap != null && oldMap.get(fr.Id).Investigation__c != null) {
                parentIdSet.add(oldMap.get(fr.Id).Investigation__c);
            }
            if(fr.Segment__c != null) {
                parentIdSet.add(fr.Segment__c);
            } else if (oldMap != null && oldMap.get(fr.Id).Segment__c != null) {
                parentIdSet.add(oldMap.get(fr.Id).Segment__c);
            }
            if(fr.ADCVD_Order__c != null) {
                parentIdSet.add(fr.ADCVD_Order__c);
                tempSet.add(fr.ADCVD_Order__c);
            } else if (oldMap != null && oldMap.get(fr.Id).ADCVD_Order__c != null) {
                parentIdSet.add(oldMap.get(fr.Id).ADCVD_Order__c);
                tempSet.add(oldMap.get(fr.Id).ADCVD_Order__c);
            }
            if(fr.Suspension_Agreement__c != null) {
                parentIdSet.add(fr.Suspension_Agreement__c);
            } else if (oldMap != null && oldMap.get(fr.Id).Suspension_Agreement__c != null) {
                parentIdSet.add(oldMap.get(fr.Id).Suspension_Agreement__c);
            }
        }
        for (ADCVD_Order__c ao : [SELECT Investigation__c, (SELECT Id FROM Segments__r) FROM ADCVD_Order__c WHERE Id IN: tempSet]) {
            parentIdSet.add(ao.Investigation__c);
            for (Segment__c s : ao.Segments__r) {
                parentIdSet.add(s.Id);
            }
        }
        return parentIdSet;  
    }

    /**
     * gets a list of all FRs for parents in scope to update...this keeps the oldest FR as the one used in calculations
     * @param  parentIdSet Set of Ids from parent Investigations or parent Segments for the FRs in context
     * @return             void
     */
    @TestVisible private static void setFrUtilMap(Set<Id> parentIdSet) {
        List<Federal_Register__c> listForFrUtilMap = new List<Federal_Register__c>();
        for (Federal_Register__c fr : [SELECT Id FROM Federal_Register__c WHERE Investigation__c IN: parentIdSet OR Segment__c IN: parentIdSet 
                                        OR ADCVD_Order__c IN: parentIdSet OR Suspension_Agreement__c IN: parentIdSet]) {
            listForFrUtilMap.add(fr);
        }

        ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(listForFrUtilMap);
        frUtilMap = listInstance.utilMap;
    }

    /**
     * Gets parents in scope, then updates them based on new FR values.  In most cases only one update will run, except Segments and ADCVD Orders which will both run when either is updated.
     * @param  newList new FRs in scope
     * @param  oldMap  the version of new FRs prior to update, used for updating parents on delete
     * @return         void
     */
    @TestVisible private static void recalculateParentsOfFederalRegister(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        Set<Id> parentIdSet = findParentsInScope(newList, oldMap);
        setFrUtilMap(parentIdSet);
        calculateInvestigations(parentIdSet);
        calculateOrders(parentIdSet);
        calculateSuspensionAgreements(parentIdSet);
        calculateSegments(parentIdSet);
    }

    /**
     * Updates the Investigations after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateInvestigations(Set<Id> parentIdSet) {
        List<Investigation__c> investigationsToUpdate = [SELECT Id FROM Investigation__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(investigationsToUpdate, false);
    }

    /**
     * Updates the Suspension Agreements after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateSuspensionAgreements(Set<Id> parentIdSet) {
        List<Suspension_Agreement__c> suspAgrToUpdate = [SELECT Id FROM Suspension_Agreement__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(suspAgrToUpdate, false);
    }

    /**
     * Updates the ADCVD Orders after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateOrders(Set<Id> parentIdSet) {
        List<ADCVD_Order__c> ordersToUpdate = [SELECT Id FROM ADCVD_Order__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(ordersToUpdate, false);
    }

    /**
     * Updates the Segments after FRs have been updated
     * @param  parentIdSet Set of Ids from Investigations, ADCVD Orders, Suspension Agreements, Segments or FRs
     * @return             void
     */
    @TestVisible private static void calculateSegments(Set<Id> parentIdSet) {
        List<Segment__c> segmentsToUpdate = [SELECT Id FROM Segment__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(segmentsToUpdate, false);
    }

    /**
     * Called prior to deleting an FR. This sets a boolean flag on the FR, then updates it,
     * triggering updates to its parents prior it being deleted.
     * @param  oldMap [description]
     * @return        [description]
     */
    @TestVisible private static void calculateParentsOnDelete(Map<Id,Federal_Register__c> oldMap) {
        List<Federal_Register__c> frList = [SELECT Id FROM Federal_Register__c WHERE Id IN: oldMap.keySet()];
        for(Federal_Register__c fr : frList) {
            fr.Do_Delete__c = true;
        }
        update frList;
    }
}