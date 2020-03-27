@isTest
public class CaseTriggerHandler_Test{
    
    @IsTest 
    static void unit_1() {

        Test.startTest();
        
        Commercial_Diplomacy_Triage__c commObj = new Commercial_Diplomacy_Triage__c();
        
        
        insert commObj;
        
        
        Case objCase = new Case();
        objCase.Status ='New';
        objCase.Subject = 'Test1';
        objCase.HTS_Comments__c = 'The merchandise covered by this 7307.11.0046  7307.11.0044';
        //objCase.Potential_Primary_Outcome__c = 'Created/Improved Business Opportunity';
        insert  objCase;
        
        objCase.Commercial_Diplomacy_Triage__c=commObj.Id;
        
        update objCase;
        
            
        Test.StopTest();
    }
    
    
    public static testmethod void Unit_2(){


        PaymentSettings__c[] settings = new PaymentSettings__c[]{
            new PaymentSettings__c(name='PRIVACY_SHIELD_APP_ID', value__c = 'dummy'),
            new PaymentSettings__c(name='PRIVACY_SHIELD_APP', value__c = 'ps'),
            new PaymentSettings__c(name='EVENTS_SERVICES_APP_ID', value__c = 'dummy'),
            new PaymentSettings__c(name='EVENTS_SERVICES_APP', value__c = 'es'),
            new PaymentSettings__c(name='AGENCY_ID', value__c = 'es'),
            new PaymentSettings__c(name='PRIVACY_SHIELD_APP_NAME', value__c = 'Privacy Shield')
        };
        insert settings;
        
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
        Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
            new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
            new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
        };
            insert TPML;
    
        Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
            insert participant;
        Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
            insert participation;
        Order order = new Order();
            order.accountid = acc.id;
            order.Participation__c = participation.id;
            order.participant__c = participant.id;
            order.program__c = program.id;
            order.effectivedate = Date.today();
            order.status = 'Draft';
        insert order;
        
        Case objCase = new Case();
        objCase.Status ='New';
        objCase.Subject = 'Test1';
        objCase.Order__c = order.Id;
        objCase.Record_Type__c = 'Export Promotion';
        objCase.accountId=acc.Id;
        objCase.Fee__c='Business Facilitation Service';
        insert objCase;
        
        try{
            objCase.status = 'Successfully Closed' ;
            
            update objCase;
        }catch(Exception exe){
        
        }
                    
        objCase.status = 'Denied' ;
        
        update objCase;
        
        
    }
    
    
    
}