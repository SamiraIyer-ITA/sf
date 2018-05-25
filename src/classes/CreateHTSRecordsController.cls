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
    
    /* Extension Controller */
    public CreateHTSRecordsController(AttachmentWriterController con) 
    { 
     	this.objectName = con.objectName;
        this.recordId = con.recordId;
     	this.attachmentBody = con.attachmentBody;
     	this.attachmentId = con.attachmentId;
        //System.debug('#: objectName: ' + objectName + ' , recordId: ' + recordId + ', attachmentBody: ' + attachmentBody +  ', attachmentId: ' + attachmentId );  
        mainMethod();   
    }   

    /* This is the main method calling other methods */
      public void mainMethod() {
    	if(attachmentBody != null && recordId != null) {    
    		Map <String, Harmonized_Tariff_Schedule__c> existingHTSNumMap = new Map <String, Harmonized_Tariff_Schedule__c>();
            List <Harmonized_Tariff_Schedule__c> existingHTSNumList = new List <Harmonized_Tariff_Schedule__c>(); 
            If (objectName == 'ADCVD_Order__c') {
                existingHTSNumList = [Select HTS_Number__c, Name from Harmonized_Tariff_Schedule__c where ADCVD_Order__r.Id =:recordId]; 
             }
            If (objectName == 'Suspension_Agreement__c') {
                existingHTSNumList = [Select HTS_Number__c, Name from Harmonized_Tariff_Schedule__c where Suspension_Agreement__r.Id =:recordId];   
             }
             //System.debug('# existingHTSNumList = ' + existingHTSNumList);
             For (Harmonized_Tariff_Schedule__c htsNums: existingHTSNumList) {
                existingHTSNumMap.put(htsNums.HTS_Number__c, htsNums); 
            }
			//System.debug('# existingHTSNumMap = ' + existingHTSNumMap);	
            List<String> htsNumList = getHTSNumber(attachmentBody);
            Map<String, String> htsNumMap = getHTSNumMap(htsNumList);
            createHTSRecords(htsNumMap, existingHTSNumMap);
    	}
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
         
        For (Integer listItem=0; listItem<htsNumListWithDecimals.size(); listItem++){
            //System.debug('# getHTSNumber: HTS Numbers List With Decimals: ' + htsNumListWithDecimals.get(listItem));
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
   
        For (string htsVal:htsNumMap.keyset()){
            //System.debug('# getHTSNumMap: HTS Numbers List WithOut Decimals: ' + htsNumMap.get(htsVal));
        }     
        return htsNumMap;
    } 
     
    /* This method inserts HTS records for the corresponding parentId  */
    public void createHTSRecords (Map<string,string> htsMap,  Map <String, Harmonized_Tariff_Schedule__c> existingHTSNumbers){
        List <Harmonized_Tariff_Schedule__c> toInsert = new List<Harmonized_Tariff_Schedule__c>();       
        For(string hts:htsMap.keyset()){
            //System.debug('# existingHTSNumbers.containsKey(htsMap.get(hts))) = ' + existingHTSNumbers.containsKey(htsMap.get(hts))); 
            If (!existingHTSNumbers.containsKey(htsMap.get(hts))){
                //System.debug('# HTS Number CAN be INSERTED'); 
                Harmonized_Tariff_Schedule__c htsRecord = new Harmonized_Tariff_Schedule__c (name = hts, HTS_Number__c = htsMap.get(hts));
                htsRecord.put(objectName, recordId);
                toInsert.add(htsRecord);
                //System.debug('# createHTSRecords: HTS Number in Map: ' + htsMap.get(hts));
            	//System.debug('# createHTSRecords: Entire HTS Record to be Upserted: ' + htsRecord);
             }  
        }
        //System.debug('# createHTSRecords: HTS Records Upserted: ' + toInsert);
        Upsert toInsert;
    }
}