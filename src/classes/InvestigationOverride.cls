public without sharing class InvestigationOverride {
    private static final String INVESTIGATION = 'Investigation__c';
    private final ApexPages.StandardController stdController;
    private Investigation__c inv {get; set;}
    private Id recordTypeId {get; set;}
    // Constructor – controller extension
    public InvestigationOverride(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        inv = (Investigation__c)stdController.getRecord();
        List<Petition__c> petitionList = [SELECT Id, ADCVD_Case_Type__c FROM Petition__c WHERE Id =: inv.Petition__c];
        if(!petitionList.isEmpty()){
            String petitionType = petitionList[0].ADCVD_Case_Type__c;
            if(petitionType.contains('CVD')) {
                RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, 'CVD');
            } else if(petitionType.contains('AD')) {
                RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, 'AD');
            }
        }
    }
    public PageReference showInvestigationPage() {
        PageReference p = new PageReference('/' + MetadataHelper.getObjectPrefix(INVESTIGATION) + '/e');
        Map<String, String> mapParams = p.getParameters();
        mapParams.putAll(ApexPages.currentPage().getParameters());
        if(recordTypeId != null) mapParams.put('RecordType', recordTypeId);
        mapParams.put('nooverride', '1');
        mapParams.remove('save_new'); // Prevent the page from trying to save the inv and create a new one
        mapParams.remove('sfdc.override');
        return p;
    }

}