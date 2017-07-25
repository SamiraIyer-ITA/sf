public without sharing class CustomMetadataSelector {

	public static List<ADCVD_Objects__mdt> allAdcvdObjects {
		get {
			if (allAdcvdObjects == null) {
				String query = Utils.soqlBuilderAllFields('ADCVD_Objects__mdt', true);
				allAdcvdObjects = database.query(query);
			}
			return allAdcvdObjects;
		} set;
	}

	public static List<Constant__mdt> allConstants {
		get {
			if (allConstants == null) {
				String query = Utils.soqlBuilderAllFields('Constant__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c FROM Constant__mdt';
				allConstants = database.query(query);
			}
			return allConstants;
		} set;
	}

	public static List<Date_Calculation__mdt> allDateCalculations {
		get {
			if (allDateCalculations == null) {
				String query = Utils.soqlBuilderAllFields('Date_Calculation__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c, ADCVD_Objects__r.Number_of_Date_Calculations__c, ' +
						'Constant_1__r.Number_Value__c, Constant_1__r.String_Value__c, ' +
						'Constant_1__r.Used_with_Field_Named__c, Constant_2__r.Number_Value__c, Constant_2__r.String_Value__c, ' +
						'Constant_2__r.Used_with_Field_Named__c, Constant_3__r.Number_Value__c, Constant_3__r.String_Value__c, ' +
						'Constant_3__r.Used_with_Field_Named__c, Constant_4__r.Number_Value__c, Constant_4__r.String_Value__c, ' +
						'Constant_4__r.Used_with_Field_Named__c FROM Date_Calculation__mdt';
				allDateCalculations = database.query(query);
			}
			return allDateCalculations;
		} set;
	}

	public static Map<String,Constant__mdt> getConstantNameToConstantMap(String offsetFieldName) {
		Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
		for (Constant__mdt c : allConstants) {
			if ((Boolean)c.get(offsetFieldName)) {
				returnMap.put(c.QualifiedApiName, c);
			}
		}
		return returnMap;
	}

	public static Constant__mdt getConstant(String idOrQualifiedApiName) {
		Constant__mdt returnConstant = null;
		if (idOrQualifiedApiName instanceOf Id) {
			Id i = (Id) idOrQualifiedApiName;
			for (Constant__mdt c : allConstants) {
				if (c.Id == i) {
					returnConstant = c;
					break;
				}
			}
		} else {
			for (Constant__mdt c : allConstants) {
				if (c.QualifiedApiName == idOrQualifiedApiName) {
					returnConstant = c;
					break;
				}
			}
		}
		return returnConstant;
	}
}