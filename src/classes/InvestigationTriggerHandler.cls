public without sharing class InvestigationTriggerHandler {
	
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
    private static FINAL Integer CVDCALCAMENDPRELIMSIGN = 31;//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer CVDCALCPRELIMSIGN = 65;//Calculated_Preliminary_Signature __c
    private static FINAL Integer CVDCALCFINALSIGN = 75;//Calculated_Final_Signature__c
    private static FINAL Integer CVDCALCITCPRELIMDETERMINATION = 45;//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer CVDCALCPRELIMEXTREQFILE = 115;//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer CVDCALCPOSTPONEPRELIMDETERFR = 120;//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer CVDPRELIMTEAMMEETINGDEADLINE = -21;//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer CVDTERMOFSUSPGAPPERIODBEG = 121;//Termination_of_Suspension_Gap_Period_Beg__c
    private static FINAL Integer CVDFINALTEAMMEETINGDEADLINE = -21;//Final_Team_Meeting_Deadline__c
    private static FINAL Integer CVDCALCULATEDAMENDEDFINALSIGNATURE = 31;//Calculated_Amended_Final_Signature__c
    private static FINAL Integer CVDESTITCNOTIFTODOCOFFINALDET = 45;//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer CVDCALCULATEDORDERFRSIGNATURE = 3;//Calculated_Order_FR_Signature__c
    private static FINAL Integer CVDCALCULATEDITCFINALFRPUBLISHED = 5;//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer CVDESTIMATEDORDERFRPUBLISHED = 7;//Estimated_Order_FR_Published__c
    
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Investigation__c> newList, List<Investigation__c> oldList, Map<Id, Investigation__c> newMap, 
        Map<Id, Investigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        initialize(newList, newMap);

        if (isBefore && isInsert) {
            syncToInvestigation(newList);
        	calculateInvestigationDates(newList);
        }
        if (isBefore && isUpdate) {
            syncToInvestigation(newList);
            calculateInvestigationDates(newList);
        }
    }
    
    //Maps used in multiple methods in calculateInvestigationDates regardless of record type
    @TestVisible private static Map<Id,Petition__c> petitionsInScopeMap = new Map<Id,Petition__c>();
    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    @TestVisible private static Map<Id,Federal_Register__c> investigationIdToFRMap = new Map<Id,Federal_Register__c>();

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Investigation__c> newList, Map<Id,Investigation__c> newMap) {
        petitionsInScopeMap = findPetitionsInScopeMap(newList);
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
        if (newMap != null) {
           investigationIdToFRMap = investigationIdToFRMap(newMap);
        }
    }
    //Syncs petition fields to investigation fields and AD to CVD if aligned
    @TestVisible private static void syncToInvestigation(List<Investigation__c> newList) {
            SyncUtility.syncObject(newList, null, true);
    }

    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList) {
    	for (Investigation__c i : newList) {
			//Ordered Methods (must be done in a specific order)
    		setCalculatedPreliminarySignature(i);
    		//dependent on setCalculatedPreliminarySignature
    		setCalcAmendedPrelimDeterminationSig(i);
    		setPrelimTeamMeetingDeadline(i);
    		setCalculatedFinalSignature(i);
    		//dependent on setCalculatedFinalSignature
    		setFinalTeamMeetingDeadline(i);
    		setEstITCNotificationtoDOCofFinalDet(i);
    		//dependent on setEstITCNotificationtoDOCofFinalDet
    		setCalculatedOrderFRSignature(i);
    		setCalculatedITCFinalFRPublished(i);
    		setEstimatedOrderFRPublished(i);

    		//Unordered Methods
    		setCalculatedITCPrelimDetermination(i);
    		setCalculatedPrelimExtensionRequestFile(i);
    		setCalculatedPostponementOfPrelimDeterFR(i);
    		setTerminationofSuspensionGapPeriodBeg(i);
    		setCalculatedAmendedFinalSignature(i);

    	}
    }
    //returns a set of Petition Ids in scope of the Investigations in trigger
    @TestVisible private static Set<Id> findIdsInScope(List<Investigation__c> newList) {
    	Set<Id> petitionIdSet = new Set<Id>();
    	for (Investigation__c i : newList) {
    		petitionIdSet.add(i.Petition__c);
    	}
    	return petitionIdSet;
    }
    //returns a map of the Petition__c objects in the form: key = Id, value = Investigation object
    //This pulls the petition fields needed via the Petition lookup field and adds them to the map
    @TestVisible private static Map<Id,Petition__c> findPetitionsInScopeMap(List<Investigation__c> newList) {
    	Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
    	Set<Id> petitionIdSet = findIdsInScope(newList);
    	for (Petition__c p : [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, 
    									Calculated_Initiation_Signature__c
    								FROM Petition__c WHERE Id IN: petitionIdSet]) {
    		returnMap.put(p.Id, p);
    	}
    	return returnMap;
    }
    //returns a map of Federal Register objects in the form: key = Investigation Id, value = Federal Register object
    @TestVisible private static Map<Id,Federal_Register__c> investigationIdToFRMap(Map<Id, Investigation__c> newMap) {
    	Map<Id,Federal_Register__c> returnMap = new Map<Id,Federal_Register__c>();
    	for (Federal_Register__c fr : [SELECT Id, Type__c, Preliminary_FR_Published__c, Postponement_of_Final_Determination_FR__c, Investigation__c 
    									FROM Federal_Register__c WHERE Investigation__c IN: newMap.keySet()]) {
    		if (fr.Type__c == 'Preliminary') {
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
    @TestVisible private static void setCalculatedPreliminarySignature(Investigation__c i) {
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Calculated_Initiation_Signature__c;//used for 
				i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMSIGN).addDays(extension);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Actual_Initiation_Signature__c;
				i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMSIGN).addDays(extension);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
            if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Calculated_Initiation_Signature__c;
                i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(CVDCALCPRELIMSIGN).addDays(extension);
                i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Actual_Initiation_Signature__c;
                i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(CVDCALCPRELIMSIGN).addDays(extension);
                i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
            }
		}
    }

   //sets Calc_Amended_Prelim_Determination_Sig__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalcAmendedPrelimDeterminationSig(Investigation__c i) {
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
			if (i.Actual_Preliminary_Signature__c == null && i.Calculated_Preliminary_Signature__c != null) {
	    		i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGN);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	} else if (i.Actual_Preliminary_Signature__c != null) {
	    		i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(ADCALCAMENDPRELIMSIGN);
	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
	    	}
	    } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (i.Actual_Preliminary_Signature__c == null && i.Calculated_Preliminary_Signature__c != null) {
                i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(CVDCALCAMENDPRELIMSIGN);
                i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
            } else if (i.Actual_Preliminary_Signature__c != null) {
                i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(CVDCALCAMENDPRELIMSIGN);
                i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
            }
		}
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Investigation__c i){
        if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
        	if (i.Calculated_Preliminary_Signature__c != null) {
        		i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(ADPRELIMTEAMMEETINGDEADLINE);
        		i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
        	}
        } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
            if (i.Calculated_Preliminary_Signature__c != null) {
                i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(CVDPRELIMTEAMMEETINGDEADLINE);
                i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
            }
        }
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Investigation__c i){
    	Federal_Register__c fr = investigationIdToFRMap.get(i.Id);
        Integer extension = i.Final_Extension_of_days__c == null ? 0 : (Integer)i.Final_Extension_of_days__c;//null check on extension, set to 0 if null
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if (fr == null || fr.Postponement_of_Final_Determination_FR__c == null) {
    			if (i.Actual_Preliminary_Signature__c == null) {
    				i.Calculated_Final_Signature__c = i.Calculated_Preliminary_Signature__c.addDays(ADCALCFINALSIGN);
    				i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
    			} else {
    				i.Calculated_Final_Signature__c = i.Actual_Preliminary_Signature__c.addDays(ADCALCFINALSIGN);
    				i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
    			}
    		} else if (fr.Postponement_of_Final_Determination_FR__c != null) {
    			i.Calculated_Final_Signature__c = fr.Preliminary_FR_Published__c.addDays(ADCALCFINALSIGN).addDays(extension);
    			i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(fr.Preliminary_FR_Published__c, i.Calculated_Final_Signature__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
            if (i.Actual_Preliminary_Signature__c == null) {
                i.Calculated_Final_Signature__c = i.Calculated_Preliminary_Signature__c.addDays(CVDCALCFINALSIGN);
                i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
            } else {
                i.Calculated_Final_Signature__c = i.Actual_Preliminary_Signature__c.addDays(CVDCALCFINALSIGN);
                i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
            }
    	}
    }

    //sets Calculated_Amended_Final_Signature__c
    @TestVisible private static void setCalculatedAmendedFinalSignature(Investigation__c i){
        if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
            if (i.Actual_Final_Signature__c != null) {
                i.Calculated_Amended_Final_Signature__c = i.Actual_Final_Signature__c.addDays(ADCALCULATEDAMENDEDFINALSIGNATURE);
                i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
            } else {
                i.Calculated_Amended_Final_Signature__c = i.Calculated_Final_Signature__c.addDays(ADCALCULATEDAMENDEDFINALSIGNATURE);
                i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
            }
        } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
            if (i.Actual_Final_Signature__c != null) {
                i.Calculated_Amended_Final_Signature__c = i.Actual_Final_Signature__c.addDays(CVDCALCULATEDAMENDEDFINALSIGNATURE);
                i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
            } else {
                i.Calculated_Amended_Final_Signature__c = i.Calculated_Final_Signature__c.addDays(CVDCALCULATEDAMENDEDFINALSIGNATURE);
                i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
            }
        }
    }

    //sets Final_Team_Meeting_Deadline__c, requires Calculated_Final_Signature__c to be set
    @TestVisible private static void setFinalTeamMeetingDeadline(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (i.Calculated_Final_Signature__c != null) {
	    		i.Final_Team_Meeting_Deadline__c = i.Calculated_Final_Signature__c.addDays(ADFINALTEAMMEETINGDEADLINE);
	    		i.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Final_Team_Meeting_Deadline__c, true);
	    	}
	    } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
	    	if (i.Calculated_Final_Signature__c != null) {
                i.Final_Team_Meeting_Deadline__c = i.Calculated_Final_Signature__c.addDays(CVDFINALTEAMMEETINGDEADLINE);
                i.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Final_Team_Meeting_Deadline__c, true);
            }
	    }
    }

    //sets Est_ITC_Notification_to_DOC_of_Final_Det__c, requires Calculated_Final_Signature__c to be set
    @TestVisible private static void setEstITCNotificationtoDOCofFinalDet(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.Actual_Final_Signature__c == null) {
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Calculated_Final_Signature__c.addDays(ADESTITCNOTIFTODOCOFFINALDET);
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
    		} else {
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Actual_Final_Signature__c.addDays(ADESTITCNOTIFTODOCOFFINALDET);
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.Actual_Final_Signature__c == null) {
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Calculated_Final_Signature__c.addDays(CVDESTITCNOTIFTODOCOFFINALDET);
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
            } else {
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Actual_Final_Signature__c.addDays(CVDESTITCNOTIFTODOCOFFINALDET);
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
            }
    	}
    }

    //sets Calculated_Order_FR_Signature__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setCalculatedOrderFRSignature(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_Order_FR_Signature__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(ADCALCULATEDORDERFRSIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_Order_FR_Signature__c, true);
    		} else {
    			i.Calculated_Order_FR_Signature__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(ADCALCULATEDORDERFRSIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_Order_FR_Signature__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVDCALCULATEDORDERFRSIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		} else {
    			i.Calculated_Order_FR_Signature__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVDCALCULATEDORDERFRSIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		}
    	}
    }

    //sets Calculated_ITC_Final_FR_Published__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setCalculatedITCFinalFRPublished(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_ITC_Final_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(ADCALCULATEDITCFINALFRPUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		} else {
    			i.Calculated_ITC_Final_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(ADCALCULATEDITCFINALFRPUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_ITC_Final_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVDCALCULATEDITCFINALFRPUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		} else {
    			i.Calculated_ITC_Final_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVDCALCULATEDITCFINALFRPUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		}
    	}
    }

    //sets Estimated_Order_FR_Published__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setEstimatedOrderFRPublished(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Estimated_Order_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(ADESTIMATEDORDERFRPUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Estimated_Order_FR_Published__c, true);
    		} else {
    			i.Estimated_Order_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(ADESTIMATEDORDERFRPUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Estimated_Order_FR_Published__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Estimated_Order_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVDESTIMATEDORDERFRPUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Estimated_Order_FR_Published__c, true);
    		} else {
    			i.Estimated_Order_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVDESTIMATEDORDERFRPUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Estimated_Order_FR_Published__c, true);
    		}
    	}
    }
    
    //Unordered Methods
    //sets Calculated_ITC_Prelim_Determination__c
    @TestVisible private static void setCalculatedITCPrelimDetermination(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if (p != null && p.Petition_Filed__c != null) {
				i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(ADCALCITCPRELIMDETERMINATION);
				i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (p != null && p.Petition_Filed__c != null) {
                i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(CVDCALCITCPRELIMDETERMINATION);
                i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
            }
		}
    }

    //sets Calculated_Prelim_Extension_Request_File__c
    @TestVisible private static void setCalculatedPrelimExtensionRequestFile(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
				i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
				i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPRELIMEXTREQFILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(CVDCALCPRELIMEXTREQFILE);
                i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(CVDCALCPRELIMEXTREQFILE);
                i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
            }
		}
    }

    //sets Calculated_Postponement_of_PrelimDeterFR__c
    @TestVisible private static void setCalculatedPostponementOfPrelimDeterFR(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
                i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(ADCALCPOSTPONEPRELIMDETERFR);
                i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
            }
		}
    }

    //sets Termination_of_Suspension_Gap_Period_Beg__c
    @TestVisible private static void setTerminationofSuspensionGapPeriodBeg(Investigation__c i){
    	Federal_Register__c fr = investigationIdToFRMap.get(i.Id);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (fr != null) {
		    	i.Termination_of_Suspension_Gap_Period_Beg__c = i.Final_Extension_of_days__c == null ? 
		    	fr.Preliminary_FR_Published__c.addDays(ADTERMOFSUSPGAPPERIODBEGWITHOUTEXT) : 
		    	fr.Preliminary_FR_Published__c.addDays(ADTERMOFSUSPGAPPERIODBEGWEXT);
		    	i.Termination_of_Suspension_Gap_Period_Beg__c = ADCVD_TollingDayUtility.getCalculatedDate(fr.Preliminary_FR_Published__c, i.Termination_of_Suspension_Gap_Period_Beg__c, true);
		    }
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (fr != null) {
                i.Termination_of_Suspension_Gap_Period_Beg__c = fr.Preliminary_FR_Published__c.addDays(CVDTERMOFSUSPGAPPERIODBEG);
                i.Termination_of_Suspension_Gap_Period_Beg__c = ADCVD_TollingDayUtility.getCalculatedDate(fr.Preliminary_FR_Published__c, i.Termination_of_Suspension_Gap_Period_Beg__c, true);
            }
		}
	}
}