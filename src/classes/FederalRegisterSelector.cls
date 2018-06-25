/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class FederalRegisterSelector implements ADCVD_Selector{

    //get the instance from the ADCVD_Case Selector
    public static FederalRegisterSelector instance = (FederalRegisterSelector)ADCVD_CaseSelector.selectorMap.get('Federal_Register__c');
    //maps of all FRs and only unlocked FRs
    public static Map<Id,Federal_Register__c> idToUnlockedFrMap = new Map<Id,Federal_Register__c>();
    public static Map<Id,Federal_Register__c> idToAllFrMap = new Map<Id,Federal_Register__c>();

    /**
    * The first Id in the parentIdToFRMap is the Id of the Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment
    * The inner map is the Id of the Federal Register and then the Federal Register itself.  This map contains all FRs - this can 
    * be reviewed at a later date once we have a archiving/locking solution
    */
    public static Map<Id, Map<Id, Federal_Register__c>> parentIdToFRMap = new Map<Id, Map<Id, Federal_Register__c>>();
    //empty constructor for this class
    public FederalRegisterSelector() {}
    //private constructor based on FRs
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
    //primary method for accessing this selector
    public static FederalRegisterSelector getInstance () {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }
    //method to get a new instance of this selector
    public static FederalRegisterSelector getNewInstance() {
        Set<Id> frIdSet = new Set<Id>();
        for (Id caseId : ADCVD_CaseSelector.caseIdToFrIdMap.keySet()) {
            frIdSet.addAll(ADCVD_CaseSelector.caseIdToFrIdMap.get(caseId));
        }
        instance = new FederalRegisterSelector(frIdSet);
        ADCVD_CaseSelector.selectorMap.put('Federal_Register__c', instance);
        return instance;
    }
    //no param method to return the unlocked map
    public Map<Id,Federal_Register__c> getMap() {
        return idToUnlockedFrMap;
    }
    //method to return either the locked or unlocked map
    public Map<Id,Federal_Register__c> getMap(Boolean includeLocked) {
        if (includeLocked) {
            return idToAllFrMap;
        } else {
            return idToUnlockedFrMap;
        }
    }
    //method to return the parentIdtoFrMap
    public Map<Id, Map<Id,Federal_Register__c>> getParentToFrMap() {
        return parentIdToFrMap;
    }
    //method to add an fr to the unlocked and all fr maps
    //also updates the parentIdToFrMap with the new Fr
    public void addFrToMap(Federal_Register__c fr) {
        if (!fr.Locked__c) {
            idToUnlockedFrMap.put(fr.Id, fr);
        }
        idToAllFrMap.put(fr.Id, fr);
        setParentIdToFrMap(fr);
    }
    //method to update the parentIdToFrMap
    private void setParentIdToFrMap(Federal_Register__c fr) {
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