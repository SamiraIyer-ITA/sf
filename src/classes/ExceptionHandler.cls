public without sharing class ExceptionHandler {
    public static final String GENERIC_ERROR_MSG = 'We were unable to perform that operation. Please try again later or submit a case by clicking "Assistance".';
    public static Void addErrorMessageToPage(String msg) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
        //TODO - overload method to handle severity
    }
    public static Void logException(Exception e) {
        system.debug(e);
        //TODO - overload method - log into database
    }
    public static Void handlePageException(Exception e) {
        //TODO - overload method to allow custom messaging, multiple exception types
        addErrorMessageToPage(GENERIC_ERROR_MSG);
        logException(e);
    }
}