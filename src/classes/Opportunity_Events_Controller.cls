Public With Sharing Class Opportunity_Events_Controller{
    public Opportunity[] newList {get; set;}
    public Id[] OpportunityIds {get; set;}

    public Opportunity_Events_Controller(Opportunity[] newList){
        this.OpportunityIds = new Id[]{};
        this.newList = newList;
        for(Opportunity opp : this.newList){
            if(opp.id != null)
                this.OpportunityIds.add(opp.id);
        }
    }

    public void updateAssets(){
        Id[] accounts = new Id[]{};
        set<id> exists = new set<id>();
        Asset[] toUpsert = new Asset[]{};
        for(Opportunity opp : this.newList){
            if(opp.isClosed && opp.isWon)
                accounts.add(opp.accountid);
        }
        Asset[] assets = [select id, price, product2id, purchasedate, UsageEndDate, accountid from Asset where AccountId = :accounts ];
        OpportunityLineItem[] lineItems = [select id, product2id, totalprice, opportunity.accountid from opportunitylineitem where id in :this.OpportunityIds];
        for(OpportunityLineItem oli : lineItems){
            for(Asset asset : assets){
                if(asset.accountId == oli.opportunity.accountid && asset.product2id == oli.product2id){
                    exists.add(oli.id);
                    asset.price = oli.totalPrice;
                    asset.UsageEndDate = date.today().addDays(365);
                    asset.Status = 'Installed';
                    toUpsert.add(asset);
                }
            }
        }
        for(OpportunityLineItem oli : lineItems){
            if(!exists.contains(oli.id)){
                Asset asset = new Asset();
                    asset.accountId = oli.opportunity.accountid;
                    asset.product2id = oli.product2id;
                    asset.price = oli.totalprice;
                    asset.purchasedate = date.today();
                    asset.UsageEndDate = date.today().addDays(365);
                    asset.status = 'Installed';
                    toUpsert.add(asset);
            }
        }
        upsert toUpsert;
    }

    public void checkOpenShoppingCarts(){
        //Get a list of all Shopping Carts that are being opened/modified.
        /*
            Shopping Cart Criteria:
                Opportunity.Site__c != null
                Opportunity.Trade_Community_User__c != null
        */
        Id[] OpenedShoppingCarts = new Id[]{};
        for(Opportunity opp : this.newList){
            if(!opp.isClosed && opp.Site__c != null && opp.trade_community_user__c != null)
                OpenedShoppingCarts.add(opp.trade_community_user__c);
        }
        
        Opportunity[] ExistingShoppingCarts = [select id, site__c, trade_community_user__c from Opportunity where isClosed = false and trade_community_user__c = :OpenedShoppingCarts];
        for(Opportunity newCart : this.newList){
            for(Opportunity existingCart : ExistingShoppingCarts){
                if(newCart.Trade_Community_User__c == existingCart.Trade_Community_User__c && newCart.site__c == existingCart.site__c){
                    newCart.addError('A Shopping Cart is already open on this Site for this User:  '+existingCart.id);
                    break;
                }
            }
        }
    }

}