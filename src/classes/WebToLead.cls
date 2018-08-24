public class WebToLead {

public Lead lead {get; set;}

public String site {get; set;}

public string getSiteName(){
    String strurl = ApexPages.currentPage().getUrl();
    if(strurl.contains('apex/')){
        strurl = strurl.split('apex/')[1];
    }
    return strurl;
}
public WebToLead(){
    this.lead = new Lead(campaign_id__c = WebToLead__c.getAll().get(getSiteName()).CampaignId__c, Source_Detail__c = 'Web To Lead - Launch');
    this.site = getSiteName();
}

public pageReference Submit(){
    PageReference output = new PageReference(WebToLead__c.getAll().get(this.site) != null ? WebToLead__c.getAll().get(this.site).return_url__c : '/welcome');
    try{
        upsert lead;
    }Catch(Exception e){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
    }
    output.setRedirect(true);
    return output;
}

}