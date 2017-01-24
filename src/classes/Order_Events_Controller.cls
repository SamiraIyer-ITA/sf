Public With Sharing Class Order_Events_Controller{
    public Order[] newList {get; set;}
    public Id[] OrderIds {get; set;}
    public map<id, order> newMap {get; set;}
    public map<id, order> oldMap {get; set;}

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
        set<Id> accounts = new set<Id>();
        set<id> exists = new set<id>();
        Asset[] toUpsert = new Asset[]{};
        for(Order order : this.newList){
            system.debug('Status:  '+order.status);
            if(order.Status == 'Activated' && oldMap.get(order.id).status != 'Activated')
                accounts.add(order.accountid);
        }
        system.debug('List of Accounts:  '+accounts);
        Asset[] assets = [select id, price, product2id, purchasedate, participant__c, participation__c, UsageEndDate, accountid from Asset where AccountId = :accounts ];
        OrderItem[] lineItems = [select id, PricebookEntry.Product2Id, pricebookentry.product2.name, unitprice, order.accountid, order.participation__c, order.participant__c from orderitem where orderid in :this.OrderIds];
        system.debug('Order Line Items:  '+lineItems);
        for(OrderItem oli : lineItems){
            for(Asset asset : assets){
                if(asset.accountId == oli.order.accountid && asset.product2id == oli.pricebookentry.product2id){
                    exists.add(oli.id);
                    asset.price = oli.unitPrice;
                    asset.participant__c = oli.order.participant__c;
                    asset.participation__c = oli.order.participation__c;
                    asset.UsageEndDate = date.today().addDays(365);
                    asset.Status = 'Installed';
                    toUpsert.add(asset);
                }
            }
        }
        system.debug('Existing:  '+exists);
        if(accounts.size() != 0)
        for(OrderItem oli : lineItems){
            if(!exists.contains(oli.id)){
                if(accounts.contains(oli.order.accountId)){
                    Asset asset = new Asset();
                    asset.accountId = oli.order.accountid;
                    asset.name = oli.pricebookentry.product2.name;
                    asset.product2id = oli.pricebookentry.product2id; 
                    asset.price = oli.unitprice;
                    asset.purchasedate = date.today();
                    asset.installdate = date.today();
                    asset.participant__c = oli.order.participant__c;
                    asset.participation__c = oli.order.participation__c;
                    asset.UsageEndDate = date.today().addDays(365);
                    asset.status = 'Installed';
                    toUpsert.add(asset);
                }
            }
        }
        upsert toUpsert;
    }
}