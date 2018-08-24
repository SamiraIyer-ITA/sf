public class SiteMap_Controller {

public string getXML(){
    return '<?xml version="1.0" encoding="UTF-8"?>';
}

public string domain {get; set;}
public id site {get; set;}

public SiteMap_Controller(){
    this.domain = URL.getSalesforceBaseUrl().getHost();
    this.site = [select id from site__c where domain__c = :this.domain or UseAsDefault__c = true order by domain__c nulls last limit 1].id;
}

public page__c[] getPages(){
    return [select id, lastmodifieddate, clean_url__c, update_frequency__c from page__c where
            site__c = :this.site
           ];
}

}