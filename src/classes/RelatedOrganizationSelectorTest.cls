/*
 * Create by Eitan Alfiya
 * on 5/9/2018
 * Mil Corporation
 */
@isTest
public class RelatedOrganizationSelectorTest {

    private static Related_Organization__c relatedOrg{
        get{
            if(relatedOrg == null){
                relatedOrg = [Select Id, Name, Type__c From Related_Organization__c Limit 1];
            }
            return relatedOrg;
        }
        set;
    }
    
    @testSetup static void dataSetup(){
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //Create parent for Related Organization
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-111-222', 'AD ME', true);
        Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        //Get picklist values for type__c field, using schema class in case picklist values changes
        List<Schema.PicklistEntry> typeFieldPicklistValues = Related_Organization__c.Type__c.getDescribe().getPicklistValues(); 
        Related_Organization__c relatedOrg = TestUtils.createRelatedOrg(petition, false);
        relatedOrg.Type__c = typeFieldPicklistValues[0].getValue();
        insert relatedOrg;
    }
    
    @isTest static void testRelatedOrganizations(){
        List<Related_Organization__c> relatedOrgsList = RelatedOrganizationSelector.allRelatedOrganizations;
        System.assertEquals(relatedOrg.Id, relatedOrgsList[0].Id);
        System.assertEquals(relatedOrg.Name, relatedOrgsList[0].Name);
        for(Related_Organization__c org:relatedOrgsList){
            System.debug(org.Id +' --- '+org.Name+' --- '+org.Petition__c);

        }
    }
    
    @isTest static void testRelatedOrganizationsInContext(){
        Set<String> fields = new Set<String>{'Name', 'Type__c'};
        List<Related_Organization__c> relatedOrgsInContext = RelatedOrganizationSelector.getRelatedOrganizationsInContext(new Set<Id>{relatedOrg.Id}, fields, true);
        System.assertEquals(relatedOrg.Name, relatedOrgsInContext[0].Name);
        System.assertEquals(relatedOrg.Type__c, relatedOrgsInContext[0].Type__c);
    }
    
    
}