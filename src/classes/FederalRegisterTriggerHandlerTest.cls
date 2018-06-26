@isTest
public class FederalRegisterTriggerHandlerTest {
    private static Date publishDate = System.today();
    private static User u{
        get{
            if(u == null){
                u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
                                Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
                            FROM User WHERE LastName =: 'LastName1' LIMIT 1];
            }
            return u;
        }
    }
    private static List<Investigation__c> iList {
        get {
            if(iList == null) {
                iList = [SELECT Id, Calculated_Final_Signature__c FROM Investigation__c];
            }
            return iList;
        }
    }
    private static Investigation__c iAD {
        get {
            if(iAD == null) {
                Id recordType = Utils.getRecordTypeIdMap('Investigation__c').get('AD');
                iAD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, 
                            Calculated_Final_Signature__c, Petition__c 
                        FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
            }
            return iAD;
        }   
    }
    private static Set<Id> investigationIdSet {
        get {
            if(investigationIdSet == null) {
                investigationIdSet = new Set<Id>();
                for(Investigation__c i : iList) {
                    investigationIdSet.add(i.Id);
                }
            }
            return investigationIdSet;
        }
    }
 
    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, publishDate, true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
    }
}