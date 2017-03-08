//TODO - create user story on "has tolling days been applied" to an investigation / petition / segment//
@isTest
public without sharing class BulkCsvTest {
    @isTest
    private static void testad() {
        runTestOnCsv('testad', 59);
    }
    @isTest
    private static void testadholiday() {
        runTestOnCsv('testadholiday', 65);
    }
    @isTest
    private static void testCvdHoliday() {
        runTestOnCsv('testCvdHoliday', 61);
    }
    @isTest
    private static void testcvd() {
        runTestOnCsv('testcvd', 55);
    }
    @isTest
    private static void Mario_CVD_unitTest_1TdAfterSD() {
        runTestOnCsv('Mario_CVD_unitTest_1TdAfterSD', 55);
    }
    @isTest
    private static void Mario_CVD_unitTest_1TdBeforeSD() {
        runTestOnCsv('Mario_CVD_unitTest_1TdBeforeSD', 55);
    }
    @isTest
    private static void testnegative() {
        runTestOnCsv('testnegative', 59);
    }
    @isTest
    private static void testtolling() {
        runTestOnCsv('testtolling', 85);
    }
    @isTest
    private static void testtollingEnd() {
        runTestOnCsv('TestEndDateBetweenTollingDaysCVD', 60);
    }
    @isTest
    private static void Mario_CVD_unitTest_2TdBetweenSDandED(){
        runTestOnCsv('Mario_CVD_unitTest_2TdBetweenSDandED', 55);
    }
    private static String               csvFile;
    private static List<String>       csvArray       = new List<String>();       //an array for CSV file lines. Each entry is a new line. 
    private static Map<String, Integer>   headerFieldIndexMap= new Map<String, Integer>();
    private static Map<Integer, String>   headerColIndexMap  = new Map<Integer, String>();   //map key contains the column index and the value contains the column name
    private static Map<Integer, String>   assrtionsColIndexMap= new Map<Integer, String>();   //map key contains the column index and the value contains the column name
    private static Map<Integer, String>   inputColIndexMap  = new Map<Integer, String>();  //map key contains the column index and the value contains the column name

    private static List<String>       resultsList     = new List<String>();      //list of each test result
    private static Integer              succesfulCount     = 0;              //number of records that passed assertions
    private static Integer              failureCount     = 0;              //number of records that failed to meet assertions
    private static Boolean              failure       = false;            //Boolean to track whether or not a record failed
    private static FINAL String       PREFIX_INPUT     = 'I__';            //Prefix of columns for input values
    private static FINAL String       PREFIX_ASSERT     = 'AV__';            //Prefix of columns for assertion values
    private static FINAL String       EXTERNAL_ID_FIELD_NAME = 'External_Id__c';
    private static FINAL String       DESCRIPTION_COL    = 'Test_Description';
    private static FINAL String       EXTERNAL_ID_COL    = 'External ID';
    private static FINAL String       PARENT_RECORD_COL  = 'Parent Record';
    private static FINAL String         RECORD_TYPE         = 'RecordType.Name';
    private static FINAL String       OBJECT_COL      = 'ObjectName';
    private static FINAL String       OPERATION_COL    = 'Operation Order';
    private static FINAL String       EXPECTED_DML_COL  = 'DMLSuccess';
    private static Integer              operationColIndex;                  //index of the operation order column
    private static Integer          recordTypeColumnIndex;
    private static Integer              parentRecordColIndex;                //index of the parent record column
    private static Integer              objectColumnIndex;                  //index of the object column 
    private static Integer              externalIdColumnIndex;                //index of the external ID
    private static Integer              descriptionColumnIndex;                //index of the description
    private static Integer              expectedDMLcolumnIndex;
    private static Map<Integer, List<String>>   orderedMapList   = new Map<Integer, List<String>>(); //map of unparsed rows grouped by operation order
    private static Map<String, Set<String>> objectQuerySet    = new Map<String, Set<String>>();
    private static Set<String>      sObjectToExcludeFromValidation = new Set<String>{'Holiday'};
    private static String           outputCSVfile         = '';
	@isTest
	private static void testad() {
		runTestOnCsv('testad', 59);
	}
	@isTest
	private static void testad_initiation_extension_bound() {
		runTestOnCsv('testad_initiation_extension_bound', 59);
	}
	@isTest
	private static void testad_final_extension_bound() {
		runTestOnCsv('testad_initiation_extension_bound', 59);
	}
	@isTest
	private static void testad_preliminary_extension_bound() {
		runTestOnCsv('testad_preliminary_extension_bound', 59);
	}
	@isTest
	private static void testad_holiday() {
		runTestOnCsv('testad_holiday', 63);
	}
	@isTest
	private static void testad_tolling_day_after_end_date() {
		runTestOnCsv('testad_tolling_day_after_end_date', 58);
	}
	@isTest
	private static void testad_tolling_day_before_start_date() {
		runTestOnCsv('testad_tolling_day_before_start_date', 58);
	}
	@isTest
	private static void testad_tolling_day_between_both_dates() {
		runTestOnCsv('testad_tolling_day_between_both_dates', 58);
	}
	@isTest
	private static void testad_tolling_day_between_end_date() {
		runTestOnCsv('testad_tolling_day_between_end_date', 58);
	}
	@isTest
	private static void testad_tolling_day_between_start_date() {
		runTestOnCsv('testad_tolling_day_between_start_date', 58);
	}	
	@isTest
	private static void testcvd() {
		runTestOnCsv('testcvd', 55);
	}
	@isTest
	private static void testcvd_initiation_extension_bound() {
		runTestOnCsv('testcvd_initiation_extension_bound', 55);
	}
	@isTest
	private static void testcvd_final_extension_bound() {
		runTestOnCsv('testcvd_initiation_extension_bound', 55);
	}
	@isTest
	private static void testcvd_preliminary_extension_bound() {
		runTestOnCsv('testcvd_preliminary_extension_bound', 55);
	}
	@isTest
	private static void testcvd_tolling_day_after_end_date() {
		runTestOnCsv('testcvd_tolling_day_after_end_date', 55);
	}
	@isTest
	private static void testcvd_tolling_day_before_start_date() {
		runTestOnCsv('testcvd_tolling_day_before_start_date', 55);
	}
	@isTest
	private static void testcvd_tolling_day_between_both_dates() {
		runTestOnCsv('testcvd_tolling_day_between_both_dates', 55);
	}
	@isTest
	private static void testcvd_tolling_day_between_start_date() {
		runTestOnCsv('testcvd_tolling_day_between_start_date', 55);
	}
	@isTest
	private static void testcvd_tolling_day_between_end_date() {
		runTestOnCsv('testcvd_tolling_day_between_end_date', 55);
	}
	@isTest
	private static void testcvd_holiday() {
		runTestOnCsv('testcvd_holiday', 46);
	}


  /* could have the same record as two different test rows, each with a different operation order */ 
    public class testRow {
        public Map<String, String> InputValueMap   = new Map<String, String>();
        public Map<String, String> AssrtValueMap   = new Map<String, String>(); //String of assert field, value of assert field
        public List<String> RecordErrors       = new List<String>();
        public Id RecordType            = null;
        public Boolean ExpectedDML           = true;
        public String Description           = '';
        public String ExternalId            = ''; 
        public String ParentRecord           = '';
        public String SObjectType           = '';
        public Integer OperationOrder         = 0;
        public Integer RowNumber;

        public Id SfdcId {
            get; 
            set {
                this.SfdcId = value; //set value of SFDC ID
                if(this.ExpectedDML == false) { //if expected result was false, add an error
                    this.RecordErrors.add('Expected Failure, but DML performed successfully');
                }
            }
        }
        public Boolean Error             {
            get {
                if(this.ExpectedDML == true && this.SfdcId == null) { //if ID is null, but expected it is not, add an error
                    this.RecordErrors.add('Expected the record to get have successful DML, but it was not successful.');
                }
                if(this.RecordErrors.isEmpty()) { //if there are record errors - then the record had an error in general
                    return false;
                } else {
                    return true;
                }
            }
        }
        

        public testRow(List<String> myCurrentRow, Integer rowNumber) {
            try {
                this.Description     = myCurrentRow[descriptionColumnIndex];
                this.ExternalId     = myCurrentRow[externalIdColumnIndex];
                this.ParentRecord     = myCurrentRow[parentRecordColIndex];
                this.SObjectType     = myCurrentRow[objectColumnIndex];
                this.OperationOrder   = String.isBlank(myCurrentRow[operationColIndex]) ? 0 : Integer.valueOf(myCurrentRow[operationColIndex]);
                this.ExpectedDML     = String.isBlank(myCurrentRow[expectedDMLcolumnIndex]) ? TRUE : Boolean.valueOf(myCurrentRow[expectedDMLcolumnIndex]);
                this.RowNumber      = rowNumber;
                
                if(recordTypeColumnIndex != null && !String.isBlank(myCurrentRow[recordTypeColumnIndex])) {
                    this.RecordType = getRecordTypeIdByName(this.sObjectType, myCurrentRow[recordTypeColumnIndex]);
                }

                if(!String.isBlank(this.SObjectType)) {//if the object type is null, it is not a valid record
                    //TODO - if object does not exist, throws an error that the external id does not exist
                    if(!sObjectToExcludeFromValidation.contains(this.SObjectType)){
                        this.InputValueMap.put(EXTERNAL_ID_FIELD_NAME, this.ExternalId); //validate external Id exists on object
                    } else {
                        this.ExpectedDML = false; // dont validate if they are setup objects?
                    }
                    
                    for(Integer i = 0; i < myCurrentRow.size(); i++) { //iterate over row
                        String cellValue = myCurrentRow[i];      //value of the cell in scope
                        String columnName = headerColIndexMap.get(i);  //the name of the column
                        if(cellValue.trim() != '') {       //ignore blank cells
                            if(!validFieldName(this.sObjectType, columnName) && (inputColIndexMap.containsKey(i) || assrtionsColIndexMap.containsKey(i))) {    //validate field is valid for sObject
                                this.RecordErrors.add('Invalid column name ' + columnName + ' for the sObject ' + this.sObjectType);
                            } else {
                                if(inputColIndexMap.containsKey(i)) {
                                    this.InputValueMap.put(inputColIndexMap.get(i), cellValue);
                                }
                                if(assrtionsColIndexMap.containsKey(i)) {
                                    this.AssrtValueMap.put(assrtionsColIndexMap.get(i), cellValue);
                                }
                            }
                        }
                    }
                }
            } catch (exception e) {
                this.RecordErrors.add(e.getMessage());
            } finally {
                allTestRows.add(this);
                externalIdToTestRow.put(this.ExternalId, this);
                rowNumberToTestRow.put(this.RowNumber, this);
            }
        }
    }
  
    public static Map<String, TestRow> externalIdToTestRow = new Map<String, TestRow>();
    public static Map<Integer, TestRow> rowNumberToTestRow = new Map<Integer, TestRow>();
    public static List<TestRow> allTestRows = new List<TestRow>();
  
  /* Ordered List of Rows to Process - ordered by OperationOrder column */
    public static Map<Integer, List<TestRow>> orderedTestRow {
        get {
            if(orderedTestRow == null) {
                orderedTestRow = new Map<Integer, List<TestRow>>();
                for(TestRow tr: allTestRows) {
                    List<TestRow> currentTrList;
                    if(orderedTestRow.get(tr.OperationOrder) == null) {
                    currentTrList = new List<TestRow>();
                    } else {
                    currentTrList = orderedTestRow.get(tr.OperationOrder);
                    }
                    currentTrList.add(tr);
                    orderedTestRow.put(tr.OperationOrder, currentTrList);
                }
            }
        return orderedTestRow;
        }
    }
  /* Enhancement list 
  *  User interface to load CSVs. Auto create the apex unit test. 
  *  Test Result object
  *  Option to run tests, roll back, and generate / attach CSV to test result
  * 
  */
    
    public static void runTestOnCsv(String fileName, Integer expectedCount) {
    //try {
        //query static resource
        csvFile = getStaticResource(fileName);
        //initialize file & populate header, input and assertion map
        initializeFile(csvFile);
        
        runOrderedOperation();
        
        system.assertEquals(expectedCount, closeout(), 'Wrong expected count');
    //} catch (exception e) {
    //  system.assert(false, 'Test Failed to process correctly' + e.getMessage());
    //}
    }

    
    private static User adminUser {
        get {
            if(adminUser == null) {
                String uniqueString = String.ValueOf(System.Now().getTime());
                Id adminProfileId = [SELECT Id FROM Profile WHERE Name=: 'System Administrator' LIMIT 1].Id;
                adminUser = new User();
                adminUser.ProfileId = adminProfileId;
                adminUser.isActive = true;
                adminUser.Alias = uniqueString.left(7);
                adminUser.LocaleSidKey = 'en_US';
                adminUser.LanguageLocaleKey='en_US';
                adminUser.LastName = uniqueString;
                adminUser.FirstName = uniqueString;
                adminUser.EmailEncodingKey = 'ISO-8859-1';
                adminUser.Email = uniqueString + '@' + uniqueString  +'.com';
                adminUser.TimeZoneSidKey = 'America/New_York';
                adminUser.CommunityNickname = uniqueString;
                adminUser.UserName = uniqueString + '@' + uniqueString  +'.com';
                insert adminUser;

                }
            return adminUser;
            } 
    set;}

    /* method to process ALL test rows - processes them by the ordered key */
    private static void runOrderedOperation() {
        for(Integer i: orderedTestRow.keySet()) { //loop through ordered set of operations
            if(i == 0 && Test.isRunningTest()) { //operation order 0 is for data setup
            test.startTest();
            System.runAs(adminUser){
                runOrderedRow(i);
            }
            test.stopTest();
            } else {
            //system.runAs(adminUser) {
                runOrderedRow(i);
            //}
            }
        } // end loop
    }

    //map used to keep track of what row is being processed for a given external ID at a given time
    private static Map<String, Integer> externalIdToCurrentRow = new Map<String, Integer>();
    /* method processes a given integer value */
    private static void runOrderedRow(Integer i) {
        List<sObject> sObjectListToInsert = new List<sObject>();//list of records to insert
        List<sObject> sObjectListToUpdate = new List<sObject>();//list of records to update
        Set<Id> idsToQuery = new Set<Id>();           //set of IDs to query once validation is complete

        Map<String, Set<String>> sObjectFieldsToQuery = new Map<String, Set<String>>(); //map for all fields to query for given sObject
        for(TestRow tr: orderedTestRow.get(i)){ //loop through rows, populate maps to query
            externalIdToCurrentRow.put(tr.ExternalId, tr.RowNumber);
            Set<String> assrtFieldSet;      //set of fields to assert and ensure values are correct
            if(sObjectFieldsToQuery.get(tr.SObjectType) == null) { //ensure value exists, if not instantiate it
                assrtFieldSet = new Set<String>();
            } else {
                assrtFieldSet = sObjectFieldsToQuery.get(tr.SObjectType);
            }
            assrtFieldSet.addAll(tr.AssrtValueMap.keySet());    //add values to the set to query
            sObjectFieldsToQuery.put(tr.SObjectType, assrtFieldSet);
            
            TestRow relatedRow = externalIdToTestRow.get(tr.ExternalId); //pull back existing related row
            //TODO - if same row occurs twice and has different assertions it will fail
            //sObject list do not support upsert
            if(createsObjectFromTestRow(tr) != null) {
                system.debug('Creating sObject from row' + tr);
                if(relatedRow.SfdcId == null) { //insert record if it has not been populated already
                    sObjectListToInsert.add(createsObjectFromTestRow(tr));
                } else {             //update record if it exists already
                    sObjectListToUpdate.add(createsObjectFromTestRow(tr));
                }
            }
        }

        if(!sObjectListToInsert.isEmpty()) {
            List<Database.SaveResult> srList = database.insert(sObjectListToInsert, false); 
            for (Database.SaveResult sr : srList) {
                if(sr.isSuccess()) {
                    idsToQuery.add(sr.getId());
                } else {
                    system.debug('DML Failure' + sr.getErrors());
                }
            }
        }

        if(!sObjectListToUpdate.isEmpty()) {
            List<Database.SaveResult> srList = database.update(sObjectListToUpdate, false); 
            for (Database.SaveResult sr : srList) {
                if(sr.isSuccess()) {
                    idsToQuery.add(sr.getId());
                } else {
                    system.debug('V&A Record failed:' + sr + PARSER.CRLF + 'V&A DML Error: ' + sr.getErrors());
                }
            }
        }
        validateAndAssert(sObjectFieldsToQuery, idsToQuery);
    }

    public static void validateAndAssert(Map<String, Set<String>> sObjectFieldsToQuery, Set<Id> idsToQuery) {
        /* QUERY - VALIDATE AND ASSERT -- V&A */

        //loop through each object that was part of the operation order and build dynamic query
        for(String sObjToQuery : sObjectFieldsToQuery.keySet()) {
            //TODO skip certain objects ? ... should we query setup records?
            if(sObjectToExcludeFromValidation.contains(sObjToQuery)) {continue;}
            //skip blank objects
            if(sObjToQuery == '') {continue;}
            
            //build dynamic query
            String soqlQuery = 'SELECT Id, ' + EXTERNAL_ID_FIELD_NAME +' '; //build dynamic SOQL query
            for(String fieldToQuery: sObjectFieldsToQuery.get(sObjToQuery)) {
                soqlQuery += ', ' + fieldToQuery;
            }
            soqlQuery += ' FROM ' + sObjToQuery + ' WHERE ID IN: idsToQuery';
            //Yes - query in a for loop - it is possible two different sObjects could be updated in the same operation order.
            //we will want to validate all of them regardless.
            List<sObject> recordsToValidate = database.query(soqlQuery);
    
                //validate fields are as expected
                for(sObject sObj: recordsToValidate) {
                    //initialized record maps
                    String sObjExternalId = (String)sObj.get(EXTERNAL_ID_FIELD_NAME);
                    Integer rowNumber = externalIdToCurrentRow.get(sObjExternalId);
                    TestRow externalRow = externalIdToTestRow.get(sObjExternalId); //pull back existing related row
                    ExternalRow.SfdcId = (Id)sObj.get('Id'); 
                    if(externalRow == null) {
                        system.debug('V&A Error - row not found:' + sObjExternalId);
                        continue;
                    }

                    //populate ID into related row (will be used for updates later)
                    TestRow relatedRow = rowNumberToTestRow.get(rowNumber);
                    relatedRow.SfdcId = (Id)sObj.get('Id'); 
                    
                    /* Validate values from Database match what was expected */
                    Map<String, String> expectedValues = relatedRow.AssrtValueMap; //pull expected values from the related testrow
                    for(String field: expectedValues.keySet()) {
                        Schema.DisplayType fieldType = getDataType(relatedRow.SObjectType, field);
                        try{ 
                            if(sObj.get(field) != stringToDisplayType(expectedValues.get(field), fieldType)) {
                                relatedRow.RecordErrors.add('V&A: Row ' + rowNumber + 'Unexpected value for field:' + field + ' Actual value: ' + sObj.get(field) + ' - Expected Value: ' + expectedValues.get(field));
                            }
                        } catch (exception e) {
                            relatedRow.RecordErrors.add('Failed to test input value - error:' + e.getMessage());
                        }
                    }
                }
            }
        }
    //map key = sObject name, returns map of object (key) to relationship name (value)
    public static Map<String, Map<String, String>> sObjectToParentMap = new Map<String, Map<String, String>>();
    public static Map<String, Schema.SObjectType> gd { 
        get {
            if(gd == null) {
            gd = Schema.getGlobalDescribe();
            } 
            return gd;
        } set;
    }
    private static Id getRecordTypeIdByName(String sObjName, String recordTypeName) {
        if(String.isBlank(sObjName) 
            || String.isBlank(recordTypeName)
            || gd.get(sObjName) == null
            || gd.get(sObjName).getDescribe().getRecordTypeInfosByName() == null
            || gd.get(sObjName).getDescribe().getRecordTypeInfosByName().get(recordTypeName) == null
            ) {
            return null;
        }
        return gd.get(sObjName).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    //TODO - KNOWN LIMITATION - cannot handle / differentiate multiple parents of same sObjectType
    public static void buildParentsObjectMap(Set<String> sObjectSet) {
        for(String sObjName: sObjectSet) {
            if(String.isBlank(sObjName)) { continue; }

            //TODO - need it to throw and error if the OBJECT does not exist - should say object does not exist - but states external Id does not exist
            //throw error blows up if no external ID name is found
            if(!sObjectToExcludeFromValidation.contains(sObjName)) {
                system.assert(validFieldName(sObjName, EXTERNAL_ID_FIELD_NAME), 'Expected external Id: ' + EXTERNAL_ID_FIELD_NAME + ' on object ' + sObjName + '. Please create the unique external ID field on the object.');
            }
            Map<String, String> objNameToRelationshipName = new Map<String, String>();
            Schema.SObjectType sObjType = gd.get(sObjName); //dynamic binding of sObject name to schema
            for(Schema.SobjectField strFld: sObjType.getDescribe().fields.getMap().Values()) {
                if(strFld.getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                    String parentObj = '' + strFld.getDescribe().getReferenceTo()[0];     //object name of parent
                    String relationshipName = (String)strFld.getDescribe().getRelationshipName(); //field relationship name of parent
                    objNameToRelationshipName.put(parentObj, relationshipName);
                } 
            }
            sObjectToParentMap.put(sObjName, objNameToRelationshipName);
        }
    }

    /* sets the parent record by the external ID of the parent - auto looksup sObjectType*/
    private static void setParentByExternalId(TestRow tr, sObject sObj) {
        try {
            TestRow parentRecord = externalIdToTestRow.get(tr.ParentRecord);
            sObject parentSObj = gd.get(parentRecord.SObjectType).newSObject();
            parentSObj.put(EXTERNAL_ID_FIELD_NAME, parentRecord.ExternalId);
            //case sensitive SObject Name - bad
            Map<String, String> parentFieldMap = sObjectToParentMap.get(tr.SObjectType);
            String relationshipFieldName = parentFieldMap.get(parentRecord.SObjectType);
            sObj.putSObject(relationshipFieldName, parentSObj);
        } catch (exception e) {
            tr.RecordErrors.add('Failed to set parent from row:' + e.getMessage());
        }
    }

    /* method used to convert CSV string to the correct data type */
    public static object stringToDisplayType(String s, Schema.DisplayType fieldType) {
        object o;
        s = s.trim();
        if(fieldType == Schema.DisplayType.Date) {
            o = Date.Parse(s);
        } else if(fieldType == Schema.DisplayType.DateTime) {
            o = DateTime.Parse(s);  

        } else if(fieldType == Schema.DisplayType.Double ||
            fieldtype == Schema.DisplayType.Percent ||
            fieldType == Schema.DisplayType.Currency) {
            o = Decimal.ValueOf(s);

        } else if (fieldType == Schema.DisplayType.Reference) {
            o = Id.ValueOf(s);
        } else if (fieldType == Schema.DisplayType.Time) {
            system.debug('##Time:' + s);
        } else if (fieldType == Schema.DisplayType.DataCategoryGroupReference) {
            system.debug('##DataCategoryGroupReference:' + s);
        } else if (fieldType == Schema.DisplayType.Boolean) {
            o = Boolean.ValueOf(s);
        } else if (fieldType == Schema.DisplayType.DOUBLE) {
            o = Double.ValueOf(s);
        } else if (fieldType == Schema.DisplayType.ID) {
            o = ID.ValueOf(s);
        } else if (fieldType == Schema.DisplayType.Integer) {
            o = Integer.ValueOf(s);
        } else {
            o = s;
        } 
        return o;
    }

    /* this method takes a test row as an input and returns an sObject */
    private static sObject createsObjectFromTestRow(TestRow tr) {
        sObject sObj;
        try {
            sObj = gd.get(tr.SObjectType).newSObject();
            if(!String.IsBlank(tr.ParentRecord)) { //associate to a parent if needed
                setParentByExternalId(tr, sObj);
            }
            if(tr.RecordType != null) {
                sObj.put('RecordTypeId', tr.RecordType);
            }
            /* loop through input fields and set the correct values in the sObject */ 
            for(String inputField: tr.InputValueMap.keySet()) {
                if(tr.SfdcId != null) {
                    sObj.put('Id', tr.SfdcId);
                }
                Schema.DisplayType fieldType = getDataType(tr.SObjectType, inputField);
                sObj.put(inputField, stringToDisplayType(tr.InputValueMap.get(inputField), fieldType));
            }
        } catch (exception e) {
            tr.RecordErrors.add('Failed to construct sObject from row: ' + e.getMessage());
        }
        return sObj;
    }

    /* method used to check if a field name is valid for a given sObject */
    private static Boolean validFieldName(String sObjectName, String fieldName) {
        if(String.IsBlank(sObjectName.trim()) 
            || String.isBlank(fieldName.trim()) 
            || String.isBlank(fieldName) 
            || getFieldsForSObject(sObjectName) == null
            ) { 
            return false; 
        } 

        return getFieldsForSObject(sObjectName).containsKey(fieldName.trim());
    }

    /* method returns field names for a given sObject */
    private static Map<String, Schema.SObjectField> getFieldsForSObject(String sObjectName){
        if(!String.IsBlank(sObjectName) && gd.get(sObjectName.trim()) != null){
            return gd.get(sObjectName.trim()).getDescribe().fields.getMap();
        } 
        return null;
    }

    /* method returns data type of given sObject's field name */
    public static Schema.DisplayType getDataType(String sObjectName, String fieldName) {
        return getFieldsForSObject(sObjectName).get(fieldName).getDescribe().getType();
    } 

    /* method to query a static resource and return as string */
    private static string getStaticResource(String fileName) {
        StaticResource sr = [SELECT Id, Body
                                        FROM StaticResource 
                                        WHERE Name =: fileName
                                        LIMIT 1];
            Blob csvBlob = sr.Body;
        String csvBody = csvBlob.toString();

        return csvBody;
    }
    

    /* populateHeaderMaps - reads the header row - 
     * populates the column index for expected columns (description, external Id, etc)
     * then separates the input and the assert values into different maps
     */
    private static void populateHeaderMaps(List<String> headerRow) {
        for(Integer i = 0; i < headerRow.size(); i++) {
            String s = headerRow[i].trim();
            if(s == DESCRIPTION_COL) {
                descriptionColumnIndex = i; 
            } else if (s == RECORD_TYPE) {
                recordTypeColumnIndex = i;
            } else if (s == EXTERNAL_ID_COL) {
                externalIdColumnIndex = i;
            } else if (s == PARENT_RECORD_COL) {
                parentRecordColIndex = i;
            } else if (s == OBJECT_COL) {
                objectColumnIndex = i;  
            } else if (s == OPERATION_COL) {
                operationColIndex = i;
            } else if (s == EXPECTED_DML_COL) {
                expectedDMLcolumnIndex = i;
            } else if(s.startsWith(PREFIX_ASSERT)) {
                s = s.remove(PREFIX_ASSERT);
                assrtionsColIndexMap.put(i, s.trim());
            } else if (s.startsWith(PREFIX_INPUT)) {
                s = s.remove(PREFIX_INPUT);
                inputColIndexMap.put(i, s.trim());
            }
            headerFieldIndexMap.put(s.trim(), i);
            headerColIndexMap.put(i, s.trim());
        }
        /* validates the expected fields exist */
        system.assert(descriptionColumnIndex != null, 'Invalid description column index. Expecting column: ' + DESCRIPTION_COL);
        system.assert(externalIdColumnIndex != null, 'Invalid externalId column index. Expecting column: ' + EXTERNAL_ID_COL);
        system.assert(parentRecordColIndex != null, 'Invalid parentRecord column index. Expecting column: ' + PARENT_RECORD_COL);
        system.assert(objectColumnIndex != null, 'Invalid object column index. Expecting column: ' + OBJECT_COL);
        system.assert(operationColIndex != null, 'Invalid operation order column index. Expecting column: ' + OPERATION_COL);
        system.assert(expectedDMLcolumnIndex != null, 'Invalid expectedDML column index. Expecting column: ' + EXPECTED_DML_COL);
    }
    /* initializes the file - takes a CSV string*/ 
    private static void initializeFile(String myCsvFileString) {
        /* TODO - fix bug where if the last row is blank - the last row fails to get inserted correctly */
        myCsvFileString += (Parser.CRLF + ',,'); //hack to resolve last row issue
        
        //split csv into an array
        //TODO - handle intra cell line breaks
        csvArray = myCsvFileString.split('\n');

        //read the header & populate maps
        populateHeaderMaps(parseCSVLine(csvArray[0]));

        //build testRows
        Set<String> sObjectSet = new Set<String>();
        for(Integer i = 1; i < csvArray.size(); i++) {
            if(!String.IsBlank(csvArray[i].replaceAll(',','').replaceAll(' ', ''))) { //ignore rows that are blank
                TestRow tr = new TestRow(parseCSVLine(csvArray[i]), i+1); //create a test row - keep track of which row of file it is
                sObjectSet.add(tr.SObjectType);
            }
        }
        //build the parent maps
        buildParentsObjectMap(sObjectSet);
     }

     private static Integer closeout() {
         Integer successCount = 0;
         Integer errorCount = 0;
         for(TestRow tr: allTestRows) {
         if(!tr.Error) {
             successCount++;
            } else {
            errorCount++;
            for(String s: tr.RecordErrors) {
                system.debug('V&A Test Failure:' + tr.RowNumber + ':' + s + ':' + tr);
            }
            }
        }
        system.debug('V&A success count:' + successCount);
        system.debug('V&A error count: ' + errorCount);
        system.debug('V&A Total Count: ' + allTestRows.size());

        system.debug('System Stats CPU Time:' + LIMITS.getCpuTime());
        system.debug('System Stats DML Rows:' + LIMITS.getDmlRows());
        system.debug('System Stats SOQL Cnt:' + LIMITS.getQueries());
        return successCount;
    }
    
    private static List<String> parseCSVLine(String contents) {
        //https://developer.salesforce.com/page/Code_Samples#Parse_a_CSV_with_APEX
        List<String> allFields = new List<String>();
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        Integer num = 0;
        List<String> fields = contents.split(',');
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field: fields) {
            if (field.startsWith('"') && field.endsWith('"')) {
            cleanFields.add(field.replaceAll('DBLQT','"'));
            } else if (field.startsWith('"')) {
            makeCompositeField = true;
            compositeField = field;
            } else if (field.endsWith('"')) {
            compositeField += ',' + field;
            cleanFields.add(compositeField.replaceAll('DBLQT','"'));
            makeCompositeField = false;
            } else if (makeCompositeField) {
            compositeField +=  ',' + field;
            } else {
            cleanFields.add(field.replaceAll('DBLQT','"'));
            }
        }
        return cleanFields;
    }

    /*TODO- method is currently unused - will be used later to generate a CSV output on actual data imports */
    private void addLineToOutput(String csvRecord, String msg, List<sObject> sObjectList) {
        String newCSVLine = csvRecord;
        if(sObjectList != null && !sObjectList.isEmpty()) {
            succesfulCount++;
            for(sObject s: sObjectList) {
        
            }
        } else {
            failureCount++;
            newCSVLine += ',Failure: ' + msg;
        }
        outputCSVfile += newCSVLine + Parser.CRLF;
    }
}