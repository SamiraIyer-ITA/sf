public class caseEmailHandler {
    public caseEmailHandler(){}
    
    public void addComment(emailMessage[] eM){
        if(!eM.isEmpty()) {
            List<CaseComment> emailComments = new List<CaseComment>();
            Set<Id> parentIds = new Set<Id>();
            Map<Id, String> caseToRecordTypeMap = new Map<Id, String>();
            Set<String> excludedRecordTypesSet = excludedCaseRecordTypes();
            for(emailMessage e : eM){
                parentIds.add(e.ParentId);
            }
            // Map recordIds to RecordTypeId
            List<Case> allCases = [SELECT Id, RecordTypeId, RecordType.DeveloperName FROM Case WHERE Id IN :parentIds];
            Set<String> recordTypeNames = new Set<String>();
            for(Case c :allCases){
                caseToRecordTypeMap.put(c.Id, c.RecordType.Name);
            }
            for (emailMessage e : eM) {
                Id parentId = e.ParentId;
                if (parentId != null) {
                    String sobjectType = parentId.getSObjectType().getDescribe().getName();
                    if (sobjectType == 'Case' && !excludedRecordTypesSet.contains(caseToRecordTypeMap.get(e.ParentId))) {
                        CaseComment comment = new CaseComment();
                        comment.commentbody = e.TextBody;//.substringBefore('<>');
                        comment.parentid = e.ParentId;
                        comment.IsPublished = true;
                        emailComments.add(comment);
                    }
                }
            }
            if (!emailComments.isEmpty()) {
                insert emailComments;
            }
        }
    }
    private Set<String> excludedCaseRecordTypes(){
        Set<String> excludedRecordTypesSet = new Set<String>();
        // Exclude Case Record Types 'Advocacy', 'Commercial Diplomacy', 'Export Protection' and 'Investment Protection'
        excludedRecordTypesSet.add('Advocacy');
        excludedRecordTypesSet.add('Commercial_Diplomacy');
        excludedRecordTypesSet.add('Export_Promotion');
        excludedRecordTypesSet.add('Investment_Promotion');
        return excludedRecordTypesSet;
    }
}