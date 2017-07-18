public without sharing class DateCalculationConditionService {
	@TestVisible private SObject record {get; set;}
	@TestVisible private Date_Calculation__mdt dc {get; set;}
	@TestVisible private Integer condition {get; set;}

	public DateCalculationConditionService () {}
	public DateCalculationConditionService (SObject record, Date_Calculation__mdt dc, Integer condition) {
		this.record = record;
		this.dc = dc;
		this.condition = condition;
	}

	public Boolean checkCondition(SObject record, Date_Calculation__mdt dc, Integer condition) {
    	//Return value
    	Boolean returnBoolean = false;
    	//Field Names from custom metadata to get
    	String conditionalFieldName = 'Conditional_Field_' + String.valueOf(condition) + '_Name__c';
    	String conditionalFieldOperator = 'Conditional_Field_' + String.valueOf(condition) + '_Operator__c';
    	String conditionalFieldValue = 'Conditional_Field_' + String.valueOf(condition) + '_Value__c';
    	String operator = String.valueOf(dc.get(conditionalFieldOperator));
    	System.debug('*** operator: ' + operator);
    	//Values of fields as objects
    	Object tempRecordFieldValue = record.get(String.valueOf(dc.get(conditionalFieldName)));
    	System.debug('*** tempRecordFieldValue: ' + tempRecordFieldValue);
    	Object tempCmtFieldValue = dc.get(String.valueOf(conditionalFieldValue));
    	System.debug('*** tempCmtFieldValue: ' + tempCmtFieldValue);
    	Integer cmtFieldIntegerValue = typeCastToInteger(tempCmtFieldValue);
    	Date cmtFieldDateValue = typeCastToDate(tempCmtFieldValue);
        Boolean cmtFieldBooleanValue = typeCastToBoolean(tempCmtFieldValue);
    	//Type cast to specific primitive data type
    	if (cmtFieldDateValue != null) {
    		Date recordFieldValue = tempRecordFieldValue != null ? (Date) tempRecordFieldValue : null;
    		Date cmtFieldValue = (Date) tempCmtFieldValue;
    		returnBoolean = getConditionResult(recordFieldValue, cmtFieldValue, operator);
    	} else if (cmtFieldIntegerValue != null) {
    		Integer recordFieldValue = tempRecordFieldValue != null ? ((Integer)((Decimal) tempRecordFieldValue)) : 0;
    		System.debug('*** Integer recordFieldValue: ' + recordFieldValue);
    		Integer cmtFieldValue = Integer.valueOf(tempCmtFieldValue);
    		System.debug('*** Integer cmtFieldValue: ' + cmtFieldValue);
    		returnBoolean = getConditionResult(recordFieldValue, cmtFieldValue, operator);
    	} else if (cmtFieldBooleanValue != null) {
            Boolean recordFieldValue = tempRecordFieldValue != null ? Boolean.valueOf(tempRecordFieldValue) : null;
            System.debug('*** Boolean recordFieldValue: ' + recordFieldValue);
            Boolean cmtFieldValue = tempCmtFieldValue != null ? Boolean.valueOf(tempCmtFieldValue) : null;
            System.debug('*** Boolean cmtFieldValue: ' + cmtFieldValue);
            returnBoolean = getConditionResult(recordFieldValue, cmtFieldValue, operator);
        } else if (tempCmtFieldValue instanceOf String && ((String)tempCmtFieldValue).indexOf(';') < 0) {
    		String recordFieldValue = tempRecordFieldValue != null ? String.valueOf(tempRecordFieldValue) : '';
    		System.debug('*** String recordFieldValue: ' + recordFieldValue);
    		String cmtFieldValue = (String) tempCmtFieldValue;
    		Set<String> cmtFieldValueSet = new Set<String>();
    		System.debug('*** String cmtFieldValue: ' + cmtFieldValue);
    		returnBoolean = getConditionResult(recordFieldValue, cmtFieldValue, operator);
    	} else if (tempCmtFieldValue instanceOf String && ((String)tempCmtFieldValue).indexOf(';') > 0) {
    		String recordFieldValue = tempRecordFieldValue != null ? String.valueOf(tempRecordFieldValue) : '';
    		System.debug('*** String recordFieldValue: ' + recordFieldValue);
    		Set<String> cmtFieldValue = new Set<String>();
    		for (String s : ((String)tempCmtFieldValue).split(';')) {
    			cmtFieldValue.add(s);
    		}
    		System.debug('*** String cmtFieldValue: ' + cmtFieldValue);
    		returnBoolean = getConditionResult(recordFieldValue, cmtFieldValue, operator);
    	} else if (tempCmtFieldValue == null) {
    		if (operator == 'Equals') {
    			returnBoolean = tempRecordFieldValue == null ? true : false;
    		} else if (operator == 'Not Equals To') {
    			returnBoolean = tempRecordFieldValue != null ? true : false;
    		} else if (operator == 'Until Past') {
                returnBoolean = ((Date) tempRecordFieldValue < System.today());
            }
    	}
    	return returnBoolean;
    }

    @TestVisible private Boolean getConditionResult(Date recordFieldValue, Date cmtFieldValue, String operator) {
    	//Set Boolean Based on logic in cmt
    	if (operator == 'Equals') {
    		return (recordFieldValue == cmtFieldValue);
    	} else if (operator == 'Not Equals To') {
    		return (recordFieldValue != cmtFieldValue);
    	} else if (operator == 'Greater Than') {
    		return(recordFieldValue > cmtFieldValue);
    	} else if (operator == 'Less Than') {
    		return(recordFieldValue < cmtFieldValue);
    	} else if (operator == 'Greater Than Or Equals To') {
    		return(recordFieldValue >= cmtFieldValue);
    	} else if (operator == 'Less Than Or Equals To') {
    		return(recordFieldValue <= cmtFieldValue);
    	} else if (operator == 'Until Past') {
            return(recordFieldValue > System.today());
        }
    	return false;
    }
    @TestVisible private Boolean getConditionResult(Integer recordFieldValue, Integer cmtFieldValue, String operator) {
    	//Set Boolean Based on logic in cmt
    	if (operator == 'Equals') {
    		return (recordFieldValue == cmtFieldValue);
    	} else if (operator == 'Not Equals To') {
    		return (recordFieldValue != cmtFieldValue);
    	} else if (operator == 'Greater Than') {
    		return(recordFieldValue > cmtFieldValue);
    	} else if (operator == 'Less Than') {
    		return(recordFieldValue < cmtFieldValue);
    	} else if (operator == 'Greater Than Or Equals To') {
    		return(recordFieldValue >= cmtFieldValue);
    	} else if (operator == 'Less Than Or Equals To') {
    		return(recordFieldValue <= cmtFieldValue);
    	}
    	return false;
    }
    @TestVisible private Boolean getConditionResult(String recordFieldValue, String cmtFieldValue, String operator) {
    	//Set Boolean Based on logic in cmt
    	if (operator == 'Equals') {
    		return (recordFieldValue == cmtFieldValue);
    	} else if (operator == 'Not Equals To') {
    		return (recordFieldValue != cmtFieldValue);
    	}
    	return false;
    }
    @TestVisible private Boolean getConditionResult(Boolean recordFieldValue, Boolean cmtFieldValue, String operator) {
        //Set Boolean Based on logic in cmt
        if (operator == 'Equals') {
            return (recordFieldValue == cmtFieldValue);
        } else if (operator == 'Not Equals To') {
            return (recordFieldValue != cmtFieldValue);
        }
        return false;
    }
    @TestVisible private Boolean getConditionResult(String recordFieldValue, Set<String> cmtFieldValue, String operator) {
    	//Set Boolean Based on logic in cmt
    	if (operator == 'Equals') {
    		return (cmtFieldValue.contains(recordFieldValue));
    	} else if (operator == 'Not Equals To') {
    		return (!cmtFieldValue.contains(recordFieldValue));
    	}
    	return false;
    }

    @TestVisible private Integer typeCastToInteger(Object o) {
		try {
    		return Integer.valueOf(o);
		} catch (Exception e) {
            return null;
		}
		return null;
	}

	@TestVisible private Date typeCastToDate(Object o) {
		try {
			return Date.parse(String.valueOf(o));
		} catch (Exception e) {
            return null;
		}
		return null;
	}

    @TestVisible private Boolean typeCastToBoolean(Object o) {
        try {
            return Boolean.valueOf(o);
        } catch (Exception e) {
            return null;
        }
        return null;
    }
}