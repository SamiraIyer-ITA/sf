@isTest
public class Test_caseEmailHandler {
    public static testMethod void testONE(){
        //SETUP TEST DATA
        Account comAccount = new Account(name='Community Account'); //create account
        insert comAccount;
        Contact comContact = new contact(LastName = 'comContact', AccountId = comAccount.Id); //create contact
        insert comContact;
        case pc = new case(contactid=comContact.id, accountid=comAccount.id, subject = 'Testing', description = 'More test');
        insert pc;
        
        
        EmailMessage emailMsg = new EmailMessage();
        emailMsg.ToAddress = 'noreply@trade.gov';
        emailMsg.FromAddress = 'noreply@trade.gov';
        emailMsg.FromName = 'Privacy Shield';
        emailMsg.Subject = 'mail.getSubject()';
        emailMsg.HtmlBody = 'mail.getHtmlBody()';
        emailMsg.ParentId = pc.Id; //Attach to the case
        emailMsg.MessageDate = system.now();
        emailMsg.Status = '0';
        insert emailMsg;
        
        EmailMessage[] eM = new emailMessage[]{};
        eM.add(emailMsg);
        
        Test.startTest();
            caseEmailHandler myController = new CaseEmailHandler();
        
            myController.addComment(eM);
        Test.stopTest();
    }

    public static testMethod void testTWO(){
        //SETUP TEST DATA
        Account comAccount = new Account(name='Community Account'); //create account
        insert comAccount;
        Contact comContact = new contact(LastName = 'comContact', AccountId = comAccount.Id); //create contact
        insert comContact;
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Documentation').getRecordTypeId();
        case pc = new case(contactid=comContact.id, accountid=comAccount.id, subject = 'Testing', description = 'More test',
            RecordTypeId = recordTypeId);
        insert pc;


        EmailMessage emailMsg = new EmailMessage();
        emailMsg.ToAddress = 'noreply@trade.gov';
        emailMsg.FromAddress = 'noreply@trade.gov';
        emailMsg.FromName = 'Privacy Shield';
        emailMsg.Subject = 'mail.getSubject()';
        emailMsg.HtmlBody = 'mail.getHtmlBody()';
        emailMsg.ParentId = pc.Id; //Attach to the case
        emailMsg.MessageDate = system.now();
        emailMsg.Status = '0';
        insert emailMsg;

        EmailMessage[] eM = new emailMessage[]{};
        eM.add(emailMsg);

        Test.startTest();
        caseEmailHandler myController = new CaseEmailHandler();

        myController.addComment(eM);
        Test.stopTest();
    }
}