trigger caseEmail on EmailMessage (after insert) {
    caseEmailHandler handler = new caseEmailHandler();
    
    if(Trigger.isAfter && Trigger.isInsert)
        handler.addComment(Trigger.new);
}