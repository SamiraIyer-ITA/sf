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
        //System.debug('#1 MainClass: recordId: ' + recordId + ', attachmentBody: ' + attachmentBody +  ', attachmentId: ' + attachmentId );  
	 	mainMethod();   
    }   

    /* This is the main method having calls all other methods */
      public void mainMethod() {
    	if(attachmentBody != null && recordId != null) {    
    		List<String> htsNumList = getHTSNumber(attachmentBody);
            Map<String, String> htsNumMap = getHTSNumMap(htsNumList);
            createHTSRecords(htsNumMap);
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
            //System.debug('#2 MainClass: HTS Numbers List With Decimals: ' + htsNumListWithDecimals.get(listItem));
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
            //System.debug('#3 MainClass: HTS Numbers List WithOut Decimals: ' + htsNumMap.get(htsVal));
        }     
        return htsNumMap;
    } 
     
    /* This method inserts HTS records for the corresponding parentId  */
    public void createHTSRecords (map<string,string> htsMap){
        List <Harmonized_Tariff_Schedule__c> toInsert = new List<Harmonized_Tariff_Schedule__c>();       
        For(string hts:htsMap.keyset()){
                Harmonized_Tariff_Schedule__c htsRecord = new Harmonized_Tariff_Schedule__c (name = hts, HTS_Number__c = htsMap.get(hts));
                htsRecord.put(objectName, recordId);
                toInsert.add(htsRecord);
                //System.debug('#4 MainClass: HTS Number in Map: ' + htsMap.get(hts));
            	//System.debug('#5 MainClass: Entire HTS Record to be Upserted: ' + htsRecord);
        }
        //System.debug('#6 MainClass: HTS Records Upserted: ' + toInsert);
        Upsert toInsert;
    }
}