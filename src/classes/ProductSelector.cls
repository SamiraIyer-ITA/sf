Global class ProductSelector {
    /*
    This class provides methods to manage Orders and Products, similar to a shopping cart.
    */

    Public Order createOrder(Id accountId, Id applicationId, Id programId){
        Order order;
        try{
            order = new Order(
                Program__c = programId,
                Participant__c = applicationId,
                Status = 'In Progress',
                effectivedate = Date.today(),
                AccountId = accountId
            );
            insert order;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, e);
            return null;
        }
        return order;    
    }

    public void removeProductsFromOrder(Id orderId, Id[] products){
        OrderItem[] oi = [select id from orderitem where orderid = :orderid and product2id in :products];
        delete oi;
    }

    public OrderItem[] addProductsToOrder(Id orderId, Id[] products){
        OrderItem[] output = new OrderItem[]{};
        Order order = [select id, pricebook2id, (select id from orderitems where not id in :products) from order where id = :orderId limit 1];
        
        //remove any products that are not in the list provided
//        delete order.orderitems;

        system.debug('Products:  '+products);
        PricebookEntry[] pbes = [select id, unitprice from pricebookentry where pricebook2Id = :order.pricebook2id and product2id in :products];
        system.debug(pbes);
        for(PricebookEntry pbe : pbes){
            output.add(new OrderItem(orderid = orderId, quantity = 1, pricebookentryid = pbe.id, unitprice = pbe.unitprice));
        }        

        upsert output;
        return output;
    }

    public OrderItem addPriceBookEntryToOrder(Id orderId, Id priceBookEntryId) {
        OrderItem orderItem;
        try{
            PricebookEntry pbe = [SELECT id, unitprice FROM PricebookEntry WHERE Id = :priceBookEntryId AND IsActive = true LIMIT 1];
            orderItem = new OrderItem (
                OrderId = orderId,
                PricebookEntryId = priceBookEntryId,
                Quantity = 1,
                UnitPrice = pbe.unitPrice);
            insert orderItem;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, e);
            return null;
        }
        return orderItem;
    }
    
    
    public OrderItem addProductToOrder(Id orderId, Id productId, Id priceBookId) {
        OrderItem orderItem;
        try{
            Pricebook2 pbook = [SELECT id FROM Pricebook2 WHERE id = :priceBookId LIMIT 1];
            PricebookEntry pbe = [SELECT id, unitprice FROM PricebookEntry WHERE pricebook2Id = :pbook.id AND product2Id = :productId AND IsActive = true LIMIT 1];
            orderItem = addPriceBookEntryToOrder(orderId, pbe.id);
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, e);
            return null;
        }
        return orderItem;
    }
    
    public boolean deleteProductFromOrder(Id orderId, Id productId) {
        try {
            delete [SELECT id FROM OrderItem WHERE Orderid = :orderId AND Product2Id = :productid];
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            return false;
        }
        return true;
    }
    
    public List<Product2> getAllOrderProducts (Id orderId) {
        List<OrderItem> orderItems = [SELECT id, orderId, Product2Id FROM OrderItem WHERE orderId = :orderId];
        List<Id> productIds = new List<Id>();
        for (OrderItem oi: orderItems) {
            productIds.add(oi.Product2Id);
        }
        List<Product2> products = [SELECT Id, ProductCode, Description, Family, Class__c, Category__c, Name FROM Product2 WHERE Id in :productIds]; 
        return products;    
    }
    
    public boolean deleteOrder (Id orderId) {
        try {
            delete [SELECT id FROM Order WHERE id = :orderId];
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            return false;
        }
        return true;
    }
    
    /*public boolean payForOrder(Id orderId) {
        //Not sure about this yet
        return true;
    }*/

}