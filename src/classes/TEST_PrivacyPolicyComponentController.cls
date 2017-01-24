@isTest
public class TEST_PrivacyPolicyComponentController {
    
    public static testmethod void test1(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        	insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            insert product;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
            insert asset;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
            insert framework;
             Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
            insert participant;
        Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
            insert participation;
        
        PrivacyPolicyComponentController controller = new PrivacyPolicyComponentController();
        boolean showArtEditScreen = controller.showArtEditScreen;
        controller.showArtEditScreen = false;
        controller.participantId = participation.id;
        controller.deleteArtifact();
        controller.selectedArtifact = new Artifact__c();
        controller.save();
        
        system.assertEquals(controller.participantId, participation.id);
    }
    
}