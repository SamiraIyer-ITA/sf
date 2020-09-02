@isTest
public class ProductsTest {

	static Map<String, Schema.RecordTypeInfo> recordTypeMap
		= Product2.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	static Id productId = fflib_IDGenerator.generate(Product2.SObjectType);
	static Id LEGACY_RECORD_TYPE_ID = recordTypeMap.get('Legacy').getRecordTypeId();
	static Id EVENT_RECORD_TYPE_ID = recordTypeMap.get('Events').getRecordTypeId();

	@IsTest
	static void testNewInstanceOfProductsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Product2> productsList  = new List<Product2>{ new Product2() };
			IProducts iProducts = (IProducts) Products.newInstance(productsList);
		System.assertNotEquals(iProducts, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfProductsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> productIds = new Set<Id>{ productId };
			IProducts iProducts = (IProducts) Products.newInstance(productIds);
		System.assertNotEquals(iProducts, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void test_ProductsTrigger_withDml() {
		// Insert product with required fields to test Products trigger. We need to specify Legacy here.
		insert new Product2(
			Name = 'Test Product',
			RecordTypeId = LEGACY_RECORD_TYPE_ID
		);
	}

	@IsTest
	static void testBeforeInsert_setEventsAcountingCode_noDml(){
		Product2 testProduct = new Product2(
			Id = productId,
			Name = 'testProduct',
			Family = 'Certified Trade Mission',
			IsPrimary__c = true,
			RecordTypeId = EVENT_RECORD_TYPE_ID
		);
		testProduct = (Product2)fflib_ApexMocksUtils.setReadOnlyFields(
			testProduct,
			Product2.class,
			new Map<SObjectField, Object> {
				Product2.Event_Type_Smart_Code__c => 'N',
				Product2.Record_Type_Developer_Name__c => 'Events'
			}
		);
		fflib_SObjectDomain.Test.Database.onInsert(
			new List<Product2>{ testProduct }
		);
		fflib_SObjectDomain.triggerHandler(Products.class);
		System.assertEquals('0N01', testProduct.Accounting_Code__c, 'Verify correct code');
	}
}