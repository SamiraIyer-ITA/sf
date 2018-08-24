public without sharing class CaseTriggerHandler {
    
    public static void mainEntry(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap,
        Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isBefore, Boolean isAfter) {
        if (isAfter && isUpdate) {
            
            //Check if any of these cases qualify to be sent to Exim Bank
            sendToEximBank(newList); 
            updateAssets(newList);
        }   
    }

    private static void updateAssets(list<Case> caseList){
        set<id> OrderIds = new set<id>();
        set<id> AccountIds = new set<id>();
        set<id> MakeAssets = new set<id>();
        set<id> DeniedOrders = new set<id>();
        for(case c : caseList){
            if(c.order__c != null && (c.status == 'Successfully Closed' || c.status == 'Denied')){
                if(c.status == 'Denied'){
                    DeniedOrders.add(c.order__c);
                }
                OrderIds.add(c.order__c);
            }
            if(c.accountId != null){
                AccountIds.add(c.accountid);
            }
        }
        list<asset> toUpsert = new list<asset>();
        list<third_party__c> ThirdParties = new list<third_party__c>();
        set<Third_Party__c> ThirdPartiesToUpdate = new set<third_party__c>();
        list<Asset> assets = [select id, status, product2id, accountid, installdate, usageenddate, price, (select id, name, Third_Party_Master_List__c from third_parties__r) from Asset where AccountId = :AccountIds ];
        list<OrderItem> lineItems = [select id, PricebookEntry.Product2Id, order.accountid, unitprice, (select id, name, Third_Party_Master_List__c from third_parties__r) from orderitem where orderid in :OrderIds];
        set<id> AlreadyExistsTP = new set<id>();
        set<id> AlreadyExistsUpsert = new set<id>();

        for(OrderItem oli : lineItems){
            //loop throug the list of assets
            for(Asset asset : assets){
                //if the asset matches the current account for the order, and the product matches
                    //update the price
                for(OrderItem item : lineItems){
                    if(item.pricebookentry.product2Id == asset.product2Id){
                        asset.price = item.unitPrice;
                        asset.usageEndDate = Date.today().addDays(365);
                        break;
                    }
                }
                    //update the usage end date
                if(asset.installDate == null){
                    asset.installDate = Date.today();
                }
                    //if the status is not 'inactive' or 'active', mark it as 'purchased'
                    //set the contact to the same contact that created the order
                if(asset.accountId == oli.order.accountid && asset.product2id == oli.pricebookentry.product2id){
                    if(DeniedOrders.contains(oli.orderid)){
                        asset.Status = 'Denied';
                        asset.usageEndDate = Date.today();
                    }else{
                        asset.Status = 'Active';
                    }
                }
                
                if(!AlreadyExistsUpsert.contains(asset.id)){
                    toUpsert.add(asset);
                    AlreadyExistsUpsert.add(asset.id);
                    
                }             
                for(third_party__c atp: asset.third_parties__r){
                    AlreadyExistsTP.add(atp.third_party_master_list__c);
                }
            
                for(third_party__c otp : oli.third_parties__r){
                    if(!AlreadyExistsTP.contains(otp.third_party_master_List__c)){
                        AlreadyExistsTP.add(otp.third_party_master_list__c);
                        otp.asset__c = asset.id;
                        ThirdPartiesToUpdate.add(otp);
                    }
                }
            }
        }
        
        for(third_party__c tp : ThirdPartiesToUpdate){
            ThirdParties.add(tp);
        }
        
        database.update(toUpsert);
        database.update(ThirdParties);
    }
    
    private static void sendToEximBank(List<Case> caseList) {
        Id networkId = PartnerConnectionHelper.getInstance().getConnectionId('Export-Import Bank of the United States'); 
        System.debug('Networkid = ' + networkId);
        List<PartnerNetworkRecordConnection> prncList = new List<PartnerNetworkRecordConnection>();
       
        if (networkId != null) {  
            for (Case c: caseList) {
                if (c.ConnectionReceivedId == null
                    && c.Status == 'Successfully Closed'
                    && c.Record_Type__c == 'Export Promotion'
                    && c.Fee__c != ''
                    && c.Fee__c != 'Administration'
                    && c.Fee__c != 'No Fee-Based Services Used'
                    && c.Fee__c != 'HQ Use Only - Administration'
                    && c.Contact_Email_Opt_Out__c == false) {
                        
                    //This case should be sent to Exim Bank
                    PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection(
                                                                    ConnectionId = networkId,
                                                                    LocalRecordId = c.Id,
                                                                    SendClosedTasks = false,
                                                                    SendOpenTasks = false,
                                                                    SendEmails = false);
                    prncList.add(newConnection);
                }
            }
                
            if (prncList.size() > 0) {
                database.insert(prncList);
            }
        }
            
    } 
}