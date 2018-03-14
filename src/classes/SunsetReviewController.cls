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
            String qry = soqlBuilderAllFieldsForRecord('Segment__c', i);
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
        //Map<String, Schema.SObjectField> fieldMap = Utils.cachedGD.get(SobjectApiName).getDescribe().fields.getMap();
        Set<String> searchFields = new Set<String>{'Adequacy_of_Respondents_Submission__c'};
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