/**
 * 
 *    Created by Joshua Moody
 *    on 6/25/2019
 *    MIL Corporation
 * 
 **/

public without sharing class RecusalMapper implements ADCVD_IMapper{

    //get the instance from the ADCVD_CaseMapper
    public static RecusalMapper instance = (RecusalMapper)ADCVD_CaseMapper.mapperMap.get('Recusal__c');
    //Maps of unlocked and of all recusals.  The unlocked map is primarily used when updating recusals, the unlocked
    //map is sometimes used to retrieve values when updating other related objects
    public static Map<Id,Recusal__c> idToUnlockedRecusalMap = new Map<Id,Recusal__c>();
    public static Map<Id,Recusal__c> idToAllRecusalMap = new Map<Id,Recusal__c>();
    public static Map<Id,List<Recusal__c>> userIdToUnlockedRecusalMap = new Map<Id,List<Recusal__c>>();

    //no param constructor used in the ADCVD_CaseMapper on initialization
    public RecusalMapper() {}

    //private contructor used via the getNewInstance method
    @TestVisible
    private RecusalMapper(Set<Id> recusalIdSet) {
        if(idToUnlockedRecusalMap.isEmpty()) {
            for (Recusal__c rec : RecusalSelector.newInstance().selectById(recusalIdSet)) {
                addStaffToMap(rec);
            }
        }
    }

    //primary method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
    public static RecusalMapper getInstance () {
        if (instance == null) {
            return getNewInstance(new Set<Id>());
        }
        return instance;
    }

    //method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
    //this overload accepts a set of User Ids that is used to get recusals not related to ADCVD Cases
    public RecusalMapper getInstance (Set<Id> userIdSet) {
        if (instance == null) {
            return getNewInstance(userIdSet);
        }
        return instance;
    }

    //exposed method for getting a new instance of this selector. will overwrite the existing instance in the ADCVD_CaseMapper
    public static RecusalMapper getNewInstance(Set<Id> userIdSet) {
        Set<Id> recusalIdSet = new Set<Id>();
        for (Recusal__c rec : RecusalSelector.newInstance().selectByUserAndNoCase(userIdSet)) {
            recusalIdSet.add(rec.Id);
        }
        //for loop query and add to recusalIdSet
        for (Id caseId : ADCVD_CaseMapper.caseIdToRecusalIdMap.keySet()) {
            recusalIdSet.addAll(ADCVD_CaseMapper.caseIdToRecusalIdMap.get(caseId));
        }
        instance = new RecusalMapper(recusalIdSet);
        ADCVD_CaseMapper.mapperMap.put('Recusal__c', instance);
        return instance;
    }

    //gets the unlocked recusal map
    public Map<Id,Recusal__c> getMap() {
        return idToUnlockedRecusalMap;
    }

    //accepts a param to specify the return of either all recusals or only unlocked ones
    public Map<Id,Recusal__c> getMap(Boolean includeLocked) {
        if (includeLocked) {
            return idToAllRecusalMap;
        } else {
            return idToUnlockedRecusalMap;
        }
    }

    //gets the recusal map by userId
    public Map<Id,List<Recusal__c>> getMapByUserIds() {
        return userIdToUnlockedRecusalMap;
    }

    //method to add new or updated recusals to the maps, called in this class and in the recusal trigger handler
    public void addStaffToMap(Recusal__c rec) {
        Date today = System.today();
        if (!rec.Locked__c && rec.Start_Date__c <= today && rec.End_Date__c >= today) {
            idToUnlockedRecusalMap.put(rec.Id, rec);
            List<Recusal__c> tempList = new List<Recusal__c>();
            if (userIdToUnlockedRecusalMap.get(rec.User__c) != null) {
                tempList.addAll(userIdToUnlockedRecusalMap.get(rec.User__c));
            }
            tempList.add(rec);
            userIdToUnlockedRecusalMap.put(rec.User__c, tempList);
        }
        idToAllRecusalMap.put(rec.Id, rec);
    }

}