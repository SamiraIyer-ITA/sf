@IsTest
private class EventProductCodeGeneratorTest {

	// We need to get the current index one value from the class as it's dynamic
	static String indexOneValue = EventProductCodeGenerator.getIndexOneValue();
	static Set<String> filters = new Set<String>{ '%' + indexOneValue + 'N__'  };

	// We need to serialize a Map into a Product to set the formula field so it can be read
	static Product2 getMockProduct(String family, String fxEventTypeSmartCode) {
		Product2 testProduct = new Product2(
			Name = 'Test ' + family,
			Family = family,
			IsPrimary__c = true,
			RecordTypeId = EventProductCodeGenerator.EVENT_RECORD_TYPE_ID
		);
		testProduct = (Product2)fflib_ApexMocksUtils.setReadOnlyFields(
			testProduct,
			Product2.class,
			new Map<SObjectField, Object> {Product2.Event_Type_Smart_Code__c => fxEventTypeSmartCode}
		);
		return testProduct;
	}

	@IsTest
	static void testSetProductCodes_FirstInstance() {
		String expectedNextProductCode = indexOneValue + 'N01';
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IProductsSelector mocksSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		AggregateResultProxy[] mockedGroupedResults = new List<AggregateResultProxy> {
			new AggregateResultProxy()
				.withAliasAndValue('Family','Certified Trade Mission')
				.withAliasAndValue('maxSmartCode', null)
		};
		// Given
		mocks.startStubbing();
		List<Product2> testProducts = new List<Product2>{ getMockProduct('Certified Trade Mission', 'N') };
		mocks.when(mocksSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mocksSelector.selectMaxProductCodesByFamily(filters)).thenReturn(mockedGroupedResults);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mocksSelector);
		// When
		IProductCodeGenerator codeGenerator
			= (IProductCodeGenerator) di_Injector.Org.getInstance(EventProductCodeGenerator.class);
		codeGenerator.setProductCodes(testProducts);
		// Then
		((IProductsSelector)
			mocks.verify(mocksSelector)).selectMaxProductCodesByFamily(filters);
		System.assertEquals(expectedNextProductCode, testProducts[0].Accounting_Code__c,
			'Verify product code is first instance.');
	}

	@IsTest
	static void testSetProductCodes_NextIncrement() {
		String maxSmartCode = indexOneValue + 'NAB';
		String expectedNextProductCode = indexOneValue + 'NAC';
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IProductsSelector mocksSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		AggregateResultProxy[] mockedGroupedResults = new List<AggregateResultProxy> {
			new AggregateResultProxy()
				.withAliasAndValue('Family','Certified Trade Mission')
				.withAliasAndValue('maxSmartCode', maxSmartCode)
		};
		// Given
		mocks.startStubbing();
		List<Product2> testProducts = new List<Product2>{ getMockProduct('Certified Trade Mission', 'N') };
		mocks.when(mocksSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mocksSelector.selectMaxProductCodesByFamily(filters)).thenReturn(mockedGroupedResults);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mocksSelector);
		// When
		IProductCodeGenerator codeGenerator
			= (IProductCodeGenerator) di_Injector.Org.getInstance(EventProductCodeGenerator.class);
		codeGenerator.setProductCodes(testProducts);
		// Then
		((IProductsSelector)
			mocks.verify(mocksSelector)).selectMaxProductCodesByFamily(filters);
		System.assertEquals(expectedNextProductCode, testProducts[0].Accounting_Code__c,
			'Verify product code is next in order.');
	}

	@IsTest
	static void testSetProductCodes_IncrementThirdIndex() {
		String maxSmartCode = indexOneValue + 'N0Z';
		String expectedNextProductCode = indexOneValue + 'N10';
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IProductsSelector mocksSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		AggregateResultProxy[] mockedGroupedResults = new List<AggregateResultProxy> {
			new AggregateResultProxy()
				.withAliasAndValue('Family','Certified Trade Mission')
				.withAliasAndValue('maxSmartCode', maxSmartCode)
		};
		// Given
		mocks.startStubbing();
		List<Product2> testProducts = new List<Product2>{ getMockProduct('Certified Trade Mission', 'N') };
		mocks.when(mocksSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mocksSelector.selectMaxProductCodesByFamily(filters)).thenReturn(mockedGroupedResults);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mocksSelector);
		// When
		IProductCodeGenerator codeGenerator
			= (IProductCodeGenerator) di_Injector.Org.getInstance(EventProductCodeGenerator.class);
		codeGenerator.setProductCodes(testProducts);
		// Then
		((IProductsSelector)
			mocks.verify(mocksSelector)).selectMaxProductCodesByFamily(filters);
		System.assertEquals(expectedNextProductCode, testProducts[0].Accounting_Code__c,
			'Verify the third index of the product code was incremented.');
	}

	@IsTest
	static void testSetProductCodes_MaxSmartCodeIndex() {
		String maxSmartCode = indexOneValue + 'NZZ';
		String expectedExceptionMessage
			= String.format(Label.Product_Code_Generator_Max_Smart_Code, new List<String>{ indexOneValue + 'NZZ', indexOneValue + 'N' });
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IProductsSelector mocksSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		AggregateResultProxy[] mockedGroupedResults = new List<AggregateResultProxy> {
			new AggregateResultProxy()
				.withAliasAndValue('Family','Certified Trade Mission')
				.withAliasAndValue('maxSmartCode', maxSmartCode)
		};
		// Given
		mocks.startStubbing();
		List<Product2> testProducts = new List<Product2>{ getMockProduct('Certified Trade Mission', 'N') };
		mocks.when(mocksSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mocksSelector.selectMaxProductCodesByFamily(filters)).thenReturn(mockedGroupedResults);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mocksSelector);
		// When
		IProductCodeGenerator codeGenerator
			= (IProductCodeGenerator) di_Injector.Org.getInstance(EventProductCodeGenerator.class);
		try {
			codeGenerator.setProductCodes(testProducts);
			// Then
		} catch (Exception e) {
			System.assertEquals(expectedExceptionMessage, e.getMessage(),
				'Verify exception was thrown due to max product code.');
		}
	}

	@IsTest
	static void testSetProductCodes_NoEventSmartCode() {
		String expectedExceptionMessage
			= String.format(Label.Product_Code_Generator_No_Smart_Code, new List<String>{ 'No Family Smart Code' });
		// Given
		List<Product2> testProducts = new List<Product2>{ getMockProduct('No Family Smart Code', null) };
		// When
		IProductCodeGenerator codeGenerator
			= (IProductCodeGenerator) di_Injector.Org.getInstance(EventProductCodeGenerator.class);
		try {
			codeGenerator.setProductCodes(testProducts);
			// Then
		} catch (Exception e) {
			System.assertEquals(expectedExceptionMessage, e.getMessage(),
				'Verify exception was thrown due family without event type smart code.');
		}
	}

	@IsTest
	static void testGetIndexOneValue_FiscalMonthLessThanNine() {
		EventProductCodeGenerator.fiscalYear = '2020';
		EventProductCodeGenerator.fiscalMonth = 8;
		System.assertEquals('0', EventProductCodeGenerator.getIndexOneValue());
	}

	@IsTest
	static void testGetIndexOneValue_FiscalMonthGreaterThanNine() {
		EventProductCodeGenerator.fiscalYear = '2020';
		EventProductCodeGenerator.fiscalMonth = 11;
		System.assertEquals('1', EventProductCodeGenerator.getIndexOneValue());
	}

	@IsTest
	static void testGetIndexOneValue_FiscalYearNine_FiscalMonthGreaterThanNine() {
		EventProductCodeGenerator.fiscalYear = '2019';
		EventProductCodeGenerator.fiscalMonth = 11;
		System.assertEquals('0', EventProductCodeGenerator.getIndexOneValue());
	}
}