public without sharing class FederalRegisterTriggerHandler {
	public static boolean preventRecursion = false;
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
        }
        if(isAfter && isUpdate) {
            initialize(newList, newMap);
            recalculateParentsOfFederalRegister(newList);
        }
        if(isAfter && isDelete) {
            initialize(oldMap.values(), null);
            recalculateParentsOfFederalRegister(oldMap.values());
        }
    }

    //Map to Federal Register Utility instances
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    @TestVisible private static ADCVD_Selector adcvdSelector;
    @TestVisible private static FederalRegisterSelector frSelector;
    @TestVisible private static ADCVD_CaseSelector caseSelector;

    @TestVisible private static void initialize(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseSelector = (ADCVD_CaseSelector) ADCVD_CaseSelector.selectorMap.get('ADCVD_Case__c');
        caseSelector = caseSelector.getInstance(caseIdSet);
        if (newMap != null) {
            addNewFrsToSelectors(newMap);
        }
    }
    @TestVisible private static Set<Id> getCaseIdSet (List<Federal_Register__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> petitionIdSet = new Set<Id>();
        Set<Id> investigationIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> suspAgrmtIdSet = new Set<Id>();
        Set<Id> segmentIdSet = new Set<Id>();
        for (Federal_Register__c fr : newList) {
            if(fr.Petition__c != null) {
                setFrParent(fr, 'Petition__c');
                petitionIdSet.add(fr.Petition__c);
            } else if(fr.Investigation__c != null) {
                setFrParent(fr, 'Investigation__c');
                investigationIdSet.add(fr.Investigation__c);
            } else if(fr.Segment__c != null) {
                setFrParent(fr, 'Segment__c');
                segmentIdSet.add(fr.Segment__c);
            } else if(fr.ADCVD_Order__c != null) {
                setFrParent(fr, 'ADCVD_Order__c');
                orderIdSet.add(fr.ADCVD_Order__c);
            } else if(fr.Suspension_Agreement__c != null) {
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

    @TestVisible private static void setCaseValues(List<Federal_Register__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Federal_Register__c fr : newList) {
            Id parentId = (Id) fr.get(fr.FR_Parent__c);
            adcvdSelector = (ADCVD_Selector) caseSelector.getSelector(fr.FR_Parent__c).getInstance();
            fr = (Federal_Register__c) pvs.setCaseValuesFromParent(adcvdSelector.getMap(false).get(parentId), fr);
        }
    }

    @TestVisible private static void setFrParent (Federal_Register__c fr, String parentName) {
        if (String.isBlank(fr.FR_Parent__c)) {
            fr.FR_Parent__c = parentName;
        }
    }

    @TestVisible private static void addNewFrsToSelectors(Map<Id,Federal_Register__c> newMap) {
        Map<Id,List<Federal_Register__c>> caseToFrsMap = new Map<Id,List<Federal_Register__c>>();
        frSelector = (FederalRegisterSelector) caseSelector.getSelector('Federal_Register__c');
        for (Federal_Register__c fr : newMap.values()) {
            frSelector.addFrToMap(fr);
            List<Federal_Register__c> tempList = caseToFrsMap.get(fr.ADCVD_Case__c) != null ?
                                                   caseToFrsMap.get(fr.ADCVD_Case__c) : new List<Federal_Register__c>();
            tempList.add(fr);
            caseToFrsMap.put(fr.ADCVD_Case__c, tempList);
        }
        for (Id caseId : caseToFrsMap.keySet()) {
            caseSelector.setCaseIdToFrMap(caseId, caseToFrsMap.get(caseId));
        }
        caseSelector.putSelector('Federal_Register__c', frSelector);
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
            parentIdSet.add((Id)fr.get(fr.FR_Parent__c));
            parentIdSet.addAll(findRelatedInScope(fr));
        }
        return parentIdSet;  
    }

    @TestVisible private static Set<Id> findRelatedInScope(Federal_Register__c fr) {
        Set<Id> returnIdSet = new Set<Id>();
        if (fr.Type__c == 'Order') {
            returnIdSet.addAll(caseSelector.getIdSet(fr.ADCVD_Case__c, 'Investigation__c'));
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
        //calculateSuspensionAgreements(parentIdSet);
        //calculateSegments(parentIdSet);
    }

    @TestVisible private static List<SObject> getUpdateList(Set<Id> parentIdSet, String objectName) {
        ADCVD_Selector tempSelector = caseSelector.getSelector(objectName).getInstance();
        Map<Id,SObject> masterMap = (Map<Id,SObject>) tempSelector.getMap(false);
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
        List<Suspension_Agreement__c> suspAgrToUpdate = [SELECT Id FROM Suspension_Agreement__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(suspAgrToUpdate, false);
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
        List<Segment__c> segmentsToUpdate = [SELECT Id FROM Segment__c WHERE Id IN: parentIdSet AND Locked__c =: false];
        database.update(segmentsToUpdate, false);
    }
}