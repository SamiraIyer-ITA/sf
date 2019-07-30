public class FederalRegisterChatterPostWriter extends ChatterPostWriter {
    
    //empty constructor for base class map
    public FederalRegisterChatterPostWriter(){}
    
    //post templates from custom metadata
    private Map<String, Automated_Chatter_Post__mdt> postsMap = getPostsMap('Federal_Register__c');
    
    //override your order logic for multiple chatter post conditions
    public override void checkConditions(SObject newRecord, SObject oldRecord) {
        newOrderFrAdded(newRecord, oldRecord);
    }
    
    //conditionally builds a chatter post
    @TestVisible private void newOrderFrAdded(SObject newRecord, SObject oldRecord) {
        //if condition is not met, return
        if(!isOrderFrAdded(newRecord, oldRecord) || newRecord.get('ADCVD_Order__c') == null) {
            return;
        }
        ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper.getInstance(new Set<Id>{(Id)newRecord.get('ADCVD_Case__c')});
        InvestigationMapper invMapper = (InvestigationMapper) caseMapper.getMapper('Investigation__c').getInstance();
        ADCVD_OrderMapper orderMapper = (ADCVD_OrderMapper) caseMapper.getMapper('ADCVD_Order__c').getInstance();
        ADCVD_Order__c ao = orderMapper.getMap(true).get((Id)newRecord.get('ADCVD_Order__c'));
        Investigation__c inv = invMapper.getMap(true).get(ao.Investigation__c);
        //get details from record
        String detailsFromRecord = '<p>Thanks for adding an Order FR to the Order. Please go back to the Investigation and update the Investigation Outcome to \"Order\".</p>';
        //insert case info into post template
        String templateWithCaseInfo = addTemplateWithCaseInfo(inv, postsMap.get('Order FR'));
        finishPost(templateWithCaseInfo, detailsFromRecord, inv, true);
    }
    
    //Confirm a data change to Type Order
    private Boolean isOrderFrAdded(SObject newRecord, SObject oldRecord) {
        //evaluation as states so if both fields change but the result is the same state, no message sent
        String newType = newRecord != null ? String.valueOf(newRecord.get('Type__c')) : '';
        String oldType = oldRecord != null ? String.valueOf(oldRecord.get('Type__c')) : '';
        if (newType == 'Order' && (String.isBlank(oldType) || oldType != 'Order')) {
            return true;
        } else {
            return false;
        }
    }
}