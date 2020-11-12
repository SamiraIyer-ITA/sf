public class caseEmailHandler {
    public caseEmailHandler(){}
    
    public void addComment(emailMessage[] eM){
        if(!eM.isEmpty()) {
            List<CaseComment> emailComments = new List<CaseComment>();
            for (emailMessage e : eM) {
                Id parentId = e.ParentId;
                if (parentId != null) {
                    String sobjectType = parentId.getSObjectType().getDescribe().getName();
                    if (sobjectType == 'Case') {
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
}