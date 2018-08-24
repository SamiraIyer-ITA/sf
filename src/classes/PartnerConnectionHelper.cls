/*
* This class was inspired from here:  https://developer.salesforce.com/page/Best_Practices_for_Salesforce_to_Salesforce
*/

public class PartnerConnectionHelper {
	    
    private static PartnerConnectionHelper instance;
    
    private PartnerConnectionHelper() {}  //Don't allow this class to be instantiated publicly
    
    public static PartnerConnectionHelper getInstance() {
    	if (instance == null) {
    		instance = new PartnerConnectionHelper();
    	}
    	return instance;
    }
    
    private Map<String, PartnerNetworkConnection> partnerNetConMap;
    
    /*
    	If the list of Partner Network Connections changes, this method can be called to refresh the list in this object
   	  	The return value indicates whether the list was refreshed.
    */
    public boolean refreshConnectionList() {
    	List<PartnerNetworkConnection> pncs =
            [SELECT id, connectionStatus, connectionName FROM PartnerNetworkConnection WHERE connectionStatus = 'Accepted'];
        System.debug('Partner Network Connection List: ' + pncs);
        for (PartnerNetworkConnection pnc: pncs) {
        	partnerNetConMap.put(pnc.ConnectionName, pnc);
        }
        if (pncs.isEmpty()) {
        	return false;
        } else {
        	return true;
        }
    }
    
    public Id getConnectionId(String connectionName) {
    	if (partnerNetConMap == null) {
    		partnerNetConMap = new Map<String, PartnerNetworkConnection>();
    	}
    	if (partnerNetConMap.isEmpty()) {
    		refreshConnectionList();
    	}
    	PartnerNetworkConnection pnc = partnerNetConMap.get(connectionName);
    	System.debug(partnerNetConMap.get(connectionName).connectionStatus + ': '+ partnerNetConMap.get(connectionName).connectionName);
    	if (pnc != null) {
    		return pnc.id;
    	}
    	return null;
    }
}