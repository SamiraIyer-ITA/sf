public with sharing class ApplicationsPageController {
    public List<Participation__c> applications {get;set;}
    public ApplicationsPageController() {
     applications = [SELECT Name,Form_Application_Link__c,Program__r.Name,Most_Recent_Case__r.Status from Participation__c where OwnerId =: UserInfo.getUserId() order by Program__r.Name asc,Name asc];
    }
}