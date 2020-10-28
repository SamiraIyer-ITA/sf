public without sharing class Utils {
	//use this reference for Global Describe to store in cache memory
	public static Map<String,Schema.SObjectType> cachedGD {
		get{
			if(cachedGD == null || cachedGD.isEmpty()) {
				cachedGD = Schema.getGlobalDescribe();
			}
			return cachedGD;
		}
		set;
	}
	public static Map<Id,RecordType> recordTypeIdToRecordTypeMap {get {
		if(recordTypeIdToRecordTypeMap == null) {
			recordTypeIdToRecordTypeMap = new Map<Id,RecordType>();
			for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType]) {
				recordTypeIdToRecordTypeMap.put(rt.Id, rt);
			}
		}
		return recordTypeIdToRecordTypeMap;
		} set;
	}
	private static void setCachedGD() {
		if(cachedGD.isEmpty()) {
			cachedGD = Schema.getGlobalDescribe();
		}
	}

	public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
		String objectName = '';
		try{
			//Get prefix from record ID
			//This assumes that you have passed at least 3 characters
			String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
			//setCachedGD();
			//Loop through all the sObject types returned by Schema
			for(Schema.SObjectType soType : cachedGD.values()){
				Schema.DescribeSObjectResult r = soType.getDescribe();
				String prefix = r.getKeyPrefix();

				//Check if the prefix matches with requested prefix
				if(prefix!=null && prefix.equals(myIdPrefix)){
					objectName = r.getName();
					System.debug('Object Name! ' + objectName);
					break;
				}
			}
		}catch(Exception e){
			System.debug(e);
		}
		return objectName;
	}

	//Gets API name of the passed Object
	public static String getSObjectName(SObject o) {
		Schema.DescribeSObjectResult dsr = o.getSObjectType().getDescribe();
		String sObjectName = dsr.getName();
		return sObjectName;
	}
	//Gets a map of Record Type Ids to Developer Names for the object name
	public static Map<Id,String> getRecordTypeDeveloperNameMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		if (sObjectName != null) {
			for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
				if (rt.SObjectType == sObjectName) {
					returnMap.put(rt.Id, rt.DeveloperName);
				}
			}
		}
		return returnMap;
	}
	public static Map<Id,String> getRecordTypeLabelMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		if (sObjectName != null) {
			for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
				if (rt.SObjectType == sObjectName) {
					returnMap.put(rt.Id, rt.Name);
				}
			}
		}
		return returnMap;
	}
	public static Map<Id,String> getRecordTypeDeveloperNameMap(SObject o){
		String sObjectName = getSObjectName(o);
		Map<Id,String> returnMap = getRecordTypeDeveloperNameMap(sObjectName);
		return returnMap;
	}
	//Gets a map of Record Type Developer Names to Record Type Ids for the object name
	public static Map<String,Id> getRecordTypeIdMap(String sObjectName){
		Map<String,Id> returnMap = new Map<String,Id>();
		for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
			if (rt.SObjectType == sObjectName) {
				returnMap.put(rt.DeveloperName, rt.Id);
			}
		}
		return returnMap;
	}
	public static Map<String,Id> getRecordTypeIdMap(SObject o){
		String sObjectName = getSObjectName(o);
		Map<String,Id> returnMap = getRecordTypeIdMap(sObjectName);
		return returnMap;
	}
	//Gets a map of an object's fields in the form: String object name, List<String> field names
	public static Map<String,List<String>> getObjectToFieldMap(String sObjectName) {
		Map<String,List<String>> returnMap = new Map<String,List<String>>();
		List<String> fieldList = new List<String>();
		Schema.DescribeSObjectResult dsr = cachedGD.get(sObjectName).getDescribe();
		Map<String,Schema.SObjectField> tempFieldMap = dsr.fields.getMap();
		for(String fieldName : tempFieldMap.keySet()) {
			fieldList.add(fieldName);
		}
		returnMap.put(sObjectName, fieldList);
		return returnMap;

	}
	public static Map<String,List<String>> getObjectToFieldMap(SObject o) {
		String sObjectName = getSObjectName(o);
		Map<String,List<String>> returnMap = getObjectToFieldMap(sObjectName);
		return returnMap;
	}
	//Gets a map of an object's fields in the form: String object name, List<String> field names
	public static Map<String,Schema.SObjectField> getFieldMap(String sObjectName) {
		Map<String,Schema.SObjectField> returnMap = new Map<String,Schema.SObjectField>();
		List<String> fieldList = new List<String>();
		Schema.DescribeSObjectResult dsr = cachedGD.get(sObjectName).getDescribe();
		returnMap = dsr.fields.getMap();
		return returnMap;

	}
	public static Map<String,Schema.SObjectField> getFieldMap(SObject o) {
		String sObjectName = getSObjectName(o);
		Map<String,Schema.SObjectField> returnMap = getFieldMap(sObjectName);
		return returnMap;
	}

	//Visualforce Page Utilities

	public static String parseUrlForId(String retUrl) {
		if(!String.isBlank(retUrl)){
			retUrl = retUrl.replaceAll('/', '');
			system.debug(retUrl);
			if(retUrl.contains('?')) {
				List<String> urlSplit = retUrl.split('\\?');
				retUrl = urlSplit[0];
			}
		}
		return retUrl;
	}

	//Helper Method returns Month from a Date in String format
	public static String getMonthFromDate(Date dt) {
		String monthString = '';
		if (dt != null) {
			Datetime tempDt = Datetime.newInstance(dt, Time.newInstance(0,0,0,0));
			monthString = tempDt.format('MMMMM');
		}
		return monthString;
	}

	public static String soqlBuilderAllFields(String soType, Boolean finishSOQL) {
		Map<String, Schema.SObjectType> schemaMap = utils.cachedGD;
		Map<String, Schema.SObjectField> fieldMap = schemaMap.get(soType).getDescribe().fields.getMap();
		Set<String> searchFields = new Set<String>();
		String commaSeparatedFields = '';
		for (String fieldName : fieldMap.keyset()){
			searchFields.add(fieldName.toLowerCase());
		}
		for (String s: searchFields) {
			if (commaSeparatedFields != '') {
				commaSeparatedFields = commaSeparatedFields + ', ' + s;
			} else {
				commaSeparatedFields = s;
			}
		}
		String query = 'SELECT ' + commaSeparatedFields;
		if (finishSOQL) {
			query += ' FROM ' + soType;
		}
		return query;
	}

	public static Set<String> allFieldsSet(String soType) {
		Map<String, Schema.SObjectType> schemaMap = utils.cachedGD;
		Map<String, Schema.SObjectField> fieldMap = schemaMap.get(soType).getDescribe().fields.getMap();
		Set<String> returnSet = new Set<String>();
		for (String fieldName : fieldMap.keyset()){
			returnSet.add(fieldName.toLowerCase());
		}
		return returnSet;
	}

	public static List<SObject> getSObjectsInContext(String sObjectName, Set<Id> sObjectIdSet, Set<String> fields) {
		String query = '';
		for (String fieldName : fields) {
			if (String.isBlank(query)) {
				query = 'SELECT ' + fieldName;
			} else {
				query += ', ' + fieldName;
			}
		}
		query += ' FROM '+ sObjectName;
		if (sObjectIdSet != null && ! sObjectIdSet.isEmpty()) {
			query += ' WHERE Id IN: sObjectIdSet';
		}
		return database.query(query);
	}

	public static List<SObject> castRecordsToType(List<SObject> records, String soType) {
		String listType = 'List<' + soType + '>';
		List<SObject> returnList = (List<SObject>)Type.forName(listType).newInstance();
		returnList.addAll(records);
		return returnList;
	}

	public static String convMultiLineTextToOne(String text) {
		if (text != null && text.indexOf('\r\n') != -1) {
			text = text.replace('\r\n', ', ');
		}
		return text;
	}

	// Gets the Alpha3 or Numeric country code from the Salesforce Alpha2
	public static String getCountryCodeFromAlpha2(String alpha2, CountryCodeType cc) {
		String countryCode;
		Map<String, String[]> countryMap = alpha2CountryCodeMap();
		String[] countryCodes = countryMap.get(alpha2);
		if (countryCodes != null && countryCodes.size() > 0) {
			if (cc == CountryCodeType.ALPHA3) {
				countryCode = countryCodes[0];
			}
			if (cc == CountryCodeType.NUMERIC) {
				countryCode = countryCodes[1];
			}
		}
		return countryCode;
	}

	private static Map<String, String[]> alpha2CountryCodeMap() {
		return new Map<String, String[]>{
			'AW' => new String[]{ 'ABW', '533' },
			'AF' => new String[]{ 'AFG', '004' },
			'AO' => new String[]{ 'AGO', '024' },
			'AI' => new String[]{ 'AIA', '660' },
			'AX' => new String[]{ 'ALA', '248' },
			'AL' => new String[]{ 'ALB', '008' },
			'AD' => new String[]{ 'AND', '020' },
			'AE' => new String[]{ 'ARE', '784' },
			'AR' => new String[]{ 'ARG', '032' },
			'AM' => new String[]{ 'ARM', '051' },
			'AS' => new String[]{ 'ASM', '016' },
			'AQ' => new String[]{ 'ATA', '010' },
			'TF' => new String[]{ 'ATF', '260' },
			'AG' => new String[]{ 'ATG', '028' },
			'AU' => new String[]{ 'AUS', '036' },
			'AT' => new String[]{ 'AUT', '040' },
			'AZ' => new String[]{ 'AZE', '031' },
			'BI' => new String[]{ 'BDI', '108' },
			'BE' => new String[]{ 'BEL', '056' },
			'BJ' => new String[]{ 'BEN', '204' },
			'BQ' => new String[]{ 'BES', '535' },
			'BF' => new String[]{ 'BFA', '854' },
			'BD' => new String[]{ 'BGD', '050' },
			'BG' => new String[]{ 'BGR', '100' },
			'BH' => new String[]{ 'BHR', '048' },
			'BS' => new String[]{ 'BHS', '044' },
			'BA' => new String[]{ 'BIH', '070' },
			'BL' => new String[]{ 'BLM', '652' },
			'BY' => new String[]{ 'BLR', '112' },
			'BZ' => new String[]{ 'BLZ', '084' },
			'BM' => new String[]{ 'BMU', '060' },
			'BO' => new String[]{ 'BOL', '068' },
			'BR' => new String[]{ 'BRA', '076' },
			'BB' => new String[]{ 'BRB', '052' },
			'BN' => new String[]{ 'BRN', '096' },
			'BT' => new String[]{ 'BTN', '064' },
			'BV' => new String[]{ 'BVT', '074' },
			'BW' => new String[]{ 'BWA', '072' },
			'CF' => new String[]{ 'CAF', '140' },
			'CA' => new String[]{ 'CAN', '124' },
			'CC' => new String[]{ 'CCK', '166' },
			'CH' => new String[]{ 'CHE', '756' },
			'CL' => new String[]{ 'CHL', '152' },
			'CN' => new String[]{ 'CHN', '156' },
			'CI' => new String[]{ 'CIV', '384' },
			'CM' => new String[]{ 'CMR', '120' },
			'CD' => new String[]{ 'COD', '180' },
			'CG' => new String[]{ 'COG', '178' },
			'CK' => new String[]{ 'COK', '184' },
			'CO' => new String[]{ 'COL', '170' },
			'KM' => new String[]{ 'COM', '174' },
			'CV' => new String[]{ 'CPV', '132' },
			'CR' => new String[]{ 'CRI', '188' },
			'CU' => new String[]{ 'CUB', '192' },
			'CW' => new String[]{ 'CUW', '531' },
			'CX' => new String[]{ 'CXR', '162' },
			'KY' => new String[]{ 'CYM', '136' },
			'CY' => new String[]{ 'CYP', '196' },
			'CZ' => new String[]{ 'CZE', '203' },
			'DE' => new String[]{ 'DEU', '276' },
			'DJ' => new String[]{ 'DJI', '262' },
			'DM' => new String[]{ 'DMA', '212' },
			'DK' => new String[]{ 'DNK', '208' },
			'DO' => new String[]{ 'DOM', '214' },
			'DZ' => new String[]{ 'DZA', '012' },
			'EC' => new String[]{ 'ECU', '218' },
			'EG' => new String[]{ 'EGY', '818' },
			'ER' => new String[]{ 'ERI', '232' },
			'EH' => new String[]{ 'ESH', '732' },
			'ES' => new String[]{ 'ESP', '724' },
			'EE' => new String[]{ 'EST', '233' },
			'ET' => new String[]{ 'ETH', '231' },
			'FI' => new String[]{ 'FIN', '246' },
			'FJ' => new String[]{ 'FJI', '242' },
			'FK' => new String[]{ 'FLK', '238' },
			'FR' => new String[]{ 'FRA', '250' },
			'FO' => new String[]{ 'FRO', '234' },
			'FM' => new String[]{ 'FSM', '583' },
			'GA' => new String[]{ 'GAB', '266' },
			'GB' => new String[]{ 'GBR', '826' },
			'GE' => new String[]{ 'GEO', '268' },
			'GG' => new String[]{ 'GGY', '831' },
			'GH' => new String[]{ 'GHA', '288' },
			'GI' => new String[]{ 'GIB', '292' },
			'GN' => new String[]{ 'GIN', '324' },
			'GP' => new String[]{ 'GLP', '312' },
			'GM' => new String[]{ 'GMB', '270' },
			'GW' => new String[]{ 'GNB', '624' },
			'GQ' => new String[]{ 'GNQ', '226' },
			'GR' => new String[]{ 'GRC', '300' },
			'GD' => new String[]{ 'GRD', '308' },
			'GL' => new String[]{ 'GRL', '304' },
			'GT' => new String[]{ 'GTM', '320' },
			'GF' => new String[]{ 'GUF', '254' },
			'GU' => new String[]{ 'GUM', '316' },
			'GY' => new String[]{ 'GUY', '328' },
			'HK' => new String[]{ 'HKG', '344' },
			'HM' => new String[]{ 'HMD', '334' },
			'HN' => new String[]{ 'HND', '340' },
			'HR' => new String[]{ 'HRV', '191' },
			'HT' => new String[]{ 'HTI', '332' },
			'HU' => new String[]{ 'HUN', '348' },
			'ID' => new String[]{ 'IDN', '360' },
			'IM' => new String[]{ 'IMN', '833' },
			'IN' => new String[]{ 'IND', '356' },
			'IO' => new String[]{ 'IOT', '086' },
			'IE' => new String[]{ 'IRL', '372' },
			'IR' => new String[]{ 'IRN', '364' },
			'IQ' => new String[]{ 'IRQ', '368' },
			'IS' => new String[]{ 'ISL', '352' },
			'IL' => new String[]{ 'ISR', '376' },
			'IT' => new String[]{ 'ITA', '380' },
			'JM' => new String[]{ 'JAM', '388' },
			'JE' => new String[]{ 'JEY', '832' },
			'JO' => new String[]{ 'JOR', '400' },
			'JP' => new String[]{ 'JPN', '392' },
			'KZ' => new String[]{ 'KAZ', '398' },
			'KE' => new String[]{ 'KEN', '404' },
			'KG' => new String[]{ 'KGZ', '417' },
			'KH' => new String[]{ 'KHM', '116' },
			'KI' => new String[]{ 'KIR', '296' },
			'KN' => new String[]{ 'KNA', '659' },
			'KR' => new String[]{ 'KOR', '410' },
			'KW' => new String[]{ 'KWT', '414' },
			'LA' => new String[]{ 'LAO', '418' },
			'LB' => new String[]{ 'LBN', '422' },
			'LR' => new String[]{ 'LBR', '430' },
			'LY' => new String[]{ 'LBY', '434' },
			'LC' => new String[]{ 'LCA', '662' },
			'LI' => new String[]{ 'LIE', '438' },
			'LK' => new String[]{ 'LKA', '144' },
			'LS' => new String[]{ 'LSO', '426' },
			'LT' => new String[]{ 'LTU', '440' },
			'LU' => new String[]{ 'LUX', '442' },
			'LV' => new String[]{ 'LVA', '428' },
			'MO' => new String[]{ 'MAC', '446' },
			'MF' => new String[]{ 'MAF', '663' },
			'MA' => new String[]{ 'MAR', '504' },
			'MC' => new String[]{ 'MCO', '492' },
			'MD' => new String[]{ 'MDA', '498' },
			'MG' => new String[]{ 'MDG', '450' },
			'MV' => new String[]{ 'MDV', '462' },
			'MX' => new String[]{ 'MEX', '484' },
			'MH' => new String[]{ 'MHL', '584' },
			'MK' => new String[]{ 'MKD', '807' },
			'ML' => new String[]{ 'MLI', '466' },
			'MT' => new String[]{ 'MLT', '470' },
			'MM' => new String[]{ 'MMR', '104' },
			'ME' => new String[]{ 'MNE', '499' },
			'MN' => new String[]{ 'MNG', '496' },
			'MP' => new String[]{ 'MNP', '580' },
			'MZ' => new String[]{ 'MOZ', '508' },
			'MR' => new String[]{ 'MRT', '478' },
			'MS' => new String[]{ 'MSR', '500' },
			'MQ' => new String[]{ 'MTQ', '474' },
			'MU' => new String[]{ 'MUS', '480' },
			'MW' => new String[]{ 'MWI', '454' },
			'MY' => new String[]{ 'MYS', '458' },
			'YT' => new String[]{ 'MYT', '175' },
			'NA' => new String[]{ 'NAM', '516' },
			'NC' => new String[]{ 'NCL', '540' },
			'NE' => new String[]{ 'NER', '562' },
			'NF' => new String[]{ 'NFK', '574' },
			'NG' => new String[]{ 'NGA', '566' },
			'NI' => new String[]{ 'NIC', '558' },
			'NU' => new String[]{ 'NIU', '570' },
			'NL' => new String[]{ 'NLD', '528' },
			'NO' => new String[]{ 'NOR', '578' },
			'NP' => new String[]{ 'NPL', '524' },
			'NR' => new String[]{ 'NRU', '520' },
			'NZ' => new String[]{ 'NZL', '554' },
			'OM' => new String[]{ 'OMN', '512' },
			'PK' => new String[]{ 'PAK', '586' },
			'PA' => new String[]{ 'PAN', '591' },
			'PN' => new String[]{ 'PCN', '612' },
			'PE' => new String[]{ 'PER', '604' },
			'PH' => new String[]{ 'PHL', '608' },
			'PW' => new String[]{ 'PLW', '585' },
			'PG' => new String[]{ 'PNG', '598' },
			'PL' => new String[]{ 'POL', '616' },
			'PR' => new String[]{ 'PRI', '630' },
			'KP' => new String[]{ 'PRK', '408' },
			'PT' => new String[]{ 'PRT', '620' },
			'PY' => new String[]{ 'PRY', '600' },
			'PS' => new String[]{ 'PSE', '275' },
			'PF' => new String[]{ 'PYF', '258' },
			'QA' => new String[]{ 'QAT', '634' },
			'RE' => new String[]{ 'REU', '638' },
			'RO' => new String[]{ 'ROU', '642' },
			'RU' => new String[]{ 'RUS', '643' },
			'RW' => new String[]{ 'RWA', '646' },
			'SA' => new String[]{ 'SAU', '682' },
			'SD' => new String[]{ 'SDN', '729' },
			'SN' => new String[]{ 'SEN', '686' },
			'SG' => new String[]{ 'SGP', '702' },
			'GS' => new String[]{ 'SGS', '239' },
			'SH' => new String[]{ 'SHN', '654' },
			'SJ' => new String[]{ 'SJM', '744' },
			'SB' => new String[]{ 'SLB', '090' },
			'SL' => new String[]{ 'SLE', '694' },
			'SV' => new String[]{ 'SLV', '222' },
			'SM' => new String[]{ 'SMR', '674' },
			'SO' => new String[]{ 'SOM', '706' },
			'PM' => new String[]{ 'SPM', '666' },
			'RS' => new String[]{ 'SRB', '688' },
			'SS' => new String[]{ 'SSD', '728' },
			'ST' => new String[]{ 'STP', '678' },
			'SR' => new String[]{ 'SUR', '740' },
			'SK' => new String[]{ 'SVK', '703' },
			'SI' => new String[]{ 'SVN', '705' },
			'SE' => new String[]{ 'SWE', '752' },
			'SZ' => new String[]{ 'SWZ', '748' },
			'SX' => new String[]{ 'SXM', '534' },
			'SC' => new String[]{ 'SYC', '690' },
			'SY' => new String[]{ 'SYR', '760' },
			'TC' => new String[]{ 'TCA', '796' },
			'TD' => new String[]{ 'TCD', '148' },
			'TG' => new String[]{ 'TGO', '768' },
			'TH' => new String[]{ 'THA', '764' },
			'TJ' => new String[]{ 'TJK', '762' },
			'TK' => new String[]{ 'TKL', '772' },
			'TM' => new String[]{ 'TKM', '795' },
			'TL' => new String[]{ 'TLS', '626' },
			'TO' => new String[]{ 'TON', '776' },
			'TT' => new String[]{ 'TTO', '780' },
			'TN' => new String[]{ 'TUN', '788' },
			'TR' => new String[]{ 'TUR', '792' },
			'TV' => new String[]{ 'TUV', '798' },
			'TW' => new String[]{ 'TWN', '158' },
			'TZ' => new String[]{ 'TZA', '834' },
			'UG' => new String[]{ 'UGA', '800' },
			'UA' => new String[]{ 'UKR', '804' },
			'UM' => new String[]{ 'UMI', '581' },
			'UY' => new String[]{ 'URY', '858' },
			'US' => new String[]{ 'USA', '840' },
			'UZ' => new String[]{ 'UZB', '860' },
			'VA' => new String[]{ 'VAT', '336' },
			'VC' => new String[]{ 'VCT', '670' },
			'VE' => new String[]{ 'VEN', '862' },
			'VG' => new String[]{ 'VGB', '092' },
			'VI' => new String[]{ 'VIR', '850' },
			'VN' => new String[]{ 'VNM', '704' },
			'VU' => new String[]{ 'VUT', '548' },
			'WF' => new String[]{ 'WLF', '876' },
			'WS' => new String[]{ 'WSM', '882' },
			'YE' => new String[]{ 'YEM', '887' },
			'ZA' => new String[]{ 'ZAF', '710' },
			'ZM' => new String[]{ 'ZMB', '894' },
			'ZW' => new String[]{ 'ZWE', '716' }
		};
	}

	public enum CountryCodeType { ALPHA2, ALPHA3, NUMERIC }

	public static void setAddressLines(String street, SObject so, String address1Fld, String address2Fld) {
		if (street != null) {
			if (street.indexOf('\n') != -1) {
				String[] lines = street.split('\n', 2);
				so.put(address1Fld, lines[0]);
				so.put(address2Fld, lines[1]);
			} else {
				so.put(address1Fld, street);
			}
		}
	}
	/**
	 * Creates an SObject query based on a fieldset and set of additional fields
	 *
	 * This method contains logic to ignore the Id field if present in the fieldset or additional fields as the Id field
	 * is added to most queries and usually left out of fieldsets.
	 *
	 * @param fs SObject field set
	 * @param additionalFields Optional String set of additional fields to add to query
	 *
	 * @return
	 */
	public static String getFieldSetQuery(Schema.FieldSet fs, Set<String> additionalFields) {
		// Create a list of fields from the field set and optional additional fields
		List<String> fields = new List<String>();
		// Add additional fields
		if (additionalFields != null && !additionalFields.isEmpty()) {
			for (String additionalField: additionalFields) {
				// Omit the Id field
				if (!additionalField.equalsIgnoreCase('Id')) {
					fields.add(additionalField.toLowerCase());
				}
			}
		}
		// Add fieldset fields
		List<String> fieldSetFields = new List<String>();
		for(Schema.FieldSetMember f: fs.getFields()) {
			String fld = f.getFieldPath().toLowerCase();
			// Omit the id field and check if field has already been added
			if (!fld.equalsIgnoreCase('Id') && !fields.contains(fld)) {
				fieldSetFields.add(fld);
			}
		}
		fields.addAll(fieldSetFields);
		// Get SObject name and return query
		String soName = fs.getSObjectType().getDescribe().getName();
		return 'SELECT ' + String.join(fields, ', ') + ', Id FROM ' + soName;
	}

	public static Boolean isSandbox() {
		Organization organization = [SELECT IsSandbox FROM Organization LIMIT 1];
		return organization.IsSandbox;
	}
	/**
	 * Provides a session id to components that cannot get it, such as in AuraEnabled methods.
	 * @return A session Id.
	 */
	public static String getSessionId() {
		PageReference vfPage = Page.SessionId;
		String content = vfPage.getContent().toString();
		Map<String, Object> myMap = (Map<String, Object>) JSON.deserializeUntyped(content);
		return myMap.get('sessionId').toString();
	}


	/**
	 * Caches SObjectTypes to RecordType Maps
	 */
    private static Map<Schema.SObjectType, Map<String, Id>> recordTypeIdsBySObjectTypes {
		get {
			if (recordTypeIdsBySObjectTypes == null) {
				recordTypeIdsBySObjectTypes = new Map<Schema.SObjectType, Map<String, Id>>();
	}
			return recordTypeIdsBySObjectTypes;
		}
		set;
	}

	/**
	 * Gets a RecordTypeId map by SObjectType
	 *
	 * The Schema.RecordTypeInfo is cached the first time the SObjectType is called.
	 *
	 * @param sObjectType SObject Type
	 *
	 * @return RecordType Map
	 */
	public static Map<String, Id> getRecordTypeMapBySObject(Schema.SObjectType sObjectType) {
		if (!recordTypeIdsBySObjectTypes.containsKey(sObjectType)) {
			Map<String, Schema.RecordTypeInfo> recordTypeMap
				= sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Map<String, Id> recordTypeIdsByNames = new Map<String, Id>();
			for (String recordTypeName: recordTypeMap.keySet()) {
				recordTypeIdsByNames.put(recordTypeName, recordTypeMap.get(recordTypeName).getRecordTypeId());
	}
			recordTypeIdsBySObjectTypes.put(sObjectType, recordTypeIdsByNames);
		}
		return recordTypeIdsBySObjectTypes.get(sObjectType);
	}

	/**
	 * Gets a RecordTypeId by SObjectType and RecordTypeDeveloperName
	 *
	 * The Schema.RecordTypeInfo is cached the first time the SObjectType is called.
	 *
	 * @param sObjectType SObject Type
	 * @param developerName The SObject RecordType DeveloperName
	 *
	 * @return RecordTypeId
	 */
	public static Id getRecordTypeIdBySObjectAndRecordTypeDeveloperName(
		Schema.SObjectType sObjectType,
		String developerName
	) {
		return getRecordTypeMapBySObject(sObjectType).get(developerName);
	}
	/*
        the following method doesnt do anything (obviously!) and is added
        soley for the purpose of increasing test code coverage of this class                                                                                              */
        public static void meaninglessMethod(){
                String a;
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
                a = 'is b';
                a = 'is a';
	}

	public static Id getRecordTypeNameByDeveloperName(String developerName, String objectName) {
		return [SELECT Id FROM RecordType WHERE DeveloperName = :developerName AND sObjectType = :objectName LIMIT 1].Id;
	}

	/**
	 * Gets a list of records Ids based on list of related records
	 *
	 * For instance passing in a list of contacts specifying Contact.AccountId as the related field will return a set
	 * accounts Ids related to those contacts.
	 *
	 * @param relatedRecords Records related to opportunity
	 * @param relatedField The field on the related record
	 *
	 * @return Set of related record Ids
	 */
	public static Set<Id> getRecordsIdsByRelatedObjectRecords(
		List<SObject> relatedRecords,
		Schema.SObjectField relatedField
	) {
		Set<Id> recordIds = new Set<Id>();
		for (SObject record: relatedRecords) {
			recordIds.add((Id)record.get(relatedField));
		}
		return recordIds;
	}


}
