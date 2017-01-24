public class Landing_Controller{
public pagereference redirect(){
    Site__c site = [select default_page__c, default_page__r.clean_url__c, VisualForce_Redirect__c from site__c where domain__c = :URL.getSalesforceBaseUrl().getHost() or UseAsDefault__c = true order by UseAsDefault__c asc limit 1];
    if(site.VisualForce_Redirect__c != null){
        PageReference pg = new PageReference('/'+site.VisualForce_Redirect__c);
        pg.setRedirect(true);
        return pg;    
    }
    if(site.default_page__c != null){
        if(site.default_page__r.clean_url__c != null){
            PageReference pg = new PageReference(site.default_page__r.clean_url__c);
            pg.setRedirect(false);
            return pg;
        }else{
            PageReference pg = Page.page;
            pg.getParameters().put('id', site.default_page__c);
            pg.setRedirect(false);
            return pg;
        }
    }
    return null;
}
}