public without sharing class PrivacyPolicyComponentController {
    public PrivacyPolicyComponentController() {
        
    }

    public Boolean showArtEditScreen { get { //boolean that toggles the edit screen on and off
        if(showArtEditScreen == null) {
            showArtEditScreen = false;
        }
    return showArtEditScreen; 
    } set;} 
    //variable for holding the artifact record being created / editing

    public Artifact__c selectedArtifact {get; set;} //Artifact that is to be edited / created

    public String editArtId {get; set;} //ID of the artifact that is currently being edited

    public String participantId {get; set;} //participant ID of the artifact

    public Attachment attach {get; set;} //attachment to be created

    public PageReference deleteArtifact() { //delete artifact
        Artifact__c a = new Artifact__c(Id = editArtId);
        SafeDMLHandler.safeDelete(a, true);
        editArtId = null;
        return null;
    }

    public PageReference editArtifact() { //edit mode method
        showArtEditScreen = false;
        boolean found = false;
        for(Artifact__c a: artifactList) {
            if(a.Id == editArtId) {//sets the variable for where to render the artifact
                selectedArtifact = a; //populates artifact
                showArtEditScreen = true; //renders screen
                found = true; 
            }
        }
        if(!found) { //in case the data became stale?
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to find record');
            //ApexPages.addMessage(msg);
        }
        return null;
    }
    public List<Artifact__c> artifactList { get; set; } //list of artifacts passed in ... we could query this instead of passing it in

    public PageReference addArtifact(){ //creates a new artifact
        selectedArtifact = new Artifact__c(Participation_Number__c = participantId, isCurrent__c = true);
        artifactList.add(selectedArtifact);
        showArtEditScreen = true;
        return null;
    }

    public PageReference cancelArtifact(){ //closes edit screen, clears state and if it is a new artifact, removes from list
        if(selectedArtifact.Id == null) {
            Integer i = 0;
            while (i < artifactList.size()) { 
                if(artifactList.get(i).Id == null) {
                    artifactList.remove(i);
                }
                i++;
            }
        }
        selectedArtifact = null;
        showArtEditScreen = false;
        return null;
    }

    public PageReference save() { //this way blows up state if over ~3MB :-/
        //TODO if they hit while in editMode - throw error
        if(!String.isBlank(Apexpages.currentPage().getParameters().get('attachmentName')) ||
            !String.isBlank(Apexpages.currentPage().getParameters().get('attachmentBody'))) {
                attach = new Attachment(
                    Name = Apexpages.currentPage().getParameters().get('attachmentName'),
                    ContentType = Apexpages.currentPage().getParameters().get('attachmentContentType'),
                    Body = EncodingUtil.base64Decode(Apexpages.currentPage().getParameters().get('attachmentBody')),
                    Description = Apexpages.currentPage().getParameters().get('attachmentDescription')
                );
        } else {
            attach = null;
        }
        //TODO Validate file types
        if(attach == null && String.isBlank(selectedArtifact.External_Artifact_URL__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You must add a link to a public URL or upload a copy of your privacy policy'));
        } else {
            if(selectedArtifact != null) {
                try{ 
                    upsert selectedArtifact;
                    if(attach != null) {
                        attach.ParentId = selectedArtifact.Id;
                        insert attach;
                    }
                    showArtEditScreen = false;
                } catch (exception e) {
                    system.debug(e);
                    //TODO handle messaging
                }
            }
        }
        return null;
    }
}