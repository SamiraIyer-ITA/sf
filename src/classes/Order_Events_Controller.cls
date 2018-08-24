Public With Sharing Class Order_Events_Controller{
    public Order[] newList {get; set;}
    public Id[] OrderIds {get; set;}
    public map<id, order> newMap {get; set;}
    public map<id, order> oldMap {get; set;}
    public Set<Id> newlyPaidOrders {get; set;}  //Populated in updateAssets()
    public Set<Id> updatedAssets {get; set;}  //Populated in updateAssets()

    public Order_Events_Controller(Order[] newList, map<id, order> oldMap, map<id, order> newMap){
        this.OrderIds = new Id[]{};
        this.newList = newList;
        this.newMap = newMap;
        this.oldMap = oldMap;
        for(Order order : this.newList){
            if(order.id != null)
                this.OrderIds.add(order.id);
        }
    }
    
    public void updateAssets(){
        map<id, id> ProductToFramework = new map<id, id>();
        newlyPaidOrders = new Set<Id>();
        updatedAssets = new Set<Id>();
        set<Id> accounts = new set<Id>();
        set<id> exists = new set<id>();
        Asset[] toUpsert = new Asset[]{};
        //get the list of IDs for Contacts for Orders
        map<id, id> UserToContact = new map<id, id>();  //a map of User Id to its related Contact
        //get a list of all orders that have have just been marked as 'Paid'
        for(Order order : this.newList){
            if(order.Status == 'Paid' && oldMap.get(order.id).status != 'Paid'){
                accounts.add(order.accountid);
                UserToContact.put(order.createdbyid, null);
                newlyPaidOrders.add(order.id);
            }
        }
        
        for(User u : [select id, contactid from user where id in :UserToContact.keySet()]){
            if(u.contactId != null){
                UserToContact.put(u.id, u.contactId);
            }
        }
        for(Framework__c framework : [select id, product__c from framework__c where isActive__c = true]){
            ProductToFramework.put(framework.product__c, framework.id);
        }

        Asset[] assets = [select id, status, quantity, price, product2id, purchasedate, participant__c, UsageEndDate, accountid, hr_data__c, non_hr_data__c, Confirm_HR_Compliance__c from Asset where AccountId = :accounts ];
        OrderItem[] lineItems = [select id, order.program__c, PricebookEntry.Product2Id, pricebookentry.product2.name, unitprice, hr_data__c, non_hr_data__c, Confirm_HR_Compliance__c, order.accountid, order.participant__c, order.createdById from orderitem where orderid in :this.OrderIds];
        List<Third_Party__c> ThirdParties = new list<Third_Party__c>();
        
        for(OrderItem oli : lineItems){
            //loop throug the list of assets
            for(Asset asset : assets){
                //if the asset matches the current account for the order, and the product matches
                    //update the price
                    //update the usage end date
                    //if the status is not 'inactive' or 'active', mark it as 'purchased'
                    //set the contact to the same contact that created the order
                if(asset.accountId == oli.order.accountid && asset.product2id == oli.pricebookentry.product2id){
                    exists.add(oli.id);
                    asset.price = oli.unitPrice;
                    asset.participant__c = oli.order.participant__c;
                    asset.program__c = oli.order.program__c;
                    asset.quantity = 1;
                    asset.hr_data__c = oli.hr_data__c;
                    asset.non_hr_data__c = oli.non_hr_data__c;
                    if(ProductToFramework.get(oli.pricebookentry.product2Id) != null){
                            asset.framework__c = ProductToFramework.get(oli.PricebookEntry.product2Id);
                        }
                    asset.Confirm_HR_Compliance__c = oli.Confirm_HR_Compliance__c;
                    if(asset.status != 'Active' && asset.status != 'Inactive'){
                        asset.Status = 'Purchased';
                        asset.UsageEndDate = date.today().addDays(365);
                    }
                    asset.ContactId = UserToContact.get(oli.order.CreatedById);
                    toUpsert.add(asset);
                    updatedAssets.add(asset.id);
                }
            }
        }
        
        if(accounts.size() != 0)
        for(OrderItem oli : lineItems){
            //if the order item was not already processed
            if(!exists.contains(oli.id)){
                if(accounts.contains(oli.order.accountId)){
                    //Create a new Assset
                        //Assign it to the current account for the order item, set the price, purchase date, 
                        //instal date, participation__c record, and a status of 'Purchased' with a usage end date of +365 Today()
                    Asset asset = new Asset();
                        asset.accountId = oli.order.accountid;
                        asset.name = oli.pricebookentry.product2.name;
                        asset.product2id = oli.pricebookentry.product2id; 
                        asset.price = oli.unitprice;
                        asset.program__c = oli.order.program__c;
                        asset.purchasedate = date.today();
                        asset.installdate = date.today();
                        asset.hr_data__c = oli.hr_data__c;
                        asset.non_hr_data__c = oli.non_hr_data__c;
                        if(ProductToFramework.get(oli.pricebookentry.product2Id) != null){
                            asset.framework__c = ProductToFramework.get(oli.PricebookEntry.product2Id);
                        }
                        asset.Confirm_HR_Compliance__c = oli.Confirm_HR_Compliance__c;
                        asset.quantity = 1;
                        asset.participant__c = oli.order.participant__c;
                        asset.UsageEndDate = date.today().addDays(365);
                        asset.ContactId = UserToContact.get(oli.order.CreatedById);
                        asset.status = 'Purchased';
                    toUpsert.add(asset);
                    updatedAssets.add(asset.id);
                }
            }
        }
        upsert toUpsert;
        ProductAssetMap = new map<id, id>();
        for(asset asset : [select id, product2id from asset where id in :toUpsert]){
            for(OrderItem oli : lineItems){
                if(oli.pricebookentry.product2id == asset.product2id){
                    ProductAssetMap.put(oli.id, asset.id);
                    break;
                }
            }
        }
    }
    
    public map<id, id> ProductAssetMap {get; set;}
    
    public void updateThirdParties() {
        //The Asset field on Third Party needs to be updated.
        //This method assumes that updatesAssets has been called first to populate newlyPaidOrders and updatedAssets
        
        //Get the Third Parties for the newly paid Orders
        System.debug('newlyPaidOrders = ' + newlyPaidOrders);
        List<Third_Party__c> tParties = [SELECT Id, Asset__c, Order_Product__c, Order_Product__r.Pricebookentry.Product2Id FROM Third_Party__c WHERE Order_Product__r.Order.Id in :newlyPaidOrders];
        //Get the Assets that were just updated
        //Loop through the Third Parties to update the asset Id where the Product2.Id matches the Asset Map
        for (Third_Party__c tp: tParties) {
            System.debug('Third Party to Update = ' + tp.id + '; Third Party Asset = ' + tp.Order_Product__r.Pricebookentry.Product2Id);
            tp.asset__c = ProductAssetMap.get(tp.order_product__c);
        }
        update tParties;
    }
}