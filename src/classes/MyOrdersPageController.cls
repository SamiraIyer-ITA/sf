public class MyOrdersPageController {

private User user {get; set;}


public map<id, list<order>> OrderMap {get; set;}
public map<id, participant__c> ParticipantMap {get; set;}
public list<Participant__c> participations {get; set;}
public list<Order> Orders {get; set;}

public MyOrdersPageController(){
    this.ParticipantMap  = new map<id, Participant__c>();
    this.Orders = new list<Order>();

    Id userId = UserInfo.getUserId();
    this.user = [SELECT id, contactid, contact.accountid FROM User WHERE id = :userId LIMIT 1];
    if(this.user.contactId != null){
        this.participations = [select id, name
         from Participant__c where Participant__r.Organization__c = :this.user.contact.accountId]; 
         if(this.participations.size() == 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Your organization has not applied to any Frameworks yet.'));
         }else{
             for(Participant__c participant : this.participations){
                 this.ParticipantMap.put(participant.id, participant);
             }
             this.orders = [select 
                            id, ordernumber, TotalAmount, status, effectivedate, participation__c, accountid, createddate,
                            (select id, Pricebookentry.Product2.Name from orderitems),
                            (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c 
                             FROM Payments__r)
                             from order where Participation__c = :this.participantMap.keySet() order by createddate desc];             
         }     
    }else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'You must be logged in as a Community User to see MyOrders.'));
    }
}
}