public without sharing class InvestigationTriggerHandler {
	
	//FINAL Investigation Record Type Developer Names
	private static FINAL String ADRECORD = 'AD';
	private static FINAL String CVDRECORD = 'CVD';

	//FINAL AD Record Type Offsets
    private static FINAL Integer AD_CALC_AMEND_PRELIM_SIGN = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Amend_Prelim_Det_Sig').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer AD_CALC_PRELIM_SIGN = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c
    private static FINAL Integer AD_CALC_FINAL_SIGN = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer AD_CALC_ITC_PRELIM_DET = ((Integer)setInvestigationApiToConstants().get('AD_Calc_ITC_Prelim_Det').Number_Value__c);//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer AD_CALC_PRELIM_EXT_REQ_FILE = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Prelim_Ext_Request_File').Number_Value__c);//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer AD_CALC_POSTPONE_PRELIM_DET_FR = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Postpone_Prelim_Det_FR').Number_Value__c);//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer AD_PRELIM_TEAM_MEETING_DEADLINE = ((Integer)setInvestigationApiToConstants().get('AD_Prelim_Team_Meeting_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer AD_TERM_SUSP_GAP_PERIOD_BEG_W_EXT = ((Integer)setInvestigationApiToConstants().get('AD_Term_Susp_Gap_Period_Beg_w_FinExt').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c with Final Extension of days
    private static FINAL Integer AD_TERM_SUSP_GAP_PERIOD_BEG_W_O_EXT = ((Integer)setInvestigationApiToConstants().get('AD_Term_Susp_Gap_Period_Beg_w_o_FinExt').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c without Final Extension of days
    private static FINAL Integer AD_FINAL_TEAM_MEETING_DEADLINE = ((Integer)setInvestigationApiToConstants().get('AD_Final_Team_Meeting_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer AD_CALC_AMENDED_FINAL_SIGNATURE = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Amend_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c
    private static FINAL Integer AD_EST_ITC_NOTIF_DOC_FINAL_DET = ((Integer)setInvestigationApiToConstants().get('AD_Est_ITC_Note_of_DOC_to_Final_Det').Number_Value__c);//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer AD_CALC_ORDER_FR_SIGNATURE = ((Integer)setInvestigationApiToConstants().get('AD_Calc_Order_FR_Sig').Number_Value__c);//Calculated_Order_FR_Signature__c
    private static FINAL Integer AD_CALC_ITC_FINAL_FR_PUBLISHED = ((Integer)setInvestigationApiToConstants().get('AD_Calc_ITC_Final_FR_Published').Number_Value__c);//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer AD_EST_ORDER_FR_PUBLISHED = ((Integer)setInvestigationApiToConstants().get('AD_Est_Order_FR_Published').Number_Value__c);//Estimated_Order_FR_Published__c

    //FINAL CVD Record Type Offsets
    private static FINAL Integer CVD_CALC_AMEND_PRELIM_SIGN = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Amend_Prelim_Det_Sig').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer CVD_CALC_PRELIM_SIGN = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c
    private static FINAL Integer CVD_CALC_FINAL_SIGN = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer CVD_CALC_ITC_PRELIM_DET = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_ITC_Prelim_Det').Number_Value__c);//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer CVD_CALC_PRELIM_EXT_REQ_FILE = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Prelim_Ext_Request_File').Number_Value__c);//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer CVD_CALC_POSTPONE_PRELIM_DET_FR = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Postpone_Prelim_Det_FR').Number_Value__c);//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer CVD_PRELIM_TEAM_MEETING_DEADLINE = ((Integer)setInvestigationApiToConstants().get('CVD_Prelim_Team_Meeting_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer CVD_TERM_SUSP_GAP_PERIOD_BEG = ((Integer)setInvestigationApiToConstants().get('CVD_Term_Susp_Gap_Period_Beg').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c
    private static FINAL Integer CVD_FINAL_TEAM_MEETING_DEADLINE = ((Integer)setInvestigationApiToConstants().get('CVD_Final_Team_Meeting_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer CVD_CALC_AMENDED_FINAL_SIGNATURE = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Amend_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c
    private static FINAL Integer CVD_EST_ITC_NOTIF_DOC_FINAL_DET = ((Integer)setInvestigationApiToConstants().get('CVD_Est_ITC_Note_to_DOC_of_Final_Det').Number_Value__c);//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer CVD_CALC_ORDER_FR_SIGNATURE = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_Order_FR_Sig').Number_Value__c);//Calculated_Order_FR_Signature__c
    private static FINAL Integer CVD_CALC_ITC_FINAL_FR_PUBLISHED = ((Integer)setInvestigationApiToConstants().get('CVD_Calc_ITC_Final_FR_Published').Number_Value__c);//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer CVD_EST_ORDER_FR_PUBLISHED = ((Integer)setInvestigationApiToConstants().get('CVD_Est_Order_FR_Published').Number_Value__c);//Estimated_Order_FR_Published__c
    
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Investigation__c> newList, List<Investigation__c> oldList, Map<Id, Investigation__c> newMap, 
        Map<Id, Investigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        if (isBefore && isInsert) {
            initialize(newList, newMap);
            syncToInvestigation(newList);
        	calculateInvestigationDates(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList, newMap);
            syncToInvestigation(newList);
            calculateInvestigationDates(newList);
        }
        if (isAfter && isUpdate) {
            initialize(newList, newMap);
            recalculateCVDinvestigations(newMap);
        }
    }
    
    //Maps used in multiple methods in calculateInvestigationDates regardless of record type
    @TestVisible private static Map<Id,Petition__c> petitionsInScopeMap = new Map<Id,Petition__c>();
    @TestVisible private static Set<Id> unfinishedPetitions = new Set<Id>();
    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    @TestVisible private static Map<String,Investigation_Constant__mdt> investigationApiToConstants = new Map<String,Investigation_Constant__mdt>();

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Investigation__c> newList, Map<Id,Investigation__c> newMap) {
        petitionsInScopeMap = findPetitionsInScopeMap(newList);
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
        if (newMap != null) {
            ADCVD_FederalRegisterUtility frMapUtil = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Investigations with an Id
        }
    }
    //Syncs petition fields to investigation fields and AD to CVD if aligned
    @TestVisible private static void syncToInvestigation(List<Investigation__c> newList) {
            SyncUtility.syncObject(newList, null, true);
    }
    //Primary calculation method for Trigger Handler
    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList) {
        Boolean completePetition = false;
    	for (Investigation__c i : newList) {
            completePetition = findCompletePetition(i);
            if(completePetition) {
    			//Ordered Methods (must be done in a specific order)
        		setCalculatedPreliminarySignature(i);
        		//dependent on setCalculatedPreliminarySignature
        		setCalcAmendedPrelimDeterminationSig(i);
        		setPrelimTeamMeetingDeadline(i);
        		setCalculatedFinalSignature(i);
        		//dependent on setCalculatedFinalSignature
                setCalculatedAmendedFinalSignature(i);
        		setFinalTeamMeetingDeadline(i);
        		setEstITCNotificationtoDOCofFinalDet(i);
        		//dependent on setEstITCNotificationtoDOCofFinalDet
        		setCalculatedOrderFRSignature(i);
        		setCalculatedITCFinalFRPublished(i);
        		setEstimatedOrderFRPublished(i);
        		//Unordered Methods
        		setCalculatedPrelimExtensionRequestFile(i);
        		setCalculatedPostponementOfPrelimDeterFR(i);
            }
            //do not require petition signature values
            setCalculatedITCPrelimDetermination(i);
    		setTerminationofSuspensionGapPeriodBeg(i);
    	}
    }
    //returns a list of CVD Investigations to update if the aligned AD Investigation is updated
    @TestVisible private static void recalculateCVDinvestigations(Map<Id,Investigation__c> newMap) {
        List<Investigation__c> CVDinvestigations = [SELECT Id FROM Investigation__c WHERE AD_Investigation_Aligned_To__c IN: newMap.keySet()];
        update CVDinvestigations;
    }

    /*******************************************************************************
     * Methods in this section are used to set class level variables or 
     * make it easier access to them in the class
     ********************************************************************************/

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
    	for (Petition__c p : [SELECT Id, Petition_Filed__c, Initiation_Extension_of_days__c, Actual_Initiation_Signature__c, 
    									Calculated_Initiation_Signature__c
    								FROM Petition__c WHERE Id IN: petitionIdSet]) {
    		returnMap.put(p.Id, p);
            if(p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c == null) {
                unfinishedPetitions.add(p.Id);
            }
    	}
    	return returnMap;
    }
    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Investigation_Constant__mdt> setInvestigationApiToConstants() {
        Map<String,Investigation_Constant__mdt> returnMap = new Map<String,Investigation_Constant__mdt>();
        List<Investigation_Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Record_Type_Name__c, Number_Value__c FROM Investigation_Constant__mdt 
                                                        WHERE Investigation_Calculation_Offset__c =: true];
        for(Investigation_Constant__mdt ic : tempList) {
            returnMap.put(ic.QualifiedAPIName, ic);
        }
        return returnMap;
    }
    
    /****************************************************************************************
    *These methods set the values for specific dates as part of calculateInvestigationDates()
    *The naming convention is set<FieldAPIName>
    *All share the same params of a single Investigation object
    ****************************************************************************************/

    //checks that the petition has the values to proceed...this avoids NPEs on Petitions without dates to start calculations
    @TestVisible private static Boolean findCompletePetition(Investigation__c i){
        Boolean returnBoolean = false;
        Petition__c p = petitionsInScopeMap.get(i.Petition__c);
        if(!unfinishedPetitions.contains(p.Id)){
            returnBoolean = true;
        }
        return returnBoolean;
    }

    //Ordered Methods
    //sets Calculated_Preliminary_Signature__c
    @TestVisible private static void setCalculatedPreliminarySignature(Investigation__c i) {
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Calculated_Initiation_Signature__c;//used for CVD alignment lookup
				i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(AD_CALC_PRELIM_SIGN).addDays(extension);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Actual_Initiation_Signature__c;
				i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(AD_CALC_PRELIM_SIGN).addDays(extension);
				i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
            if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Calculated_Initiation_Signature__c;
                i.Calculated_Preliminary_Signature__c = p.Calculated_Initiation_Signature__c.addDays(CVD_CALC_PRELIM_SIGN).addDays(extension);
                i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Petition_Initiation_Signature__c = p.Actual_Initiation_Signature__c;
                i.Calculated_Preliminary_Signature__c = p.Actual_Initiation_Signature__c.addDays(CVD_CALC_PRELIM_SIGN).addDays(extension);
                i.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Preliminary_Signature__c, true);
            }
		}
    }

   //sets Calc_Amended_Prelim_Determination_Sig__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalcAmendedPrelimDeterminationSig(Investigation__c i) {
        if (i.Amend_the_Preliminary_Determination__c == 'No') {
            i.Calc_Amended_Prelim_Determination_Sig__c = null;
        } else {
        	if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    			if (i.Actual_Preliminary_Signature__c == null && i.Calculated_Preliminary_Signature__c != null) {
    	    		i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(AD_CALC_AMEND_PRELIM_SIGN);
    	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
    	    	} else if (i.Actual_Preliminary_Signature__c != null) {
    	    		i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(AD_CALC_AMEND_PRELIM_SIGN);
    	    		i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
    	    	}
    	    } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
    			if (i.Actual_Preliminary_Signature__c == null && i.Calculated_Preliminary_Signature__c != null) {
                    i.Calc_Amended_Prelim_Determination_Sig__c = i.Calculated_Preliminary_Signature__c.addDays(CVD_CALC_AMEND_PRELIM_SIGN);
                    i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
                } else if (i.Actual_Preliminary_Signature__c != null) {
                    i.Calc_Amended_Prelim_Determination_Sig__c =  i.Actual_Preliminary_Signature__c.addDays(CVD_CALC_AMEND_PRELIM_SIGN);
                    i.Calc_Amended_Prelim_Determination_Sig__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calc_Amended_Prelim_Determination_Sig__c, true);
                }
    		}
        }
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Investigation__c i){
        if(recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
        	if (i.Calculated_Preliminary_Signature__c != null) {
        		i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(AD_PRELIM_TEAM_MEETING_DEADLINE);
        		i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
        	}
        } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
            if (i.Calculated_Preliminary_Signature__c != null) {
                i.Prelim_Team_Meeting_Deadline__c = i.Calculated_Preliminary_Signature__c.addDays(CVD_PRELIM_TEAM_MEETING_DEADLINE);
                i.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Prelim_Team_Meeting_Deadline__c, true);
            }
        }
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Investigation__c i){
        Integer extension = i.Final_Extension_of_days__c == null ? 0 : (Integer)i.Final_Extension_of_days__c;//null check on extension, set to 0 if null
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
            ADCVD_FederalRegisterUtility frUtil = ADCVD_FederalRegisterUtility.getInstance(i);
            Date prelimpublished = frUtil != null ? frUtil.preliminaryPublishedDate : null;
            System.debug(prelimpublished);
    		if (extension > 0 && prelimpublished != null) {
                i.Calculated_Final_Signature__c = prelimpublished.addDays(AD_CALC_FINAL_SIGN).addDays(extension);
                i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimpublished, i.Calculated_Final_Signature__c, true);
            } else {
                if (i.Actual_Preliminary_Signature__c == null) {
                    i.Calculated_Final_Signature__c = i.Calculated_Preliminary_Signature__c.addDays(AD_CALC_FINAL_SIGN);
                    i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
                } else {
                    i.Calculated_Final_Signature__c = i.Actual_Preliminary_Signature__c.addDays(AD_CALC_FINAL_SIGN);
                    i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
                }
            }
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
            if (i.Actual_Preliminary_Signature__c == null) {
                i.Calculated_Final_Signature__c = i.Calculated_Preliminary_Signature__c.addDays(CVD_CALC_FINAL_SIGN);
                i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
            } else {
                i.Calculated_Final_Signature__c = i.Actual_Preliminary_Signature__c.addDays(CVD_CALC_FINAL_SIGN);
                i.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Preliminary_Signature__c, i.Calculated_Final_Signature__c, true);
            }
    	}
    }

    //sets Calculated_Amended_Final_Signature__c
    @TestVisible private static void setCalculatedAmendedFinalSignature(Investigation__c i){
        if (i.Will_you_Amend_the_Final__c == 'No') {
            i.Calculated_Amended_Final_Signature__c = null;
        } else {
            if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
                if (i.Actual_Final_Signature__c != null) {
                    i.Calculated_Amended_Final_Signature__c = i.Actual_Final_Signature__c.addDays(AD_CALC_AMENDED_FINAL_SIGNATURE);
                    i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
                } else {
                    i.Calculated_Amended_Final_Signature__c = i.Calculated_Final_Signature__c.addDays(AD_CALC_AMENDED_FINAL_SIGNATURE);
                    i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
                }
            } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
                if (i.Actual_Final_Signature__c != null) {
                    i.Calculated_Amended_Final_Signature__c = i.Actual_Final_Signature__c.addDays(CVD_CALC_AMENDED_FINAL_SIGNATURE);
                    i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
                } else {
                    i.Calculated_Amended_Final_Signature__c = i.Calculated_Final_Signature__c.addDays(CVD_CALC_AMENDED_FINAL_SIGNATURE);
                    i.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Calculated_Amended_Final_Signature__c, true);
                }
            }
        }
    }

    //sets Final_Team_Meeting_Deadline__c, requires Calculated_Final_Signature__c to be set
    @TestVisible private static void setFinalTeamMeetingDeadline(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (i.Calculated_Final_Signature__c != null) {
	    		i.Final_Team_Meeting_Deadline__c = i.Calculated_Final_Signature__c.addDays(AD_FINAL_TEAM_MEETING_DEADLINE);
	    		i.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Final_Team_Meeting_Deadline__c, true);
	    	}
	    } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
	    	if (i.Calculated_Final_Signature__c != null) {
                i.Final_Team_Meeting_Deadline__c = i.Calculated_Final_Signature__c.addDays(CVD_FINAL_TEAM_MEETING_DEADLINE);
                i.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Final_Team_Meeting_Deadline__c, true);
            }
	    }
    }

    //sets Est_ITC_Notification_to_DOC_of_Final_Det__c, requires Calculated_Final_Signature__c to be set
    @TestVisible private static void setEstITCNotificationtoDOCofFinalDet(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.Actual_Final_Signature__c == null) {
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Calculated_Final_Signature__c.addDays(AD_EST_ITC_NOTIF_DOC_FINAL_DET);
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
    		} else {
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Actual_Final_Signature__c.addDays(AD_EST_ITC_NOTIF_DOC_FINAL_DET);
    			i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.Actual_Final_Signature__c == null) {
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Calculated_Final_Signature__c.addDays(CVD_EST_ITC_NOTIF_DOC_FINAL_DET);
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Calculated_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
            } else {
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = i.Actual_Final_Signature__c.addDays(CVD_EST_ITC_NOTIF_DOC_FINAL_DET);
                i.Est_ITC_Notification_to_DOC_of_Final_Det__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Actual_Final_Signature__c, i.Est_ITC_Notification_to_DOC_of_Final_Det__c, true);
            }
    	}
    }

    //sets Calculated_Order_FR_Signature__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setCalculatedOrderFRSignature(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_Order_FR_Signature__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(AD_CALC_ORDER_FR_SIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_Order_FR_Signature__c, true);
    		} else {
    			i.Calculated_Order_FR_Signature__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(AD_CALC_ORDER_FR_SIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_Order_FR_Signature__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVD_CALC_ORDER_FR_SIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		} else {
    			i.Calculated_Order_FR_Signature__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVD_CALC_ORDER_FR_SIGNATURE);
    			i.Calculated_Order_FR_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_Order_FR_Signature__c, true);
    		}
    	}
    }

    //sets Calculated_ITC_Final_FR_Published__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setCalculatedITCFinalFRPublished(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_ITC_Final_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(AD_CALC_ITC_FINAL_FR_PUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		} else {
    			i.Calculated_ITC_Final_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(AD_CALC_ITC_FINAL_FR_PUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Calculated_ITC_Final_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVD_CALC_ITC_FINAL_FR_PUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		} else {
    			i.Calculated_ITC_Final_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVD_CALC_ITC_FINAL_FR_PUBLISHED);
    			i.Calculated_ITC_Final_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Calculated_ITC_Final_FR_Published__c, true);
    		}
    	}
    }

    //sets Estimated_Order_FR_Published__c, requires Est_ITC_Notification_to_DOC_of_Final_Det__c to be set
    @TestVisible private static void setEstimatedOrderFRPublished(Investigation__c i) {
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Estimated_Order_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(AD_EST_ORDER_FR_PUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Estimated_Order_FR_Published__c, true);
    		} else {
    			i.Estimated_Order_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(AD_EST_ORDER_FR_PUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Estimated_Order_FR_Published__c, true);
    		}
    	} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD && i.AD_Investigation_Aligned_To__c == null) {
    		if(i.ITC_Notification_to_DOC_of_Final_Determ__c == null) {
    			i.Estimated_Order_FR_Published__c = i.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(CVD_EST_ORDER_FR_PUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.Est_ITC_Notification_to_DOC_of_Final_Det__c, i.Estimated_Order_FR_Published__c, true);
    		} else {
    			i.Estimated_Order_FR_Published__c = i.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(CVD_EST_ORDER_FR_PUBLISHED);
    			i.Estimated_Order_FR_Published__c = ADCVD_TollingDayUtility.getCalculatedDate(i.ITC_Notification_to_DOC_of_Final_Determ__c, i.Estimated_Order_FR_Published__c, true);
    		}
    	}
    }
    
    //Unordered Methods

    //sets Calculated_Prelim_Extension_Request_File__c
    @TestVisible private static void setCalculatedPrelimExtensionRequestFile(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
				i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(AD_CALC_PRELIM_EXT_REQ_FILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
				i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(AD_CALC_PRELIM_EXT_REQ_FILE);
				i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Calculated_Prelim_Extension_Request_File__c = p.Calculated_Initiation_Signature__c.addDays(CVD_CALC_PRELIM_EXT_REQ_FILE);
                i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Calculated_Prelim_Extension_Request_File__c = p.Actual_Initiation_Signature__c.addDays(CVD_CALC_PRELIM_EXT_REQ_FILE);
                i.Calculated_Prelim_Extension_Request_File__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Prelim_Extension_Request_File__c, true);
            }
		}
    }

    //sets Calculated_Postponement_of_PrelimDeterFR__c
    @TestVisible private static void setCalculatedPostponementOfPrelimDeterFR(Investigation__c i){
    	Petition__c p = petitionsInScopeMap.get(i.Petition__c);
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(AD_CALC_POSTPONE_PRELIM_DET_FR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			} else if (p != null && p.Actual_Initiation_Signature__c != null) {
				i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(AD_CALC_POSTPONE_PRELIM_DET_FR);
				i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
			}
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (p != null && p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c != null) {
                i.Calculated_Postponement_of_PrelimDeterFR__c = p.Calculated_Initiation_Signature__c.addDays(CVD_CALC_POSTPONE_PRELIM_DET_FR);
                i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Calculated_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
            } else if (p != null && p.Actual_Initiation_Signature__c != null) {
                i.Calculated_Postponement_of_PrelimDeterFR__c = p.Actual_Initiation_Signature__c.addDays(CVD_CALC_POSTPONE_PRELIM_DET_FR);
                i.Calculated_Postponement_of_PrelimDeterFR__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Actual_Initiation_Signature__c, i.Calculated_Postponement_of_PrelimDeterFR__c, true);
            }
		}
    }
    //sets Calculated_ITC_Prelim_Determination__c
    @TestVisible private static void setCalculatedITCPrelimDetermination(Investigation__c i){
        Petition__c p = petitionsInScopeMap.get(i.Petition__c);
        Integer extension = i.Prelim_Extension_of_days__c == null ? 0 : (Integer)i.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
        if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
            if (p != null && p.Petition_Filed__c != null) {
                i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(AD_CALC_ITC_PRELIM_DET).addDays(extension);
                i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
            }
        } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
            if (p != null && p.Petition_Filed__c != null) {
                i.Calculated_ITC_Prelim_Determination__c = p.Petition_Filed__c.addDays(CVD_CALC_ITC_PRELIM_DET).addDays(extension);
                i.Calculated_ITC_Prelim_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, i.Calculated_ITC_Prelim_Determination__c, true);
            }
        }
    }

    //sets Termination_of_Suspension_Gap_Period_Beg__c
    @TestVisible private static void setTerminationofSuspensionGapPeriodBeg(Investigation__c i){
        ADCVD_FederalRegisterUtility frUtil = ADCVD_FederalRegisterUtility.getInstance(i);
        Federal_Register__c fr = frUtil != null ? frUtil.preliminaryFR : null;
    	Date prelimpublished = frUtil != null ? frUtil.preliminaryPublishedDate : null;
    	if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
	    	if (prelimpublished != null) {
		    	i.Termination_of_Suspension_Gap_Period_Beg__c = i.Final_Extension_of_days__c == null ? 
		    	prelimpublished.addDays(AD_TERM_SUSP_GAP_PERIOD_BEG_W_O_EXT) : 
		    	prelimpublished.addDays(AD_TERM_SUSP_GAP_PERIOD_BEG_W_EXT);
		    	i.Termination_of_Suspension_Gap_Period_Beg__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimpublished, i.Termination_of_Suspension_Gap_Period_Beg__c, true);
		    } else if (i.Termination_of_Suspension_Gap_Period_Beg__c != null && fr == null) {
                i.Termination_of_Suspension_Gap_Period_Beg__c = null;//after delete of fr
            }
		} else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
			if (prelimpublished != null) {
                i.Termination_of_Suspension_Gap_Period_Beg__c = prelimpublished.addDays(CVD_TERM_SUSP_GAP_PERIOD_BEG);
                i.Termination_of_Suspension_Gap_Period_Beg__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimpublished, i.Termination_of_Suspension_Gap_Period_Beg__c, true);
            } else if (i.Termination_of_Suspension_Gap_Period_Beg__c != null && fr == null) {
                i.Termination_of_Suspension_Gap_Period_Beg__c = null;//after delete of fr
            }
		}
	}
}