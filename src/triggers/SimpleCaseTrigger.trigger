trigger SimpleCaseTrigger on Case (after update) {
    // Define connection id 
    Id networkId = ConnectionHelper.getConnectionId('Export-Import Bank of the United States'); 
    System.debug('Networkid = ' + networkId);
    List <Case> sendToExim = New List<Case>();
    List <Contact> currentContact = new List<Contact>();
    List<PartnerNetworkRecordConnection> prncList = new List<PartnerNetworkRecordConnection>();
    for (Case c : Trigger.New){
        //Check to see if contact has opted out of email marketing
        currentContact = [SELECT Name, HasOptedOutOfEmail, Phone FROM Contact WHERE Name = :c.Contact_Name_copy__c];
        if (currentContact.size() > 0) {
            system.debug('Opt value = ' + currentContact[0].HasOptedOutofEmail);
            if (currentContact[0].HasOptedOutofEmail == false) {
                    //Test to that the case has been successfully closed and has not been sent to EXIM Before
                    if (c.ConnectionReceivedId == null && c.ConnectionSentID == null && c.Status == 'Successfully Closed' && c.Record_Type__c == 'Export Promotion'
                       && c.Fee__c != '' && c.Fee__c != 'Administration' && c.Fee__c != 'No Fee-Based Services Used' && c.Fee__c != 'HQ Use Only - Administration'){
                    sendToExim.add(c);
                    System.debug('Case #'+ c.CaseNumber + ' added for ' + c.Contact_Name_copy__c);
                }
                
            }
        }

    }
    
    //Create Connection to send to Exim
    for (Case newCases : sendToExim){
        PartnerNetworkRecordConnection newConnection =
                    new PartnerNetworkRecordConnection(
                        ConnectionId = networkId,
                        LocalRecordId = newCases.Id,
                        SendClosedTasks = false,
                        SendOpenTasks = false,
                        SendEmails = false);
                         

        prncList.add(newConnection);
        
    }
    if (prncList.size() > 0) {
        database.insert(prncList);
    }
    
    
}