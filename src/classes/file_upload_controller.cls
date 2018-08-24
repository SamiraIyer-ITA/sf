public class file_upload_controller {
    public PageReference doNothing() {
        return null;
    }


public attachment attachment {get; set;}
public boolean uploaded {get; set;}

public Artifact__c artifact {get; set;}

public file_upload_controller(){
    this.uploaded = false;
    this.attachment = new attachment();
    if(ApexPages.currentPage().getParameters().get('parentId') != null){
        this.attachment.parentId = ApexPages.currentPage().getParameters().get('parentId');
        this.artifact = [select id, external_artifact_url__c from artifact__c where id = :this.attachment.parentId limit 1];
    }
}

public void upload(){
    try{
        insert this.attachment;
        this.artifact.external_artifact_url__c = '/servlet/servlet.FileDownload?file='+this.attachment.id;
        update this.artifact;
        this.uploaded = true;
    }catch(exception e){
        system.debug(e);
    }
}
}