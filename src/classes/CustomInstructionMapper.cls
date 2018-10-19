/**
 * Created by Joshua Moody on 8/29/18.
 */

public without sharing class CustomInstructionMapper  implements ADCVD_IMapper {


    //get the instance from the ADCVD_CaseMapper
    public static CustomInstructionMapper instance = (CustomInstructionMapper)ADCVD_CaseMapper.mapperMap.get('Custom_Instruction__c');

    //Maps of unlocked and of all Custom Instructions.  The unlocked map is primarily used when updating Custom Instructions, the unlocked
    //map is sometimes used to retrieve values when updating other related objects
    public static Map<Id,Custom_Instruction__c> idToUnlockedCustomInstructionMap = new Map<Id,Custom_Instruction__c>();
    public static Map<Id,Custom_Instruction__c> idToAllCustomInstructionMap = new Map<Id,Custom_Instruction__c>();

    //no param constructor used in the ADCVD_CaseMapper on initialization
    public CustomInstructionMapper() {}

    //private contructor used via the getNewInstance method
    @TestVisible
    private CustomInstructionMapper(Set<Id> cstInstIdSet) {
        if(idToUnlockedCustomInstructionMap.isEmpty()) {
        	List<Custom_Instruction__c> tempList = CustomInstructionSelector.newInstance().selectById(cstInstIdSet);
        	if (tempList != null) {
	            for (Custom_Instruction__c ci : tempList) {
	                addCstInstToMap(ci);
	            }
	        }
        }
    }

    //primary method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
    public static CustomInstructionMapper getInstance () {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }

    //exposed method for getting a new instance of this selector. will overwrite the existing instance in the ADCVD_CaseMapper
    public static CustomInstructionMapper getNewInstance() {
        Set<Id> customInstructionIdSet = new Set<Id>();
        for (Id caseId : ADCVD_CaseMapper.caseIdToCstInstIdMap.keySet()) {
            CustomInstructionIdSet.addAll(ADCVD_CaseMapper.caseIdToCstInstIdMap.get(caseId));
        }
        instance = new CustomInstructionMapper(customInstructionIdSet);
        ADCVD_CaseMapper.mapperMap.put('Custom_Instruction__c', instance);
        return instance;
    }

    //gets the unlocked petition map
    public Map<Id,Custom_Instruction__c> getMap() {
        return idToUnlockedCustomInstructionMap;
    }

    //accepts a param to specify the return of either all Custom Instructions or only unlocked ones
    public Map<Id,Custom_Instruction__c> getMap(Boolean includeLocked) {
        if (includeLocked) {
            return idToAllCustomInstructionMap;
        } else {
            return idToUnlockedCustomInstructionMap;
        }
    }
    
    //method to add new or updated Custom Instructions to the maps, called in this class and in the Custom Instruction trigger handler
    public void addCstInstToMap(Custom_Instruction__c ci) {
        if (!ci.Locked__c) {
            idToUnlockedCustomInstructionMap.put(ci.Id, ci);
        }
        idToAllCustomInstructionMap.put(ci.Id, ci);
    }

}