public class carouselController {

    public void search() {
        getImages();
    }

    public Carousel_Item__c[] getcItems(){
        return [select id, name, header__c, description__c, button_text__c, button_path__c, image__c, image__r.Image__c, sort_order__c from Carousel_Item__c where content__c = :record order by sort_order__c asc nulls last];
    }

    public Carousel_Item__c cItem {get; set;}

    public string search {get; set;}

    public Image__c[] getImages(){
        if(this.search != null && this.search != ''){
            this.search = '%'+this.search+'%';
            return [select id, name, image__c from image__c where (name like :this.search or alt__c like :this.search) and type__c = 'Carousel Image' limit 25];
        }
        else
            return [select id, name, image__c from image__c where type__c = 'Carousel Image' limit 25];
    }

    public id record {get; set;}

    public carouselController(ApexPages.StandardController controller) {
        if(ApexPages.CurrentPage().getParameters().get('id') != null){
            this.record = ApexPages.CurrentPage().getParameters().get('id');
        }
    }
    
    public void doNothing(){
        if(this.cItem == null)
            this.cItem = new Carousel_Item__c();
        if(ApexPages.CurrentPage().getParameters().get('ci') != null){
            this.cItem = [select id, name, header__c, description__c, button_text__c, button_path__c, image__c, sort_order__c from Carousel_Item__c where id = :ApexPages.CurrentPage().getParameters().get('ci')];
        }else if(ApexPages.currentPage().getParameters().get('img') != null){
            this.cItem = new Carousel_Item__c();
            this.cItem.image__c = ApexPages.currentPage().getParameters().get('img');
        }
    }
    
    public void newSlide(){
        this.cItem = new Carousel_Item__c();
    }
    
    public pageReference saveSlide(){
        try{
            this.cItem.content__c = record;
            system.debug('@@'+this.cItem);
            upsert this.cItem;
            system.debug(this.cItem.id);
            newSlide();
        }catch(Exception e){
            system.debug('@@'+e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }        
        return null;
    }
    
    public pageReference cancel(){
        newSlide();
        return null;
    }

    public pageReference deleteSlide(){
        try{
            if(this.cItem.id != null){
                delete this.cItem;
            }
            newSlide();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return null;
    }

}