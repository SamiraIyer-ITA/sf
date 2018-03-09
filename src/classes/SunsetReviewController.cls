/**
 * 
 *    Created by Joshua Moody
 *    on Mar 16 2017
 *    MIL Corporation
 * 
 **/

public class SunsetReviewController {

    /***********************************************************
    * This class is the controller/extension for a page that displays
    * the dynamic field inline vf section of a sunset review.
    * This class provides methods to:
    * 1. Dynamically display in the correct UX (can be updated to 
    * using the lightningStylesheets tag, which is currently in beta)
    * 2. Dynamically display fields based on the logic that determines
    * where a sunset review is a 90, 120, or 240 day review
    * 3. Get, update and display updated calculations in page
    ***********************************************************/

    public Id recordId {get; set;}
    @AuraEnabled
    public Segment__c ssReview {
    	get { 
	        if(ssReview == null) {
	            if(recordId == null) {
	                ssReview = new Segment__c();
	            } else {
	                queryReview();
	            }
	        }
        return ssReview;
    	} 
    	set;
    }
    public String ssReviewType {get; set;}
    public List<Schema.FieldSetMember> reviewInfoFieldsList {get {
        if(reviewInfoFieldsList == null) {
            reviewInfoFieldsList = Schema.SObjectType.Segment__c.FieldSets.Review_Information.getFields();
            reviewInfoFieldsList = uiUtils.sortFieldSetListForHTML(reviewInfoFieldsList);
        }
        return reviewInfoFieldsList;
        } set;
    } 
    public List<Schema.FieldSetMember> fieldsList90 {get {
        if(fieldsList90 == null) {
            fieldsList90 = Schema.SObjectType.Segment__c.FieldSets.Is_90_Day.getFields();
            fieldsList90 = uiUtils.sortFieldSetListForHTML(fieldsList90);
        }
        return fieldsList90;
        } set;
    } 
    public List<Schema.FieldSetMember> fieldsList120 {get {
        if(fieldsList120 == null) {
            fieldsList120 = Schema.SObjectType.Segment__c.FieldSets.Is_120_Day.getFields();
            fieldsList120 = uiUtils.sortFieldSetListForHTML(fieldsList120);
        }
        return fieldsList120;
        } set;
    } 
    public List<Schema.FieldSetMember> fieldsList240 {get {
        if(fieldsList240 == null) {
            fieldsList240 = Schema.SObjectType.Segment__c.FieldSets.Is_240_Day.getFields();
            fieldsList240 = uiUtils.sortFieldSetListForHTML(fieldsList240);
        }
        return fieldsList240;
        } set;
    } 
    public Boolean isSalesforce1 {get {
        isSalesforce1 =uiUtils.isSalesforce1();
        return isSalesforce1;
        } set;
    }

    public Boolean isLightningExperience {get {
        isLightningExperience =uiUtils.isLightningExperience();
        return isLightningExperience;
        } set;
    }

    public Boolean isSalesforceClassic {get {
        isSalesforceClassic =uiUtils.isSalesforceClassic();
        return isSalesforceClassic;
        } set;
    }

    public PageReference toggleEdit() {
        if (recordId != null) {
            edit = edit ? false : true;
        } else {
            edit = true;
        }
        return null;
    }
    public Boolean edit {
    	get { 
	        if(edit == null && recordId != null) {
	            edit = false;
	        } else if(recordId == null) {
	            edit = true;
	        }
	        return edit; 
        } 
    	set;
    }
    private DateCalculationService dcs {
        get {
            dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Sunset_Review');
            return dcs;
        } set;
    }

