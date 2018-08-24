public with sharing class teamController {
    public recordtype rt{get; set;}
    

    public teamController(){
        
        if(ApexPages.currentPage().getParameters().get('type') != null && ApexPages.currentPage().getParameters().get('type') != ''){
            rt= [SELECT Name
                 FROM recordtype
                 WHERE sobjecttype = 'section__c'
                 AND name = :ApexPages.currentPage().getParameters().get('type')
                 LIMIT 1];
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: No Barrier Parameter has been selected!'));
        }
    }

    public section__c[] getteamList(){
        section__c[] team = new section__c[]{};
        if(ApexPages.currentPage().getParameters().get('type') != null && ApexPages.currentPage().getParameters().get('type') != ''){
            team = [SELECT id, Name, page__r.id
                    FROM section__c
                    WHERE page__r.id != ''
                     AND recordtype.name = :ApexPages.currentPage().getParameters().get('type')
                    ORDER by Name
                    LIMIT 20];    
            return team;
        }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: No Records are Available!'));
            return null;
        }
        
   }
}