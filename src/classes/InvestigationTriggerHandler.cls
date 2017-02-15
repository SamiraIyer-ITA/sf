public class InvestigationTriggerHandler {
	//Final Investigation Record Type Developer Names
	private static final String adRecord = 'AD';
	private static final String cvdRecord = 'CVD';

	//Final AD Record Type Offsets
    private static final Integer adCalcAmendPrelimSignOffset = 31;
    private static final Integer adCalcPrelimSignOffset = 140;
    private static final Integer adCalcFinalSignOffset = 75;
    private static final Integer adCalcITCPrelimDeterminationOffset = 45;
    private static final Integer adCalcPrelimExtReqFileOffset = 115;
    private static final Integer adCalcPostPonePrelimDeterFROffset = 120;
    private static final Integer adPrelimTeamMeetingDeadlineOffset = -21;

    //Final CVD Record Type Offsets
    //TODO
    
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Investigation__c> newList, List<Investigation__c> oldList, Map<Id, Investigation__c> newMap, 
        Map<Id, Investigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isBefore && isInsert) {
        	calculateInvestigationDates(newList);
        }
        if(isBefore && isUpdate) {
            calculateInvestigationDates(newList);
        }
    }
    
    //Maps used in multiple methods in calculateInvestigationDates regardless of record type
    private static Map<Id,Investigation__c> investigationsInScopeMap = new Map<Id,Investigation__c>();
    private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();

    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList){
    	investigationsInScopeMap = findInvestigationsInScopeMap(newList);
    	recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
    	for(Investigation__c i : newList){
			//Ordered Methods (must be done in a specific order)
    		setCalculatedPreliminarySignature(i);
    		setCalcAmendedPrelimDeterminationSig(i);
    		setPrelimTeamMeetingDeadline(i);


    		//Unordered Methods
    		setCalculatedITCPrelimDetermination(i);
    		setCalculatedPrelimExtensionRequestFile(i);
    		setCalculatedPostponementOfPrelimDeterFR(i);
    		
    	}
    }
    //Setup Methods used to set class level variables
    //returns a set of Ids from the list of new Investigations in trigger
    @TestVisible private static Set<Id> findIdsInScope(List<Investigation__c> newList){
    	Set<Id> investigationIdSet = new Set<Id>();
    	for(Investigation__c i : newList){
    		investigationIdSet.add(i.Id);
    	}
    	return investigationIdSet;
    }
    //returns a map of the new Investigations in the form: key = Id, value = Investigation object
    //This pulls the petition fields needed via the Petition lookup field and adds them to the map
    @TestVisible private static Map<Id,Investigation__c> findInvestigationsInScopeMap(List<Investigation__c> newList){
    	Set<Id> investigationIdSet = findIdsInScope(newList);
    	Map<Id,Investigation__c> tempMap = new Map<Id,Investigation__c>();
    	for(Investigation__c i : [SELECT Id, Petition__r.Id, Petition__r.Petition_Filed__c, Petition__r.Actual_Initiation_Signature__c, 
    									Petition__r.Calculated_Initiation_Signature__c, RecordTypeId
    								FROM Investigation__c WHERE Id IN: investigationIdSet]){
    		tempMap.put(i.Id, i);
    	}
    	return tempMap;
    }
    //returns a map of the new Investigations in the form: key = Id, value = Record Type Name
    //used to separate which values should be set
    @TestVisible private static Map<Id,String> findRecordTypeNameMap(List<Investigation__c> newList){
    	Map<Id,String> tempMap = new Map<Id,String>();
    	Map<Id,Schema.RecordTypeInfo> recordTypeIdMap = Investigation__c.sObjectType.getDescribe().getRecordTypeInfosById();
    	for(Investigation__c i : newList){
    		tempMap.put(i.Id, recordTypeIdMap.get(i.recordTypeId).getName());
    	}
    	return tempMap;
    }

    /***************************************************************
    *These methods set the values for specific fields
    *The naming convention is set<FieldAPIName>
    *All share the same params of a single Investigation object
    ***************************************************************/

    //Ordered Methods
    //sets Calculated_Preliminary_Signature__c
    @TestVisible private static void setCalculatedPreliminarySignature(Investigation__c i){
    	Petition__c p = investigationsInScopeMap.get(i.Id).Petition__r;
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
			if(investigationsInScopeMap.get(i.Id).Petition__r.Actual_Initiation_Signature__c == null){
				i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(adCalcPrelimSignOffset).addDays((Integer)i.Prelim_Extension_of_days__c);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else {
				i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(adCalcPrelimSignOffset).addDays((Integer)i.Prelim_Extension_of_days__c);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == cvdRecord) {
			//TODO
		}
    }

   //sets Calc_Amended_Prelim_Determination_Sig__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalcAmendedPrelimDeterminationSig(Investigation__c i){
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
			if(i.Actual_Preliminary_Signature__c == null){
	    		i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(adCalcAmendPrelimSignOffset);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	} else {
	    		i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(adCalcAmendPrelimSignOffset);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	}
	    } else if (recordTypeNameMap.get(i.RecordTypeId) == cvdRecord) {
			//TODO
		}
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Investigation__c i){
    	if(i.Calculated_Preliminary_Signature__c != null){
    		i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(adPrelimTeamMeetingDeadlineOffset);
    		i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
    	}
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Investigation__c i){
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
    		//if(i.Actual_Preliminary_Signature__c == null && i.Postponement_of_Final_Determ_FR_Pub__c == null){

    		//}
    	}
    }
    
    //Unordered Methods
    //sets Calculated_ITC_Prelim_Determination__c
    @TestVisible private static void setCalculatedITCPrelimDetermination(Investigation__c i){
    	Petition__c p = investigationsInScopeMap.get(i.Id).Petition__r;
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
			i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(adCalcITCPrelimDeterminationOffset);
			i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
		} else if (recordTypeNameMap.get(i.RecordTypeId) == cvdRecord) {
			//TODO
		}
    }

    //sets Calculated_Prelim_Extension_Request_File__c
    @TestVisible private static void setCalculatedPrelimExtensionRequestFile(Investigation__c i){
    	Petition__c p = investigationsInScopeMap.get(i.Id).Petition__r;
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
	    	if(investigationsInScopeMap.get(i.Id).Petition__r.Actual_Initiation_Signature__c == null){
				i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(adCalcPrelimExtReqFileOffset);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			} else {
				i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(adCalcPrelimExtReqFileOffset);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == cvdRecord) {
			//TODO
		}
    }

    //sets Calculated_Postponement_of_PrelimDeterFR__c
    @TestVisible private static void setCalculatedPostponementOfPrelimDeterFR(Investigation__c i){
    	Petition__c p = investigationsInScopeMap.get(i.Id).Petition__r;
    	if(recordTypeNameMap.get(i.RecordTypeId) == adRecord){
	    	if(investigationsInScopeMap.get(i.Id).Petition__r.Actual_Initiation_Signature__c == null){
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(adCalcPostPonePrelimDeterFROffset);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			} else {
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(adCalcPostPonePrelimDeterFROffset);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == cvdRecord) {
			//TODO
		}
    }
}