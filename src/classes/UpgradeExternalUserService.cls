public without sharing class UpgradeExternalUserService implements Queueable{
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
    
    // Run Job as Queabale attemp to bypass security // profile issues
    public void execute(QueueableContext context) {
        //list<user> userList = new list<User>();
        user extUserRec;
        extUserRec = [select id,Username,Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,contactId,TimeZoneSidKey,usertype
                      from user where id =: userInfo.getUserId()];
       
      //contct information (causing issues)  
        // Contact oldContact = [select Id,AccountId from Contact where id =: extUserRec.contactId];
        Contact newContact = new Contact();
        newcontact = [select id from contact where isClone__C =: true and Email =: extUserRec.email limit 1];
        system.debug('contact results : ' + newcontact);
        user currentUser = new User();
        currentUser.Id = Userinfo.getUserId();
        user newUser = new User();
        newUser =  extUserRec.clone(false, true, false, false);
        newUser.Username = extUserRec.Username + 'CCL';
        newUser.contactId = newcontact.Id;
        newUser.ProfileId = communityTradeUserProfileId;
        
        extUserRec.IsActive = false;
        // update extUserRec;
        // update new user (id = extUserRec.Id, isActive = false);
        system.debug('User to update info' + extUserRec);
        insert newUser;   //return 'Error with no excption?';
    }
    
    public static string upgradeToCustomerLicense(User u) {
        try{
            //list<user> userList = new list<User>();
            user extUserRec;
            extUserRec = [select id,Username,Alias,Email,EmailEncodingKey,LastName,LanguageLocaleKey,LocaleSidKey,contactId,TimeZoneSidKey,usertype
                          from user where id =: userInfo.getUserId()];
            system.debug('User Date ' + 	extUserRec.ContactId);
            Contact oldContact = [select Id,AccountId from Contact where id =: extUserRec.contactId];
            Contact newContact = new Contact();
            newcontact = [select id from contact where isClone__C =: true and Email =: extUserRec.email limit 1];
            system.debug('contact results : ' + newcontact);
            user currentUser = new User();
            currentUser.Id = Userinfo.getUserId();
            user newUser = new User();
            newUser =  extUserRec.clone(false, true, false, false);
            newUser.Username = extUserRec + 'CCl';
            newUser.contactId = newcontact.Id;
            newUser.ProfileId = communityTradeUserProfileId;
            newUser.ProfileId = oldContact.AccountId;
            system.debug('new user info :' + newUser);
            extUserRec.IsActive = false;
            // update extUserRec;
            // update new user (id = extUserRec.Id, isActive = false);
            system.debug('User to update info' + extUserRec);
            insert newUser;   //return 'Error with no excption?';
            return 'Error with no excption?';
        }
        catch(exception e){
            return e.getMessage();
        }
    }
    
    public static void upgradeToCustomerLicense2(User u) {
        u.ProfileId = communityTradeUserProfileId;
        update u;
    }
}