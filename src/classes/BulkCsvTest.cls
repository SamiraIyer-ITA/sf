@isTest
public with sharing class BulkCsvTest {
  private static String           csvFile;
  private static List<String>        csvArray       = new List<String>();       //an array for CSV file lines. Each entry is a new line. 
  private static Map<String, Integer>   headerFieldIndexMap= new Map<String, Integer>();
  private static Map<Integer, String>   headerColIndexMap  = new Map<Integer, String>();   //map key contains the column index and the value contains the column name
  private static Map<Integer, String>   assrtionsColIndexMap= new Map<Integer, String>();   //map key contains the column index and the value contains the column name
  private static Map<Integer, String>   inputColIndexMap  = new Map<Integer, String>();  //map key contains the column index and the value contains the column name

  private static List<String>        resultsList     = new List<String>();      //list of each test result
//  private static String           errorMessage     = '';              
  private static Integer           succesfulCount     = 0;              //number of records that passed assertions
  private static Integer           failureCount     = 0;              //number of records that failed to meet assertions
//  private static Boolean           firstLoop       = true;
  private static Boolean           failure       = false;            //Boolean to track whether or not a record failed
  private static FINAL String        PREFIX_INPUT     = 'I__';            //Prefix of columns for input values
  private static FINAL String        PREFIX_ASSERT     = 'AV__';            //Prefix of columns for assertion values
  //private static FINAL String        OBJECT_COLUMN     = 'I__Object';          //sObject column name
  private static FINAL String       EXTERNAL_ID_FIELD_NAME = 'External_Id__c';
  private static FINAL String       DESCRIPTION_COL    = 'Test_Description';
  private static FINAL String       EXTERNAL_ID_COL    = 'External ID';
  private static FINAL String       PARENT_RECORD_COL  = 'Parent Record';
  private static FINAL String       OBJECT_COL      = 'ObjectName';
  private static FINAL String       OPERATION_COL    = 'Operation Order';
  private static FINAL String       EXPECTED_DML_COL  = 'DMLSuccess';
  private static Integer           operationColIndex;                  //index of the operation order column
  private static Integer           parentRecordColIndex;                //index of the parent record column
  private static Integer           objectColumnIndex;                  //index of the object column 
  private static Integer           externalIdColumnIndex;                //index of the external ID
  private static Integer           descriptionColumnIndex;                //index of the description
  private static Integer           expectedDMLcolumnIndex;
  private static Map<Integer, List<String>>   orderedMapList   = new Map<Integer, List<String>>(); //map of unparsed rows grouped by operation order
  private static Map<String, Set<String>> objectQuerySet    = new Map<String, Set<String>>();

  private static String       outputCSVfile         = '';


  /* could have the same record as two different test rows, each with a different operation order */ 
  public class testRow {
    public Map<String, String> InputValueMap   = new Map<String, String>();
    public Map<String, String> AssrtValueMap   = new Map<String, String>(); //String of assert field, value of assert field
    public List<String> RecordErrors       = new List<String>();

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

        if(!String.isBlank(this.SObjectType)) {//if the object type is null, it is not a valid record
          this.InputValueMap.put(EXTERNAL_ID_FIELD_NAME, this.ExternalId); //validate external Id exists on object
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
  public static Map<Integer, TestRow> rowNumberToTestRow  = new Map<Integer, TestRow>();
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
  @isTest
  private static void testad() {
    runTestOnCsv('testad', 109);
  }
  @isTest
  private static void testcvd() {
    runTestOnCsv('testcvd', 85);
  }
  public static void runTestOnCsv(String fileName, Integer expectedCount) {
    //try {
      //query static resource
      csvFile = getStaticResource(fileName);
      //initialize file & populate header, input and assertion map
      initializeFile(csvFile);
      
      runOrderedOperation();
      system.assertEquals(expectedCount, validateAndAssert(), 'Wrong expected count');
      system.debug('CPU Time:' + LIMITS.getCpuTime());
      system.debug('DML Rows:' + LIMITS.getDmlRows());
      system.debug('SOQL Cnt:' + LIMITS.getQueries());
    //} catch (exception e) {
    //  system.assert(false, 'Test Failed to process correctly' + e.getMessage());
    //}
  }
  private static void runOrderedOperation() {
    
    for(Integer i: orderedTestRow.keySet()) { //loop through ordered set of operations
      Map<String, Integer> externalIdToCurrentRow = new Map<String, Integer>();
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
          }
          }
      }

        if(!sObjectListToUpdate.isEmpty()) {
          List<Database.SaveResult> srList = database.update(sObjectListToUpdate, false); 
        for (Database.SaveResult sr : srList) {
          if(sr.isSuccess()) {
            idsToQuery.add(sr.getId());
          }
          }
      }
      //loop through fields to query and build dynamic query
      for(String sObjToQuery : sObjectFieldsToQuery.keySet()) { 
        if(sObjToQuery == '') {continue;}
        String soqlQuery = 'SELECT Id, ' + EXTERNAL_ID_FIELD_NAME +' '; //build dynamic SOQL query
        for(String fieldToQuery: sObjectFieldsToQuery.get(sObjToQuery)) {
          soqlQuery += ', ' + fieldToQuery;
        }
        soqlQuery += ' FROM ' + sObjToQuery + ' WHERE ID IN: idsToQuery';
        List<sObject> objectsToValidate = database.query(soqlQuery);
        //validate fields are as expected
        for(sObject sObj: objectsToValidate) {
          String sObjExternalId = (String)sObj.get(EXTERNAL_ID_FIELD_NAME);
          Integer rowNumber = externalIdToCurrentRow.get(sObjExternalId);
          TestRow externalRow = externalIdToTestRow.get(sObjExternalId); //pull back existing related row
          ExternalRow.SfdcId = (Id)sObj.get('Id'); 
          TestRow relatedRow = rowNumberToTestRow.get(rowNumber);
          relatedRow.SfdcId = (Id)sObj.get('Id'); 
                     //populate ID into related row
          Map<String, String> expectedValues = relatedRow.AssrtValueMap; //pull expected values from the related testrow
          for(String field: expectedValues.keySet()) {
            Schema.DisplayType fieldType = getDataType(relatedRow.SObjectType, field);
            try{ 
             if(sObj.get(field) != stringToDisplayType(expectedValues.get(field), fieldType)) {
              relatedRow.RecordErrors.add('Unexpected value for field:' + field + '. Actual value: ' + sObj.get(field) + ' --- Expected Value: ' + expectedValues.get(field));
          }
              } catch (exception e) {
              	relatedRow.RecordErrors.add('Failed to test input value - error:' + e.getMessage());

            }
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
  //KNOWN LIMITATION - can not handle multiple parents of same sObjectType
  public static void buildParentsObjectMap(Set<String> sObjectSet) {
    for(String sObjName: sObjectSet) {
      if(String.isBlank(sObjName)) { continue; }
      system.debug(sObjName);

      //blows up if no external ID name is found?
      system.assert(validFieldName(sObjName, EXTERNAL_ID_FIELD_NAME), 'Expected external Id: ' + EXTERNAL_ID_FIELD_NAME + ' on object ' + sObjName + '. Please create the unique external ID field on the object.');
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
  public static object stringToDisplayType(String s, Schema.DisplayType fieldType) {
    object o;
    if(fieldType == Schema.DisplayType.Date) {
      o = Date.Parse(s);  
    } else if(fieldType == Schema.DisplayType.DateTime) {
      o = DateTime.Parse(s);  

    } else if(fieldType == Schema.DisplayType.Double ||
      fieldtype == Schema.DisplayType.Percent ||
      fieldType == Schema.DisplayType.Currency) {
      o = Decimal.ValueOf(s);

    } else if (fieldType == Schema.DisplayType.Reference) {
      //TODO - later 
    } else if (fieldType == Schema.DisplayType.Time) {
      //TODO - later 
    } else if (fieldType == Schema.DisplayType.DataCategoryGroupReference) {
      //TODO - later
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
  private static sObject createsObjectFromTestRow(TestRow tr) {
    sObject sObj;
    try {
      sObj = gd.get(tr.SObjectType).newSObject();
      if(!String.IsBlank(tr.ParentRecord)) {
        setParentByExternalId(tr, sObj);
      }
      for(String inputField: tr.InputValueMap.keySet()) {

        Schema.DisplayType fieldType = getDataType(tr.SObjectType, inputField);
        sObj.put(inputField, stringToDisplayType(tr.InputValueMap.get(inputField), fieldType));
        
      }
    } catch (exception e) {
      tr.RecordErrors.add('Failed to construct sObject from row: ' + e.getMessage());
    } 
    return sObj;
  }

  private static Boolean validFieldName(String sObjectName, String fieldName) {
    if(String.IsBlank(sObjectName.trim()) || String.isBlank(fieldName.trim()) || String.isBlank(fieldName) || getFieldsForSObject(sObjectName) == null) { return false; }
    return getFieldsForSObject(sObjectName).containsKey(fieldName.trim());
  }

  private static Map<String, Schema.SObjectField> getFieldsForSObject(String sObjectName){
    if(!String.IsBlank(sObjectName) && gd.get(sObjectName.trim()) != null){
      return gd.get(sObjectName.trim()).getDescribe().fields.getMap();
      } 
      return null;
  }

  private static Schema.DisplayType getDataType(String sObjectName, String fieldName) {
    return getFieldsForSObject(sObjectName).get(fieldName).getDescribe().getType();
  } 

  private static string getStaticResource(String fileName) {
    StaticResource sr = [SELECT Id, Body
                                  FROM StaticResource 
                                  WHERE Name =: fileName
                                  LIMIT 1];
        Blob csvBlob = sr.Body;
    String csvBody = csvBlob.toString();

    return csvBody;
  }
  //this method reads the header & populate maps
  private static void populateHeaderMaps(List<String> headerRow) {
    for(Integer i = 0; i < headerRow.size(); i++) {

      String s = headerRow[i].trim();
      system.debug(s);
      if(s == DESCRIPTION_COL) {
        descriptionColumnIndex = i;  
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
      }
      if(s.startsWith(PREFIX_ASSERT)) {
        s = s.remove(PREFIX_ASSERT);
        assrtionsColIndexMap.put(i, s.trim());
      } else if (s.startsWith(PREFIX_INPUT)) {
        s = s.remove(PREFIX_INPUT);
        inputColIndexMap.put(i, s.trim());
      }
      headerFieldIndexMap.put(s.trim(), i);
      headerColIndexMap.put(i, s.trim());
    }
    system.assert(descriptionColumnIndex != null, 'Invalid description column index. Expecting column: ' + DESCRIPTION_COL);
    system.assert(externalIdColumnIndex != null, 'Invalid externalId column index. Expecting column: ' + EXTERNAL_ID_COL);
    system.assert(parentRecordColIndex != null, 'Invalid parentRecord column index. Expecting column: ' + PARENT_RECORD_COL);
    system.assert(objectColumnIndex != null, 'Invalid object column index. Expecting column: ' + OBJECT_COL);
    system.assert(operationColIndex != null, 'Invalid operation order column index. Expecting column: ' + OPERATION_COL);
    system.assert(expectedDMLcolumnIndex != null, 'Invalid expectedDML column index. Expecting column: ' + EXPECTED_DML_COL);
  }
  /* initialize the file */ 
  private static void initializeFile(String myCsvFileString) {
    //split csv into an array
    //does not handle intra cell line breaks
    csvArray = myCsvFileString.split('\n');
    //read the header & populate maps

    populateHeaderMaps(parseCSVLine(csvArray[0]));
    //build testRows
    Set<String> sObjectSet = new Set<String>();
    for(Integer i = 1; i < csvArray.size(); i++) {
      if(!String.IsBlank(csvArray[i].replaceAll(',','').replaceAll(' ', ''))) {
        TestRow tr = new TestRow(parseCSVLine(csvArray[i]), i+1);
        sObjectSet.add(tr.SObjectType);
      }
    }
    buildParentsObjectMap(sObjectSet);
    
     }
     private static Integer validateAndAssert() {
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
     
     private static void finish() {
       if(failureCount > 0) {
         //loop through errors and print out failure rows
       } 
       //loop through success and print out errors

       system.assertEquals(failureCount, 0);
    
     }
}