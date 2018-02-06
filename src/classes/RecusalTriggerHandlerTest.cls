/**
 * 
 *    Created by Joshua Moody
 *    on Oct 3 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class RecusalTriggerHandlerTest {

	/************************************************
    * This class performs unit tests on the RecusalTriggerHandler
    * under these condititions.
    * 1. Test to ensure that a related recusal correctly syncs to it's primary
    *************************************************/

	static Petition__c p {
		get {
			if (p == null) {
				p = [SELECT Id FROM Petition__c LIMIT 1];
			}
			return p;
		} set;
	}
	static Investigation__c i {
		get {
			if (i == null) {
				i = [SELECT Id FROM Investigation__c LIMIT 1];
			}
			return i;
		} set;
	}
	static ADCVD_Order__c o {
        get {
            if (o == null) {
                o = [SELECT Id FROM ADCVD_Order__c LIMIT 1];
            }
            return o;
        } set;
    }
    static Segment__c s {
        get {
            if (s == null) {
                s = [SELECT Id FROM Segment__c LIMIT 1];
            }
            return s;
        } set;
    }
    static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			return u;
		} set;
	}
	static Recusal__c primaryRecusal {
		get{
			if(primaryRecusal == null) {
				Id recordType = Utils.getRecordTypeIdMap('Recusal__c').get('Primary');
				primaryRecusal = [SELECT Id, User__c, Start_Date__c, End_Date__c, RecordTypeId FROM Recusal__c WHERE RecordTypeId =: recordType LIMIT 1];
			}
			return primaryRecusal;
		} set;
	}
	static Recusal__c relatedRecusal {
		get{
			if(relatedRecusal == null) {
				Id recordType = Utils.getRecordTypeIdMap('Recusal__c').get('Related');
				relatedRecusal = [SELECT Id, User__c, Start_Date__c, End_Date__c, RecordTypeId FROM Recusal__c WHERE RecordTypeId =: recordType LIMIT 1];
			}
			return relatedRecusal;
		} set;
	}

    @isTest static void syncTest() {
    	Test.startTest();
		primaryRecusal = TestUtils.createRecusal(u.Id, System.today(), System.today().addDays(3), true);

    	relatedRecusal = TestUtils.createRecusal(primaryRecusal.Id, p.Id, 'Petition__c', true);
    	relatedRecusal = null;
    	System.assertEquals(relatedRecusal.User__c, primaryRecusal.User__c);

    	primaryRecusal.End_Date__c = primaryRecusal.End_Date__c.addDays(3);
    	update primaryRecusal;
    	relatedRecusal = null;

    	Test.stopTest();

    	System.assertEquals(relatedRecusal.End_Date__c, System.today().addDays(6));
    }

	@testSetup static void dataSetup() {
		Test.startTest();
        p = TestUtils.createPetition(System.today().addDays(-280), 'AD ME', true);
        i = TestUtils.createInvestigation('AD', p, true);
        o = TestUtils.createOrder(i, true);
        s = TestUtils.createSegment(o, 'Administrative_Review', true);
        u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
	}
}