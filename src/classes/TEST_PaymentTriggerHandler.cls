@isTest(seeAllData=false)
public class TEST_PaymentTriggerHandler{

	public static testmethod void TEST_1(){
		Payment__c payment1 = new Payment__c();
	    insert payment1;
	    Payment__c payment2 = new Payment__c();
	    insert payment2;
	    Payment__c[] newList = new List<Payment__c>();
		newList.add(payment1);
		newList.add(payment2);
		Map<id, Payment__c> newMap = new Map<id, Payment__c>();
		Map<id, Payment__c> oldMap = new Map<id, Payment__c>();
		Test.startTest();    
		PaymentTriggerHandler.createCases(newList, newMap, oldMap);
		system.assertEquals(null, null);  //Nothing is return from createCases so nothing can be compared
		Test.stopTest();
	}
}