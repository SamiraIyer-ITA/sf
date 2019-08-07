/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: CasesTest.cls
	Purpose: Test class for ICases and Cases.
 */
@IsTest
private class CasesTest {

	@IsTest
	static void testNewInstanceOfCasesDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Case> caseList  = new List<Case>();
		caseList.add(new Case());
		ICases iCase = (ICases) Cases.newInstance(caseList);
		System.assertNotEquals(iCase, null, 'Interface returned as null and should not have');
	}

	@isTest
	static void testUpdateContactAndOfficer_Insert() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case();
		//myCase.Name ='Name';
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		myCase.Participation_Profile__c = myApplication.Id;
		myCase.AccountId = myAccount.Id;
		//try insert
		insert myCase;

		Test.startTest();
		//test successful insert trigger
		Case myCase2 = [select Organization_Contact__c,Organization_Corporate_Officer__c from Case where Id =: myCase.Id];
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}

	@isTest
	static void testUpdateContactAndOfficer_Update() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case();
		//myCase.Name ='Name';
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		myCase.Participation_Profile__c = myApplication.Id;
		myCase.AccountId = myAccount.Id;
		//try insert
		insert myCase;

		Test.startTest();
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		//try update
		update myCase;

		Case myCase2 = [select Organization_Contact__c,Organization_Corporate_Officer__c from Case where Id =: myCase.Id];

		//test successful update trigger
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}

	@IsTest
	static void testCasesTrigger_InsertCaseRecord_TriggerIsCovered() {
		try { insert new Case(); } catch (Exception e) {}
	}

}