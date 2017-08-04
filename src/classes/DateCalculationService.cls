public without sharing class DateCalculationService {

	@TestVisible private Map<String,Date_Calculation__mdt> dateCalculations = new Map<String,Date_Calculation__mdt>();
	@TestVisible private Map<String,Map<Id,SObject>> baseObjectMap = new Map<String,Map<Id,SObject>>();
	@TestVisible private Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();

	public void getCalculatedDates(List<SObject> soList, String soType, String recordTypeName) {
		setDateCalculations(soType, recordTypeName);
		getBaseObjectMap(soList);
		getFrUtilMap(soList);
		for (SObject record : soList) {
			calculateDates(record, soType);
		}
	}
    @TestVisible private void setDateCalculations(String soType, String recordTypeName) {
        if (dateCalculations == null || dateCalculations.isEmpty()) {
        	dateCalculations = DateCalculationSelector.getDateCalculationsMap(soType, recordTypeName);
        }
    }

    @TestVisible private void calculateDates(SObject record, String soType) {
    	for (String key : dateCalculations.keySet()) {
    		Date_Calculation__mdt dc = dateCalculations.get(key);
    		String calculatedDateName = dc.Calculated_Date_Field_Name__c;
    		System.debug('*** calculatedDateName: ' + calculatedDateName);
    		Integer numberOfBaseDates = (Integer) dc.Number_of_Base_Date_Fields__c;
    		Integer numberOfConditionals = (Integer) dc.Number_of_Conditionals__c;
    		Integer numberOfConstants = (Integer) dc.Number_of_Constants__c;
    		String tollingService = dc.Tolling_Service__c;
    		Integer offset = dc.Constant_1__r.Number_Value__c != null ? (Integer) dc.Constant_1__r.Number_Value__c : 0;
    		Integer extension = 0;
    		Date baseDate = null;
    		Date tempDate = null;
    		Boolean skipCalculation = false;
    		Map<String,Object> conditionalObjectMap = new Map<String,Object>();
    		Map<String,Boolean> conditionalResults = new Map<String,Boolean>();

    		//check conditional fields first
    		if (numberOfConditionals != null && numberOfConditionals > 0) {
    			conditionalResults = getConditionals(record, dc, numberOfConditionals);
    			System.debug('*** conditionalResults: ' + conditionalResults);
    			conditionalObjectMap = applyConditionals(record, soType, dc, conditionalResults, numberOfBaseDates);
    			System.debug('*** conditionalObjectMap: ' + conditionalObjectMap);
    		}
    		//assign the conditionalObject to the right value
    		if (!conditionalObjectMap.isEmpty()) {
	    		for (String s : conditionalObjectMap.keySet()) {
	    			if (conditionalObjectMap.get(s) != null && s == 'Date') {
		    			baseDate = (Date) conditionalObjectMap.get(s);
		    		} else if (conditionalObjectMap.get(s) != null && s == 'Integer') {
		    			offset = ((Integer)((Decimal) conditionalObjectMap.get(s)));
		    		} else if (conditionalObjectMap.get(s) != null && s == 'Skip') {
		    			skipCalculation = true;
		    		}
	    		}
	    	}
    		//conditional result is not skip (includes blanks), execute
    		if (conditionalResults.containsKey('Align') && conditionalResults.get('Align')) {
    			continue;
    		} else if ((!conditionalResults.containsKey('Skip') || !conditionalResults.get('Skip')) 
    			&& !skipCalculation){
    			for (Integer i = 1; i <= numberOfBaseDates; i++) {
    				baseDate = baseDate == null ? getBaseDate(record, soType, dc, i) : baseDate;
    				System.debug('*** baseDate: ' + baseDate);
    			}
	    		if (!String.isBlank(dc.Extension_Field_1_Name__c)) {
	    			extension = getExtension(record, dc);
	    		}
	    		if (baseDate != null && tollingService == 'Get Calculated Date') {
		    		tempDate = baseDate.addDays(offset).addDays(extension);
		    		tempDate = ADCVD_TollingDayUtility.getCalculatedDate(baseDate, tempDate, true);
		    	} else if (baseDate != null && tollingService == 'Count Back Business Days') {
		    		tempDate = ADCVD_TollingDayUtility.countBackBusinessDays(baseDate, offset);
		    	}
	    		record.put(calculatedDateName, tempDate);
    		} else {
    			record.put(calculatedDateName, null);
    		}
    	}
    }

    @TestVisible private Map<String,Object> applyConditionals(SObject record, String soType, Date_Calculation__mdt dc, Map<String,Boolean> conditionalResults, Integer numberOfBaseDates) {
    	Map<String,Object> returnMap = new Map<String,Object>();
    	Set<Integer> skippedDates = new Set<Integer>();
    	Boolean dateConditional = false;
    	for (String result : conditionalResults.keySet()) {
    		Object tempObject = null;
    		if (result == null || conditionalResults.get(result) == null) continue;
	    	if ((result == 'Skip' && conditionalResults.get(result)) || (conditionalResults.get('Execute') != null && !conditionalResults.get('Execute'))) {
	    		returnMap.put('Skip', true);
	    		return returnMap;
	    	} else if (result.contains('Use Date') && conditionalResults.get(result) && returnMap.get('Date') == null) {
	    		Integer i = Integer.valueOf(result.right(1));
	    		tempObject = getBaseDate(record, soType, dc, i);
	    		returnMap.put('Date', tempObject);
	    		dateConditional = true;
	    	} else if (result.contains('Use Date') && !conditionalResults.get(result)) {
	    		skippedDates.add(Integer.valueOf(result.right(1)));
	    		dateConditional = true;
	    	} else if (result.contains('Use Constant') && conditionalResults.get(result)) {
	    		Integer i = Integer.valueOf(result.right(1));
	    		String constant = 'Constant_' + String.valueOf(i) + '__c';
	    		Id constantId = (Id) dc.get(constant);
	    		tempObject = CustomMetadataSelector.getConstant(constantId).Number_Value__c;
	    		returnMap.put('Integer', tempObject);
	    	}
	    }
	    if (returnMap.get('Date') == null && !skippedDates.isEmpty()) {
	    	Object tempObject = null;
	    	for (Integer i = 1; i <= numberOfBaseDates; i++) {
				tempObject = (tempObject == null && !skippedDates.contains(i)) ? getBaseDate(record, soType, dc, i) : tempObject;
				returnMap.put('Date', tempObject);
			}
	    }
	    if (returnMap.get('Date') == null && dateConditional) returnMap.put('Skip', true);
    	return returnMap;
    }

    @TestVisible private Map<String,Boolean> getConditionals(SObject record, Date_Calculation__mdt dc, Integer numberOfConditionals) {
    	Map<String,Boolean> returnMap = new Map<String,Boolean>();
    	for (Integer i = 1; i <= numberOfConditionals; i++) {
    		SObject baseRecord = !String.isBlank(String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Object__c'))) ? getBaseConditionalObject(record, dc, i) : record;
    		String conditionalFieldResult = String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Result__c'));
    		System.debug('*** conditionalFieldResult: ' + conditionalFieldResult);
    		DateCalculationConditionService dccs = new DateCalculationConditionService(baseRecord, dc, i);
    		Boolean tempBoolean = dccs.checkCondition(baseRecord, dc, i);
    		System.debug('*** tempBoolean: ' + tempBoolean);
    		if (returnMap.get(conditionalFieldResult) != true) returnMap.put(conditionalFieldResult, tempBoolean);
    	}
    	return returnMap;
    }

    

    @TestVisible private Date getBaseDate(SObject record, String soType, Date_Calculation__mdt dc, Integer i) {
    	String baseDateFieldObject = 'Base_Date_Field_'+ String.valueOf(i) + '_Object__c';
    	String baseDateFieldName = 'Base_Date_Field_'+ String.valueOf(i) + '_Name__c';
    	String baseDateFieldLookupFieldName = 'Base_Date_Field_'+ String.valueOf(i) + '_Lookup_Field_Name__c';
    	String baseDateFieldType = 'Base_Date_Field_' + String.valueOf(i) + '_Type__c';
    	SObject so = null;
    	Date baseDate = null;
    	//if base field is not from the current object
    	if (dc.get(baseDateFieldObject) != null && String.valueOf(dc.get(baseDateFieldObject)) != soType) {
    		//get the base SObject (except Federal_Register__c) that has the base field we need
			so = (String.valueOf(dc.get(baseDateFieldObject)) != 'Federal_Register__c') ? 
				getBaseObject(record, String.valueOf(dc.get(baseDateFieldLookupFieldName)), String.valueOf(dc.get(baseDateFieldObject))) : so;
			//get the base field from that SObject
			baseDate = so != null && so.get(String.valueOf(dc.get(baseDateFieldName))) != null ? (Date) so.get(String.valueOf(dc.get(baseDateFieldName))) : baseDate;
			//if from a Federal_Register__c, get base field, else leave it as is
			baseDate = (String.valueOf(dc.get(baseDateFieldObject)) == 'Federal_Register__c' && frUtilMap != null && record.get('Id') != null) ? getFrDate(record, dc, baseDateFieldType) : baseDate;
		} else if (String.valueOf(dc.get(baseDateFieldName)) != null && String.valueOf(dc.get(baseDateFieldObject)) == soType){//if base field is from the current object
			baseDate = (Date) record.get(String.valueOf(dc.get(baseDateFieldName)));
		} else if (String.valueOf(dc.get(baseDateFieldName)) == 'Today') {
			baseDate = System.today();
		}
		return baseDate;
    }

    @TestVisible private Integer getExtension(SObject record, Date_Calculation__mdt dc) {
		Integer extension = record.get(dc.Extension_Field_1_Name__c) == null ? 0 : Integer.valueOf(record.get(dc.Extension_Field_1_Name__c));
		return extension;
    }

    @TestVisible private SObject getBaseConditionalObject(SObject record, Date_Calculation__mdt dc, Integer i) {
    	String baseObjectName = 'Conditional_Field_'+ String.valueOf(i) + '_Object__c';
    	String baseFieldName = 'Conditional_Field_'+ String.valueOf(i) + '_Name__c';
    	String baseFieldType = 'Conditional_Field_'+ String.valueOf(i) + '_Type__c';
    	Set<String> childSObjectNames = new Set<String> {''};

    	if (String.valueOf(dc.get(baseObjectName)) == 'Federal_Register__c') {
	    	Federal_Register__c tempFR = new Federal_Register__c ();
	    	tempFR.Type__c = String.valueOf(dc.get(baseFieldType));
	    	tempFR.Published_Date__c = getFrDate(record, dc, baseFieldType);
    		return (SObject)tempFR;
    	} else if (childSObjectNames.contains(baseObjectName)) {
    		return getBaseObject(record, '', baseObjectName, baseFieldType);
		} else {
			return getBaseObject(record, '', baseObjectName);
		}
		return null;
    }

    @TestVisible private SObject getBaseObject(SObject record, String lookupFieldName, String baseObjectName) {
    	Id tempId = (Id)record.get(lookupFieldName);
		SObject so = baseObjectMap.get(baseObjectName).get(tempId);
		System.debug('***getBaseObject so: ' + so);
		return so;
	}

	@TestVisible private SObject getBaseObject(SObject record, String lookupFieldName, String baseObjectName, String typeField) {
		Id tempId = (Id)record.get('Id');
		Map<Id,SObject> tempMap = baseObjectMap.get(baseObjectName);
		SObject so = null;
		for (Id i : tempMap.keySet()) {
			if ((Id)tempMap.get(i).get(lookupFieldName) == tempId && tempMap.get(i).get('Type__c') != null && typeField != null && tempMap.get(i).get('Type__c') == typeField) {
				so = tempMap.get(i);
				break;
			}
		}
		System.debug('***so: ' + so);
		return so;
	}

	@TestVisible private Date getFrDate(SObject record, Date_Calculation__mdt dc, String fieldType) {
		Date returnDate = null;
		if (frUtilMap != null && record.get('Id') != null && frUtilMap.get((Id)record.get('Id')) != null) {
			ADCVD_FederalRegisterUtility fru = frUtilMap.get((Id)record.get('Id'));
			returnDate = fru.varMap != null ? fru.varMap.get(String.valueOf(dc.get(fieldType))) : null;
		}
		return returnDate;
	}

	@TestVisible private void getFrUtilMap(List<SObject> soList) {
		frUtilMap = DateCalculationSelector.getFrUtilMap(soList);
	}

	@TestVisible private void getBaseObjectMap(List<SObject> soList) {
		if (baseObjectMap == null || baseObjectMap.isEmpty()) {
			Map<String,String> lookupFieldNameToObjectNameMap = new Map<String,String>();
			String targetObjectName = '';
			for (Date_Calculation__mdt dc : dateCalculations.values()) {
				targetObjectName = targetObjectName == '' ? dc.ADCVD_Objects__r.Object_API_Name__c : targetObjectName;
				System.debug('*** targetObjectName: ' + targetObjectName);
				for (Integer i = 1; i <=5; i++) {
					String lookupFieldName = 'Base_Date_Field_' + String.valueOf(i) + '_Lookup_Field_Name__c';
					String objectName = 'Base_Date_Field_' + String.valueOf(i) + '_Object__c';
					lookupFieldNameToObjectNameMap.put(String.valueOf(dc.get(lookupFieldName)), String.valueOf(dc.get(objectName)));
				}
			}
			System.debug('*** lookupFieldNameToObjectNameMap: ' + lookupFieldNameToObjectNameMap);
			for (String lookupFieldName : lookupFieldNameToObjectNameMap.keySet()) {
				String objectName = lookupFieldNameToObjectNameMap.get(lookupFieldName);
				if (objectName == 'Petition__c') {
					baseObjectMap.put('Petition__c', DateCalculationSelector.getPetitionsInScope(soList, targetObjectName, lookupFieldName));
				}
			}
			System.debug('*** baseObjectMap: ' + baseObjectMap);	
		}
	}

	@TestVisible private class NextMajorDeadline {
		Date_Calculation__mdt dc {get; set;}
		Date calculatedDate {get; set;}
		public NextMajorDeadline(Date_Calculation__mdt dc, Date calculatedDate) {
			this.dc = dc;
			this.calculatedDate = calculatedDate;
		}
	}
}