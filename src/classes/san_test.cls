@istest
private class san_test{

    static testMethod void statusonlinetest(){

Content__c cc = new Content__c (Name = 'ABC', Status__c = 'Online', Display_Title__c = 'ABC-Title');
insert cc;
Content_Version__c cv = [Select Content__c FROM Content_Version__c where Atom__c = :cc.id LIMIT 1 ];
//System.assertEquals(cc.Id, cv.Content__c);
    }
        
    static testMethod void statusrejectedtest(){
        
Content__c cc1 = new Content__c (Name = 'ABC-1', Status__c = 'Draft: Rejected', Display_Title__c = 'ABC-Title-1');
insert cc1;
Content_Version__c cv1 = [Select Content__c FROM Content_Version__c where Atom__c = :cc1.id LIMIT 1 ];        
//System.assertEquals(cc1.Id, cv1.Content__c);
 }
}