public without sharing class SegmentTriggerHandler {
	
    private static Map<String,Segment_Constant__mdt> segmentCalcOffsets = segmentCalcOffsets();
	//FINAL Segment Record Types
	private static FINAL String ADMIN_REVIEW = segmentCalcOffsets.get('Admin_Review_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String ANTI_CIRCUMVENTION_REVIEW = segmentCalcOffsets.get('Anti_Circ_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String CHANGED_CIRCUMSTANCES_REVIEW = segmentCalcOffsets.get('Changed_Circ_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String EXPEDITED_REVIEW = segmentCalcOffsets.get('Exped_Review_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String NEW_SHIPPER_REVIEW = segmentCalcOffsets.get('New_Shipper_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String SCOPE_INQUIRY = segmentCalcOffsets.get('Scope_Inq_Calc_Prelim_Sig').Record_Type_Name__c;
	private static FINAL String SUNSET_REVIEW = segmentCalcOffsets.get('SS_Rev_Notice_Intent_Participate').Record_Type_Name__c;

	//FINAL Segment Administrative Review Offsets
	private static FINAL Integer AR_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('Admin_Review_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c	
	private static FINAL Integer AR_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Admin_Review_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer AR_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Admin_Review_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer AR_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Admin_Review_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	private static FINAL Integer AR_CALC_AMEN_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Admin_Review_Calc_Amen_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

    //FINAL Segment Expedited Review Offsets
    private static FINAL Integer ER_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('Exped_Review_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c    
    private static FINAL Integer ER_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Exped_Review_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c 
    private static FINAL Integer ER_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Exped_Review_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer ER_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Exped_Review_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer ER_CALC_AMEN_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Exped_Review_Calc_Amen_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

	//FINAL Segment New Shipper Review Offsets
	private static FINAL Integer NS_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('New_Shipper_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c	
	private static FINAL Integer NS_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('New_Shipper_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer NS_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('New_Shipper_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer NS_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('New_Shipper_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	private static FINAL Integer NS_CALC_AMEN_FINAL_SIG = ((Integer)segmentCalcOffsets.get('New_Shipper_Calc_Amen_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

	//FINAL Segment Scope Inquiry Offsets
	private static FINAL Integer SI_DEADLINE_FOR_DECISION_HOP = ((Integer)segmentCalcOffsets.get('Scope_Inq_Deadline_for_Decision_HoP').Number_Value__c);//Scope_Inq_Deadline_for_Decision_HoP__c	
	private static FINAL Integer SI_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('Scope_Inq_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c	
	private static FINAL Integer SI_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Scope_Inq_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c	
	private static FINAL Integer SI_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Scope_Inq_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer SI_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Scope_inq_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
	
    //FINAL Segment Anti-Circumvention Review Offsets
    private static FINAL Integer ACR_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Anti_Circ_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer ACR_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('Anti_Circ_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer ACR_CALC_INIT_SIG = ((Integer)segmentCalcOffsets.get('Anti_Circ_Init_Signature').Number_Value__c);//Calculated_Initiation_Signature__c
    private static FINAL Integer ACR_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Anti_Circ_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer ACR_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('Anti_Circ_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c  
    private static FINAL Integer ACR_NOTIFY_ITC_FIVE = ((Integer)segmentCalcOffsets.get('Anti_Circ_Notify_ITC_Five').Number_Value__c);//Notify_ITC_If_Affirmative_Prelim_Determ__c
    private static FINAL Integer ACR_NOTIFY_ITC_TWO = ((Integer)segmentCalcOffsets.get('Anti_Circ_Notify_ITC_Two').Number_Value__c);//Notify_ITC_If_Affirmative_Prelim_Determ__c
    
    //FINAL Segment Changed-Circumstances Review Offsets
    private static FINAL Integer CCR_CALC_INIT_SIG = ((Integer)segmentCalcOffsets.get('Changed_Circ_Calc_Init_Sig').Number_Value__c);//Calculated_Initiation_Signature__c
    private static FINAL Integer CCR_CALC_PRELIM_SIG = ((Integer)segmentCalcOffsets.get('Changed_Circ_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c  
    private static FINAL Integer CCR_PRELIM_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Changed_Circ_Prelim_Team_Meet_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer CCR_CALC_FINAL_SIG_FORTYFIVE = ((Integer)segmentCalcOffsets.get('Changed_Circ_Calc_Final_Sig_Fortyfive').Number_Value__c);//Calculated_Final_Signature__c for 45 days
    private static FINAL Integer CCR_CALC_FINAL_SIG_TWOSEVENTY = ((Integer)segmentCalcOffsets.get('Changed_Circ_Calc_Final_Sig_Twoseventy').Number_Value__c);//Calculated_Final_Signature__c for 270 days
    private static FINAL Integer CCR_FINAL_TEAM_MEET_DEADLINE = ((Integer)segmentCalcOffsets.get('Changed_Circ_Final_Team_Meet_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c

    //FINAL Segment Sunset Review Offsets
    //All Sunset Reviews
    private static FINAL Integer SSR_NOTICE_INTENT_PARTICIPATE = ((Integer)segmentCalcOffsets.get('SS_Rev_Notice_Intent_Participate').Number_Value__c);//Notice_of_Intent_to_Participate__c
    private static FINAL Integer SSR_NOTIFY_CLUSTER_CDNTR_NO_INT = ((Integer)segmentCalcOffsets.get('SS_Rev_Notify_Cluster_Cdntr_No_Int').Number_Value__c);//Notify_Cluster_Coordinator_No_Interest__c
    private static FINAL Integer SSR_SUBSTAN_RESP_DUE_ALL_PARTIES = ((Integer)segmentCalcOffsets.get('SS_Rev_Substan_Resp_Due_All_Parties').Number_Value__c);//Substantive_Response_Due_For_All_Parties__c 
    private static FINAL Integer SSR_REV_INFORM_CLUSTER_CDNTR_IF_NO_RESP = ((Integer)segmentCalcOffsets.get('SS_Rev_Inform_Cluster_Cdntr_If_No_Resp').Number_Value__c);//Inform_Cluster_Coordinator_if_No_Respons__c
    private static FINAL Integer SSR_CALC_REVO_OR_CONT_FR = ((Integer)segmentCalcOffsets.get('SS_Rev_Calc_Revo_or_Cont_FR').Number_Value__c);//Calculated_Revocation_or_Continuation_FR__c
    //90 Day Sunset Reviews
    private static FINAL Integer SSR_90_NOTIFY_ITC_NO_DOMESTIC_INT = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Notify_ITC_No_Domestic_Int').Number_Value__c);//Notify_ITC_of_No_Domestic_Interest__c
    private static FINAL Integer SSR_90_INADEQUATE_DOM_RESP_TO_ITC = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Inadequate_Dom_Resp_to_ITC').Number_Value__c);//Inadequate_Domestic_Response_note_to_ITC__c
    private static FINAL Integer SSR_90_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer SSR_90_FIN_SIG_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Fin_Sig_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on NO Final FR
    private static FINAL Integer SSR_90_FIN_FR_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Fin_FR_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on Final FR
    private static FINAL Integer SSR_90_FIN_SIG_ISSUE_LIQ_REVO_INSTR = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Fin_Sig_Issue_Liq_Revo_Instr').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on NO Final FR
    private static FINAL Integer SSR_90_FIN_FR_ISSUE_LIQ_REVO_INSTR = ((Integer)segmentCalcOffsets.get('SS_Rev_90_Fin_FR_Issue_Liq_Revo_Instr').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on Final FR
    //120 Day Sunset Reviews
    private static FINAL Integer SSR_120_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer SSR_120_REVO_SIG_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Revo_Sig_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on NO Revocation FR
    private static FINAL Integer SSR_120_REVO_FR_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Revo_FR_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on Revocation FR
    private static FINAL Integer SSR_120_REVO_SIG_ISSUE_LIQ_REVO_INS = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Revo_Sig_Issue_Liq_Revo_Ins').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on NO Revocation FR
    private static FINAL Integer SSR_120_REVO_FR_ISSUE_LIQ_REVO_INS = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Revo_FR_Issue_Liq_Revo_Ins').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on Revocation FR
    private static FINAL Integer SSR_120_REBUTTAL_COMMENTS_DUE = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Rebuttal_Comments_Due').Number_Value__c);//Rebuttal_Comments_Due__c
    private static FINAL Integer SSR_120_ADEQUACY_DET_AND_LET_TO_ITC = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Adequacy_Det_and_Let_to_ITC').Number_Value__c);//Adequacy_Determination_and_Letter_to_ITC__c
    private static FINAL Integer SSR_120_COMMENTS_ON_ADEQ_DET_FILED = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Comments_on_Adeq_Det_Filed').Number_Value__c);//Comments_on_Adequacy_Determination_Filed__c
    private static FINAL Integer SSR_120_MEMO_ON_ADEQUACY_DET = ((Integer)segmentCalcOffsets.get('SS_Rev_120_Memo_on_Adequacy_Det').Number_Value__c);//Memorandum_on_Adequacy_Determination__c
    //240 Day Sunset Review
    private static FINAL Integer SSR_240_CALC_FINAL_SIG = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer SSR_240_REVO_SIG_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Revo_Sig_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on NO Revocation FR
    private static FINAL Integer SSR_240_REVO_FR_UPDATE_ACE_CUS_MOD = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Revo_FR_Update_ACE_Cus_Mod').Number_Value__c);//Update_ACE_Customs_Module__c based on Revocation FR
    private static FINAL Integer SSR_240_REVO_SIG_ISSUE_LIQ_REVO_INS = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Revo_Sig_Issue_Liq_Revo_Ins').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on NO Revocation FR
    private static FINAL Integer SSR_240_REVO_FR_ISSUE_LIQ_REVO_INS = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Revo_FR_Issue_Liq_Revo_Ins').Number_Value__c);//Issue_Liquidation_Revocation_Instruction__c based on Revocation FR
    private static FINAL Integer SSR_240_REBUTTAL_COMMENTS_DUE = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Rebuttal_Comments_Due').Number_Value__c);//Rebuttal_Comments_Due__c
    private static FINAL Integer SSR_240_ADEQUACY_DET_AND_LET_TO_ITC = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Adequacy_Det_and_Let_to_ITC').Number_Value__c);//Adequacy_Determination_and_Letter_to_ITC__c
    private static FINAL Integer SSR_240_COMMENTS_ON_ADEQ_DET_FILED = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Comments_on_Adeq_Det_Filed').Number_Value__c);//Comments_on_Adequacy_Determination_Filed__c
    private static FINAL Integer SSR_240_MEMO_ON_ADEQUACY_DET = ((Integer)segmentCalcOffsets.get('SS_Rev_240_Memo_on_Adequacy_Det').Number_Value__c);//Memorandum_on_Adequacy_Determination__c
	
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
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    @TestVisible private static String ssrType = '';

    @TestVisible private static void calculateSegmentDates(List<Segment__c> newList) {
    	for (Segment__c s : newList) {
			//Ordered Methods (must be done in a specific order)
            setSsrType(s);
			setDeadlineForDecisionForHoP(s);
            setCalculatedInitationSignature(s);
    		setCalculatedPreliminarySignature(s);
    		//dependent on setCalculatedPreliminarySignature
    		setPrelimTeamMeetingDeadline(s);
            setNotifyItcIfAffirmPrelimIsDetermine(s);
    		setCalculatedFinalSignature(s);
    		//dependent on setCalculatedFinalSignature
            setFinalTeamMeetingDeadline(s);
            setCalculatedAmendedFinalSignature(s);
            setCalculatedRevocationOrContinuationFR(s);
    		//dependent on setCalculatedFinalSignature and setCalculatedRevocationOrContinuationFR
            setUpdateAceCustomsModule(s);
            setIssueLiquidationRevocationInstruction(s);

            //Unordered Methods (not dependent on any previous methods)
            setRebuttalCommentsDue(s);
            setAdequacyDeterminationandLetterToITC(s);
            setCommentsOnAdequacyDeterminationFiled(s);
            setMemorandumOnAdequacyDetermination(s);
            setNotifyItcOfNoDomesticInterest(s);
            setInadequateDomesticResponseNoteToITC(s);
            setNoticeOfIntentToParticipate(s);
            setSubstantiveResponseDueForAllParties(s);

            //Individual Dependencies
            //dependent on setNoticeOfIntentToParticipate
            setNotifyClusterCoordinatorNoInterest(s);
            //dependent on setSubstantiveResponseDueForAllParties
            setInformClusterCoordinatorIfNoRespons(s);
    	}
    }

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Segment__c> newList, Map<Id,Segment__c> newMap) {
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
        if(newMap != null) {
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Segments with an Id
            frUtilMap = listInstance.utilMap;
        }
    }
    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Segment_Constant__mdt> segmentCalcOffsets() {
        if(segmentCalcOffsets == null || segmentCalcOffsets.size() < 1) {
            Map<String,Segment_Constant__mdt> returnMap = new Map<String,Segment_Constant__mdt>();
            List<Segment_Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Record_Type_Name__c, Number_Value__c FROM Segment_Constant__mdt 
                                                            WHERE Segment_Calculation_Offset__c =: true];
            for(Segment_Constant__mdt sc : tempList) {
                returnMap.put(sc.QualifiedAPIName, sc);
            }
            return returnMap;
        } else {
            return segmentCalcOffsets;
        }
        
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
    		Integer extension = s.Initiation_Extension_of_days__c == null ? 0 : (Integer)s.Initiation_Extension_of_days__c;//null check on extension, set to 0 if null
    		if(s.Request_Filed__c != null) {
    			s.Deadline_for_Decision_on_How_to_Proceed__c = s.Request_Filed__c.addDays(SI_DEADLINE_FOR_DECISION_HOP).addDays(extension);
    			s.Deadline_for_Decision_on_How_to_Proceed__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Request_Filed__c, s.Deadline_for_Decision_on_How_to_Proceed__c, true);
    		}
    	}
    }

    //sets Calculated_Initiation_Signature__c
    @TestVisible private static void setCalculatedInitationSignature(Segment__c s){
        Integer extension = s.Initiation_Extension_of_days__c == null ? 0 : (Integer)s.Initiation_Extension_of_days__c;
        if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW){
            if(s.Application_Accepted__c != null){
                s.Calculated_Initiation_Signature__c = s.Application_Accepted__c.addDays(ACR_CALC_INIT_SIG).addDays(extension);
                s.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Application_Accepted__c, s.Calculated_Initiation_Signature__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if (s.Request_Filed__c != null){
                s.Calculated_Initiation_Signature__c = s.Request_Filed__c.addDays(CCR_CALC_INIT_SIG).addDays(extension);
                s.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Request_Filed__c, s.Calculated_Initiation_Signature__c, true);
            }
        }  
    }

    //sets Calculated_Preliminary_Signature__c
    @TestVisible private static void setCalculatedPreliminarySignature(Segment__c s) {
    	Integer extension = s.Prelim_Extension__c == null ? 0 : (Integer)s.Prelim_Extension__c;//null check on extension, set to 0 if null
    	if(recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
            if(s.Final_Date_of_Anniversary_Month__c != null) {
                s.Calculated_Preliminary_Signature__c = s.Final_Date_of_Anniversary_Month__c.addDays(AR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Final_Date_of_Anniversary_Month__c, s.Calculated_Preliminary_Signature__c, true);
            }
		}   
        else if(recordTypeNameMap.get(s.RecordTypeId)== EXPEDITED_REVIEW){
            if(s.Final_Date_of_Anniversary_Month__c != null) {
                s.Calculated_Preliminary_Signature__c = s.Final_Date_of_Anniversary_Month__c.addDays(ER_CALC_PRELIM_SIG).addDays(extension);
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
                s.Prelim_Extension__c = null;
            }
		} else if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW){
            if(s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Preliminary_Signature__c = s.Calculated_Initiation_Signature__c.addDays(ACR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);       
            }
            else if (s.Actual_Initiation_Signature__c != null){
                s.Calculated_Preliminary_Signature__c = s.Actual_Initiation_Signature__c.addDays(ACR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);
            }
        } else if(recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if(s.All_parties_in_agreement_to_the_outcome__c == 'No' && s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Preliminary_Signature__c = s.Calculated_Initiation_Signature__c.addDays(CCR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);  
            } else if (s.All_parties_in_agreement_to_the_outcome__c =='No' &&s.Actual_Initiation_Signature__c != null){
                s.Calculated_Preliminary_Signature__c = s.Actual_Initiation_Signature__c.addDays(CCR_CALC_PRELIM_SIG).addDays(extension);
                s.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Preliminary_Signature__c, true);                 
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
        } else if (recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW){
            if (s.Calculated_Preliminary_Signature__c != null) {
                s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(ER_PRELIM_TEAM_MEET_DEADLINE);
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
		} else if(recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW){
            if (s.Calculated_Preliminary_Signature__c != null) {
                s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(ACR_PRELIM_TEAM_MEET_DEADLINE);
                s.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Prelim_Team_Meeting_Deadline__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if (s.Calculated_Preliminary_Signature__c != null){
                s.Prelim_Team_Meeting_Deadline__c = s.Calculated_Preliminary_Signature__c.addDays(CCR_PRELIM_TEAM_MEET_DEADLINE);
                s.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Prelim_Team_Meeting_Deadline__c, true);
            }
        }
    }

    //sets Notify_ITC_if_Affirm_Prelim_is_Determine__c
    @TestVisible private static void setNotifyItcIfAffirmPrelimIsDetermine(Segment__c s){
        Date prelimPublished = null;
        if(s.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).preliminaryPublishedDate : null;
        }
        if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW){
            if (prelimPublished == null && s.Calculated_Preliminary_Signature__c != null){
                s.Notify_ITC_If_Affirmative_Prelim_Determ__c = s.Calculated_Preliminary_Signature__c.addDays(ACR_NOTIFY_ITC_TWO).addDays(ACR_NOTIFY_ITC_FIVE);
                s.Notify_ITC_If_Affirmative_Prelim_Determ__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Notify_ITC_If_Affirmative_Prelim_Determ__c, true);
            }
            else if (prelimPublished != null){
                s.Notify_ITC_If_Affirmative_Prelim_Determ__c = prelimPublished.addDays(ACR_NOTIFY_ITC_TWO);
                s.Notify_ITC_If_Affirmative_Prelim_Determ__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimPublished, s.Notify_ITC_If_Affirmative_Prelim_Determ__c, true);
            }
        }  
    }

    //sets Calculated_Final_Signature__c, requires Calculated_Preliminary_Signature__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Segment__c s){
        Date prelimPublished = null;
        Date initPublished = null;
        if(s.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).preliminaryPublishedDate : null;
            initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
        }
        Integer extension = s.Final_Extension_of_days__c == null ? 0 : (Integer)s.Final_Extension_of_days__c;//null check on extension, set to 0 if null
    	if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
    		if (prelimPublished == null && s.Calculated_Preliminary_Signature__c != null) {
				s.Calculated_Final_Signature__c = s.Calculated_Preliminary_Signature__c.addDays(AR_CALC_FINAL_SIG).addDays(extension);
				s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Calculated_Final_Signature__c, true);
    		} else if (prelimPublished != null) {
    			s.Calculated_Final_Signature__c = prelimPublished.addDays(AR_CALC_FINAL_SIG).addDays(extension);
    			s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(prelimPublished, s.Calculated_Final_Signature__c, true);
    		}
    	} else if (recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW){
            if (prelimPublished == null && s.Calculated_Preliminary_Signature__c != null) {
                s.Calculated_Final_Signature__c = s.Calculated_Preliminary_Signature__c.addDays(ER_CALC_FINAL_SIG).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Preliminary_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (prelimPublished != null) {
                s.Calculated_Final_Signature__c = prelimPublished.addDays(ER_CALC_FINAL_SIG).addDays(extension);
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
                s.Final_Extension_of_days__c = null;
            }
		} else if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW){
            if (s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Calculated_Initiation_Signature__c.addDays(ACR_CALC_FINAL_SIG).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (s.Actual_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Actual_Initiation_Signature__c.addDays(ACR_CALC_FINAL_SIG).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if (s.Is_this_review_expedited__c == 'Yes' && s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Calculated_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_FORTYFIVE).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (s.Is_this_review_expedited__c == 'Yes' && s.Actual_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Actual_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_FORTYFIVE).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (s.Is_this_review_expedited__c == 'No' && s.All_parties_in_agreement_to_the_outcome__c == 'Yes' && s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Calculated_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_FORTYFIVE).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);                    
            } else if (s.Is_this_review_expedited__c == 'No' && s.All_parties_in_agreement_to_the_outcome__c == 'Yes' && s.Actual_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Actual_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_FORTYFIVE).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);
            } else if (s.Is_this_review_expedited__c == 'No' && s.All_parties_in_agreement_to_the_outcome__c == 'No' && s.Actual_Initiation_Signature__c == null && s.Calculated_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Calculated_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_TWOSEVENTY).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);  
            } else if (s.Is_this_review_expedited__c == 'No' && s.All_parties_in_agreement_to_the_outcome__c == 'No' && s.Actual_Initiation_Signature__c != null){
                s.Calculated_Final_Signature__c = s.Actual_Initiation_Signature__c.addDays(CCR_CALC_FINAL_SIG_TWOSEVENTY).addDays(extension);
                s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Initiation_Signature__c, s.Calculated_Final_Signature__c, true);                        
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW){    
            Integer prelimExtension = s.Prelim_Extension__c == null ? 0 : (Integer)s.Prelim_Extension__c;
            if (initPublished != null) {
                if (ssrType == '90') {
                        s.Calculated_Final_Signature__c = initPublished.addDays(SSR_90_CALC_FINAL_SIG);
                        s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Calculated_Final_Signature__c, true);
                } else if (ssrType =='120') {
                        s.Calculated_Final_Signature__c = initPublished.addDays(SSR_120_CALC_FINAL_SIG);
                        s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Calculated_Final_Signature__c, true);
                } else if (ssrType == '240') {
                        s.Calculated_Final_Signature__c = initPublished.addDays(SSR_240_CALC_FINAL_SIG).addDays(prelimExtension).addDays(extension);
                        s.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Calculated_Final_Signature__c, true);
                }
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
	    } else if(recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW){
            if (s.Calculated_Final_Signature__c != null) {
                s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c.addDays(ER_FINAL_TEAM_MEET_DEADLINE);
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
		} else if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW) {
            if (s.Calculated_Final_Signature__c != null) {
                s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c.addDays(ACR_FINAL_TEAM_MEET_DEADLINE);
                s.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Final_Team_Meeting_Deadline__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if (s.Calculated_Final_Signature__c != null){
                s.Final_Team_Meeting_Deadline__c = s.Calculated_Final_Signature__c;
                s.Final_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Final_Team_Meeting_Deadline__c, true);
            }
        }
    }

    //sets Calculated_Amended_Final_Signature__c
    @TestVisible private static void setCalculatedAmendedFinalSignature(Segment__c s){
    	if(s.Will_you_Amend_the_Final__c == 'Yes') {
	        if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
	        	if(s.Actual_Final_Signature__c == null && s.Calculated_Final_Signature__c != null){
		            s.Calculated_Amended_Final_Signature__c = s.Calculated_Final_Signature__c.addDays(AR_CALC_AMEN_FINAL_SIG);
		            s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
		        } else if (s.Actual_Final_Signature__c != null) {
	                s.Calculated_Amended_Final_Signature__c = s.Actual_Final_Signature__c.addDays(AR_CALC_AMEN_FINAL_SIG);
	                s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
	            }
	        } else if (recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW) {
                if(s.Actual_Final_Signature__c == null && s.Calculated_Final_Signature__c != null){
                    s.Calculated_Amended_Final_Signature__c = s.Calculated_Final_Signature__c.addDays(ER_CALC_AMEN_FINAL_SIG);
                    s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
                } else if (s.Actual_Final_Signature__c != null) {
                    s.Calculated_Amended_Final_Signature__c = s.Actual_Final_Signature__c.addDays(ER_CALC_AMEN_FINAL_SIG);
                    s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
                }
            } else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
	        	if(s.Actual_Final_Signature__c == null && s.Calculated_Final_Signature__c != null){
		            s.Calculated_Amended_Final_Signature__c = s.Calculated_Final_Signature__c.addDays(NS_CALC_AMEN_FINAL_SIG);
		            s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
		        } else if (s.Actual_Final_Signature__c != null) {
	                s.Calculated_Amended_Final_Signature__c = s.Actual_Final_Signature__c.addDays(NS_CALC_AMEN_FINAL_SIG);
	                s.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Final_Signature__c, s.Calculated_Amended_Final_Signature__c, true);
	            }
	        }
	    } else {
	    	s.Calculated_Amended_Final_Signature__c = null;
	    }
    }

    //sets Calculated_Revocation_or_Continuation_FR__c
    @TestVisible private static void setCalculatedRevocationOrContinuationFR(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date finalPublished = null;
            if(s.Id != null && frUtilMap != null) {
                finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).finalPublishedDate : null;
            }
            if(finalPublished != null) {
                s.Calculated_Revocation_or_Continuation_FR__c = finalPublished.addDays(SSR_CALC_REVO_OR_CONT_FR);
                s.Calculated_Revocation_or_Continuation_FR__c = ADCVD_TollingDayUtility.getCalculatedDate(finalPublished, s.Calculated_Revocation_or_Continuation_FR__c, true);
            }
        } else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW){
            if (s.Request_Filed__c != null){
                s.Calculated_Initiation_Signature__c = s.Request_Filed__c.addDays(CCR_CALC_INIT_SIG).addDays(extension);
                s.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Request_Filed__c, s.Calculated_Initiation_Signature__c, true);
            }
        }  
    }

    //sets Update_ACE_Customs_Module__c
    @TestVisible private static void setUpdateAceCustomsModule(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date finalPublished = null;
            Date revoPublished = null;
            if(s.Id != null && frUtilMap != null) {
                finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).finalPublishedDate : null;
                revoPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).revocationPublishedDate : null;
            }
            if (ssrType == '90') {
                if(finalPublished != null) {
                    s.Update_ACE_Customs_Module__c = finalPublished.addDays(SSR_90_FIN_FR_UPDATE_ACE_CUS_MOD);//negative
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Update_ACE_Customs_Module__c, s.Update_ACE_Customs_Module__c, false);//offset is -1
                } else if (s.Actual_Final_Signature__c == null && s.Calculated_Final_Signature__c != null){
                    s.Update_ACE_Customs_Module__c = s.Calculated_Final_Signature__c.addDays(SSR_90_FIN_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Update_ACE_Customs_Module__c, true);
                } else if (s.Actual_Final_Signature__c != null) {
                    s.Update_ACE_Customs_Module__c = s.Actual_Final_Signature__c.addDays(SSR_90_FIN_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Final_Signature__c, s.Update_ACE_Customs_Module__c, true);
                }
            } else if (ssrType == '120' && s.Continuation_or_Revocation__c == 'Revocation') {
                if(revoPublished != null) {
                    s.Update_ACE_Customs_Module__c = revoPublished.addDays(SSR_120_REVO_FR_UPDATE_ACE_CUS_MOD);//negative
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Update_ACE_Customs_Module__c, s.Update_ACE_Customs_Module__c, false);//offset is -1
                } else if (s.Actual_Revocation_or_Continuation_FR__c == null && s.Calculated_Revocation_or_Continuation_FR__c != null){
                    s.Update_ACE_Customs_Module__c = s.Calculated_Revocation_or_Continuation_FR__c.addDays(SSR_120_REVO_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Revocation_or_Continuation_FR__c, s.Update_ACE_Customs_Module__c, true);
                } else if (s.Actual_Revocation_or_Continuation_FR__c != null) {
                    s.Update_ACE_Customs_Module__c = s.Actual_Revocation_or_Continuation_FR__c.addDays(SSR_120_REVO_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Revocation_or_Continuation_FR__c, s.Update_ACE_Customs_Module__c, true);
                }
            } else if (ssrType == '240' && s.Continuation_or_Revocation__c == 'Revocation') {
                if(revoPublished != null) {
                    s.Update_ACE_Customs_Module__c = revoPublished.addDays(SSR_240_REVO_FR_UPDATE_ACE_CUS_MOD);//negative
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Update_ACE_Customs_Module__c, s.Update_ACE_Customs_Module__c, false);//offset is -1
                } else if (s.Actual_Revocation_or_Continuation_FR__c == null && s.Calculated_Revocation_or_Continuation_FR__c != null){
                    s.Update_ACE_Customs_Module__c = s.Calculated_Revocation_or_Continuation_FR__c.addDays(SSR_240_REVO_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Revocation_or_Continuation_FR__c, s.Update_ACE_Customs_Module__c, true);
                } else if (s.Actual_Revocation_or_Continuation_FR__c != null) {
                    s.Update_ACE_Customs_Module__c = s.Actual_Revocation_or_Continuation_FR__c.addDays(SSR_240_REVO_SIG_UPDATE_ACE_CUS_MOD);
                    s.Update_ACE_Customs_Module__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Revocation_or_Continuation_FR__c, s.Update_ACE_Customs_Module__c, true);
                }
            }
        }
    }

    //sets Issue_Liquidation_Revocation_Instruction__c
    @TestVisible private static void setIssueLiquidationRevocationInstruction(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date finalPublished = null;
            Date revoPublished = null;
            if(s.Id != null && frUtilMap != null) {
                finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).finalPublishedDate : null;
                revoPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).revocationPublishedDate : null;
            }
            if (ssrType == '90') {
                if(finalPublished != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = finalPublished.addDays(SSR_90_FIN_FR_ISSUE_LIQ_REVO_INSTR);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(finalPublished, s.Issue_Liquidation_Revocation_Instruction__c, false);
                } else if (s.Actual_Final_Signature__c == null && s.Calculated_Final_Signature__c != null){
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Calculated_Final_Signature__c.addDays(SSR_90_FIN_SIG_ISSUE_LIQ_REVO_INSTR);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Final_Signature__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                } else if (s.Actual_Final_Signature__c != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Actual_Final_Signature__c.addDays(SSR_90_FIN_SIG_ISSUE_LIQ_REVO_INSTR);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Final_Signature__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                }
            } else if (ssrType == '120' && s.Continuation_or_Revocation__c == 'Revocation') {
                if(revoPublished != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = revoPublished.addDays(SSR_120_REVO_FR_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(revoPublished, s.Issue_Liquidation_Revocation_Instruction__c, false);
                } else if (s.Actual_Revocation_or_Continuation_FR__c == null && s.Calculated_Revocation_or_Continuation_FR__c != null){
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Calculated_Revocation_or_Continuation_FR__c.addDays(SSR_120_REVO_SIG_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Revocation_or_Continuation_FR__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                } else if (s.Actual_Revocation_or_Continuation_FR__c != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Actual_Revocation_or_Continuation_FR__c.addDays(SSR_120_REVO_SIG_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Revocation_or_Continuation_FR__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                }
            } else if (ssrType == '240' && s.Continuation_or_Revocation__c == 'Revocation') {
                if(revoPublished != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = revoPublished.addDays(SSR_240_REVO_FR_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(revoPublished, s.Issue_Liquidation_Revocation_Instruction__c, false);
                } else if (s.Actual_Revocation_or_Continuation_FR__c == null && s.Calculated_Revocation_or_Continuation_FR__c != null){
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Calculated_Revocation_or_Continuation_FR__c.addDays(SSR_240_REVO_SIG_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Calculated_Revocation_or_Continuation_FR__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                } else if (s.Actual_Revocation_or_Continuation_FR__c != null) {
                    s.Issue_Liquidation_Revocation_Instruction__c = s.Actual_Revocation_or_Continuation_FR__c.addDays(SSR_240_REVO_SIG_ISSUE_LIQ_REVO_INS);
                    s.Issue_Liquidation_Revocation_Instruction__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Actual_Revocation_or_Continuation_FR__c, s.Issue_Liquidation_Revocation_Instruction__c, true);
                }
            }
        }
    }

    //sets Rebuttal_Comments_Due__c
    @TestVisible private static void setRebuttalCommentsDue(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if (ssrType != '') {
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
            }
            if (initPublished != null) {
                if (ssrType =='120') {
                        s.Rebuttal_Comments_Due__c = initPublished.addDays(SSR_120_REBUTTAL_COMMENTS_DUE);
                        s.Rebuttal_Comments_Due__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Rebuttal_Comments_Due__c, true);
                } else if (ssrType == '240') {
                        s.Rebuttal_Comments_Due__c = initPublished.addDays(SSR_240_REBUTTAL_COMMENTS_DUE);
                        s.Rebuttal_Comments_Due__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Rebuttal_Comments_Due__c, true);
                }
            }
        }
    }

    //sets Adequacy_Determination_and_Letter_to_ITC__c
    @TestVisible private static void setAdequacyDeterminationandLetterToITC(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if (ssrType != '') {
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
            }
            if (initPublished != null) {
                if (ssrType =='120') {
                        s.Adequacy_Determination_Letter_120_day__c = initPublished.addDays(SSR_120_ADEQUACY_DET_AND_LET_TO_ITC);
                        s.Adequacy_Determination_Letter_120_day__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Adequacy_Determination_Letter_120_day__c, true);
                } else if (ssrType == '240') {
                        s.Adequacy_Determination_Letter_240_day__c = initPublished.addDays(SSR_240_ADEQUACY_DET_AND_LET_TO_ITC);
                        s.Adequacy_Determination_Letter_240_day__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Adequacy_Determination_Letter_240_day__c, true);
                }
            }
        }
    }

    //sets Comments_on_Adequacy_Determination_Filed__c
    @TestVisible private static void setCommentsOnAdequacyDeterminationFiled(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if (ssrType != '') {
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
            }
            if (initPublished != null) {
                if (ssrType =='120') {
                        s.Comments_on_Adequacy_Determination_Filed__c = initPublished.addDays(SSR_120_COMMENTS_ON_ADEQ_DET_FILED);
                        s.Comments_on_Adequacy_Determination_Filed__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Comments_on_Adequacy_Determination_Filed__c, true);
                }
            }
        }
    }

    //sets Memorandum_on_Adequacy_Determination__c
    @TestVisible private static void setMemorandumOnAdequacyDetermination(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if (ssrType != '') {
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
            }
            if (initPublished != null) {
                if (ssrType =='120') {
                        s.Memorandum_on_Adequacy_Determination__c = initPublished.addDays(SSR_120_MEMO_ON_ADEQUACY_DET);
                        s.Memorandum_on_Adequacy_Determination__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Memorandum_on_Adequacy_Determination__c, true);
                }
            }
        }
    }

    
    //Unordered Methods
    //sets Notify_ITC_of_No_Domestic_Interest__c
    @TestVisible private static void setNotifyItcOfNoDomesticInterest(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            if (ssrType == '90') {
                Date initPublished = null;
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
                if(initPublished != null) {
                    s.Notify_ITC_of_No_Domestic_Interest__c = initPublished.addDays(SSR_90_NOTIFY_ITC_NO_DOMESTIC_INT);
                    s.Notify_ITC_of_No_Domestic_Interest__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Notify_ITC_of_No_Domestic_Interest__c, true);
                }
            }
        }
    }

    //sets Inadequate_Domestic_Response_note_to_ITC__c
    @TestVisible private static void setInadequateDomesticResponseNoteToITC(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            if (ssrType == '90') {
                Date initPublished = null;
                if(s.Id != null && frUtilMap != null) {
                    initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
                }
                if(initPublished != null) {
                    s.Inadequate_Domestic_Response_note_to_ITC__c = initPublished.addDays(SSR_90_INADEQUATE_DOM_RESP_TO_ITC);
                    s.Inadequate_Domestic_Response_note_to_ITC__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Inadequate_Domestic_Response_note_to_ITC__c, true);
                }
            }
        }
    }

    //sets Notice_of_Intent_to_Participate__c
    @TestVisible private static void setNoticeOfIntentToParticipate(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if(s.Id != null && frUtilMap != null) {
                initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
            }
            if(initPublished != null) {
                s.Notice_of_Intent_to_Participate__c = initPublished.addDays(SSR_NOTICE_INTENT_PARTICIPATE);
                s.Notice_of_Intent_to_Participate__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Notice_of_Intent_to_Participate__c, true);
            }
        }
    }

    //sets Notify_Cluster_Coordinator_No_Interest__c, requires Notice_of_Intent_to_Participate__c to be set
    @TestVisible private static void setNotifyClusterCoordinatorNoInterest(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            if(s.Notice_of_Intent_to_Participate__c != null) {
                s.Notify_Cluster_Coordinator_No_Interest__c = s.Notice_of_Intent_to_Participate__c.addDays(SSR_NOTIFY_CLUSTER_CDNTR_NO_INT);
                s.Notify_Cluster_Coordinator_No_Interest__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Notice_of_Intent_to_Participate__c, s.Notify_Cluster_Coordinator_No_Interest__c, true);
            }
        }
    }

    //sets Substantive_Response_Due_For_All_Parties__c 
    @TestVisible private static void setSubstantiveResponseDueForAllParties(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            Date initPublished = null;
            if(s.Id != null && frUtilMap != null) {
                initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).initiationPublishedDate : null;
            }
            if(initPublished != null) {
                s.Substantive_Response_Due_For_All_Parties__c = initPublished.addDays(SSR_SUBSTAN_RESP_DUE_ALL_PARTIES);
                s.Substantive_Response_Due_For_All_Parties__c = ADCVD_TollingDayUtility.getCalculatedDate(initPublished, s.Substantive_Response_Due_For_All_Parties__c, true);
            }
        }
    }

    //sets Inform_Cluster_Coordinator_if_No_Respons__c, requires Substantive_Response_Due_For_All_Parties__c  to be set
    @TestVisible private static void setInformClusterCoordinatorIfNoRespons(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            if(s.Substantive_Response_Due_For_All_Parties__c != null) {
                s.Inform_Cluster_Coordinator_if_No_Respons__c = s.Substantive_Response_Due_For_All_Parties__c.addDays(SSR_REV_INFORM_CLUSTER_CDNTR_IF_NO_RESP);
                s.Inform_Cluster_Coordinator_if_No_Respons__c = ADCVD_TollingDayUtility.getCalculatedDate(s.Substantive_Response_Due_For_All_Parties__c, s.Inform_Cluster_Coordinator_if_No_Respons__c, true);
            }
        }
    }

    //sets the ssrType for a Sunset Review
    @TestVisible private static void setSsrType(Segment__c s) {
        if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
            if ((s.Notice_of_intent_to_participate_Ips__c == 'No' || s.Domestic_Party_File_Substan_Response__c == 'No')  
                    && s.Review_to_address_zeroing_in_Segments__c != 'Yes') {
                ssrType = '90';
            } else if (s.Notice_of_intent_to_participate_Ips__c == 'Yes' && s.Domestic_Party_File_Substan_Response__c == 'Yes' 
                    && s.Respondent_File_Substantive_Response__c == 'No' && s.Review_to_address_zeroing_in_Segments__c != 'Yes') {
                ssrType = '120';
            } else if ((s.Notice_of_intent_to_participate_Ips__c == 'Yes' && s.Domestic_Party_File_Substan_Response__c == 'Yes'
                    && s.Respondent_File_Substantive_Response__c == 'Yes') || s.Review_to_address_zeroing_in_Segments__c == 'Yes') {
                ssrType = '240';
            }
            if(ssrType == '120' || ssrType == '240') {
                if (s.Adequacy_of_Respondents_Submission__c =='Adequate or Substantive') {
                    ssrType = '240';
                } else if(s.Adequacy_of_Respondents_Submission__c =='Inadequate or Non-Substantive') {
                    ssrType = '120';
                }
            }
        }
    }

    //for Sunset Review Controller
    public Segment__c calculateSegmentDates(String ssReviewType, Segment__c s) {
        if (s != null && s.Id != null) {
            recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(s);
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(new List<Segment__c>{s});
            frUtilMap = listInstance.utilMap;
            ssrType = ssReviewType;
            setCalculatedFinalSignature(s);
            //dependent on setCalculatedFinalSignature
            setCalculatedRevocationOrContinuationFR(s);
            //dependent on setCalculatedFinalSignature and setCalculatedRevocationOrContinuationFR
            setUpdateAceCustomsModule(s);
            setIssueLiquidationRevocationInstruction(s);

            //Unordered Methods (not dependent on any previous methods)
            setRebuttalCommentsDue(s);
            setAdequacyDeterminationandLetterToITC(s);
            setCommentsOnAdequacyDeterminationFiled(s);
            setMemorandumOnAdequacyDetermination(s);
            setNotifyItcOfNoDomesticInterest(s);
            setInadequateDomesticResponseNoteToITC(s);
            setNoticeOfIntentToParticipate(s);
            setSubstantiveResponseDueForAllParties(s);

            //Individual Dependencies
            //dependent on setNoticeOfIntentToParticipate
            setNotifyClusterCoordinatorNoInterest(s);
            //dependent on setSubstantiveResponseDueForAllParties
            setInformClusterCoordinatorIfNoRespons(s);
        }
        
        return s;
    }
}