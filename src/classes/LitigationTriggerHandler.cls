public without sharing class LitigationTriggerHandler {

    private static Map<String,Constant__mdt> litigationCalcOffsets = litigationCalcOffsets();
    //FINAL Litigation Record Types
    private static FINAL String INT_LITIGATION = litigationCalcOffsets.get('Int_Lit_Calc_Initiation_Sig').ADCVD_Objects__r.Record_Type_Name__c;
    private static FINAL String REMAND = litigationCalcOffsets.get('Remand_Calc_Draft_Remand_Release').ADCVD_Objects__r.Record_Type_Name__c;

    //FINAL Litigation International Litigation Offsets
    private static FINAL Integer IL_CALC_INIT_SIGN = ((Integer)litigationCalcOffsets.get('Int_Lit_Calc_Initiation_Sig').Number_Value__c);//Calculated_Initiation_Signature__c    
    private static FINAL Integer IL_CALC_PRELIM_SIG = ((Integer)litigationCalcOffsets.get('Int_Lit_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature__c
    private static FINAL Integer IL_CALC_FINAL_SIG = ((Integer)litigationCalcOffsets.get('Int_Lit_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    

    //FINAL Litigation Remand Offsets
    private static FINAL Integer RE_CALC_DRAFT_REMAND_RELEASE = ((Integer)litigationCalcOffsets().get('Remand_Calc_Draft_Remand_Release').Number_Value__c);//Calculated_Preliminary_Signature__c  
    private static FINAL Integer RE_PRELIM_TEAM_MEETING_DEADLINE = ((Integer)litigationCalcOffsets().get('Remand_Prelim_Team_Meeting_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c  
    private static FINAL Integer RE_CALC_AMEND_FINAL_SIG = ((Integer)litigationCalcOffsets().get('Remand_Calc_Amended_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c

	public static boolean preventRecursion = false;
    public static void mainEntry(List<Litigation__c> newList, List<Litigation__c> oldList, Map<Id, Litigation__c> newMap, 
        Map<Id, Litigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        if (isBefore && isInsert) {
            initialize(newList);
            calculateLitigationDates(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList);
            calculateLitigationDates(newList);
        }
    }

    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();

    @TestVisible private static void calculateLitigationDates(List<Litigation__c> newList) {
        for (Litigation__c l : newList) {
            //Ordered Methods (must be done in a specific order)
            //such empty
            //Unordered Methods (dependencies are inline comments)
            setCalculatedInitiationSignature(l);//Int_Lit: Request_Filed__c
            setCalculatedPreliminarySignature(l);//Int_Lit: Request_Filed__c
            setCalculatedFinalSignature(l);//Int_Lit: Request_Filed__c ... Remand: Expected_Final_Signature_Before_Ext__c
            setCalculatedDraftRemandReleaseToParty(l);//Remand: Calculated_Final_Signature__c
            setPrelimTeamMeetingDeadline(l);//Remand: Calculated_Draft_Remand_release_to_party__c
            setCalculatedAmendedFinalSignature(l);//Remand: Court_of_Panel_s_Ruling__c
        }
    }

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Litigation__c> newList) {
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
    }

    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> litigationCalcOffsets() {
        Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
        List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
                                                ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
                                        FROM Constant__mdt 
                                        WHERE Litigation_Calculation_Offset__c =: true];
        for(Constant__mdt lc : tempList) {
            returnMap.put(lc.QualifiedAPIName, lc);
        }
        return returnMap;
    }

    //sets Calculated_Initiation_Signature__c, requires Request_Filed__c to be set
    @TestVisible private static void setCalculatedInitiationSignature(Litigation__c l){
        if(recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if (l.Request_Filed__c != null) {
                l.Calculated_Initiation_Signature__c = l.Request_Filed__c.addDays(IL_CALC_INIT_SIGN);
                l.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Request_Filed__c, l.Calculated_Initiation_Signature__c, true);
            }
        }
    }

    //sets Calculated_Preliminary_Signature__c, requires Request_Filed__c to be set
    @TestVisible private static void setCalculatedPreliminarySignature(Litigation__c l) {
        Integer extension = l.Prelim_Extension_of_days__c == null ? 0 : (Integer)l.Prelim_Extension_of_days__c;//null check on extension, set to 0 if null
        if(recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if(l.Request_Filed__c != null) {
                l.Calculated_Preliminary_Signature__c = l.Request_Filed__c.addDays(IL_CALC_PRELIM_SIG).addDays(extension);
                l.Calculated_Preliminary_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Request_Filed__c, l.Calculated_Preliminary_Signature__c, true);
            }
        }
    }

    //sets Prelim_Team_Meeting_Deadline__c, requires Calculated_Draft_Remand_release_to_party__c to be set
    @TestVisible private static void setPrelimTeamMeetingDeadline(Litigation__c l) {
        if(recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if(l.Calculated_Draft_Remand_release_to_party__c != null) {
                l.Prelim_Team_Meeting_Deadline__c = l.Calculated_Draft_Remand_release_to_party__c.addDays(RE_PRELIM_TEAM_MEETING_DEADLINE);
                l.Prelim_Team_Meeting_Deadline__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Prelim_Team_Meeting_Deadline__c, l.Prelim_Team_Meeting_Deadline__c, true);
            }
        }
    }

    //sets Calculated_Final_Signature__c, requires Request_Filed__c to be set or on Remand, requires Expected_Final_Signature_Before_Ext__c to be set
    @TestVisible private static void setCalculatedFinalSignature(Litigation__c l){
        Integer extension = l.Final_Extension_of_days__c == null ? 0 : (Integer)l.Final_Extension_of_days__c;//null check on extension, set to 0 if null
        if (recordTypeNameMap.get(l.RecordTypeId) == INT_LITIGATION) {
            if (l.Request_Filed__c != null) {
                l.Calculated_Final_Signature__c = l.Request_Filed__c.addDays(IL_CALC_FINAL_SIG).addDays(extension);
                l.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Request_Filed__c, l.Calculated_Final_Signature__c, true);
            }
        } else if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if (l.Expected_Final_Signature_Before_Ext__c != null) {
                l.Calculated_Final_Signature__c = l.Expected_Final_Signature_Before_Ext__c.addDays(extension);
                l.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Expected_Final_Signature_Before_Ext__c, l.Calculated_Final_Signature__c, true);
            }
        }
    }

    //sets Calculated_Draft_Remand_release_to_party__c, requires Calculated_Final_Signature__c to be set by user input in Expected_Final_Signature_Before_Ext__c
    @TestVisible private static void setCalculatedDraftRemandReleaseToParty(Litigation__c l) {
        if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if (l.Expected_Final_Signature_Before_Ext__c != null) {
                l.Calculated_Draft_Remand_release_to_party__c = l.Expected_Final_Signature_Before_Ext__c.addDays(RE_CALC_DRAFT_REMAND_RELEASE);
                l.Calculated_Draft_Remand_release_to_party__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Calculated_Draft_Remand_release_to_party__c, l.Calculated_Draft_Remand_release_to_party__c, true);
            }
        }
    }

    //sets Calculated_Amended_Final_Signature__c
    @TestVisible private static void setCalculatedAmendedFinalSignature(Litigation__c l){
        if (recordTypeNameMap.get(l.RecordTypeId) == REMAND) {
            if(l.Court_of_Panel_s_Ruling__c != null){
                l.Calculated_Amended_Final_Signature__c = l.Court_of_Panel_s_Ruling__c.addDays(RE_CALC_AMEND_FINAL_SIG);
                l.Calculated_Amended_Final_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(l.Court_of_Panel_s_Ruling__c, l.Calculated_Amended_Final_Signature__c, true);
            }
        }
    }
}