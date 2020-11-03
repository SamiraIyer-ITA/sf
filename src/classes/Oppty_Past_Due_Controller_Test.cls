@isTest
private class Oppty_Past_Due_Controller_Test {
    @isTest static void testMethod1() {
        Account objAccount = new Account(Name = 'Test Account');
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Test', AccountId = objAccount.Id);
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity(AccountId = objAccount.Id, Name = 'Test Opportunity', StageName = 'Qualification',
                                                     CloseDate = Date.today().addDays(20), Assigned_User__c = UserInfo.getUserId(), 
                                                     Assigned_Date__c = Date.today().addDays(-1));
        insert objOpportunity;
                
        Oppty_Past_Due_Controller.getStatus(objOpportunity.Id);
    }
}