/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class FederalRegisterMapper implements ADCVD_IMapper{

    //get the instance from the ADCVD_Case Mapper
    public static FederalRegisterMapper instance = (FederalRegisterMapper)ADCVD_CaseMapper.selectorMap.get('Federal_Register__c');
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
    public FederalRegisterMapper() {}
    //private constructor based on FRs
    private FederalRegisterMapper(Set<Id> frIdSet) {
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
    public static FederalRegisterMapper getInstance () {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }
    //method to get a new instance of this selector
    public static FederalRegisterMapper getNewInstance() {
        Set<Id> frIdSet = new Set<Id>();
        for (Id caseId : ADCVD_CaseMapper.caseIdToFrIdMap.keySet()) {
            frIdSet.addAll(ADCVD_CaseMapper.caseIdToFrIdMap.get(caseId));
        }
        instance = new FederalRegisterMapper(frIdSet);
        ADCVD_CaseMapper.selectorMap.put('Federal_Register__c', instance);
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

    /**
    * Populate the above inner classes with the correct Federal Registers.
    * These will be the oldest one, except for the Continuation Federal Register, which is the newest one.
    *
    * @param soIdSet
    * @param objectName
    */
    public Map<Id, MappedFRs> getMappedFRs(Set<Id> soIdSet) {  //objectName is the sObject name of the Ids
        Map<Id, MappedFRs> returnMap = new Map<Id, MappedFRs>();
        for (Id soId : soIdSet) {
            //Create the appropriate inner class based on objectName
            //try {
            MappedFRs tempClass = new MappedFRs();
            //set the myId on that inner class
            tempClass.myId = soId;
            //Call a virtual class method that is implemented differently on each method.  This way the same method call can get us the correct logic dynamically.
            tempClass.getFRsFromId(soId);
            returnMap.put(soId, tempClass);
        }
        return returnMap;
    }

    /**
    * MappedFRs is an inner class which is implemented by an inner class for each of the types of Federal Registers.
    */
    public class MappedFRs {
        @TestVisible private ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.selectorMap.get('ADCVD_Case__c');
        @TestVisible private FederalRegisterMapper frMapper = (FederalRegisterMapper) ADCVD_CaseMapper.selectorMap.get('Federal_Register__c').getInstance();
        @TestVisible Id myId { get; private set; }  //Id will vary, based on the inner case
        public Map<String, Date> typeToPublishedDateMap = new Map<String, Date>();
        public Map<String, Federal_Register__c> frsByType = new Map<String, Federal_Register__c>();

        /**
         * Retrieve the Federal Registers for a given sObject Id.
         * The sObject Id is the Id of a Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment.
         *
         * @param soId
         */
        public void getFRsFromId(Id soId) {
            Set<Id> relatedIdSet = caseMapper.getFrRelatedParents(soId);
            System.debug(LoggingLevel.DEBUG, '*** relatedIdSet: ' + relatedIdSet);
            if (relatedIdSet == null || relatedIdSet.isEmpty()) {return;}
            List<Federal_Register__c> frsInScope = new List<Federal_Register__c>();
            for (Id relatedId : relatedIdSet) {
                System.debug(LoggingLevel.DEBUG, '*** frMapper from mapper: ' + frMapper);
                if (frMapper.getParentToFrMap().containsKey(relatedId)) {
                    frsInScope.addAll(frMapper.getParentToFrMap().get(relatedId).values());
                }
            }
            for (Federal_Register__c fr : frsInScope) {
                mapFR(fr);
            }
            removeMappers();
        }
        public void removeMappers() {
            caseMapper = null;
            frMapper = null;
        }
        public void mapFR(Federal_Register__c fr) {
            Federal_Register__c mappedFR = frsByType.get(fr.Type__c) != null ? frsByType.get(fr.Type__c) : null;
            switch on fr.Type__c {
                when 'Continuation' {
                    if (mappedFR == null || (mappedFR != null && fr.CreatedDate > mappedFR.CreatedDate)) {
                        frsByType.put(fr.Type__c, fr);
                        typeToPublishedDateMap.put(fr.Type__c, fr.Published_Date__c);
                    }
                }
                when else {
                    if (mappedFR == null || (mappedFR != null && fr.CreatedDate < mappedFR.CreatedDate)) {
                        frsByType.put(fr.Type__c, fr);
                        typeToPublishedDateMap.put(fr.Type__c, fr.Published_Date__c);
                    }
                }
            }  
        }
    }
}