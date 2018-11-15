public class NewToMarketSearchLog {
    @future
    public static void createSearchLog(String geographiesToEvaluate,String marketsAlreadyExportingTo,Long millisecondsSearch,Integer numberOfRecordsReturned,String productsCurrentlyExporting,DateTime searchSubmittedDateTime,String searchZipCode) {
        NTM_Search_Log__c newLog = new NTM_Search_Log__c(Geographies_to_Evaluate__c=geographiesToEvaluate,Markets_Already_Exporting_To__c=marketsAlreadyExportingTo,Milliseconds_to_return_results__c=millisecondsSearch,Number_of_Records_Returned__c=numberOfRecordsReturned,products_Currently_Exporting__c=productsCurrentlyExporting,Search_Submitted_Date_Time__c=searchSubmittedDateTime,Zip_Code__c=searchZipCode);
        insert newLog;
    }
}