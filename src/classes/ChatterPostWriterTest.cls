/**
 * 
 *    Created by Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

@IsTest
public class ChatterPostWriterTest {
    private static Date petitionDate = Date.newInstance(2019, 3, 5);
    private static Date publishDate = Date.newInstance(2019, 3, 5);

    private static ADCVD_Case__c testADCase ;
    private static Petition__c newP;

    @IsTest
    static void testGetMap() {

        ChatterPostWriter cpw = new ChatterPostWriter();

        Test.startTest();
        System.assert(cpw.getMap(false).isEmpty());
        System.assert(cpw.getMap(true).isEmpty());

        Test.stopTest();
    }

    @IsTest
    static void testRemoveBatchedRecords() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        newP.Tolling_Update__c = false;
        oldP.Tolling_Update__c = true;

        Map<Id, SObject> newPMap = new Map<Id, SObject>();
        newPMap.put(newP.Id, newP);
        Map<Id, SObject> oldPMap = new Map<Id, SObject>();
        oldPMap.put(oldP.Id, oldP);

        ChatterPostWriter cpw = new ChatterPostWriter();
        Map<Id, SObject> testMap = cpw.removeBatchedRecords(newPMap, oldPMap);

        Test.startTest();
        System.assert(testMap.isEmpty());

        Test.stopTest();
    }
    @IsTest
    static void testInitialize() {

        dataSetup();

        Map<Id, SObject> newPMap = new Map<Id, SObject>();
        newPMap.put(newP.Id, newP);

        ChatterPostWriter cpw = new ChatterPostWriter();
        cpw.initialize(newPMap, 'Petition__c');

        Test.startTest();
        System.assert(StaffingAssignmentsSelector.parentIdsToStaffLists.isEmpty());

        Test.stopTest();
    }
    @IsTest
    static void testGetChatterPosts() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        Map<Id, SObject> newPMap = new Map<Id, SObject>();
        newPMap.put(newP.Id, newP);
        Map<Id, SObject> oldPMap = new Map<Id, SObject>();
        oldPMap.put(oldP.Id, oldP);

        ChatterPostWriter cpw = new ChatterPostWriter('Petition__c', newPMap, oldPMap);

        Test.startTest();
        //*************************NOT SURE WHAT TO TEST HERE
        //System.assert(testMap.isEmpty());

        Test.stopTest();
    }

    @IsTest
    static void testFieldChanged() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        Test.startTest();
        newP.Tolling_Update__c = true;
        oldP.Tolling_Update__c = true;

        ChatterPostWriter cpw = new ChatterPostWriter();

        Map<String, String> testMap = cpw.fieldChanged('Tolling_Update__c', newP, oldP);
        System.assert(testMap.isEmpty());

        newP.Tolling_Update__c = false;
        testMap = cpw.fieldChanged('Tolling_Update__c', newP, oldP);
        System.assert(!testMap.isEmpty());

        Test.stopTest();
    }

    @IsTest
    static void testAddExtensionChangeToPost() {

        Map<String, String> newToOldValueMap = new Map<String, String>();
        newToOldValueMap.put('1', '2');

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addExtensionChangeToPost('Preliminary', newToOldValueMap);

        System.assertEquals(testString, '<p>Preliminary Extension Number of Days changed from 2 to 1</p>');

        Test.stopTest();
    }

    @IsTest
    static void testAddExtensionResultToPost() {

        dataSetup();

        newP.Calculated_Initiation_Signature__c = petitionDate;

        Map<String, String> fieldNameToLabelMap = new Map<String, String>();
        fieldNameToLabelMap.put('Calculated_Initiation_Signature__c', 'Test');

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addExtensionResultToPost(fieldNameToLabelMap, newP);

        System.assertEquals(testString, '<p>The Test date is: <b>' + petitionDate.format() + '</b></p>');

        Test.stopTest();
    }

    @IsTest
    static void testFinishPost() {
        dataSetup();
        Petition__c oldP = newP.clone(true, true, true, true);
        Test.startTest();
        //newP.Tolling_Update__c = true;
        //oldP.Tolling_Update__c = true;
        ChatterPostWriter cpw = new ChatterPostWriter();
        cpw.finishPost('test', 'test', newP, true);
        //System.assert(testMap.isEmpty());
        //newP.Tolling_Update__c = false;
        //testMap = cpw.fieldChanged('Tolling_Update__c', newP, oldP);
        //System.assert(!testMap.isEmpty());
        Test.stopTest();

    }
    @IsTest
    static void testAddTemplateWithCaseInfo() {
        dataSetup();
        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        Map<String, Automated_Chatter_Post__mdt> postsMap = cpw.getPostsMap('Investigation__c');
        cpw.AddTemplateWithCaseInfo(newP, postsMap.get('Extension'));
        Test.stopTest();
        System.assert(!postsMap.isEmpty());
        System.assertEquals(true, postsMap.containsKey('Extension'));

    }

    @IsTest
    static void testGetLitigationStateChangeIs() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = '';
        oldP.Litigation_YesNo__c = 'Yes';
        oldP.Litigation_Resolved__c = 'Yes';



        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.getLitigationStateChange(newP, oldP);

        System.assertEquals(testString, ' is being litigated.');

        Test.stopTest();
    }

    @IsTest
    static void testGetLitigationStateChangeIsNot() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';
        oldP.Litigation_YesNo__c = 'Yes';
        oldP.Litigation_Resolved__c = '';



        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.getLitigationStateChange(newP, oldP);

        System.assertEquals(testString, ' is not being litigated.');

        Test.stopTest();
    }

    @IsTest
    static void testGetLitigationStateChangeNoChange() {

        dataSetup();

        Petition__c oldP = newP.clone(true, true, true, true);

        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';
        oldP.Litigation_YesNo__c = 'Yes';
        oldP.Litigation_Resolved__c = 'Yes';



        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.getLitigationStateChange(newP, oldP);

        System.assertEquals(testString, 'No Change');

        Test.stopTest();
    }

    @IsTest
    static void testAddAlignmentChangeToPostRemoved() {

        Map<String, String> newToOldValueMap = new Map<String, String>();
        newToOldValueMap.put(null, 'test');

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addAlignmentChangeToPost(newToOldValueMap);

        System.assertEquals('Alignment has been removed', testString);

        Test.stopTest();
    }

    @IsTest
    static void testAddAlignmentChangeToPostAdded() {
        Map<String, String> newToOldValueMap = new Map<String, String>();
        newToOldValueMap.put('test', 'test');

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addAlignmentChangeToPost(newToOldValueMap);

        System.assertEquals('Alignment has been added', testString);

        Test.stopTest();
    }

    @IsTest
    static void testSetCaseInformation() {

        dataSetup();

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.setCaseInformation(newP);

        System.assertEquals(newP.ADCVD_Case_Number_Text__c + '--' + newP.Name +', '+newP.Product_Short_Name_Text__c+' from ' + newP.Country_Text__c, testString);

        Test.stopTest();
    }

    @IsTest
    static void testAddLinkToPost() {

        dataSetup();

        Test.startTest();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addLinkToPost(newP);

        System.assertEquals('<p>' + 'Link to record: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + (Id)newP.get('Id')+'</p>', testString);

        Test.stopTest();
    }
    @IsTest
    static void testGetRoleToUserIdListMap() {

        dataSetup();

        Test.startTest();
        String testString = 'This is a test';
        ChatterPostWriter cpw = new ChatterPostWriter();
        Map<String, List<Id>> testMap = cpw.getRoleToUserIdListMap(newP, testString);

        System.assert(testMap.isEmpty());

        testString = 'This is a CurrentUser test';
        cpw = new ChatterPostWriter();
        testMap = cpw.getRoleToUserIdListMap(newP, testString);

        System.assert(!testMap.isEmpty());

        Test.stopTest();
    }
    @IsTest
    static void testAddUserIdsToPost() {

        Test.startTest();
        Map<String, List<Id>> testMap = new Map<String, List<Id>>();
        ChatterPostWriter cpw = new ChatterPostWriter();
        String testString = cpw.addUserIdsToPost(testMap, '');

        System.debug('testString------------'+testString);

        System.assert(String.isBlank(testString));

        Test.stopTest();
    }

    @IsTest
    static void testAddPostToPostMap() {

        dataSetup();

        Test.startTest();
        String testString = 'This is a test';
        ChatterPostWriter cpw = new ChatterPostWriter();
        cpw.addPostToPostMap(testString, newP, true);

        System.assert(!cpw.getMap(true).isEmpty());

        testString = 'This is a test';
        cpw = new ChatterPostWriter();
        cpw.addPostToPostMap(testString, newP, false);

        System.assert(!cpw.getMap(false).isEmpty());

        Test.stopTest();
    }

    @testSetup static void dataSetup() {
        testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', false);
        testAdCase.Id = fflib_IDGenerator.generate(ADCVD_Case__c.SObjectType);

        newP = TestUtils.createPetition(testADCase, petitionDate, false);
        newP.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);

        newP.ADCVD_Case_Number_Text__c = 'TestCase';
        newP.Product_Short_Name_Text__c = 'TestProductShortName';
        newP.Country_Text__c = 'Belarus';

    }

}