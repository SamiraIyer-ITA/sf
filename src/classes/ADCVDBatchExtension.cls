public class ADCVDBatchExtension {
    
    public Id ADCVDCaseId;
    
    public ADCVDBatchExtension(ApexPages.StandardController controller) {
       
       ADCVDCaseId = controller.getRecord().Id;
            
    }
    
    
    public PageReference callBatch(){
        
        List<ADCVD_Case__c> newList = new List<ADCVD_Case__c>();
        newList.add(new ADCVD_Case__c(Id=ADCVDCaseId));
        Database.executeBatch(new ADCVDStandardCaseFieldsBatch(newList));
        
        PageReference pg = new PageReference('/'+ADCVDCaseId);
        
        return pg;
        
        
    }

}