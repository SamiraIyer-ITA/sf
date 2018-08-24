@isTest(seealldata = false)
public class TEST_MyOrders{

    public static testmethod void InternalUser(){
        PageReference pageRef = Page.MyOrders;
        Test.setCurrentPage(pageRef);
        MyOrdersPageController controller = new MyOrdersPageController();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('You must be logged in as a Community User to see MyOrders.')){
                b = true;
                break;
            }
        }
        system.assert(b);
    }
    
    public static testmethod void ExternalUser_NoOrders(){
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        contact c = new Contact();
            c.firstname = 'John';
            c.lastname = 'Smith';
            c.email = 'John.Smith@no.mail';
            c.accountid = acc.id;
            insert c;
        User u = new User( email=c.email,
            UserName=c.email, 
            Alias = c.firstname,
            TimeZoneSidKey='America/New_York',
            EmailEncodingKey='ISO-8859-1',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US',
            ContactId = c.id,
            LastName = c.lastname,
            ProfileId = p.id,
            CommunityNickname = c.firstname+c.lastname);
            insert u;

            System.runAs(u){
                PageReference pageRef = Page.MyOrders;
                Test.setCurrentPage(pageRef);
                MyOrdersPageController controller = new MyOrdersPageController();
                List<Apexpages.Message> msgs = ApexPages.getMessages();
                boolean b = false;
                for(Apexpages.Message msg:msgs){
                    if (msg.getDetail().contains('Your organization has not applied to any Frameworks yet.')){
                        b = true;
                        break;
                    }
                }
                system.assert(b);            
            }
    }

    public static testmethod void ExternalUser_WithOrders(){
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        contact c = new Contact();
            c.firstname = 'John';
            c.lastname = 'Smith';
            c.email = 'John.Smith@no.mail';
            c.accountid = acc.id;
            insert c;
        User u = new User( email=c.email,
            UserName=c.email, 
            Alias = c.firstname,
            TimeZoneSidKey='America/New_York',
            EmailEncodingKey='ISO-8859-1',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US',
            ContactId = c.id,
            LastName = c.lastname,
            ProfileId = p.id,
            CommunityNickname = c.firstname+c.lastname);
            insert u;

            System.runAs(u){
                Participation__c Participant = new Participation__c(organization__c = acc.id, name = acc.name, Postal_Code__c = acc.billingpostalcode);
                insert Participant;
                Participant__c Participation = new Participant__c(Participant__c = Participant.id);
                insert Participation;
                Order Order = new Order(AccountId=acc.id, participant__c = Participant.id, participation__c = Participation.id, effectivedate = Date.today(), status='Draft');
                insert Order;
                PageReference pageRef = Page.MyOrders;
                Test.setCurrentPage(pageRef);
                MyOrdersPageController controller = new MyOrdersPageController();
                system.assertEquals(controller.orders.size(), 1);
                
                MyOrdersComponentController component = new MyOrdersComponentController();
                    component.orders = controller.orders;
                    component.getOrderMap();
            }
    }
}