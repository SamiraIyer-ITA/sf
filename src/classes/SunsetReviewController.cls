public class SunsetReviewController {
    public Id recordId {get; set;}
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
    private static SegmentTriggerHandler sth {
    	get {
    		if (sth == null) {
    			sth = new SegmentTriggerHandler();
    		}
    		return sth;
    	}
    	set;
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
            	updateSSReview('90');
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
            	&& ssReview.Respondent_File_Substantive_Response__c == 'No' && ssReview.Review_to_address_zeroing_in_Segments__c != 'Yes') {
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
            	updateSSReview('120');
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
            	updateSSReview('240');
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
            recordId = ssReview.Id;
            if(ApexPages.currentPage().getParameters() == null || ApexPages.currentPage().getParameters().get('Id') == null) {
                ApexPages.currentPage().getParameters().put('Id', ssReview.Id);
            }
            //cancel(); //requeries and rerenders form
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        //  After successful Save, navigate to the default view page
        PageReference redirectSuccess = new PageReference(getReturnUrl());
        return (redirectSuccess);
        //return null;
    }
    public pageReference cancel() {
        toggleEdit();
        queryReview();
        if(!String.isBlank(getReturnUrl())) {
            return new PageReference(getReturnUrl());
        }
        return null;
    }
    public PageReference updateSSReview() {
    	updateSSReview(ssReviewType);
    	return null;
    }
    private void updateSSReview (String ss) {
    	if(ssReview != null) {
    		ssReview = sth.calculateSegmentDates(ss, ssReview);
    	}
    }

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
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        Set<String> searchFields = new Set<String>();
        String commaSeparatedFields = '';
        for (String fieldName : fieldMap.keyset()){
            searchFields.add(fieldName.toLowerCase());
        }
        Map<String, Schema.FieldSet> FsMap = schemaMap.get(SobjectApiName).getDescribe().fieldSets.getMap();
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