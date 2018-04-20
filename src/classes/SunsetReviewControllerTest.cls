@isTest
public class SunsetReviewControllerTest {
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
                s = [SELECT Id, Notice_of_intent_to_participate_Ips__c, Domestic_Party_File_Substan_Response__c, Respondent_File_Substantive_Response__c, Review_to_address_zeroing_in_Segments__c 
                        FROM Segment__c LIMIT 1];
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
        }
    }
    static SunsetReviewController ext;
    static PageReference pageRef;
    static ApexPages.StandardController con;

    @isTest static void sunsetTypeTest() {
        Test.startTest();
        sunsetSetup();
        ext.toggleEdit();
        System.assertNotEquals(null, ext.reviewInfoFieldsList);
        System.assertNotEquals(null, ext.fieldsList90);
        System.assertNotEquals(null, ext.fieldsList120);
        System.assertNotEquals(null, ext.fieldsList240);

        ext.ssReview.Notice_of_intent_to_participate_Ips__c = 'No';
        System.assertEquals(true, ext.is90day);
        System.assertEquals(false, ext.is120day);
        System.assertEquals(false, ext.is240day);

        ext.ssReview.Notice_of_intent_to_participate_Ips__c = 'Yes';
        ext.ssReview.Domestic_Party_File_Substan_Response__c = 'Yes';
        ext.ssReview.Respondent_File_Substantive_Response__c = 'No';
        System.assertEquals(false, ext.is90day);
        System.assertEquals(true, ext.is120day);
        System.assertEquals(false, ext.is240day);

        ext.ssReview.Review_to_address_zeroing_in_Segments__c = 'Yes';

        Test.stopTest();
        System.assertEquals(false, ext.is90day);
        System.assertEquals(false, ext.is120day);
        System.assertEquals(true, ext.is240day);
    }
    @isTest static void saveTest() {
        Test.startTest();
        sunsetSetup();
        ext.toggleEdit();
        ext.ssReview.Notice_of_intent_to_participate_Ips__c = 'No';
        ext.save();

        Test.stopTest();

    }
//    @isTest static void cancelTest() {
//        Test.startTest();
//        sunsetSetup();
//        ext.toggleEdit();
//        ext.cancel();
//
//        Test.stopTest();
//        System.assertEquals(false, ext.edit);
//    }
    @isTest static void uxContext() {
        Test.startTest();
        sunsetSetup();
        
        Test.stopTest();
        System.assertNotEquals(null, ext.isSalesforce1);
        System.assertNotEquals(null, ext.isLightningExperience);
        System.assertNotEquals(null, ext.isSalesforceClassic);
    }
    
    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = TestUtils.createAdminUser(false, 'myemail@email.com.testita', 1);
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
        Segment__c testARseg = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
    } 
    private static void sunsetSetup(){
        pageRef = Page.SunsetReview;
        pageRef.getParameters().put('id', s.Id);
        pageRef.getParameters().put('retURL', 'apex/'+ s.Id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(s);
        ext = new SunsetReviewController(con);
    }
}