//*******************************************************************
//  Author : Daniel Haro
//  Class: CP_scheduled_Upgrade_External_User
//  Version: 1.00 
//  Description: Processes a community users request to have there account upgraded. Updates the user license, user profile 
//               and the users contact record (account association). If The account does not exist one is created.
//               
//  Assumptions: The requesting user is an external community user and has an associated contact record
//*****************************************
//
//NOTES:
//To Start the Class run the following script
//CP_Scheduled_Upgrade_External_User m = new CP_Scheduled_Upgrade_External_User();
//String sch = '0 5 16 ? * * *';
//Where 0 --> sec 5--> minuets 16--> hour (Time of current day to run)
//String jobID = system.schedule('Merge Job', sch, m);
//
//to Stop Job(s) run script
//for(CronTrigger ct:[SELECT Id FROM CronTrigger where state =: 'WAITING']) {
//System.abortJOb(ct.Id);
//}


global class CP_scheduled_Upgrade_External_User implements Schedulable {
    
    private static Id communityTradeUserProfileId {
        get {
            if (communityTradeUserProfileId == null) {
                communityTradeUserProfileId = [SELECT Id FROM Profile 
                                               WHERE Name =: 'Customer Trade Community User' 
                                               LIMIT 1].Id;
            }
            return communityTradeUserProfileId;
        }
        set;
    }
    private static Map<Id,User> usersToUpgradeMap {
        get {
            if (usersToUpgradeMap == null) {
                usersToUpgradeMap = new Map<Id, User>();
                for (User u : [SELECT Id, ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE External_User_Upgrade_Request__c = true AND Profile.Name =: 'MCP-External-User']) {
                    usersToUpgradeMap.put(u.Id, u);
                }
            }
            return usersToUpgradeMap;
        }
        set;
    }
    
    Integer intervalMinutes;
    public CP_Scheduled_Upgrade_External_User() {
        this.intervalMinutes = 5;
    }
    
    global void execute(SchedulableContext SC) {
        // Re-schedule this class to run again in "intervalMinutes" time
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(intervalMinutes);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' +
            nextRunTime.month() + ' ? ' + nextRunTime.year();
        System.schedule(CP_scheduled_Upgrade_External_User.class.getName() + '-' + now.format(), cronString, new CP_scheduled_Upgrade_External_User());

        if (usersToUpgradeMap != null && !usersToUpgradeMap.isEmpty()) {
            upgradeUser();
            accountAction();
        }
    }
    
    @future
    public static void upgradeUser(){
        for(User u : usersToUpgradeMap.Values()){
            u.ProfileId = communityTradeUserProfileId;
        }
        if(usersToUpgradeMap.values().size() > 0){
            Database.update(usersToUpgradeMap.values());
        }
    }
    @future
    public static void accountAction(){
        Map<Id, Contact> contactsToUpdateMap = new Map<Id, Contact>();
        Map<Id,String> contactIdToOrgNameFromLeadMap = new Map<Id,String>();
        Map<String,Id> accountNameToIdMap = new Map<String,Id>();
        List<Account> accountsToCreate = new List <Account>();

        //Create filtered Map for Contacts that need to be updated and List to query lead object!
        for(User u : usersToUpgradeMap.Values()){
            if(u.Contact.Account.Name ==  Label.MCP_ExternalUserAccount){
                contactsToUpdateMap.put(u.ContactId, new Contact(Id = u.ContactId)); //// <---- ????
            }
        }
        //Get Required leads if baseContactMap.keySet List is not empty
        if(contactsToUpdateMap.isEmpty()) return;

        //populate maps
        contactIdToOrgNameFromLeadMap = populateLeadMap(contactsToUpdateMap);
        accountNameToIdMap = populateAccountMap(contactIdToOrgNameFromLeadMap);

        for(Id contactId : contactIdToOrgNameFromLeadMap.keyset()) {
            String currentAccountName = contactIdToOrgNameFromLeadMap.get(contactId);
            if (!accountNameToIdMap.containsKey(currentAccountName)) {
                accountsToCreate.add(new Account(Name = currentAccountName));
            } else {
                contactsToUpdateMap.get(contactId).AccountId = accountNameToIdMap.get(currentAccountName);
            }
        }
        //create new accounts
        if(accountsToCreate != null && !accountsToCreate.isempty()){
            Database.insert(accountsToCreate);
        }
        
        // add new account ids to account tracking Map
        for (account currentAccount : accountsToCreate){
            accountNameToIdMap.put(currentAccount.name,currentAccount.Id);
        }
        //update contact records
        for (id currentContactId : contactIdToOrgNameFromLeadMap.Keyset()){
            //get contact to update
            if(contactsToUpdateMap.containsKey(currentContactId)){
                contactsToUpdateMap.get(currentContactId).AccountId = accountNameToIdMap.get(contactIdToOrgNameFromLeadMap.get(currentContactId));
            }
        }
        //update database
        Database.update(contactsToUpdateMap.values());
    }
    private static Map<Id,String> populateLeadMap (Map<Id, Contact> contactsToUpdateMap) {
        Map<Id,String> returnMap = new Map<Id,String>();
        for (Lead l : [SELECT Id, Registrant__c, Organization_Name__c FROM Lead WHERE Registrant__c in: contactsToUpdateMap.keyset()]) {
            returnMap.put(l.Registrant__c, l.Organization_Name__c);
        }
        return returnMap;
    }
    private static Map<String, Id> populateAccountMap (Map<Id, String> contactIdToOrgNameFromLeadMap) {
        Map<String, Id> returnMap = new Map<String, Id>();
        if (!contactIdToOrgNameFromLeadMap.isEmpty()) {
            for (Account a : [SELECT Id, Name FROM Account WHERE Name IN: contactIdToOrgNameFromLeadMap.values()]) {
                returnMap.put(a.Name, a.Id);
            }
        }
        return returnMap;
    }
}