    //constructor for controller
    public SunsetReviewController() {
        if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('Id') != null) {
            recordId = ApexPages.currentPage().getParameters().get('Id');
            queryReview();
        }
    }
    public SunsetReviewController(ApexPages.StandardController stdController) {
        this.ssReview = (Segment__c)stdController.getRecord();
        recordId = this.ssReview.Id;
        queryReview();
    }

    public Boolean is90day {
        get {
            if ((ssReview.Notice_of_intent_to_participate_Ips__c == 'No' || ssReview.Domestic_Party_File_Substan_Response__c == 'No')  
            	&& ssReview.Review_to_address_zeroing_in_Segments__c != 'Yes') {
                is90day = true;
                ssReview.Adequacy_of_Respondents_Submission__c = null;
            } else {
                is90day = false;
            }
            if(is90day) {
            	//updateSSReview('90');
            }
            return is90day;
        } 
        set {
            is90day = value;
            if (value == true) {
                is120day = false;
                is240day = false;
            }
        }
    }
    public Boolean is120day {
        get {
            if (ssReview.Notice_of_intent_to_participate_Ips__c == 'Yes' && ssReview.Domestic_Party_File_Substan_Response__c == 'Yes' 
            	&& ssReview.Respondent_File_Substantive_Response__c != 'Yes' && ssReview.Review_to_address_zeroing_in_Segments__c != 'Yes') {
                is120day = true;
           
            } else {
                is120day = false;
            }
        	if (ssReview.Adequacy_of_Respondents_Submission__c =='Adequate or Substantive') {
            	is120day = false;
            } else if(ssReview.Adequacy_of_Respondents_Submission__c =='Inadequate or Non-Substantive') {
            	is120day = true;
            }
            if(is120day) {
            	//updateSSReview('120');
            }
            return is120day;
        } 
        set {
            is120day = value;
            if (value == true) {
                is90day = false;
                is240day = false;
            }
        }
    }
    public Boolean is240day {
        get {
            if ((ssReview.Notice_of_intent_to_participate_Ips__c == 'Yes' && ssReview.Domestic_Party_File_Substan_Response__c == 'Yes'
            	&& ssReview.Respondent_File_Substantive_Response__c == 'Yes') || ssReview.Review_to_address_zeroing_in_Segments__c == 'Yes') {
                is240day = true;
            } else {
                is240day = false;
            }
        	if (ssReview.Adequacy_of_Respondents_Submission__c =='Inadequate or Non-Substantive') {
            	is240day = false;
            } else if (ssReview.Adequacy_of_Respondents_Submission__c =='Adequate or Substantive') {
            	is240day = true;
            }
            if(is240day) {
            	//updateSSReview('240');
            }
            return is240day;
        } 
        set {
            is240day = value;
            if (value == true) {
                is90day = false;
                is120day = false;
            }
        }
    }
    public String getReturnUrl() {
        return ApexPages.currentPage().getParameters().get('retURL');
    }
    public PageReference save() {
        try {
            upsert(ssReview);
            cancel(); //requeries and rerenders form
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        //toggleEdit();
        return null;
    }
    public pageReference cancel() {
        toggleEdit();
        queryReview();
        if(!String.isBlank(getReturnUrl())) {
            return new PageReference(getReturnUrl());
        }
        return null;
    }
    /*public PageReference updateSSReview() {
    	updateSSReview(ssReviewType);
    	return null;
    }
    private void updateSSReview (String ss) {
    	if(ssReview != null) {
            System.debug('updateSSReview: ' + ss + ' ' + ssReview);
    		ssReview.Sunset_Review_Type__c = ss;
            dcs.getCalculatedDates(new List<Segment__c>{ssReview}, 'Segment__c', 'Sunset_Review');
    	}
    }*/

    private void queryReview(){
        Id i = ApexPages.currentPage().getParameters().get('Id');
        if (i != null) {
            String qry = 'SELECT rebuttal_comments_due__c, adequacy_determination_letter_to_itc__c, comments_on_adequacy_determination_filed__c, memorandum_on_adequacy_determination__c, adequate_after_reconsideration__c, next_due_to_das_deadline__c, final_issues_due_to_das__c, actual_final_issues_to_das__c, final_concurrence_due_to_das__c, actual_final_concurrence_to_das__c, calculated_final_signature__c, actual_final_signature__c, final_announcement_date__c, notify_itc_of_final_results__c, itc_vote_on_continuation_or_revocation__c, next_announcement_date__c, next_major_deadline__c, next_office_deadline__c, calculated_revocation_or_continuation_fr__c, actual_revocation_or_continuation_fr__c, continuation_or_revocation__c, effective_date_if_revoked__c, update_ace_customs_module__c, issue_liquidation_revocation_instruction__c, adequacy_of_respondents_submission__c, adequate_after_determination__c, preliminary_extension_remaining__c, prelim_team_meeting_deadline__c, prelim_issues_due_to_das__c, actual_prelim_issues_to_das__c, prelim_concurrence_due_to_das__c, actual_prelim_concurrence_to_das__c, calculated_preliminary_signature__c, actual_preliminary_signature__c, verification_if_needed__c, case_briefs_due__c, rebuttal_briefs_due__c, hearing_if_requested__c, final_extension_of_days__c, final_team_meeting_deadline__c, notify_itc_of_no_domestic_interest__c, inadequate_domestic_response_note_to_itc__c, litigation_hold_expiration_date__c, notice_of_intent_to_participate_ips__c, notice_of_intent_to_participate__c, domestic_party_file_substan_response__c, notify_cluster_coordinator_no_interest__c, respondent_file_substantive_response__c, substantive_response_due_for_all_parties__c, review_to_address_zeroing_in_segments__c, inform_cluster_coordinator_if_no_respons__c ' + 
                            'FROM Segment__c WHERE ID =: i';//soqlBuilderAllFieldsForRecord('Segment__c', i);
            ssReview = database.query(qry);
        } else {
            ssReview = new Segment__c();
        }
    }
    private static String soqlBuilderAllFieldsForRecord(String SobjectApiName, Id i) {
        String query = soqlBuilderAllFields(SobjectApiName);
        
        query = query + ' WHERE ID =: i';
        System.debug(query);
        return query;
    }
    private static String soqlBuilderAllFields(String SobjectApiName) {
        //Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = Utils.cachedGD.get(SobjectApiName).getDescribe().fields.getMap();
        Set<String> searchFields = new Set<String>();
        String commaSeparatedFields = '';
        /*for (String fieldName : fieldMap.keyset()){
            searchFields.add(fieldName.toLowerCase());
        }*/
        Map<String, Schema.FieldSet> FsMap = Utils.cachedGD.get(SobjectApiName).getDescribe().fieldSets.getMap();
        for (String s: FsMap.keySet()) {
            for (Schema.FieldSetMember f: FsMap.get(s).getFields()) {
                searchFields.add(String.valueOf(f.getFieldPath()).toLowerCase());
            }
        }

        for (String s: searchFields) {
            if (commaSeparatedFields != '') {
                commaSeparatedFields = commaSeparatedFields + ', ' + s;
            } else {
                commaSeparatedFields = s;
            }
        }
        String query = 'SELECT ' + commaSeparatedFields + ' FROM ' + SobjectApiName;
        return query;
    }
}