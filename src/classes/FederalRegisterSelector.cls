public without sharing class FederalRegisterSelector implements ADCVD_Selector{

    /**
    * This is a selector class to hold Federal Register information for the execution cycle.
    *
    * Example of normal execution cycle:
    * A trigger, such as InvestigationTriggerHandler will reference the FederalRegisterMapper.
    * The FederalRegisterMapper will call the FederalRegisterSelector.
    * The FederalRegisterSelector will retrieve data from the ADCVD_CaseSelector class and via SOQL, storing the data for reference during a transaction.
    * The FederalRegisterMapper then uses the retrieved data and maps it in inner classes and a map called masterMap.
    * The FederalRegisterMapper masterMap is then utilized by the InvestigationTriggerHandler.
    *
    */

    public static FederalRegisterSelector instance = (FederalRegisterSelector)ADCVD_CaseSelector.selectorMap.get('Federal_Register__c');
    public static Map<Id,Federal_Register__c> idToUnlockedFrMap = new Map<Id,Federal_Register__c>();
    public static Map<Id,Federal_Register__c> idToAllFrMap = new Map<Id,Federal_Register__c>();

    /**
    * The first Id in the parentIdToFRMap is the Id of the Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment
    * The inner map is the Id of the Federal Register and then the Federal Register itself.  There is only an
    * unlocked version of this map at this time.
    */
    public static Map<Id, Map<Id, Federal_Register__c>> parentIdToFRMap = new Map<Id, Map<Id, Federal_Register__c>>();
    public FederalRegisterSelector() {}
    private FederalRegisterSelector(Set<Id> frIdSet) {
        if (idToUnlockedFrMap.isEmpty()) {
            List<Federal_Register__c> tempList = new List<Federal_Register__c>();
            String queryString = Utils.soqlBuilderAllFields('Federal_Register__c', false);
            queryString += ' FROM Federal_Register__c WHERE Id IN: frIdSet';
            tempList = database.query(queryString);
            for (Federal_Register__c fr : tempList) {
                addFrToMap(fr);
            }
        }
    }

    public static FederalRegisterSelector getInstance () {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }
    public static FederalRegisterSelector getNewInstance() {
        Set<Id> frIdSet = new Set<Id>();
        for (Id caseId : ADCVD_CaseSelector.caseIdToFrIdMap.keySet()) {
            frIdSet.addAll(ADCVD_CaseSelector.caseIdToFrIdMap.get(caseId));
        }
        instance = new FederalRegisterSelector(frIdSet);
        ADCVD_CaseSelector.selectorMap.put('Federal_Register__c', instance);
        return instance;
    }
    public Map<Id,Federal_Register__c> getMap() {
        return idToUnlockedFrMap;
    }
    public Map<Id,Federal_Register__c> getMap(Boolean includeLocked) {
        if (includeLocked) {
            return idToAllFrMap;
        } else {
            return idToUnlockedFrMap;
        }
    }
    public Map<Id, Map<Id,Federal_Register__c>> getParentToFrMap() {
        return parentIdToFRMap;
    }
    public void addFrToMap(Federal_Register__c fr) {
        if (!fr.Locked__c) {
            idToUnlockedFrMap.put(fr.Id, fr);
            populateMaps(fr);
        }
        idToAllFrMap.put(fr.Id, fr);
    }

    /**
    * Populate the maps caseIdToFRMap and parentIdToFRMap based on case Ids in scope.
    */
    private void populateMaps(Federal_Register__c fr) {
        //Create a temporary map
        Map<Id, Federal_Register__c> tempMap;
        //Populate the maps with each Federal Register returned
        Id parentId = (Id)fr.get(fr.FR_Parent__c);
        tempMap = parentIdToFRMap.containsKey(parentId) ?
                    parentIdToFRMap.get(parentId) : new Map<Id, Federal_Register__c>();
        tempMap.put(fr.Id, fr);
        parentIdToFRMap.put(parentId, tempMap);
    }
}