global class PublishArticles implements Database.Batchable<sObject>{
    global final String Query;
    
    global PublishArticles(string obj){
        query = 'select id, IsVisibleInCsp, knowledgearticleid from '+obj+' where publishStatus = \'Draft\' and language=\'en_US\' and IsVisibleInCsp = true limit 10000';        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject art : scope){
            try{
                KbManagement.PublishingService.publishArticle(string.valueOf(art.get('knowledgearticleid')), false);
            }catch(Exception e){
                system.debug(string.valueOf(art.get('knowledgearticleid')));
                system.debug(e);
            }
        }
    }

    global void finish(Database.BatchableContext BC){
        //used later if we want to send a completion email
    }
}