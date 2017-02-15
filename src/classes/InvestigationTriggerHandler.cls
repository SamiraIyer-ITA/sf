public class InvestigationTriggerHandler {
	
	//FINAL Investigation Record Type Developer Names
	private static FINAL String ADRECORD = 'AD';
	private static FINAL String CVDRECORD = 'CVD';

	//FINAL AD Record Type Offsets
    private static FINAL Integer ADCALCAMENDPRELIMSIGN = 31;//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer ADCALCPRELIMSIGN = 140;//Calculated_Preliminary_Signature __c
    private static FINAL Integer ADCALCFINALSIGN = 75;//Calculated_Final_Signature__c
    private static FINAL Integer ADCALCITCPRELIMDETERMINATION = 45;//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer ADCALCPRELIMEXTREQFILE = 115;//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer ADCALCPOSTPONEPRELIMDETERFR = 120;//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer ADPRELIMTEAMMEETINGDEADLINE = -21;//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer ADTERMOFSUSPGAPPERIODBEGWEXT = 181;//Termination_of_Suspension_Gap_Period_Beg__c with Final Extension of days
    private static FINAL Integer ADTERMOFSUSPGAPPERIODBEGWITHOUTEXT = 121;//Termination_of_Suspension_Gap_Period_Beg__c without Final Extension of days
    private static FINAL Integer ADFINALTEAMMEETINGDEADLINE = -21;//Final_Team_Meeting_Deadline__c
    private static FINAL Integer ADCALCULATEDAMENDEDFINALSIGNATURE = 31;//Calculated_Amended_Final_Signature__c
    private static FINAL Integer ADESTITCNOTIFTODOCOFFINALDET = 45;//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer ADCALCULATEDORDERFRSIGNATURE = 3;//Calculated_Order_FR_Signature__c
    private static FINAL Integer ADCALCULATEDITCFINALFRPUBLISHED = 5;//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer ADESTIMATEDORDERFRPUBLISHED = 7;//Estimated_Order_FR_Published__c

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
    private static Map<Id,Federal_Register__c> investigationIdToFRMap = new Map<Id,Federal_Register__c>();

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
    @TestVisible private static Set<Id> findIdsInScope(List<Investigation__c> newList){
    	Set<Id> petitionIdSet = new Set<Id>();
    	Set<Id> fedRegisterIdSet = new Set<Id>();
    	for(Investigation__c i : newList){
    		petitionIdSet.add(i.Petition__c);
    	}
    	return petitionIdSet;
    }
    //returns a map of the Petition__c objects in the form: key = Id, value = Investigation object
    //This pulls the petition fields needed via the Petition lookup field and adds them to the map
    @TestVisible private static Map<Id,Petition__c> findPetitionsInScopeMap(List<Investigation__c> newList){
    	Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
    	Set<Id> petitionIdSet = findIdsInScope(newList);
    	for(Petition__c p : [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, 
    									Calculated_Initiation_Signature__c
    								FROM Petition__c WHERE Id IN: petitionIdSet]){
    		returnMap.put(p.Id, p);
    	}
    	return returnMap;
    }
    //returns a map of Federal Register objects in the form: key = Investigation Id, value = Federal Register object
    @TestVisible private static Map<Id,Federal_Register__c> investigationIdToFRMap(Map<Id, Investigation__c> newMap){
    	Map<Id,Federal_Register__c> returnMap = new Map<Id,Federal_Register__c>();
    	for(Federal_Register__c fr : [SELECT Id, Type__c, Published_Date__c, Postponement_of_Final_Determination_FR__c, Investigation__c 
    									FROM Federal_Register__c WHERE Investigation__c IN: newMap.keySet()]){
    		if(fr.Type__c == 'Preliminary'){
    			returnMap.put(fr.Investigation__c, fr);
    		}
    	}
    	return returnMap;
    }

    /***************************************************************
    *These methods set the values for specific fields
    *The naming convention is set<FieldAPIName>
    *All share the same params of a single Investigation object
    ***************************************************************/

    //Ordered Methods
    //sets Calculated_Preliminary_Signature__c
    @TestVisible private static void setCalculatedPreliminarySignature(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
    		Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
			if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null){
				i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMSIGN).addDays(extension);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else if(p != null && p.Actual_Initiation_Signature__c != null && p.Actual_Initiation_Signature__c != null && i.Prelim_Extension_of_days__c != null){
				i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMSIGN).addDays(extension);
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
	    		i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGN);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	} else if(i.Actual_Preliminary_Signature__c != null){
	    		i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGN);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	}
	    } else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Investigation__c i){
    	if(i.Calculated_Preliminary_Signature__c != null){
    		i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(ADPRELIMTEAMMEETINGDEADLINE);
    		i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
    	}
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Investigation__c i){
    	Federal_Register__c fr = investigationIdToFRMap.get(i.Id);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
    		Integer extension = i.Final_Extension_of_days__c == null ? 0 : (Integer)i.Final_Extension_of_days__c;
    		if(fr == null || fr.Postponement_of_Final_Determination_FR__c == null){
    			i.Calculated_Final_Signature__c = i.Actual_Preliminary_Signature__c == null ? 
    			i.Calculated_Preliminary_Signature__c.addDays(ADCALCFINALSIGN) : 
    			i.Actual_Preliminary_Signature__c.addDays(ADCALCFINALSIGN);
    		} else if(fr.Postponement_of_Final_Determination_FR__c!= null){
    			i.Calculated_Final_Signature__c = fr.Preliminary_FR_Published__c.addDays(ADCALCFINALSIGN).addDays(extension);
    		}
    	}
    }
    
    //Unordered Methods
    //sets Calculated_ITC_Prelim_Determination__c
    @TestVisible private static void setCalculatedITCPrelimDetermination(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
    		if(p != null && p.Petition_Filed__c != null){
				i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(ADCALCITCPRELIMDETERMINATION);
				i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Calculated_Prelim_Extension_Request_File__c
    @TestVisible private static void setCalculatedPrelimExtensionRequestFile(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
	    	if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null){
				i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null){
				i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }

    //sets Calculated_Postponement_of_PrelimDeterFR__c
    @TestVisible private static void setCalculatedPostponementOfPrelimDeterFR(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD){
	    	if(p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null){
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			} else if(p != null && p.Actual_Initiation_Signature__c != null){
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			}
		} else if(recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD){
			//TODO
		}
    }
}