@IsTest
public class orderTriggerTest {
	@isTest static void createOrder() { 
      	Account a = new Account(name='Test');
        insert a;
        Order o = new Order();
        

        //o.pricebook2id = [SELECT id FROM pricebook2 WHERE program__c = :this.participation.framework__r.program__c LIMIT 1].id;
        o.EffectiveDate = Date.today().addDays(1);
        o.Status = 'Draft';  
        safeDMLHandler.safeinsert(o, false);
        
        safeDMLHandler.safeupdate(o, false);
        
        safeDMLHandler.safeupsert(o, false);
        
        safeDMLHandler.safedelete(o, false);
        List<sObject> sObjList = new List<sObject>();
        sObjList.add(o);
        safeDMLHandler.safeinsert(sObjList, false);
        
        safeDMLHandler.safeupdate(sObjList, false);
        
        safeDMLHandler.safeupsert(sObjList, false);
        
        safeDMLHandler.safedelete(sObjList, false);
        o.accountid = a.id;
        safeDMLHandler.safeinsert(o, false);
        
        safeDMLHandler.safeupdate(o, false);
        
        safeDMLHandler.safeupsert(o, false);
        
        safeDMLHandler.safedelete(o, false);
    }
}