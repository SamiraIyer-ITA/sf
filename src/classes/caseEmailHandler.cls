public class caseEmailHandler {
    public caseEmailHandler(){}
    
    public void addComment(emailMessage[] eM){
        for(emailMessage e: eM){
            CaseComment comment = new CaseComment();
            comment.commentbody = e.TextBody;//.substringBefore('<>');
            comment.parentid = e.ParentId;
            comment.IsPublished = true; 
            
            insert comment;
        }
        
    }
        
}