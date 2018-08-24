public class UserTriggerHelper {
    public static void UpdateEmailAndFederationId(List<User> usr)
    {
        for(User u : usr)
        {
            if(u.AD_User_Id__c!= null && u.AD_User_Id__c != '') {
                if (u.Email != u.AD_User_Id__c)
                    u.Email = u.AD_User_Id__c;
                if(u.FederationIdentifier != u.AD_User_Id__c)
                    u.FederationIdentifier = u.AD_User_Id__c;
            }
        }
    }

   public static void preventADProcessTZUpdate(List<User> newUsr, map<Id, User> oldUserMap)
   {
      if(Userinfo.getUserName().startsWith('integrationuser')) {
        for(User usr : newUsr) { 
            if(oldUserMap.get(usr.id).TimeZoneSidKey != usr.TimeZoneSidKey)
            {
                usr.TimeZoneSidKey = oldUserMap.get(usr.id).TimeZoneSidKey;
            }
        }
      }
   }
    
    public static void PreventReadOnlyUpdate(List<User> newUsr, map<Id, User> oldUserMap) 
    {
        Profile prf = [Select id from Profile where name = 'ITA User Read Only'];
        for(User usr : newUsr) { 
            if(oldUserMap.get(usr.id).ProfileId != prf.id && usr.ProfileId == prf.id)
            {
                usr.ProfileId = oldUserMap.get(usr.id).ProfileId;
            }
        }
    }
    
    Public static void SetActiveFlag(List<User> newUsr, map<Id, User> oldUserMap) 
    {
        for(User usr : newUsr) {
            if(usr.Updated_by_Last_AD_Run__c == true && (oldUserMap.get(usr.id).IsActive == true) && usr.IsActive == false) {
                usr.Updated_by_Last_AD_Run__c = false;
                usr.IsActive = true;
            }
        }
    }
    
    Public static void SendInstructions(List<User> newUsr, map<Id, User> oldUserMap) 
    {
        Profile prf = [Select id from Profile where name = 'ITA User Read Only'];
        for(User usr : newUsr) {
            if(usr.ProfileId != prf.id && oldUserMap.get(usr.id).ProfileId == prf.Id && usr.isActive == true) {
                usr.OutlookInstructionsSent__c = true;
            }
        }
    }
}