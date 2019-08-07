trigger GetContactPhone on Case (before update) {
    List <Contact> currentContact = new List <Contact>();
    //finds contact of the existing case and adds the information to the Copy_Contact_Phone__c field
    for (Case c : Trigger.New){
        if (c.Copy_Contact_Phone__c == null){
            currentContact = [SELECT Name, Phone FROM Contact WHERE Name = :c.Contact_Name_copy__c];
            if (currentContact.size() >0) {
                c.Copy_Contact_Phone__c = currentContact[0].phone;
                System.debug('Current Contact = ' + c.Contact_Name_copy__c + ' ' + c.Copy_Contact_Phone__c);
            }
        }else{System.debug('Case has contact phone');}
    }   
}