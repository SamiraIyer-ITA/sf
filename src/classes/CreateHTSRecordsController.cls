/*************************************
*  This class is a service class to the AttachmentWriterContoller class.   
*  It extracts valid Harmonized Tariff Schedule (HTS) numbers from the Scope (Scope.txt attachment) field 
*  in the ADCVD Orders or Suspension Agreements, using a regular expression. Once valid HTS numbers are  
*  obtained, the decimals are removed and HTS records created for the corresponding object - which is  
*  either an ADCVD Order or a Suspension Agreement.

*  Author: Samira Iyer
*  Created On: 1/23/2018
***************************************/

public class CreateHTSRecordsController{
    public Id recordId {get; set;}
    public String attachmentBody {get; set;}
    public Id attachmentId {get; set;}
    public String objectName {get; set;}

    private FINAL String HTS_REG_EX = '((?m)(\\d{4}\\.)((\\d{2}|\\d{4})(\\.?\\d{2}|\\d{4})*))';
    private List<String> htsNumListWithDecimals = new List<String>();    
    private Id relatedCaseId;
    /* Extension Controller */
    public CreateHTSRecordsController(AttachmentWriterController con) 
    { 
     	this.objectName = con.objectName;
        this.recordId = con.recordId;
     	this.attachmentBody = con.attachmentBody;
     	this.attachmentId = con.attachmentId;
        mainMethod();
    }   

    /* This is the main method calling other methods */
      public void mainMethod() {
    	if(attachmentBody != null && recordId != null) {    
    		Map <String, Harmonized_Tariff_Schedule__c> existingHTSNumMap = new Map <String, Harmonized_Tariff_Schedule__c>();
            List<Harmonized_Tariff_Schedule__c> existingHTSNumList = [Select Id, HTS_Number__c, Name, ADCVD_Order__r.ADCVD_Case__c, Suspension_Agreement__r.ADCVD_Case__c from Harmonized_Tariff_Schedule__c where ADCVD_Order__c =:recordId OR Suspension_Agreement__c =:recordId];
            For (Harmonized_Tariff_Schedule__c htsNums: existingHTSNumList) {
                existingHTSNumMap.put(htsNums.HTS_Number__c, htsNums);
            }
            List<String> htsNumList = getHTSNumber(attachmentBody);
            Map<String, String> htsNumMap = getHTSNumMap(htsNumList);
            createHTSRecords(htsNumMap, existingHTSNumMap);
    	}
      }

    private ADCVD_Case__c getParentObject(){
        String queryString = 'SELECT ADCVD_Case__c FROM '+objectName +' WHERE Id =: recordId';
        SObject relatedParent =  Database.query(queryString);
        relatedCaseId = (Id)relatedParent.get('ADCVD_Case__c');
        String adcvdCaseQuery = 'SELECT Id, ADCVD_Case_Type__c, Commodity__c, Country__c, Product__c, Product_Short_Name__c FROM ADCVD_Case__c WHERE Id=: relatedCaseId';
        ADCVD_Case__c adcvdCaseParent = Database.query(adcvdCaseQuery);
        return adcvdCaseParent;

    }
    
    /* This method matches the HTS number pattern and returns a list of valid HTS numbers with decimals */
    public List<String> getHTSNumber(String attachmentBody){  
        Pattern htsRegExPattern = Pattern.compile(HTS_REG_EX);
        Matcher htsNumMatcher = htsRegExPattern.matcher(attachmentBody);
        While (htsNumMatcher.find()){
            If (htsNumMatcher.groupCount() != 0){
                htsNumListWithDecimals.add(htsNumMatcher.group());
            }
        } 

        return htsNumListWithDecimals;
    }
  
    /* This method returns a map of HTS Numbers with Decimals as key set and its corresponding HTS number value without decimals */
    public Map<String, String> getHTSNumMap(List<String> htsNumListWithDecimals){
        Map<String,String> htsNumMap = new Map<String, String>();
        For (Integer i=0; i<htsNumListWithDecimals.size(); i++){
            String strWithDecimals = htsNumListWithDecimals.get(i);
            String strWithoutDecimals = strWithDecimals.replaceAll('\\.', '').trim();
            htsNumMap.put(strWithDecimals, strWithoutDecimals);
        }

        return htsNumMap;
    } 
     
    /* This method inserts HTS records for the corresponding parentId  */
    public void createHTSRecords (Map<string,string> htsNumMap,  Map <String, Harmonized_Tariff_Schedule__c> existingHTSNumbers){
        List <Harmonized_Tariff_Schedule__c> toInsert = new List<Harmonized_Tariff_Schedule__c>();
        ADCVD_Case__c parent = getParentObject();
        ParentValuesService pvs = new ParentValuesService();
        For(string hts:htsNumMap.keyset()){
            If (!existingHTSNumbers.containsKey(htsNumMap.get(hts))){
                Harmonized_Tariff_Schedule__c htsRecord = new Harmonized_Tariff_Schedule__c (name = hts, HTS_Number__c = htsNumMap.get(hts));
                htsRecord = (Harmonized_Tariff_Schedule__c)pvs.setCaseValuesFromParent(parent, htsRecord);
                htsRecord.put(objectName, recordId);
                htsRecord.put('ADCVD_Case__c', relatedCaseId);
                toInsert.add(htsRecord);
             }
        }
        Upsert toInsert;
    }
}