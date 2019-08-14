@isTest
private class ReviewRecusalExtensionTest {
    static ADCVD_Case__c c {
        get {
            if (c == null) {
                c = [SELECT Id FROM ADCVD_Case__c LIMIT 1];
            }
            return c;
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
        String testlink = ext.recusalLink;
        Id testCaseId = ext.caseId;
        ext.cancel();

        Test.stopTest();
    }
    
    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        User pleaseAssignUser = TestUtils.createAdminUser(false, 'myemail2@email.com.testita', 2);
        pleaseAssignUser.LastName = 'Please Assign';
        pleaseAssignUser.Staffing_Role__c = 'Program Manager';
        insert pleaseAssignUser;
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
        Segment__c testARseg = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
    } 
    private static void primaryRecusalSetup(){
        pageRef = Page.ReviewRecusalPage;
        pageRef.getParameters().put('caseId', c.Id);
        pageRef.getParameters().put('userId', u.Id);
        pageRef.getParameters().put('retURL', 'apex/'+ c.Id);
        test.setCurrentPage(pageRef);
        Recusal__c r = TestUtils.createRecusal(u.Id, System.today(), System.today().addDays(3), true);
        con = new ApexPages.StandardController(r);
        ext = new ReviewRecusalExtension(con);
    }
}
