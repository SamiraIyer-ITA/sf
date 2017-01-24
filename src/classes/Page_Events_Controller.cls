Public Class Page_Events_Controller{
    public page__c[] newList {get; set;}
    
    public Page_Events_Controller(Page__c[] newList){
        this.newList = newList;
    }

    public void createCleanURL(){
        for(Page__c page : this.newList){
            if(page.clean_url__c != null){
                page.clean_url__c = page.clean_url__c.replaceAll(' ', '-');  //replace all spaces with an underscore
                page.clean_url__c = page.clean_url__c.replaceAll('[^A-Za-z0-9_/-]', '');  //replace all non-numeric, non-forward-slash, and non-underscore with an empty space.
            }
            if(page.clean_url__c == null){
                page.clean_url__c = page.name.replaceAll(' ', '-');  //replace all spaces with an underscore
                page.clean_url__c = page.clean_url__c.replaceAll('[^A-Za-z0-9_/-]', '');  //replace all non-numeric, non-forward-slash, and non-underscore with an empty space.
            }
            if(!page.clean_url__c.startsWith('/')){
                page.clean_url__c = '/'+page.clean_url__c;
            }
        }
    }
    
    public void checkExisting(){
        String[] friendlys = new String[]{};
        for(Page__c page : this.newList){
            friendlys.add(page.clean_url__c);
        }
        URL__c[] urlsToInsert = new URL__c[]{};
        Clean_URL__c[] cleanURLsToInsert = new Clean_URL__c[]{};
        for(Page__c page : this.newList){
            boolean exists = false;
            for(URL__c url : [select id, friendly__c, page__c, (select id, site__c, page__c from clean_urls__r) from URL__c where friendly__c = :friendlys]){
                if(url.friendly__c == page.clean_url__c){
                    exists = true;
                    boolean existsClean = false;
                    for(clean_url__c clean : url.clean_urls__r){
                        if(clean.site__c == page.site__c && page.site__c != null){
                            existsClean = true;
                            if(page.id != clean.page__c){
                                page.clean_url__c.addError('A Clean URL already exists for another page on this site with this Nickname.');
                            }
                            break;
                        }
                    }
                    if(!existsClean && page.site__c != null){
                        cleanURLsToInsert.add(new Clean_URL__c(site__c = page.site__c, url__c = url.id, page__c = page.id));
                    }else{
                        if(page.id != url.page__c && page.site__c == null)
                            page.clean_url__c.addError('A Clean URL already exists for another page on this site with this Nickname.');
                    }
                    break;
                }
            }
            if(!exists){
                if(page.site__c != null){
                    urlsToInsert.add(new URL__c(friendly__c = page.clean_url__c));
                }else{
                    urlsToInsert.add(new URL__c(friendly__c = page.clean_url__c, page__c = page.id));
                }
            }
        }
        insert urlsToInsert;
        for(Page__c page: this.newList){
            for(URL__c url : urlsToInsert){
                if(page.site__c != null){
                    cleanURLsToInsert.add(new Clean_URL__c(site__c = page.site__c, url__c = url.id, page__c = page.id));
                }
            }
        }
        insert cleanURLsToInsert;
    }
}