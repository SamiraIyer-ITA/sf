/**
 * Generates product codes for Product Events record types. Increments the product code based on the current max
 * product code (smart code).
 *
 * @author Andrew La Russa
 */
public inherited sharing class EventProductCodeGenerator implements IProductCodeGenerator {

	private static final String KEY;
	private static final Integer LAST_KEY_INDEX;
	@TestVisible private static final Id EVENT_RECORD_TYPE_ID;
	private static final String INDEX_ONE_VALUE;	
	private Set<String> baseSmartCodeFilters = new Set<String>();

	static {
		INDEX_ONE_VALUE = getIndexOneValue();
		KEY = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
		LAST_KEY_INDEX = KEY.length() - 1;
		EVENT_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName()
            .get('Events').getRecordTypeId();
	}

	private AggregateResultProxy[] groupedMaxProductCodesByFamily {
		get {
			if (groupedMaxProductCodesByFamily == null) {
				groupedMaxProductCodesByFamily
					= ProductsSelector.newInstance().selectMaxProductCodesByFamily(this.baseSmartCodeFilters);
			}
			return groupedMaxProductCodesByFamily;
		}
		set;
	}

	@TestVisible private static String fiscalYear {
		get {
			if (fiscalYear == null) {
				Period[] records = [
					SELECT	FiscalYearSettings.Name
					FROM   	Period
					WHERE  	Type = 'Year'
							AND StartDate <= TODAY
							AND EndDate >= TODAY
				];
				if (records.isEmpty()) {
					throw new EventProductCodeGeneratorException('Unable to locate the current Fiscal Year value.');
				}
				fiscalYear = records[0].FiscalYearSettings.Name;
			}
			return fiscalYear;
		}
		set;
	}

	@TestVisible private static Integer fiscalMonth {
		get {
			if (fiscalMonth == null) {
				Period[] records = [SELECT EndDate FROM Period WHERE Type = 'Month' AND StartDate = THIS_MONTH];
				if (records.isEmpty()) {
					throw new EventProductCodeGeneratorException('Unable to locate the current Fiscal Month value.');
				}
				fiscalMonth = records[0].EndDate.month();
			}
			return fiscalMonth;
		}
		set;
	}

	/**
	 * Gets the current first index value for the smart code using the fiscal year and month.
	 *
	 * @return The current smart code index one value
	 */
	@TestVisible private static String getIndexOneValue() {
		String indexOneValue = fiscalYear.substring(fiscalYear.length() -1);
		if (fiscalMonth > 9) {
			indexOneValue  = indexOneValue  == '9' 
				? '0'
				: String.valueOf(Integer.valueOf(indexOneValue) + 1);
		}
		return indexOneValue;
	}

	/**
	 * Gets the exception message when a smart code has reached it max limit for the base code.
	 *
	 * @param maxSmartCode 	The current max smart code
	 * @param baseSmartCode The base smart code
	 *
	 * @return Max smart code exception message
	 */
	@TestVisible private static String getMaxSmartCodeIndexErrorMessage(String maxSmartCode, String baseSmartCode) {
		return String.format(
			'Event has reached the maximum Product Code ({0}) for this index: {1}.',
			new String[]{ maxSmartCode, baseSmartCode}
		);
	}

	/**
	 * Gets the next available product code by incrementing the third and fourth indexes of the current max smart code.
	 *
	 * @param indexThree	Third index of the 4 character current max smart code
	 * @param indexFour		Fourth index of the 4 character current max smart code
	 * @param maxSmartCode	The current max smart code
	 * @param baseSmartCode	The base smart code. Example: '0N'
	 *
	 * @return The next product code based on the current max smart code
	 */
	private String getNextProductCode(
		Integer indexThree,
		Integer indexFour,
		String maxSmartCode,
		String baseSmartCode
	) {
		// If index four is the last key index we need to increment index three
		if (indexFour == LAST_KEY_INDEX) {
			if (indexThree == LAST_KEY_INDEX) {
				throw new EventProductCodeGeneratorException(
					getMaxSmartCodeIndexErrorMessage(maxSmartCode, baseSmartCode));
			}
			indexThree = indexThree + 1;
			indexFour = 0;
		} else {
			indexFour = indexFour + 1;
		}
		return baseSmartCode + KEY.substring(indexThree, indexThree  + 1) + KEY.substring(indexFour, indexFour + 1);
	}

	/**
	 * Sets product codes for a list of products by getting the max product code for it's family and incrementing. If
	 * this the first instance of a product for the base code it will start with base code plus '01'
	 *
	 * @param products List of products to set
	 */
	public void setProductCodes(List<Product2> products) {
		Map<String, List<Product2>> productsByFamily = new Map<String, List<Product2>>();
		for (Product2 product: products) {
			if (product.RecordTypeId == EVENT_RECORD_TYPE_ID) {
				this.baseSmartCodeFilters.add('%' + INDEX_ONE_VALUE + product.Event_Type_Smart_Code__c + '__');
				if (!productsByFamily.containsKey(product.Family)) {
					productsByFamily.put(product.Family, new List<Product2>());
				}
				productsByFamily.get(product.Family).add(product);
			}
		}
		if (!productsByFamily.isEmpty()) {
			Map<String, String> maxSmartCodesByFamily = new Map<String, String>();
			for (AggregateResultProxy groupedResultProxies: this.groupedMaxProductCodesByFamily) {
				Map<String,Object> groupedResultProxy = groupedResultProxies.getValuesByAlias();
				maxSmartCodesByFamily.put(
					(String)groupedResultProxy.get('Family'), (String)groupedResultProxy.get('maxSmartCode'));
			}
			for (String family: productsByFamily.keySet()) {
				List<Product2> familyProducts = productsByFamily.get(family);
				String baseSmartCode;
				Integer indexThree, indexFour;
				String maxSmartCode = maxSmartCodesByFamily.get(family);
				if (maxSmartCode == null) {
					// If there is not a max smart code this will be the first entry for this base code.
					baseSmartCode = INDEX_ONE_VALUE + familyProducts[0].Event_Type_Smart_Code__c;
					indexThree = 0;
					indexFour = 0;
				} else {
					baseSmartCode = maxSmartCode.substring(0,2);
					indexThree = KEY.indexOfChar(maxSmartCode.substring(2,3).charAt(0));
					indexFour = KEY.indexOfChar(maxSmartCode.substring(3,4).charAt(0));
				}
				for (Product2 familyProduct: familyProducts) {
					familyProduct.ProductCode = getNextProductCode(indexThree, indexFour, maxSmartCode, baseSmartCode);
				}
			}
		}		
	}

	public class EventProductCodeGeneratorException extends Exception {}
}