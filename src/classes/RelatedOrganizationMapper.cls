/**
 * Created by eitanalfiya on 8/21/18.
 */

public without sharing class RelatedOrganizationMapper implements ADCVD_IMapper {

	//get the instance from the ADCVD_CaseMapper
	public static RelatedOrganizationMapper instance = (RelatedOrganizationMapper) ADCVD_CaseMapper.mapperMap.get('Related_Organization__c');

	//Maps of unlocked and of all petititons.  The unlocked map is primarily used when updating petitions, the unlocked
	//map is sometimes used to retrieve values when updating other related objects
	public static Map<Id, Related_Organization__c> idToUnlockedRelatedOrganizationMap = new Map<Id, Related_Organization__c>();
	public static Map<Id, Related_Organization__c> idToAllRelatedOrganizationMap = new Map<Id, Related_Organization__c>();

	//no param constructor used in the ADCVD_CaseMapper on initialization
	public RelatedOrganizationMapper() {
	}

	//private contructor used via the getNewInstance method
	private RelatedOrganizationMapper(Set<Id> relatedOrgIdSet) {
		if (idToUnlockedRelatedOrganizationMap.isEmpty()) {
			List<Related_Organization__c> tempList = new List<Related_Organization__c>();
			String queryString = Utils.soqlBuilderAllFields('Related_Organization__c', false);
			queryString += ' FROM Related_Organization__c WHERE Id IN: relatedOrgIdSet';
			tempList = database.query(queryString);
				for (Related_Organization__c ro : tempList) {
					addRelOrgToMap(ro);
				}
			}
		}
	}

	//primary method for accessing this selector. Uses a Singleton pattern with the instance being stored on the ADCVD_CaseMapper
	public static RelatedOrganizationMapper getInstance() {
		if (instance == null) {
			return getNewInstance();
		}
		return instance;
	}

	//exposed method for getting a new instance of this selector. will overwrite the existing instance in the ADCVD_CaseMapper
	public static RelatedOrganizationMapper getNewInstance() {
		Set<Id> relatedOrganizationIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToRelOrgIdMap.keySet()) {
			relatedOrganizationIdSet.addAll(ADCVD_CaseMapper.caseIdToRelOrgIdMap.get(caseId));
		}
		instance = new RelatedOrganizationMapper(relatedOrganizationIdSet);
		ADCVD_CaseMapper.mapperMap.put('Related_Organization__c', instance);
		return instance;
	}

	//gets the unlocked petition map
	public Map<Id, Related_Organization__c> getMap() {
		return idToUnlockedRelatedOrganizationMap;
	}

	//accepts a param to specify the return of either all petitions or only unlocked ones
	public Map<Id, Related_Organization__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllRelatedOrganizationMap;
		} else {
			return idToUnlockedRelatedOrganizationMap;
		}
	}

	//method to add new or updated petitions to the maps, called in this class and in the petition trigger handler
	public void addRelOrgToMap(Related_Organization__c ro) {
		if (!ro.Locked__c) {
			idToUnlockedRelatedOrganizationMap.put(ro.Id, ro);
		}
		idToAllRelatedOrganizationMap.put(ro.Id, ro);
	}

}