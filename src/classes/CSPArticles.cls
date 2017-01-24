global class CSPArticles implements Database.Batchable<sObject>{
    global final String Query;
    
    global CSPArticles(string obj){
        query = 'select id, IsVisibleInCsp, knowledgearticleid from '+obj+' where publishStatus = \'Draft\' and language=\'en_US\' limit 10000';
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        SObject[] toUpdate = new sObject[]{};
        for(sObject art : scope){
            art.put('isVisibleInCsp', true);
            art.put('level_0__c', 'Country Commercial Guide');
            toUpdate.add(art);
        }
        update toUpdate;
    }

    global void finish(Database.BatchableContext BC){
        //used later if we want to send a completion email
    }
}