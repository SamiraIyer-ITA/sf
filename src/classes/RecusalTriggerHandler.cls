public without sharing class RecusalTriggerHandler {

	public static void mainEntry(List<Recusal__c> newList, List<Recusal__c> oldList, Map<Id, Recusal__c> newMap, 
		Map<Id, Recusal__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete,
		Boolean isBefore, Boolean isAfter){
		
        if (!AppConfigService.triggerEnabled) {return;}

		if(isBefore && isInsert) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            setCaseValues(newList);
		}
	}

    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    @TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
    @TestVisible private static RecusalMapper recMapper;

    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    @TestVisible private static void initialize(List<Recusal__c> newList, Map<Id,Recusal__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        if (!caseIdSet.isEmpty()) caseMapper = caseMapper.getInstance(caseIdSet);
    }

    //setup using this method for future use case of Recusals created for Int Orgs.
    @TestVisible private static Set<Id> getCaseIdSet (List<Recusal__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        for (Recusal__c rec : newList) {
            if(rec.ADCVD_Case__c != null) {
                setRecParent(rec, 'ADCVD_Case__c');
                caseIdSet.add(rec.ADCVD_Case__c);
            }
        }
        return caseIdSet;
    }

    @TestVisible private static void setCaseValues(List<Recusal__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Recusal__c rec : newList) {
            if(String.isBlank(rec.Recusal_Parent__c)) continue;//current business process allows for stand alone (orphaned) recusals
            Id parentId = (Id) rec.get(rec.Recusal_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(rec.Recusal_Parent__c).getInstance();
            rec = (Recusal__c) pvs.setCaseValuesFromParent(adcvdMapper.getMap(true).get(parentId), rec);
        }
    }

    @TestVisible private static void setRecParent (Recusal__c rec, String parentName) {
        if (String.isBlank(rec.Recusal_Parent__c)) {
            rec.Recusal_Parent__c = parentName;
        }
    }
}