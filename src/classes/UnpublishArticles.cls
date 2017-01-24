global class UnpublishArticles implements Database.Batchable<sObject>{
    global final String Query;
    
    global unPublishArticles(string obj){
        query = 'select id, IsVisibleInCsp, knowledgearticleid from '+obj+' where publishStatus = \'Online\' and level_0__c = NULL and language=\'en_US\' limit 10000';        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject article : scope){
            Id artId = string.valueOf(article.get('KnowledgeArticleId'));
            try{
                KbManagement.PublishingService.editOnlineArticle(artId, true);
            }catch(Exception e){
                system.debug(artId);
                system.debug(e);
            }
        }
    }

    global void finish(Database.BatchableContext BC){
        //used later if we want to send a completion email
    }
}