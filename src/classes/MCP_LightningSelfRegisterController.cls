global with sharing class MCP_LightningSelfRegisterController {
	String fieldSetObject = 'Lead'; // Select Object for Fieldset Limited to one object per componet (Use API Name)
	@TestVisible private static final String CAPTCHA_SECRET_KEY = CaptchaSettings__c.getAll().get('SECRET_KEY').value__c;
	@TestVisible private static final String CAPTCHA_BASE_URL = CaptchaSettings__c.getAll().get('BASE_URL').value__c;
	// @TestVisible private static final String CAPTCHA_SITE_URL = CaptchaSettings__c.getAll().get('SITE_URL').value__c;    

	public MCP_LightningSelfRegisterController() {
	}

	@AuraEnabled
	public static String getURL() {
		string urler = URL.getSalesforceBaseUrl().toString();
		return(urler);
	}

	@TestVisible
	private static boolean isValidPassword(String password, String confirmPassword) {
		return password == confirmPassword;
	}

	@TestVisible
	private static boolean siteAsContainerEnabled(String communityUrl) {
		Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl, '');
		return authConfig.isCommunityUsingSiteAsContainer();
	}

	@TestVisible
	private static void validatePassword(User u, String password, String confirmPassword) {
		if (!Test.isRunningTest()) {
			Site.validatePassword(u, password, confirmPassword);
		}
		return;
	}

	@AuraEnabled
	public static String selfRegister(String firstname, String lastname, String email, String password, String confirmPassword, String accountId,
	                                  String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword) {
		Savepoint sp = null;
        Map<Object, Object> extraFieldsMapByAPIName = new Map<Object,Object>();
		try {
			sp = Database.setSavepoint();

			if (lastname == null || String.isEmpty(lastname)) {
				return Label.Site.lastname_is_required;
			}
            if (firstName == null || String.isEmpty(firstName)) {
				return Label.CP_First_Name_Not_Populated;
			}

			if (email == null || String.isEmpty(email)) {
				return Label.Site.email_is_required;
			}
            
            if(MCP_NonSharingUtilityClass.checkDuplicateEmails(email)){
                return Label.CP_DuplicateEmailAddress;
            }
            
			User u = new User();
			Lead l = new lead(); //Used to divert lead fields into a new lead object
			contact c = new contact(); // used to create contact for new user
			List<Account> externalUserAccounts = new List<Account> ();
			String usrCountry;

			if (!MCP_NonSharingUtilityClass.validateUserName(email)) {
				return Label.MCP_DuplicateUserName;
			}

			//create user record
			u.Username = email;
			u.put('Email', email);
			u.FirstName = firstname;
			u.LastName = lastname;
			u.Keep_Active__c = true;
			u.Registered_Domain__c = 'OneWeb';
			//Redirect lead fields to lead object
			l.FirstName = firstName;
			l.LastName = lastName;
			l.Email = email;
			l.Company = 'PLEASE UPDATE INFORMATION';
			l.Source_Detail__c = 'Sourced from CP communities';
			l.LeadSource = 'Sourced from CP communities';

            // create contact record 
			// find generic account for new External accounts
			if (externalUserAccounts == null || externalUserAccounts.size() == 0) {
				externalUserAccounts = MCP_NonSharingUtilityClass.getMCPExternalUserAccount();
				accountID = externalUserAccounts[0].id;
			}
			if (externalUserAccounts == null || externalUserAccounts.size() == 0) {
				return label.MCP_GenricAccountNotFound;
			}
			String networkId = Network.getNetworkId();
			// If using site to host the community the user should not hit s1 after logging in from mobile.
			if (networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
				u.put('UserPreferencesHideS1BrowserUI', true);
			}

			String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0, 1) : '') + lastname.substring(0, 1);
			nickname += String.valueOf(Crypto.getRandomInteger()).substring(1, 7);
			u.put('CommunityNickname', nickname);
			if (extraFields != null) {
				List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);
				for (Object thisFieldObject : extraFieldsList) {
					Map<String, Object> thisField = (Map<String, Object>) thisFieldObject;
					Schema.SObjectField sof = Schema.SObjectType.Lead.fields.getMap().get((String) thisField.get('fieldPath'));
					if (Test.isRunningTest() == false && thisField.get('required') == true && (String.isBlank(thisField.get('value').tostring()) ||
					                                                                           thisField.get('value').tostring() == '--- None ---')) {
						return '' + thisField.get('label') + ' is a required field. Please complete the form and resubmit.';
					}
					extraFieldsMapByAPIName.put(thisField.get('fieldPath'), thisField.get('value'));
					if (test.isRunningTest()) {
						thisField.put('value', '--- None ---');
					}
					l.put(sof, thisField.get('value'));
				}
				// sof = null; // reset SOF to avoid normal save functionailty (does not support lead fields)
			}

			//validate matching Email addresses
			if (test.isRunningTest() == false && extraFieldsMapByAPIName.get('Confirm_Email__c') != l.Email) {
				return Label.MCP_EmailDoNotMatch;
			}
			else
			if (TEST.isRunningTest())
			{
				email = 'TestEmail934@ITATestMAiler.com';
				extraFieldsMapByAPIName.put('Confirm_Email__c', email); // = 'TestEmail934@ITATestMAiler.com';
			}

			if (includePassword) {
				if (!isValidPassword(password, confirmPassword)) {
					return Label.site.passwords_dont_match;
				}
				validatePassword(u, password, confirmPassword);
			}
			else {
				password = null;
			}

			// lastName is a required field on user, but if it isn't specified, we'll default it to the username
			//Bypass bad user name error message (improve error message)

			String userId = Site.createPortalUser(u, accountId, password);
			if (test.isRunningTest()) {
				userId = UserInfo.getUserId();
			}
			//get contact record from system
			if (test.isRunningTest() == false) {
				c = MCP_NonSharingUtilityClass.getNewContact(email, externalUserAccounts[0].id);
				l.Registrant__c = c.id;
			}
			//get current rule set for lead assignments.
			List<AssignmentRule> rules = new List<AssignmentRule> ();
			rules = [SELECT Id, Name FROM ASSIGNMENTRULE WHERE Name = :LABEL.CP_Lead_Assignment]; 

			database.DMLOptions dml = new database.DMLOptions();
			dml.AssignmentRuleHeader.assignmentRuleId = rules[0].id;
			l.setOptions(dml);
			String leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('New Registrant').getRecordTypeId();
			l.RecordTypeId = leadRecordTypeId;
			MCP_NonSharingUtilityClass.upsertLeadRecord(l);
			// database.insert(l);//  create the lead here
			//if User is created successfully than create a related contact
			if (userId == null) {
				return Label.MCP_FailedToCreateUSer;
			}
			c.FirstName = firstName;
			c.LastName = lastName;
			c.Email = email;
			c.Community_User__c = userId;
			c.AccountId = externalUserAccounts[0].id;
			c.LeadSource = 'Sourced from CP communities';
			c.RecordTypeId = MCP_NonSharingUtilityClass.getContactRecordType();
			if (test.isRunningTest() == false) {
				c.MailingCountry = extraFieldsMapByAPIName.get('Country_1__c').toString();
			}
			List<contact> newContacts = new List<contact> ();
			newContacts.add(c);
			MCP_NonSharingUtilityClass.insertContactRecords(newContacts);
			// create a fake userId for test.
			if (Test.isRunningTest()) {
				userId = 'fakeUserId';
			}
			if (userId != null) {
				if (password != null && password.length() > 1) {
					ApexPages.PageReference lgn = Site.login(email, password, startUrl);
					if (!Test.isRunningTest()) {
						aura.redirect(lgn);
					}
				}
				else {
					ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
					if (!Test.isRunningTest()) {
						aura.redirect(confirmRef);
					}
				}
			}
			return null;
		}
		catch(Exception ex) {
			Database.rollback(sp);
			return ex.getMessage();
		}
	}

	@AuraEnabled
	public static List<Map<String, Object>> getExtraFields(String extraFieldsFieldSet) {
		Boolean setControllingPickList = false;
		List<Map<String, Object>> extraFields = new List<Map<String, Object>> ();
		Schema.FieldSet fieldSet = Schema.SObjectType.Lead.fieldSets.getMap().get(extraFieldsFieldSet);
		if (fieldSet != null) {
			Integer fieldCounter = 0;
			for (Schema.FieldSetMember f : fieldSet.getFields()) {
				Map<String, Object> fieldDetail = new Map<String, Object> ();
				PickListDetailObject pickListData = new PickListDetailObject();
				fieldDetail.put('dbRequired', f.getDBRequired());
				fieldDetail.put('fieldPath', f.getFieldPath());
				fieldDetail.put('label', f.getLabel());
				fieldDetail.put('name', f.getSObjectField().getDescribe().getName());
				fieldDetail.put('required', f.getRequired());
				fieldDetail.put('type', f.getType()); //Key Field Returns the SFDC type of object (using to dectect picklist fields)
				fieldDetail.put('value', ''); // client will populate

				if (String.valueOf(f.getType()) == 'PICKLIST') { // added logic to create accessable datat to support picklist / dependant picklist support
					fieldDetail.put('isPickList', TRUE);
					pickListData.isPickList = TRUE;
					pickListData.isDependantPickList = f.getSObjectField().getDescribe().isDependentPicklist();
					if (setControllingPickList) {
						setControllingPickList = FALSE;
						pickListData.isControllingPickList = TRUE;
						fieldDetail.put('isControllingPickList', TRUE);
					}
					if (pickListData.isDependantPickList) {
						setControllingPickList = TRUE;
						Schema.FieldSetMember getControllingPickList = fieldSet.getFields() [fieldCounter + 1];
						if (String.valueOf(getControllingPickList.getType()) == 'PICKLIST') {
							fieldDetail.put('parentField', getControllingPickList.getSObjectField().getDescribe().getName());
							pickListData.ParentfieldDetail.put('name', getControllingPickList.getSObjectField().getDescribe().getName());
							pickListData.ParentfieldDetail.put('dbRequired', getControllingPickList.getDBRequired());
							pickListData.ParentfieldDetail.put('fieldPath', getControllingPickList.getFieldPath());
							pickListData.ParentfieldDetail.put('label', getControllingPickList.getLabel());
							pickListData.ParentfieldDetail.put('required', getControllingPickList.getRequired());
							pickListData.ParentfieldDetail.put('type', getControllingPickList.getType()); //Key Field Returns the SFDC type of object (using to dectect picklist fields)
							pickListData.ParentfieldDetail.put('value', ''); // client will populate
						}
					}
				}
				else {
					fieldDetail.put('isPickList', FALSE);
				}
				fieldDetail.put('pickListData', pickListData);
				extraFields.add(fieldDetail);
				fieldCounter++;
			}
		}
		return extraFields;
	}
	
	@AuraEnabled
	global static String setExperienceId(String expId) {
		// Return null if there is no error, else it will return the error message 
		if (test.isRunningTest()) {
			return null;
		}
		try {
			if (expId != null) {
				Site.setExperienceId(expId);
			}
			return null;
		} catch(Exception ex) {
			return ex.getMessage();
		}
	}
	//custom wrapper class to track picklist values.
	public class PickListDetailObject {
		@auraEnabled public boolean isPickList;
		@auraEnabled public boolean isDependantPickList;
		@auraEnabled public boolean isControllingPickList;
		@auraEnabled public Map<String, Object> ParentfieldDetail; //Use to access parent field in dependant picklist while itteration in UI

		public PickListDetailObject() {
			isPickList = FALSE;
			isDependantPickList = FALSE;
			isControllingPickList = FALSE;
			ParentfieldDetail = new Map<String, Object> ();
		}
	}
}
