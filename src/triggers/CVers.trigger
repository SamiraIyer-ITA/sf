trigger CVers on Content__c (after insert, after update) {
    if(runOnce.run()){
        List<Content_Version__c> cv = new List<Content_Version__c>();
        
        
    for (Content__c cc: Trigger.New) {
        if (cc.Status__c == 'Draft: Rejected' && cc.Version__c == 'Version 1') {
            cv.add(new Content_Version__c
                     (Atom__c = cc.id,
                      Name = cc.Name,
                      Content__c = cc.Content__c,
                      Atom_Title__c = cc.Display_Title__c,
                      Publishing_Status__c = cc.Status__c,
                      Version_Number__c = cc.Version__c) 
            );
        }
        
        else if (cc.Status__c == 'Online' && cc.Version__c == 'Version 1') {
            cv.add(new Content_Version__c
                     (Atom__c = cc.id,
                      Name = cc.Name,
                      Content__c = cc.Content__c,
                      Atom_Title__c = cc.Display_Title__c,
                      Publishing_Status__c = cc.Status__c,
                      Version_Number__c = cc.Version__c) 
            );
        }
    }
    insert cv;
  }
}