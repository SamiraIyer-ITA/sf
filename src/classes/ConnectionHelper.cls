public class ConnectionHelper {

    public static Id getConnectionId(String connectionName) {
    
        List<PartnerNetworkConnection> partnerNetConList =
          	//[Select id, connectionStatus, connectionName from PartnerNetworkConnection where connectionName = :connectionName];
            [Select id, connectionStatus, connectionName from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
        System.debug('Number of Connections Retrieved = ' + partnerNetConList.size());
        if ( partnerNetConList.size() != 0 ) {
            System.debug(partnerNetConList.get(0).connectionStatus + ': '+ partnerNetConList.get(0).connectionName);
            System.debug(partnerNetConList);
            return partnerNetConList.get(0).Id;
        }
        
        return null;
    }
    
    
    public static Id getConnectionOwnerId(String connectionName) {
    
        List<PartnerNetworkConnection> partnerNetConList = 
          [Select createdById from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
        
        if ( partnerNetConList.size() != 0 ) {
            return partnerNetConList.get(0).createdById;
        }
        
        return null;
    }
}