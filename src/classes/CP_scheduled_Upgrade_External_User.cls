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
    
    Integer intervalMinutes;
    public CP_scheduled_Upgrade_External_User() {
        this.intervalMinutes = 5;
    }
    
    
    global void execute(SchedulableContext SC) {
         // Re-schedule ourself to run again in "intervalMinutes" time
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(intervalMinutes);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' +
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' +
            nextRunTime.month() + ' ? ' + nextRunTime.year();
        System.schedule(CP_scheduled_Upgrade_External_User.class.getName() + '-' + now.format(), cronString, new CP_scheduled_Upgrade_External_User());
        // Abort the current job
        Id jobId = sc.getTriggerId();
        //System.abortJob(jobId);   
        upgradeUser();
        // Launch a batch job or call a future method to do the actual work
       // Database.executeBatch(new SomeBatchJob());
    }
    
    @future
    private static void upgradeUser(){
        list<user> usersList = new list<User>();
        if(usersList == null || usersList.isEmpty()){
            usersList = [select id from user where External_User_Upgrade_Request__c = true AND Profile.name =: 'MCP-External-User'];
        }
        for(user currentUser : usersList){
            currentUser.ProfileId = communityTradeUserProfileId;
        }
        if(usersList.size() > 0){
            database.update(usersList);
        }
    }
    
}