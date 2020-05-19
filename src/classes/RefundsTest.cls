/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: RefundsTest.cls
	Purpose: Test class for IRefunds and Refunds.
 */
@IsTest
private class RefundsTest {

	static Id legacyRecordTypeId = Schema.SObjectType.Order
		.getRecordTypeInfosByDeveloperName().get('Legacy').getRecordTypeId();

	@IsTest
	static void testNewInstanceOfRefundsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Refund__c> refundList  = new List<Refund__c>();
		refundList.add(new Refund__c());
		IRefunds iRefund = (IRefunds) Refunds.newInstance(refundList);
		System.assertNotEquals(iRefund, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testRefundsTrigger_InsertRefundRecord_TriggerIsCovered() {
		try { insert new Refund__c(); } catch (Exception e) {}
	}

	@isTest
	static void testRefundContactAndOfficer_Insert() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case(Participation_Profile__c=myApplication.Id);
		insert myCase;

		Asset asset = new Asset();
		asset.Name ='Name';
		asset.Organization_Contact__c = 'i@i.com';
		asset.Organization_Corporate_Officer__c = 'i@i.com';
		asset.Participant__c = myApplication.Id;
		asset.AccountId = myAccount.Id;
		insert asset;

		Order myOrder = new Order(RecordTypeId = legacyRecordTypeId,Participant__c=myApplication.Id,AccountId=myAccount.Id,Status='In Progress',EffectiveDate=Date.today());
		insert myOrder;

		Payment__c myPayment = new Payment__c(Order__c=myOrder.Id);
		insert myPayment;

		Refund__c myRefund = new Refund__c(Payment__c=myPayment.Id);
		insert myRefund;

		Participation__c myApplication2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Participation__c WHERE Id =: myApplication.Id];
		Order myOrder2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Order WHERE Id =: myOrder.Id];
		Payment__c myPayment2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Payment__c WHERE Id =: myPayment.Id];
		Refund__c myRefund2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Refund__c WHERE Id =: myRefund.Id];
		Case myCase2 = [SELECT Organization_Contact__c,Organization_Corporate_Officer__c FROM Case WHERE Id =: myCase.Id];

		Test.startTest();
		System.assertEquals('officer@success.com',myApplication2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myApplication2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myOrder2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myOrder2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myPayment2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myPayment2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myRefund2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myRefund2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}

	@isTest
	static void testRefundContactAndOfficer_Update() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='i@i.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='i@i.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case(Participation_Profile__c=myApplication.Id);
		insert myCase;

		Asset asset = new Asset();
		asset.Name ='Name';
		asset.Organization_Contact__c = 'i@i.com';
		asset.Organization_Corporate_Officer__c = 'i@i.com';
		asset.Participant__c = myApplication.Id;
		asset.AccountId = myAccount.Id;
		insert asset;

		Order myOrder = new Order(RecordTypeId = legacyRecordTypeId,Participant__c=myApplication.Id,AccountId=myAccount.Id,Status='In Progress',EffectiveDate=Date.today());
		insert myOrder;

		Payment__c myPayment = new Payment__c(Order__c=myOrder.Id);
		insert myPayment;

		Refund__c myRefund = new Refund__c(Payment__c=myPayment.Id);
		insert myRefund;

		appContacts[0].Email__c = 'officer@success.com';
		appContacts[1].Email__c = 'contact@success.com';
		update appContacts;

		Participation__c myApplication2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Participation__c WHERE Id =: myApplication.Id];
		Order myOrder2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Order WHERE Id =: myOrder.Id];
		Payment__c myPayment2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Payment__c WHERE Id =: myPayment.Id];
		Refund__c myRefund2 = [SELECT Name,Organization_Contact__c,Organization_Corporate_Officer__c FROM Refund__c WHERE Id =: myRefund.Id];
		Case myCase2 = [SELECT Organization_Contact__c,Organization_Corporate_Officer__c FROM Case WHERE Id =: myCase.Id];

		Test.startTest();
		System.assertEquals('officer@success.com',myApplication2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myApplication2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myOrder2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myOrder2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myPayment2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myPayment2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myRefund2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myRefund2.Organization_Contact__c);
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}

}