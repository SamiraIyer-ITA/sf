@RestResource(urlMapping='/content/*')
Global with sharing class REST_CONTENT{
    @HTTPGet
    Global static void get(){
        RestResponse response = RestContext.Response; 
        response.headers.put('Content-Type', 'application/javascript');
        if(RestContext.request.params.get('since') != null && RestContext.request.params.get('site') != null){
            try{
                Long timestamp = Long.valueOf(RestContext.request.params.get('since'));
                DateTime dt = DateTime.newInstance(timestamp);
                string domain = string.valueOf(RestContext.request.params.get('site'));
    
                response.responseBody = Blob.valueOf(JSON.serialize(getPages(domain, dt)));
                response.statusCode = 200;
            }catch(Exception e){
                response.statusCode = 500;
                response.responseBody = blob.valueOf(e.getMessage());
            }
        }else if(RestContext.request.params.get('site') == null){
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('Site Domain is required.');
        }else if(RestContext.request.params.get('since') == null){
            response.statusCode = 400;
            response.responseBody = blob.valueOf('A Timestamp is required.');
        }
    }

    Global class Content{
        global string title {get; set;}
        global string url {get; set;}
        global string description {get; set;}
        global string content {get; set;}
    }

    @TestVisible private static Content[] getPages(string domain, datetime since){
        Content[] output = new Content[]{};
        Site__c site = [select id from Site__c where domain__c = :domain or UseAsDefault__c = true order by UseAsDefault__c asc limit 1];
    
        Id[] pages = new Id[]{};
        for(Page_Content__c pg : [select id, page__c from Page_Content__c
                                      where page__r.site__c = :site.id and content__r.LastModifiedDate >= :since and content__r.recordType.name = 'Generic Content'
                                      order by sortorder__c asc nulls first]){
            pages.add(pg.page__c);
        }    
    
        Page_Content__c[] elements = [select 
                                        id, Display_Content_Name__c, display_title__c, Header__c, page__c,
                                        page__r.clean_url__c, page__r.page_title__c, page__r.name, page__r.description__c,
                                        content__r.content__c
                                      from Page_Content__c
                                      where page__c in :pages order by row__r.sort_order__c asc nulls first, sortorder__c asc nulls first];
    
        map<string, Content> contentMap = new map<string, Content>();  //map of the url against 
        for(Page_Content__c element : elements){
            string key = null;
            key = element.page__r.clean_url__c; //set the key to the page url
            /*if(element.page__r.clean_url__c != null){
                key = element.page__r.clean_url__c; //if the page has a clean url, use that as the index
            }else{
                key = element.page__c; //otherwise, use the page id
            }*/
            if(key != null){
                if(contentMap.get(key) == null){
                    contentMap.put(key, new Content());
                        contentMap.get(key).title = (element.page__r.page_title__c != null) ? element.page__r.page_title__c : element.page__r.name; 
                        contentMap.get(key).url = (element.page__r.clean_url__c != null) ? element.page__r.clean_url__c : '/page?id='+element.page__c; 
                        contentMap.get(key).description = element.page__r.description__c;
                        contentMap.get(key).content = '';
                }
                if(element.display_Content_Name__c == true){
                    contentMap.get(key).content += '<h1>'+((element.Header__c != null)?element.Header__c:element.display_title__c)+'</h1>';
                }
                if(element.content__c != null && element.content__r.content__c != null)
                    contentMap.get(key).content += element.content__r.content__c;
            }
        }
        for(string key :contentMap.keySet()){
            output.add(contentMap.get(key));
        }
        return output;
    }
}