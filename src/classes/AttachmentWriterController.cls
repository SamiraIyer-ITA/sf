public class AttachmentWriterController {
    private static string defaultName = 'Attachment Writer File.txt';
    public Id attachmentId {get; set;}
    public Id recordId {get; set;}
    public String attachmentBody {get; set;}
    public Boolean editAccess {get; set;}
    public Boolean readAccess {get; set;}
    public PageReference toggleEdit(){
        edit = edit ? false : true;
        return null;
    }
    public Boolean edit {get { if(edit == null) {edit = false;} return edit; } set;}
    
    public void init() {
        editAccess = false;
        readAccess = false;
        if(recordId != null) {
            List<UserRecordAccess> ura = [SELECT RecordId, HasEditAccess, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: recordId];
            if(ura.isEmpty()) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'You do not have permission to edit or view this.'));
            } else {
                for(UserRecordAccess ua: ura){
                    readAccess = readAccess ? readAccess : ua.HasReadAccess;
                    editAccess = editAccess ? editAccess : ua.HasEditAccess;
                }
                if(readAccess || editAccess) {
                    queryBody();
                }
            }
        } else {

        }
    }
    private void queryBody() {
        try {
            List<Attachment> aList = [SELECT Id, Body, Description FROM Attachment WHERE ParentId =: recordId AND Name =: defaultName LIMIT 1];
            if(!aList.isEmpty()) {
                attachmentBody = aList[0].body.toString();
                attachmentId = aList[0].Id;
            }
        } catch (Exception e) {
            system.debug(e);
        }
    }
    public AttachmentWriterController(ApexPages.StandardController stdController) {
        if(stdController.getRecord() InstanceOf ADCVD_Order__c) {
            ADCVD_Order__c o = (ADCVD_Order__c)stdController.getRecord();
            RecordId = o.Id;
        }
        init();
    }
    public AttachmentWriterController() {
        /*recordId = ApexPages.currentPage().getParameters().get('Id');
        if(recordId == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please pass in a valid ID parameter'));
        } 
        init();*/
    }
    public PageReference cancel(){
        edit = false;
        queryBody();
        return null;
    }
    public PageReference saveAttachment() {
        try {
                Attachment a = new Attachment(
                Id = attachmentId,
                parentId = recordId,
                body = Blob.valueOf(AttachmentBody),
                name = defaultName
            );
            upsert a;
            cancel();
        } catch (Exception e) {
            system.debug(e);
        }
        return null;
    }
}