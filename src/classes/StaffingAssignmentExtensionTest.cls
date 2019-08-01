/**
*
*    Created by Joshua Moody
*    on Oct 3 2017
*    MIL Corporation
*
**/

@isTest
public class StaffingAssignmentExtensionTest {
     /************************************************
    * This class performs unit tests on the StaffingAssignmentExtension
    * under these condititions.
    * 1. Test to ensure that an order's staffing assignments display and
    * are updated correctly
    * 2. Test to ensure that staffing assignments are created on insert
    * 3. Test to ensure the UI is correctly detected
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
    static StaffingAssignmentExtension ext;
    static PageReference pageRef;
    static ApexPages.StandardController con;

    @isTest static void exerciseAttributes() {
        Test.startTest();
        new StaffingAssignmentExtension(new ApexPages.StandardController(new Staffing_Assignment__c()));
        orderSetup();
        Object testSaveError = ext.saveError;
        Object testOverwriteSegments = ext.overwriteSegments;
        Object testAddWrapper = ext.addWrapper;
        List<SelectOption> testallUserSelectOptions = ext.allUserSelectOptions;
        Map<String,List<SelectOption>> testUserSelectOptions = ext.userSelectOptions;
        Map<String, List<User>> testUserRoleMap = ext.userRoleMap;
        List<Object> testStaffWrapperList = ext.staffWrapperList;
        ext.getReturnUrl();
        Staffing_Assignment__c testSA = ext.querySA();
        List<SObject> testRelOrgList = ext.getRelOrgList(ext.parentId);
        Staffing_Assignment__c testNewSA = StaffingAssignmentExtension.createNewStaffingAssignment(ext.parentId, 'Office Director');
        Test.stopTest();
    }

    @isTest static void orderTest() {
        Test.startTest();
        orderSetup();
        ext.checkParent();
        ext.noParentError = false;
        System.assertNotEquals(null, ext.parentFieldNames);
        ext.sa.Title__c = 'DAS';
        ext.sa.User__c = u.Id;
        ext.save();

        Test.stopTest();
    }
    @isTest static void petitionTest() {
        Test.startTest();
        petitionSetup();
        ext.addRow();
        ext.cancel();

        Test.stopTest();
    }
    @isTest static void investigationTest() {
        Test.startTest();
        investigationSetup();
        ext.cancel();

        Test.stopTest();
    }
    @isTest static void uxContext() {
        Test.startTest();
        orderSetup();

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
        testUser.Staffing_Role__c = 'DAS';
        insert testUser;
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
        Segment__c testARseg = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
    }
    private static void petitionSetup(){
        pageRef = Page.StaffingAssignment;
        pageRef.getParameters().put('parentId', p.Id);
        pageRef.getParameters().put('addWrapper', '1');
        pageRef.getParameters().put('retURL', 'apex/'+ p.Id);
        test.setCurrentPage(pageRef);
        Staffing_Assignment__c sa = TestUtils.createStaff(p, 'Petition__c', false);
        con = new ApexPages.StandardController(sa);
        ext = new StaffingAssignmentExtension(con);
    }
    private static void investigationSetup(){
        pageRef = Page.StaffingAssignment;
        pageRef.getParameters().put('id', i.Id);
        pageRef.getParameters().put('retURL', 'apex/'+ i.Id);
        test.setCurrentPage(pageRef);
        Staffing_Assignment__c sa = TestUtils.createStaff(i, 'Investigation__c', false);
        con = new ApexPages.StandardController(sa);
        ext = new StaffingAssignmentExtension(con);
    }
    private static void orderSetup(){
        pageRef = Page.StaffingAssignment;
        pageRef.getParameters().put('parentId', o.Id);
        pageRef.getParameters().put('addWrapper', '1');
        pageRef.getParameters().put('retURL', 'apex/'+ o.Id);
        test.setCurrentPage(pageRef);
        Staffing_Assignment__c sa = [SELECT Id, User__c, Title__c, ADCVD_Case__c, ADCVD_Order__c
        FROM Staffing_Assignment__c WHERE ADCVD_Order__c =: o.Id LIMIT 1];
        con = new ApexPages.StandardController(sa);
        ext = new StaffingAssignmentExtension(con);
    }
}