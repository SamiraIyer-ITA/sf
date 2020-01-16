//*******************************************************************
//  Author : Daniel Haro
//  Class: CP_TransitionController
//  Version: 1.00 
//  Description: Update the External_User_Upgrade_Request__c flag on the user record when a user request to upgrade there account.
//  Assumptions: The requesting user is an external community user
//*****************************************
public class CP_TransitionController {
    
    public String errorMessage{get;set;}
    
    public CP_TransitionController(){}
    
    public PageReference upgeadeAccount(){
        PageReference redirectOnSuccess;
        String userId =   UserInfo.getUserId();
        list<User> userList = new list<User>();
        list<Profile> profiles = new list<Profile>();
        User currentUser = new User();
        profiles = [SELECT id from profile where name = 'MCP-External-User' limit 1];
        if(profiles.isempty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'System error: Unable to locate required system profile'));
            //ApexPages.addMessage(myMsg);
            return null;
        }
        userList = [SELECT id, profileId FROM user WHERE id =: UserInfo.getUserId() limit 1];
        if(userList != null && !userList.isEmpty()){
            system.debug('user list not empty');
            if(userlist[0].id == UserInfo.getUserId() && userlist[0].profileId == profiles[0].id){
                system.debug('profiles match');
                currentUser.External_User_Upgrade_Request__c = true;
                database.update(currentUser);
                return new PageReference(label.CP_ContactUsRedirectURL);
            }
        }
       
            system.debug('bogus account!');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your account is not eligible for this upgrade'));
        return null;
    } //oncomplete="navigate();"
}