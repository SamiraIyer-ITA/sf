/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class PetitionMapper implements ADCVD_IMapper {

	//get the instance from the ADCVD_CaseMapper
	public static PetitionMapper instance = (PetitionMapper)ADCVD_CaseMapper.mapperMap.get('Petition__c');
	//Maps of unlocked and of all petititons.  The unlocked map is primarily used when updating petitions, the unlocked
	//map is sometimes used to retrieve values when updating other related objects
	public static Map<Id,Petition__c> idToUnlockedPetitionMap = new Map<Id,Petition__c>();
	public static Map<Id,Petition__c> idToAllPetitionMap = new Map<Id,Petition__c>();
	//no param constructor used in the ADCVD_CaseMapper on initialization
	public PetitionMapper() {}
	//private contructor used via the getNewInstance method
	private PetitionMapper(Set<Id> petitionIdSet) {
		if(idToUnlockedPetitionMap.isEmpty()) {
			for (Petition__c p : PetitionSelector.newInstance().selectById(petitionIdSet)) {
				addPetToMap(p);
			}
		}
	}
	//primary method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
	public static PetitionMapper getInstance () {
		if (instance == null) {
			 return getNewInstance();
		}
		return instance;
	}
	//exposed method for getting a new instance of this selector. will overwrite the existing instance in the ADCVD_CaseMapper
	public static PetitionMapper getNewInstance() {
		Set<Id> petitionIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToPetitionIdMap.keySet()) {
			petitionIdSet.addAll(ADCVD_CaseMapper.caseIdToPetitionIdMap.get(caseId));
		}
		instance = new PetitionMapper(petitionIdSet);
		ADCVD_CaseMapper.mapperMap.put('Petition__c', instance);
		return instance;
	}
	//gets the unlocked petition map
	public Map<Id,Petition__c> getMap() {
		return idToUnlockedPetitionMap;
	}
	//accepts a param to specify the return of either all petitions or only unlocked ones
	public Map<Id,Petition__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllPetitionMap;
		} else {
			return idToUnlockedPetitionMap;
		}
	}
	//method to add new or updated petitions to the maps, called in this class and in the petition trigger handler
	public void addPetToMap(Petition__c p) {
		if (!p.Locked__c) {
			idToUnlockedPetitionMap.put(p.Id, p);
		}
		idToAllPetitionMap.put(p.id, p);
	}
}