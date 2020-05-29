@IsTest
public class TaskCommercialInfoCmpCont_Test {


    @IsTest 
    static void unit_1() {

        Test.startTest();
        
        Commercial_Diplomacy_Triage__c commObj = new Commercial_Diplomacy_Triage__c();
        
        commObj.HTS_Comments__c = 'The merchandise covered by this 7307.11.0046  7307.11.0044';
        
        insert commObj;
        
        Task tkobj = new task(Commercial_Diplomacy_Triage__c =commObj.Id,WhatID = commObj.id,Subject='Donni',Status='New',Priority='Normal');
        
        insert tkobj;
        
        Commercial_Diplomacy_Triage__c record = TaskCommercialInfoCmpCont.getCommDiplTrig(tkobj.Id);
        
            
        Test.StopTest();
    }

}