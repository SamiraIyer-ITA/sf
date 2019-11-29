public without sharing class MCP_NonSharingUtilityClass {
    
    public static list<Recordtype> contactRecordTypes = new list<Recordtype>();

    
    public static id getContactRecordType(){
       
        return (Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ITA Contacts').getRecordTypeId()); 

    }
    
    public static void upsertLeadRecord(Lead newUserLead){
        if(newUserLead != null){
        database.upsert(newUserLead);
        }
        
    }
    
    Public static Contact getNewContact(String email, ID accountId){
        list<Contact> ContactList = new list<Contact>();
        ContactList = [select id,AccountId from Contact where email =: email and AccountId =: accountId];
        return ContactList[0];
    }
    
    public static List<account> getMCPExternalUserAccount(){
        list<account> accountList = new list<account>();
        accountList = [select id from account where name =: label.MCP_ExternalUserAccount];
        if(accountList != null && accountList.size() > 0){
            return accountList;
        }
        else{
            return null;
        }
    }
    
    public static void insertContactRecords(list<contact> contactList){
        database.upsert(contactList);
    }
    
    //replacing OTB functionaility in order to send back the user a friendlier message
    public static boolean validateUserName(String userName){
        list<User> vaildateList = new list<User>();
        if(vaildateList.isempty()){
            system.debug('run querry !! on '  + userName );
            vaildateList = [select id from user where email =: userName];
                        system.debug('run querry !!' + vaildateList);

            if(vaildateList.isEmpty()){
                return true;
            }
        }
        return false; 
    }
}