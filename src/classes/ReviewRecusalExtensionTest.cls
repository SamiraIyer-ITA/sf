@isTest
private class ReviewRecusalExtensionTest {
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
	static ReviewRecusalExtension ext;
  	static PageReference pageRef;
  	static ApexPages.StandardController con;

	@isTest static void primaryRecusalTest() {
        Test.startTest();
		primaryRecusalSetup();
		System.assertNotEquals(null, ext.parentFieldNames);
		ext.cancel();

        Test.stopTest();
	}
	@isTest static void relatedRecusalTest() {
        Test.startTest();
		relatedRecusalSetup();
		System.assertNotEquals(null, ext.parentFieldNames);
		ext.cancel();

        Test.stopTest();
	}
    @isTest static void uxContext() {
    	Test.startTest();
    	primaryRecusalSetup();
    	
    	Test.stopTest();
    	System.assertNotEquals(null, ext.isSalesforce1);
    	System.assertNotEquals(null, ext.isLightningExperience);
    	System.assertNotEquals(null, ext.isSalesforceClassic);
    }
	
	@testSetup static void dataSetup() {
        Test.startTest();
        p = TestUtils.createPetition(System.today().addDays(-280), 'AD ME', true);
        i = TestUtils.createInvestigation('AD', p, true);
        o = TestUtils.createOrder(i, true);
        s = TestUtils.createSegment(o, 'Administrative_Review', true);
        u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
    } 
    private static void primaryRecusalSetup(){
		pageRef = Page.ReviewRecusalPage;
        pageRef.getParameters().put('parentId', p.Id);
        pageRef.getParameters().put('userId', u.Id);
        pageRef.getParameters().put('retURL', 'apex/'+ p.Id);
        test.setCurrentPage(pageRef);
        Recusal__c r = TestUtils.createRecusal(u.Id, System.today(), System.today().addDays(3), true);
        con = new ApexPages.StandardController(r);
    	ext = new ReviewRecusalExtension(con);
	}
	private static void relatedRecusalSetup(){
		pageRef = Page.ReviewRecusalPage;
        pageRef.getParameters().put('parentId', p.Id);
        pageRef.getParameters().put('userId', u.Id);
        pageRef.getParameters().put('retURL', 'apex/'+ p.Id);
        test.setCurrentPage(pageRef);
        Recusal__c primary = TestUtils.createRecusal(u.Id, System.today(), System.today().addDays(3), true);
        Recusal__c related = TestUtils.createRecusal(primary.Id, p.Id, 'Petition__c', true);
        con = new ApexPages.StandardController(related);
    	ext = new ReviewRecusalExtension(con);
	}
}