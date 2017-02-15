public class InvestigationTriggerHandler {
	
	//FINAL Investigation Record Type Developer Names
	private static FINAL String ADRECORD = 'AD';
	private static FINAL String CVDRECORD = 'CVD';

	//FINAL AD Record Type Offsets
    private static FINAL Integer ADCALCAMENDPRELIMSIGNOFFSET = 31;
    private static FINAL Integer ADCALCPRELIMSIGNOFFSET = 140;
    private static FINAL Integer ADCALCFINALSIGNOFFSET = 75;
    private static FINAL Integer ADCALCITCPRELIMDETERMINATIONOFFSET = 45;
    private static FINAL Integer ADCALCPRELIMEXTREQFILEOFFSET = 115;
    private static FINAL Integer ADCALCPOSTPONEPRELIMDETERFROFFSET = 120;
    private static FINAL Integer ADPRELIMTEAMMEETINGDEADLINEOFFSET = -21;

    //FINAL CVD Record Type Offsets
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
    private static Map<Id,Petition__c> petitionsInScopeMap = new Map<Id,Petition__c>();
    private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();

    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList){
    	petitionsInScopeMap = findPetitionsInScopeMap(newList);
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
    //returns a set of Petition Ids in scope of the Investigations in trigger
    @TestVisible private static Set<Id> findPetitionIdsInScope(List<Investigation__c> newList){
    	Set<Id> petitionIdSet = new Set<Id>();
    	for(Investigation__c i : newList){
    		petitionIdSet.add(i.Petition__r.Id);
    	}
    	return petitionIdSet;
    }
    //returns a map of the Petitions in the form: key = Id, value = Investigation object
    //This pulls the petition fields needed via the Petition lookup field and adds them to the map
    @TestVisible private static Map<Id,Petition__c> findPetitionsInScopeMap(List<Investigation__c> newList){
    	Map<Id,Petition__c> tempMap = new Map<Id,Petition__c>();
    	Set<Id> petitionIdSet = findPetitionIdsInScope(newList);
    	for(Petition__c p : [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, 
    									Calculated_Initiation_Signature__c
    								FROM Petition__c WHERE Id IN: petitionIdSet]){
    		tempMap.put(p.Id, p);
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
    	Petition__c p = petitionsInScopeMap.get(i.Petition__r.Id);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
			if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null && i.Prelim_Extension_of_days__c != null){
				i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMSIGNOFFSET).addDays((Integer)i.Prelim_Extension_of_days__c);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else if(p != null && p.Actual_Initiation_Signature__c != null && p.Actual_Initiation_Signature__c != null && i.Prelim_Extension_of_days__c != null){
				i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMSIGNOFFSET).addDays((Integer)i.Prelim_Extension_of_days__c);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else {
				i.addError('Investigation '+i.Name+' does not have the required data to calculate the Calculated Preliminary Signature.');
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			//TODO
		}
    }

   //sets Calc_Amended_Prelim_Determination_Sig__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalcAmendedPrelimDeterminationSig(Investigation__c i){
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
			if(i.Actual_Preliminary_Signature__c == null && i.Calculated_Preliminary_Signature__c != null){
	    		i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGNOFFSET);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	} else if(i.Actual_Preliminary_Signature__c != null){
	    		i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGNOFFSET);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	}
	    } else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Investigation__c i){
    	if(i.Calculated_Preliminary_Signature__c != null){
    		i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(ADPRELIMTEAMMEETINGDEADLINEOFFSET);
    		i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
    	}
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Investigation__c i){
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
    		//if(i.Actual_Preliminary_Signature__c == null && i.Postponement_of_Final_Determ_FR_Pub__c == null){

    		//}
    	}
    }
    
    //Unordered Methods
    //sets Calculated_ITC_Prelim_Determination__c
    @TestVisible private static void setCalculatedITCPrelimDetermination(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__r.Id);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
    		if(p != null && p.Petition_Filed__c != null){
				i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(ADCALCITCPRELIMDETERMINATIONOFFSET);
				i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Calculated_Prelim_Extension_Request_File__c
    @TestVisible private static void setCalculatedPrelimExtensionRequestFile(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__r.Id);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
	    	if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null){
				i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILEOFFSET);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null){
				i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILEOFFSET);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Calculated_Postponement_of_PrelimDeterFR__c
    @TestVisible private static void setCalculatedPostponementOfPrelimDeterFR(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__r.Id);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
	    	if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null){
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFROFFSET);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			} else if(p != null && p.Actual_Initiation_Signature__c != null){
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFROFFSET);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }
}