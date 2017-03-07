public without sharing class SegmentTriggerHandler {
	
	//FINAL Segment Record Types
	private static FINAL String ADMIN_REVIEW = segmentCalcOffsets().get('Admin_Review_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String ANTI_CIRCUMVENTION_REVIEW = '';
	private static FINAL String CHANGED_CIRCUMSTANCES_REVIEW = '';
	private static FINAL String EXPEDITED_REVIEW = '';
	private static FINAL String NEW_SHIPPER_REVIEW = segmentCalcOffsets().get('New_Shipper_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String SCOPE_INQUIRY = segmentCalcOffsets().get('Scope_Inq_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String SUNSET_REVIEW = '';

	//FINAL Segment Administrative Review Offsets
	private static FINAL Integer AR_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets().get('Admin_Review_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c	
	private static FINAL Integer AR_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('Admin_Review_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer AR_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets().get('Admin_Review_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer AR_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('Admin_Review_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	private static FINAL Integer AR_CALC_AMEN_FINAL_SIG = ((Integer)segmentCalcOffsets().get('Admin_Review_Calc_Amen_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

	//FINAL Segment New Shipper Review Offsets
	private static FINAL Integer NS_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets().get('New_Shipper_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c	
	private static FINAL Integer NS_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('New_Shipper_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer NS_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets().get('New_Shipper_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer NS_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('New_Shipper_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	private static FINAL Integer NS_CALC_AMEN_FINAL_SIG = ((Integer)segmentCalcOffsets().get('New_Shipper_Calc_Amen_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

	//FINAL Segment Scope Inquiry Offsets
	private static FINAL Integer SI_DEADLINE_FOR_DECISION_HOP = ((Integer)segmentCalcOffsets().get('Scope_Inq_Deadline_for_Decision_HoP').Number_Value__c);//Scope_Inq_Deadline_for_Decision_HoP__c	
	private static FINAL Integer SI_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets().get('Scope_Inq_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c	
	private static FINAL Integer SI_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('Scope_Inq_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer SI_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets().get('Scope_Inq_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer SI_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets().get('Scope_inq_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	

	

	public static boolean preventRecursion = false;
    public static void mainEntry(List<Segment__c> newList, List<Segment__c> oldList, Map<Id, Segment__c> newMap, 
        Map<Id, Segment__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        if (isBefore && isInsert) {
        	initialize(newList, newMap);
        	calculateSegmentDates(newList);
        }
        if (isBefore && isUpdate) {
        	initialize(newList, newMap);
        	calculateSegmentDates(newList);

        }
        if (isAfter && isUpdate) {

        }
    }

    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();

    @TestVisible private static void calculateSegmentDates(List<Segment__c> newList) {
    	for (Segment__c s : newList) {
			//Ordered Methods (must be done in a specific order)
			setDeadlineForDecisionForHoP(s);
    		setCalculatedPreliminarySignature(s);
    		//dependent on setCalculatedPreliminarySignature
    		setPrelimTeamMeetingDeadline(s);
    		setCalculatedFinalSignature(s);
    		//dependent on setCalculatedFinalSignature
            setCalculatedAmendedFinalSignature(s);
    		setFinalTeamMeetingDeadline(s);
    	}
    }

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Segment__c> newList, Map<Id,Segment__c> newMap) {
        //petitionsInScopeMap = findPetitionsInScopeMap(newList);
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
        if(newMap != null) {
            ADCVD_FederalRegisterUtility frMapUtil = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get segments with an Id
        }
    }
    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Segment_Constant__mdt> segmentCalcOffsets() {
        Map<String,Segment_Constant__mdt> returnMap = new Map<String,Segment_Constant__mdt>();
        List<Segment_Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Record_Type_Name__c, Number_Value__c FROM Segment_Constant__mdt 
                                                        WHERE Segment_Calculation_Offset__c =: true];
        for(Segment_Constant__mdt sc : tempList) {
            returnMap.put(sc.QualifiedAPIName, sc);
        }
        return returnMap;
    }

    /*********************************************************************************
    *These methods set the values for specific fields
    *The naming convention is set<FieldAPIName>
    *All share the same params of a single Segment__c object
    *********************************************************************************/

    //Ordered Methods
    //sets Deadline_for_Decision_for_HoP__c for Scope Inquiry Segments
    @TestVisible private static void setDeadlineForDecisionForHoP(Segment__c s) {
    	if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
//TODO is Initiation_Extension_of_days__c correct?
    		Integer extension = s.Initiation_Extension_of_days__c == null ? 0 : (Integer)s.Initiation_Extension_of_days__c;//null check on extension, set to 0 if null
    		if(s.Request_Filed__c != null) {
    			s.Deadline_for_Decision_on_How_to_Proceed__c = s.Request_Filed__c.addDays(SI_DEADLINE_FOR_DECISION_HOP).addDays(extension);
    			s.Deadline_for_Decision_on_How_to_Proceed__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Request_Filed__c, s.Deadline_for_Decision_on_How_to_Proceed__c, true);
    		}
    	}
    }
    //sets Calculated_Preliminary_Signature__c
    @TestVisible private static void setCalculatedPreliminarySignature(Segment__c s) {
    	Integer extension = s.Prelim_Extension__c == null ? 0 : (Integer)s.Prelim_Extension__c;//null check on extension, set to 0 if null
        System.debug(recordTypeNameMap.get(s.RecordTypeId));
        System.debug(ADMIN_REVIEW);
    	if(recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
            if(s.Final_Date_of_Anniversary_Month__c != null) {
                s.Calculated_Preliminary_Signature__c = s.Final_Date_of_Anniversary_Month__c.addDays(AR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Final_Date_of_Anniversary_Month__c, s.Calculated_Preliminary_Signature__c, true);
            }
		} else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
			if (s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null) {
                s.Calculated_Preliminary_Signature__c = s.Calculated_Initiation_Signature__c.addDays(NS_CALC_PRELIM_SIG).addDays(extension);
				s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);
			} else if (s.Actual_Initiation_Signature__c != null) {
                s.Calculated_Preliminary_Signature__c = s.Actual_Initiation_Signature__c.addDays(NS_CALC_PRELIM_SIG).addDays(extension);
				s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
			if (s.Decision_on_How_to_Proceed__c == 'Formal' && s.Actual_Date_of_Decision_on_HoP__c != null) {
				s.Calculated_Preliminary_Signature__c = s.Actual_Date_of_Decision_on_HoP__c.addDays(SI_CALC_PRELIM_SIG).addDays(extension);
				s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Date_of_Decision_on_HoP__c, s.Calculated_Preliminary_Signature__c, true);
			} else if (s.Decision_on_How_to_Proceed__c != 'Formal') {
                s.Calculated_Preliminary_Signature__c = null;
            }
		}
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Segment__c s){
        if(recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
        	if (s.Calculated_Preliminary_Signature__c != null) {
        		s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(AR_PRELIM_TEAM_MEET_DEADLINE);
        		s.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Prelim_Team_Meeting_Deadline__c, true);
        	}
        } else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
            if (s.Calculated_Preliminary_Signature__c != null) {
                s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(NS_PRELIM_TEAM_MEET_DEADLINE);
                s.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Prelim_Team_Meeting_Deadline__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
        	if (s.Decision_on_How_to_Proceed__c == 'Formal' && s.Calculated_Preliminary_Signature__c != null) {
                s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(SI_PRELIM_TEAM_MEET_DEADLINE);
                s.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Prelim_Team_Meeting_Deadline__c, true);
            } else if (s.Decision_on_How_to_Proceed__c != 'Formal') {
                s.Prelim_Team_Meeting_Deadline__c = null;
            }
		}
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Segment__c s){
        ADCVD_FederalRegisterUtility frUtil = ADCVD_FederalRegisterUtility.getInstance(s);
        Date prelimpublished = frUtil != null ? frUtil.preliminaryPublishedDate : null;
        Integer extension = s.Final_Extension_of_days__c == null ? 0 : (Integer)s.Final_Extension_of_days__c;//null check on extension, set to 0 if null
    	if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
    		if (prelimPublished == null && s.Calculated_Preliminary_Signature__c != null) {
				s.Calculated_Final_Signature__c = s.Calculated_Preliminary_Signature__c.addDays(AR_CALC_FINAL_SIG).addDays(extension);
				s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Calculated_Final_Signature__c, true);
    		} else if (prelimPublished != null) {
    			s.Calculated_Final_Signature__c = prelimPublished.addDays(AR_CALC_FINAL_SIG).addDays(extension);
    			s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimPublished, s.Calculated_Final_Signature__c, true);
    		}
    	} else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
            if (s.Actual_Preliminary_Signature__c == null && s.Calculated_Preliminary_Signature__c != null) {
                s.Calculated_Final_Signature__c = s.Calculated_Preliminary_Signature__c.addDays(NS_CALC_FINAL_SIG).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (s.Actual_Preliminary_Signature__c != null) {
                s.Calculated_Final_Signature__c = s.Actual_Preliminary_Signature__c.addDays(NS_CALC_FINAL_SIG).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Preliminary_Signature__c, s.Calculated_Final_Signature__c, true);
            }
    	} else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
    		if (s.Decision_on_How_to_Proceed__c == 'Formal' && s.Actual_Date_of_Decision_on_HoP__c != null) {
				s.Calculated_Final_Signature__c = s.Actual_Date_of_Decision_on_HoP__c.addDays(SI_CALC_FINAL_SIG).addDays(extension);
				s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Date_of_Decision_on_HoP__c, s.Calculated_Final_Signature__c, true);
			} else if (s.Decision_on_How_to_Proceed__c != 'Formal') {
                s.Calculated_Final_Signature__c = null;
            }
		}
    }

    //sets Final_Team_Meeting_Deadline__c, requires Calculated_Final_Signature__c to be set
    @TestVisible private static void setFinalTeamMeetingDeadline(Segment__c s) {

    	if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
	    	if (s.Calculated_Final_Signature__c != null) {
	    		s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c.addDays(AR_FINAL_TEAM_MEET_DEADLINE);
	    		s.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Final_Team_Meeting_Deadline__c, true);
	    	}
	    } else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
	    	if (s.Calculated_Final_Signature__c != null) {
                s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c.addDays(NS_FINAL_TEAM_MEET_DEADLINE);
                s.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Final_Team_Meeting_Deadline__c, true);
            }
	    } else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
	    	if (s.Decision_on_How_to_Proceed__c == 'Formal' && s.Calculated_Final_Signature__c != null) {
                s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c.addDays(SI_FINAL_TEAM_MEET_DEADLINE);
                s.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Final_Team_Meeting_Deadline__c, true);
            } else if (s.Decision_on_How_to_Proceed__c != 'Formal') {
                s.Final_Team_Meeting_Deadline__c = null;
            }
		}
    }

    //sets Calculated_Amended_Final_Signature__c
    @TestVisible private static void setCalculatedAmendedFinalSignature(Segment__c s){
        if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
        	if(s.Calculated_Final_Signature__c != null){
	            s.Calculated_Amended_Final_Signature__c = s.Calculated_Final_Signature__c.addDays(AR_CALC_AMEN_FINAL_SIG);
	            s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
	        }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
        	if(s.Calculated_Final_Signature__c != null){
	            s.Calculated_Amended_Final_Signature__c = s.Calculated_Final_Signature__c.addDays(NS_CALC_AMEN_FINAL_SIG);
	            s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
	        }
        }
    }
}