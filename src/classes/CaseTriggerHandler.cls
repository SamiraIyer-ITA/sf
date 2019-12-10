public without sharing class CaseTriggerHandler {
    
    public static void mainEntry(List<Case> newList, List<Case> oldList, Map<Id, Case> newMap, Map<Id, Case> oldMap,
        Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isBefore, Boolean isAfter) {
        
        if (isAfter && (isInsert || isUpdate)) {
            //call methods
            
           deleteandinsertHTSrecord(newList);
        }
        
        if (isAfter && isUpdate) {
            
            //Check if any of these cases qualify to be sent to Exim Bank
            sendToEximBank(newList); 
            updateAssets(newList);
        }   
    }
    
    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/
    //job methods go here
    
    public  static String HTS_REG_EX = '((?m)(\\d{4}\\.)((\\d{2}|\\d{4})(\\.?\\d{2}|\\d{4})*))';
    
    // Method is set to delete and insert the related list HTS Object 
    public static void deleteandinsertHTSrecord(List<Case> newCommList) {
        
        set<Id> commids = new set<id>();
        
        
        for(Case obj : newCommList){
        
            commids.add(obj.Id);
            
        }
        
        List<Harmonized_Tariff_Schedule__c> listcheck = new List<Harmonized_Tariff_Schedule__c>();
        
        listcheck = [SELECT Id FROM Harmonized_Tariff_Schedule__c WHERE Case__c IN: commids];
        
        if(!listcheck.isEmpty()){
            delete listcheck;
        } 
        
        List <Harmonized_Tariff_Schedule__c> objnewList = new List <Harmonized_Tariff_Schedule__c>();
        
        for(Case obj : newCommList){
        
            if(obj.HTS_Comments__c != null && obj.HTS_Comments__c !=''){
                List<String> htsNumList = getHTSNumber(obj.HTS_Comments__c);
                Map<String, String> htsNumMap = getHTSNumMap(htsNumList);
                if(obj.Commercial_Diplomacy_Triage__c != null){
                    objnewList.addAll(createHTSRecords(obj.Commercial_Diplomacy_Triage__c,obj.Id,htsNumMap));
                } else {
                    objnewList.addAll(createHTSRecords(null,obj.Id,htsNumMap));
                }
                
            }
            
        }
        
        if(!objnewList.isEmpty()){
            insert objnewList;
        }
    
    }
    
    /**************************************
    * Helper Methods
    **************************************/
    //helper methods here
    
    
    /* This method matches the HTS number pattern and returns a list of valid HTS numbers with decimals */
    public static List<String> getHTSNumber(String attachmentBody){  
        List<String> htsNumListWithDecimals =new List<string>();
        Pattern htsRegExPattern = Pattern.compile(HTS_REG_EX);
        Matcher htsNumMatcher = htsRegExPattern.matcher(attachmentBody);
        While (htsNumMatcher.find()){
            If (htsNumMatcher.groupCount() != 0){
                htsNumListWithDecimals.add(htsNumMatcher.group());
            }
        } 

        return htsNumListWithDecimals;
    }
    
    
    /* This method returns a map of HTS Numbers with Decimals as key set and its corresponding HTS number value without decimals */
    public static Map<String, String> getHTSNumMap(List<String> htsNumListWithDecimals){
        Map<String,String> htsNumMap = new Map<String, String>();
        For (Integer i=0; i<htsNumListWithDecimals.size(); i++){
            String strWithDecimals = htsNumListWithDecimals.get(i);
            String strWithoutDecimals = strWithDecimals.replaceAll('\\.', '').trim();
            htsNumMap.put(strWithDecimals, strWithoutDecimals);
        }

        return htsNumMap;
    } 
    
    /* This method inserts HTS records for the corresponding parentId  */
    public static List <Harmonized_Tariff_Schedule__c> createHTSRecords (Id recordId,Id CaseId,Map<string,string> htsNumMap){
        List <Harmonized_Tariff_Schedule__c> toInsert = new List<Harmonized_Tariff_Schedule__c>();
        for(string hts:htsNumMap.keyset()){
            Harmonized_Tariff_Schedule__c htsRecord = new Harmonized_Tariff_Schedule__c (name = hts, HTS_Number__c = htsNumMap.get(hts));
            if(CaseId != null){
                htsRecord.Case__c=CaseId;
            }
            
            if(recordId != null){
                htsRecord.Commercial_Diplomacy_Triage__c=recordId;
            }
            
            toInsert.add(htsRecord);
            
        }
        
        return toInsert;
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