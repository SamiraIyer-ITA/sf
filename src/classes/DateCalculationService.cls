/**
 * 
 *    Created by Joshua Moody
 *    on Aug 3 2017
 *    MIL Corporation
 * 
 **/

public without sharing class DateCalculationService {

    /************************************************
    * This class performs the date calculations for all objects
    * in the ADCVD app.  It primarily controls the flow of logic
    * and uses other classes to read the logic stored in metadata,
    * evaluate records using that logic, and sets the date values.
    * 1. Control of logic flow (main method) is getCalculatedDates
    * 2. setDateCalculations retrieves the metadata holding the logic
    * 3. getBaseObjectMap retrieves the related objects that could affect the calculations
    * 4. getFRUtilMap retrieves Federal Registers (via the class instances)
    * 5. calculateDates is a loop of the records and does the calculations for each record
    *************************************************/

    @TestVisible private Map<String,Date_Calculation__mdt> dateCalculations = new Map<String,Date_Calculation__mdt>();
    @TestVisible private FederalRegisterMapper frMapper;
    @TestVisible private Map<Id, FederalRegisterMapper.MappedFRs> frUtilMap = new Map<Id, FederalRegisterMapper.MappedFRs>();
    @TestVisible private ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');

    public void getCalculatedDates(List<SObject> soList, String soType, String recordTypeName) {
        setDateCalculations(soType, recordTypeName);
        setFrUtilMap(soList);
        for (SObject record : soList) {
            calculateDates(record, soType);
        }
    }

    @TestVisible private void calculateDates(SObject record, String soType) {
        Date goLiveDate = AppConfigService.goLiveDate;
        for (String key : dateCalculations.keySet()) {
            Date_Calculation__mdt dc = dateCalculations.get(key);
            String calculatedDateName = dc.Calculated_Date_Field_Name__c;
            String actualDateName = dc.Actual_Date_Field_Name__c != '' ? dc.Actual_Date_Field_Name__c : '';
            if ((Date)record.get(calculatedDateName) < goLiveDate && !Test.isRunningTest()) {continue;}
            if (!String.isBlank(actualDateName)) {
                if ((Date)record.get(actualDateName) != null && !Test.isRunningTest()) {continue;}
            }
            System.debug(LoggingLevel.Debug, '*** calculatedDateName: ' + calculatedDateName);
            Integer numberOfBaseDates = (Integer) dc.Number_of_Base_Date_Fields__c;
            Integer numberOfConditionals = (Integer) dc.Number_of_Conditionals__c;
            Integer numberOfExtensions = (Integer) dc.Number_of_Extensions__c;
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
                System.debug(LoggingLevel.Debug, '*** conditionalResults: ' + conditionalResults);
                conditionalObjectMap = applyConditionals(record, soType, dc, conditionalResults, numberOfBaseDates);
                System.debug(LoggingLevel.Debug, '*** conditionalObjectMap: ' + conditionalObjectMap);
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
                    System.debug(LoggingLevel.Debug, '*** baseDate: ' + baseDate);
                }
                for (Integer i = 1; i <= numberOfExtensions; i++) {
                    extension += getExtension(record, dc, i);
                }
                if (baseDate != null && tollingService == 'Get Calculated Date') {
                    tempDate = baseDate.addDays(offset).addDays(extension);
                    tempDate = ADCVD_TollingDayUtility.getCalculatedDate(baseDate, tempDate, true, (Id)record.get('Id'));
                } else if (baseDate != null && tollingService == 'Count Back Business Days') {
                    tempDate = ADCVD_TollingDayUtility.countBackBusinessDays(baseDate, offset);
                   } else if (baseDate != null && String.isBlank(tollingService)) {
                        tempDate = baseDate.addDays(offset).addDays(extension);
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
            System.debug(LoggingLevel.Debug, '*** conditionalFieldResult: ' + conditionalFieldResult);
            DateCalculationConditionService dccs = new DateCalculationConditionService(baseRecord, dc, i);
            Boolean tempBoolean = dccs.checkCondition(baseRecord, dc, i);
            System.debug(LoggingLevel.Debug, '*** tempBoolean: ' + tempBoolean);
            if (returnMap.get(conditionalFieldResult) != true) returnMap.put(conditionalFieldResult, tempBoolean);
        }
        return returnMap;
    }

    @TestVisible private Date getBaseDate(SObject record, String soType, Date_Calculation__mdt dc, Integer i) {
        String baseDateFieldObject = dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Object__c') != null ? 
                                        String.valueOf(dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Object__c')) : '';
        String baseDateFieldName = dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Name__c') != null ?
                                        String.valueOf(dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Name__c')) : '';
        String baseDateFieldLookupFieldName = dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Lookup_Field_Name__c') != null ?
                                        String.valueOf(dc.get('Base_Date_Field_'+ String.valueOf(i) + '_Lookup_Field_Name__c')) : '';
        String baseDateFieldType = dc.get('Base_Date_Field_' + String.valueOf(i) + '_Type__c') != null ?
                                        String.valueOf(dc.get('Base_Date_Field_' + String.valueOf(i) + '_Type__c')) : '';
        SObject so = null;
        Date baseDate = null;
        //if base field is not from the current object
        if (!String.isBlank(baseDateFieldObject) && baseDateFieldObject != soType) {
            //get the base SObject (except Federal_Register__c) that has the base field we need
            so = baseDateFieldObject != 'Federal_Register__c' ? 
                getBaseObject(record, baseDateFieldLookupFieldName, baseDateFieldObject) : so;
            //get the base field from that SObject
            System.debug('*** so: ' + so);
            baseDate = so != null && so.get(baseDateFieldName) != null ? (Date) so.get(baseDateFieldName) : baseDate;
            //if from a Federal_Register__c, get base field, else leave it as is
            baseDate = (baseDateFieldObject == 'Federal_Register__c' && frUtilMap != null && record.get('Id') != null) ? 
                getFrDate(record, dc, baseDateFieldType) : baseDate;
        } else if (!String.isBlank(baseDateFieldName) && baseDateFieldObject == soType){//if base field is from the current object
            baseDate = (Date) record.get(baseDateFieldName);
        } else if (baseDateFieldName == 'Today') {//used to set to current date
            baseDate = System.today();
        }
        return baseDate;
    }

    @TestVisible private Integer getExtension(SObject record, Date_Calculation__mdt dc, Integer i) {
        String extensionObjectName = dc.get('Extension_Object_' + String.valueOf(i) + '_Name__c') != null ?
                                        String.valueOf(dc.get('Extension_Object_' + String.valueOf(i) + '_Name__c')) : '';
        String extensionFieldName = dc.get('Extension_Field_' + String.valueOf(i) + '_Name__c') != null ?
                                        String.valueOf(dc.get('Extension_Field_' + String.valueOf(i) + '_Name__c')) : '';
        SObject extRecord = !String.isBlank(extensionObjectName) ? getBaseObject(record, extensionObjectName, extensionObjectName) : record;
        Integer extension = extRecord.get(extensionFieldName) == null ? 0 : Integer.valueOf(extRecord.get(extensionFieldName));
        return extension;
    }

    @TestVisible private SObject getBaseConditionalObject(SObject record, Date_Calculation__mdt dc, Integer i) {
        String baseObjectName = dc.get('Conditional_Field_'+ String.valueOf(i) + '_Object__c') != null ?
                                String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Object__c')) : '';
        String baseFieldName = dc.get('Conditional_Field_'+ String.valueOf(i) + '_Name__c') != null ?
                                String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Name__c')) : '';
        String baseDateFieldLookupFieldName = dc.get('Conditional_Field_'+ String.valueOf(i) + '_Lookup_Field_Name__c') != null ?
                                String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Lookup_Field_Name__c')) : '';
        String baseFieldType = dc.get('Conditional_Field_'+ String.valueOf(i) + '_Type__c') != null ?
                                String.valueOf(dc.get('Conditional_Field_'+ String.valueOf(i) + '_Type__c')) : '';

        if (baseObjectName == 'Federal_Register__c') {
            Federal_Register__c tempFR = new Federal_Register__c ();
            tempFR.Type__c = baseFieldType;
            tempFR.Published_Date__c = getFrDate(record, dc, baseFieldType);
            return (SObject)tempFR;
        } else {
            return getBaseObject(record, baseDateFieldLookupFieldName, baseObjectName);
        }
        return null;
    }

    @TestVisible private SObject getBaseObject(SObject record, String lookupFieldName, String baseObjectName) {
        Id tempId = (Id)record.get(lookupFieldName);
        SObject so = null;
        ADCVD_IMapper adcvdMapper = caseMapper.getMapper(baseObjectName);
        if (adcvdMapper != null) adcvdMapper.getInstance();
            System.debug(LoggingLevel.Debug, '*** adcvdMapper: ' + adcvdMapper);
        if (adcvdMapper != null && adcvdMapper.getMap(true) != null) {
            so = adcvdMapper.getMap(true).get(tempId);
        }
        System.debug(LoggingLevel.Debug, '***getBaseObject so: ' + so);
        return so;
    }

    @TestVisible private Date getFrDate(SObject record, Date_Calculation__mdt dc, String fieldType) {
        Id recordId = record.get('Id') != null ? (Id) record.get('Id') : null;
        Date returnDate = (frUtilMap != null && recordId != null && frUtilMap.get(recordId) != null && 
                            frUtilMap.get(recordId).typeToPublishedDateMap.get(fieldType) != null) ?
                            frUtilMap.get(recordId).typeToPublishedDateMap.get(fieldType) : null;
        return returnDate;
    }

    @TestVisible private void setDateCalculations(String soType, String recordTypeName) {
        if (dateCalculations == null || dateCalculations.isEmpty()) {
            Map<Integer, Date_Calculation__mdt> tempMap = new Map<Integer, Date_Calculation__mdt>();
            Integer numberOfCalculations = 0;
            for (Date_Calculation__mdt dc : CustomMetadataSelector.allDateCalculations) {
                if (dc.ADCVD_Objects__r.Object_API_Name__c == soType && dc.Active_Calculation__c &&
                    (String.isBlank(recordTypeName) || dc.ADCVD_Objects__r.Record_Type_Name__c == recordTypeName)) {
                    tempMap.put((Integer)dc.Order_of_Execution__c, dc);
                    numberOfCalculations = numberOfCalculations == 0 ? (Integer) dc.ADCVD_Objects__r.Number_of_Date_Calculations__c : numberOfCalculations;
                }
            }
            for (Integer i = 0; i <= numberOfCalculations; i++) {
                if (tempMap.get(i) != null) {
                    dateCalculations.put(tempMap.get(i).QualifiedAPIName, tempMap.get(i));
                }
            }
        }
    }

    @TestVisible private void setFrUtilMap(List<SObject> soList) {
        Set<Id> tempSet = new Set<Id>();
        for (SObject so : soList) {
            Id soId = so.get('Id') != null ? (Id) so.get('Id') : null;
            if (soId != null) {tempSet.add(soId);}
        }
        if (!tempSet.isEmpty()) {
            frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
            frUtilMap = frMapper.getMappedFRs(tempSet, caseMapper);
        }
    }
}