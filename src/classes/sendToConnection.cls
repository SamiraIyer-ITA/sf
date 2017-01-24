public class sendToConnection{
    public static void shareFY16Records(){
        List <Case> casesToShare = [SELECT Id, CaseNumber, Subject FROM CASE 
									WHERE Record_Type__c = 'Export Promotion' 
									AND Fee__c != '' 
									AND Fee__c != 'No Fee-Based Services Used' 
									AND Fee__c != 'HQ Use Only - Administration'
                                    AND Status = 'Successfully Closed'
                                    AND Contact.HasOptedOutOfEmail = false
                                    AND ClosedDate > 2015-09-30T23:01:01+01:00];
        System.debug('# of Cases to Share = ' + casesToShare.size());
        String connName = 'Export-Import Bank of the United States';
        ID networkID = ConnectionHelper.getConnectionId(connName);
        List<PartnerNetworkRecordConnection> caseConnections =  new  List<PartnerNetworkRecordConnection>();
        
        //Ensures that the list has a value
        if (casesToShare.size() > 0 ) {
            for (Case o: casesToShare){
                PartnerNetworkRecordConnection newConnection = 
                      new PartnerNetworkRecordConnection( 
                          ConnectionId = networkId, 
                          LocalRecordId = o.Id, 
                          SendClosedTasks = false, 
                          SendOpenTasks = false, 
                          SendEmails = false 
                         // ParentRecordId = o.AccountId
                         ); 
                          
                 caseConnections.add(newConnection);  
            }
            
            //Ensure that records were added to send to connection
            if (caseConnections.size() > 0){
                database.insert(caseConnections);
            }
        }
    }
	
}