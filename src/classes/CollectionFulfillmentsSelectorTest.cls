/*
	Author: Jeff Weyhrauch
	Date: 7-2-2020
	Name: CollectionFulfillmentsSelectorTest.cls
	Purpose: The test class for the CollectionFulfillmentsSelector.cls.
 */
@IsTest
private class CollectionFulfillmentsSelectorTest {

	@IsTest
	static void CollectionFulfillmentsSelector_PassEmptySetOfIds_ReturnsEmptyListOfCollectionFulfillments(){
		List<Collection_Fulfillment__c> result = CollectionFulfillmentsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

}