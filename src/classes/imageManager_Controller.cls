public with sharing class imageManager_Controller {
    public Document image {get; set;}

    public string name {get; set;}
    public string type {get; set;}
    public SelectOption[] getTypes(){
        SelectOption[] options = new SelectOption[]{};
        options.add(new SelectOption('Carousel Image', 'Carousel Image'));
        options.add(new SelectOption('Background Image', 'Background Image'));
        return options;
    }
    
    public imageManager_Controller(){
        this.image = new Document();
    }
    
    public string filename {get; set;}
    public string description {get; set;}
    
    public void upload(){
        try{
            this.image.folderId = [select id from folder where name = 'Public Images' limit 1].id;
            this.image.name = this.filename;
            this.image.developername = this.name.replace(' ', '_');
            this.image.contentType = this.image.contentType;
            this.image.name = this.name;
            this.image.isPublic = true;
            insert this.image;
            this.image.body = null;
            Image__c img = new Image__c();
                img.name = this.name;
                img.type__c = this.type;
                img.location__c = this.image.id;
                img.alt__c = this.description;
            insert img;
            this.image = new Document();
        }catch(exception E){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, E.getMessage()));
        }
    }
}