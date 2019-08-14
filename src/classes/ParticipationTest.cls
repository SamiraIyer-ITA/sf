@IsTest
private class ParticipationTest {

	@IsTest
	static void testNewInstanceOfParticipationDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Participation__c> participationList  = new List<Participation__c>();
		participationList.add(new Participation__c());
		IParticipation part = (IParticipation) Participation.newInstance(participationList);
		System.assertNotEquals(part, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testUpdateAccountAddresses_CallWithoutSetup_IssuesNoErrors(){
		Participation__c p = new Participation__c();
		List<Participation__c> participationList = new List<Participation__c> {p};

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mock_uow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Default stub is acceptable; not expecting anything special.  Just don't want a real UOW called.
		fflibext_Application.UnitOfWork.setMock(mock_uow);
		try {
			Participation.newInstance(participationList).updateAccountAddresses();
			System.assert(true); // Should be the only assert in this test that actually executes
		} catch (Exception e){
			System.assert(false, 'UpdateAccountAddresses caused an exception and should not have');
		}
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

        Order myOrder = new Order(Participant__c=myApplication.Id,AccountId=myAccount.Id,Status='In Progress',EffectiveDate=Date.today());
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

        Order myOrder = new Order(Participant__c=myApplication.Id,AccountId=myAccount.Id,Status='In Progress',EffectiveDate=Date.today());
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
        Test.stopTest();
    }

	@IsTest
	static void testParticipationTrigger_InsertParticipationRecord_TriggerIsCovered() {
		try { insert new Participation__c(); } catch (Exception e) {}
	}

}