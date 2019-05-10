/*
	This class provides methods to manage Orders and Products, similar to a shopping cart.
*/
global class ProductSelector {

	public Order createOrder(Id accountId, Id applicationId, Id programId){
		Order order;
		try{
			order = new Order(
				Program__c = programId,
				Participant__c = applicationId,
				Status = 'In Progress',
				EffectiveDate = Date.today(),
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
		OrderItem[] oi = [
			SELECT Id
			FROM OrderItem
			WHERE OrderId = :orderId
			AND Product2Id IN :products
		];
		delete oi;
	}

	public OrderItem[] addProductsToOrder(Id orderId, Id[] products){
		OrderItem[] orderItems = new OrderItem[]{};
		Order order = [
			SELECT Id, Pricebook2Id,
			(
				SELECT Id
				FROM OrderItems
				WHERE NOT Id IN :products
			)
			FROM Order
			WHERE Id = :orderId
			LIMIT 1
		];

		PricebookEntry[] pricebookEntries = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :order.Pricebook2Id AND Product2Id IN :products];
        system.debug('Products:  '+products);
        PricebookEntry[] pbes = [select id, unitprice from pricebookentry where pricebook2Id = :order.pricebook2id and product2id in :products];
        system.debug(pbes);
		for(PricebookEntry pbe : pricebookEntries){
			orderItems.add(new OrderItem(OrderId = orderId, Quantity = 1, PricebookEntryId = pbe.Id, UnitPrice = pbe.UnitPrice));
			System.debug('###################################################### \nMethod: addProductsToOrder; \nVariableName: pbe, \nVariableValue: ' + JSON.serializePretty(pbe));
		}

		upsert orderItems;
		return orderItems;
	}

	public OrderItem addPriceBookEntryToOrder(Id orderId, Id priceBookEntryId) {
		OrderItem orderItem;
		try{
			PricebookEntry pbe = [
				SELECT Id, UnitPrice
				FROM PricebookEntry
				WHERE Id = :priceBookEntryId
				AND IsActive = TRUE
				LIMIT 1
			];
			orderItem = new OrderItem (
				OrderId = orderId,
				PricebookEntryId = priceBookEntryId,
				Quantity = 1,
				UnitPrice = pbe.UnitPrice);
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
			Pricebook2 priceBook = [
				SELECT Id
				FROM Pricebook2
				WHERE Id = :priceBookId
				LIMIT 1
			];
			PricebookEntry priceBookEntryItem = [
				SELECT Id, UnitPrice
				FROM PricebookEntry
				WHERE Pricebook2Id = :priceBook.Id
				AND Product2Id = :productId
				AND IsActive = TRUE
				LIMIT 1
			];
			orderItem = addPriceBookEntryToOrder(orderId, priceBookEntryItem.Id);
		}catch(Exception e){
			System.debug(LoggingLevel.ERROR, e);
			return null;
		}
		return orderItem;
	}

	public Boolean deleteProductFromOrder(Id orderId, Id productId) {
		try {
			delete [
				SELECT Id
				FROM OrderItem
				WHERE OrderId = :orderId
				AND Product2Id = :productId
			];
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, e);
			return false;
		}
		return true;
	}

	public List<Product2> getAllOrderProducts (Id orderId) {
		List<OrderItem> orderItems = [
			SELECT Id, OrderId, Product2Id
			FROM OrderItem
			WHERE OrderId = :orderId
		];


		List<Id> productIds = new List<Id>();
		for (OrderItem oi: orderItems) {
			productIds.add(oi.Product2Id);
		}


		List<Product2> products = [
			SELECT Id, ProductCode, Description, Family, Class__c, Category__c, Name
			FROM Product2
			WHERE Id IN :productIds
		];


		// TODO: if productIds.size() and products.size() are NOT the same #
		//  then you have added the same product more than once!!!
		if(productIds.size() != products.size()){
			throw new ProductSelectorComponentException('You have a duplicate product in your order list');
		}

		return products;
	}

	public Boolean deleteOrder (Id orderId) {
		try {
			delete [
				SELECT Id
				FROM Order
				WHERE Id = :orderId
			];
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, e);
			return false;
		}
		return true;
	}

	public class ProductSelectorComponentException extends Exception {}
}
