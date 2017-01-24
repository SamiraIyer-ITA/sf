public class Page_Section_Controller {

    public Page_Section_Controller(ApexPages.StandardController controller) {
        this.page = (Page__c)controller.getRecord();
        this.page = [select id, name, section__c, carousel__c, Page__r.name, Page__r.display_page_name__c, Collaborate_Text__c, 
                     trade_events__r.endpoint__c, trade_events__c, Collaboration_Group__c, Assistance_Text__c, content__r.name, content__r.endpoint__c, 
                     content__r.api_type__c, content__r.content__c, Secondary_Content_link__c, Secondary_Content__r.name, Secondary_Content__r.content__c, 
                     Description__c, Page_Title__c,Pop_Up_Active__c, Pop_Up_Script__c, site__r.title__c, createddate, lastmodifieddate,
                     (select id, content__r.button_path__c, row__c, row__r.image__c, row__r.image__r.location__c, row__r.container__r.class_name__c, 
                      row__r.sort_order__c, content__r.endpoint__c, content__r.api_type__c, content__r.image__c, content__r.image__r.Class__r.class_name__c, 
                      content__r.image__r.location__c, content__r.button_text__c, content__r.Content__c, content__r.name, content_container__c, content_container__r.Class_Name__c,
                      content__r.Series_Type__c, recordtype.name, Display_Content_Name__c,nongov__c, placeholder__c, content__r.display_title__c, Header__c, Button_Text__c,  Button_URL__c, button_page__c, Button_Title__c,
                      content__r.class_name__c, row__r.Enforce_Uniform_Height__c, button_page__r.Clean_URL__c
                      from page_contents__r order by row__r.sort_order__c asc, sortorder__c asc nulls last), 
                     (select Destination__c 
                      from content_overrides__r 
                      where site__r.domain__c = :URL.getSalesforceBaseUrl().getHost() limit 1) 
                     from page__c 
                     where id = :this.page.id limit 1];
        if(this.page.content_overrides__r.size() == 1){
            this.page = [select id, name, section__c, carousel__c, Page__r.name, Page__r.display_page_name__c, Collaborate_Text__c, 
                         trade_events__r.endpoint__c, trade_events__c, Collaboration_Group__c, Assistance_Text__c, content__r.name, 
                         content__r.endpoint__c, content__r.api_type__c, content__r.content__c, Secondary_Content_link__c, Secondary_Content__r.name, 
                         Secondary_Content__r.content__c, Pop_Up_Active__c, Pop_Up_Script__c,
                         (select id, content__r.button_path__c, row__c, row__r.image__c, row__r.image__r.location__c, row__r.container__r.class_name__c, 
                          row__r.sort_order__c, content__r.endpoint__c, content__r.api_type__c, content__r.image__c, content__r.image__r.Class__r.class_name__c, 
                          content__r.image__r.location__c, content__r.button_text__c, content__r.Content__c, content__r.name, content_container__c, 
                          content_container__r.Class_Name__c, content__r.Series_Type__c,nongov__c, recordtype.name, Display_Content_Name__c, placeholder__c, content__r.display_title__c, Header__c, Button_Text__c,  Button_URL__c, button_page__c, Button_Title__c, 
                          content__r.class_name__c, row__r.Enforce_Uniform_Height__c, button_page__r.Clean_URL__c
                          from page_contents__r 
                          order by row__r.sort_order__c asc, sortorder__c asc nulls last) 
                         from page__c where id = :this.page.content_overrides__r[0].Destination__c limit 1];
        }
        this.test = this.page.name;
        Section__c[] sections = [select id, name, 
                                 (select id, name, page__c, redirect__c, page__r.clean_url__c 
                                  from navigation_links__r 
                                  order by sort_order__c asc) 
                                 from section__c where id = :this.page.section__c limit 1]; 
        if(sections.size() == 1){
            this.section = sections[0];
        }

        set<id> contentIds = new set<id>();
        
        this.rowMap = new map<id, page_content__c[]>();
        this.rowStyles = new map<id, string>();
        this.workaround = new map<id, boolean>();
        this.rowBGMap = new map<id, string>();
        this.rowEnforceMap = new map<id, string>();
        this.rowOrderMap= new map<string, id>();
        double RowPlaceholder = 10000.00; 
        for(page_content__c pc : this.page.page_contents__r){
            if(pc.content__c != null)
                contentIds.add(pc.content__c);
            if(pc.row__c != null && this.rowMap.get(pc.row__c) == null){
                this.rowMap.put(pc.row__c, new Page_Content__c[]{});
                if(pc.row__r.sort_order__c != null && this.rowOrderMap.get(string.valueOf(pc.row__r.sort_order__c)) == null ){
                    this.rowOrderMap.put(string.valueOf(pc.row__r.sort_order__c).leftPad(6, '0'), pc.row__c);
                }else{
                    this.rowOrderMap.put(string.valueOf(RowPlaceholder), pc.row__c);
                    RowPlaceholder = RowPlaceholder + 1;
                }
            }
            if(this.workaround.get(pc.id) == null){
                this.workaround.put(pc.id, pc.display_content_name__c);
                if(this.firstHeader == null){
                    this.firstHeader = pc.id;
                }
            }
            if(pc.row__c != null)
                this.rowMap.get(pc.row__c).add(pc);
                if(pc.row__r.image__c != null){
                    this.rowBGMap.put(pc.row__c, pc.row__r.image__r.location__c);
/*              }else if(pc.content__r.image__c != null){
                    this.rowBGMap.put(pc.row__c, pc.content__r.image__r.location__c); */
                }else{
                    this.rowBGMap.put(pc.row__c, '');
                }
                this.rowEnforceMap.put(pc.row__c, string.valueOf(pc.row__r.Enforce_Uniform_Height__c));
                if(pc.row__r.container__c != null){ 
                    this.rowStyles.put(pc.row__c, pc.row__r.container__r.class_name__c);      
                }else{
                    if(pc.row__r.image__c != null)
                        this.rowStyles.put(pc.row__c, 'default-bg');
                    else
                        this.rowStyles.put(pc.row__c, '');
                }
        }

        String[] rowOrderList = new List<string>(this.rowOrderMap.keySet());
        rowOrderList.sort();
        this.rowOrders = new String[]{};
        for(string i : rowOrderList){
            this.rowOrders.add(this.rowOrderMap.get(i));
        }
        
        this.caroMap = new map<id, map<integer, carousel_item__c>>();
        for(carousel_item__c c : [select content__c, id, header__c, description__c, 
                                  Button_Text__c, Button_Path__c, image__c, image__r.alt__c, 
                                  image__r.Location__c, image__r.carousel_class__c from carousel_item__c 
                                  where content__c = :contentIds 
                                  order by sort_order__c asc nulls last]){
        //map<id, map<integer, carousel_item>> caroMap
            if(this.caroMap.get(c.content__c) == null)
                this.caroMap.put(c.content__c, new map<integer, carousel_item__c>());
                
            this.caroMap.get(c.content__c).put(this.caroMap.get(c.content__c).size(), c);
        }
        
        if(this.page.carousel__c != null){
            this.carousel = [select id, header__c, description__c, Button_Text__c, Button_Path__c, image__c, image__r.alt__c, image__r.Location__c, image__r.carousel_class__c 
                             from carousel_item__c 
                             where content__c = :this.page.carousel__c 
                             order by sort_order__c asc nulls last];
            this.carouselMap = new map<integer, Carousel_Item__c>();
            integer i = 0;
            for(Carousel_item__c c : this.carousel){
                this.carouselMap.put(i, c);
                i++;            
            }
        }
        this.CollaborationText = this.page.collaborate_text__c;
        this.CollaborationGroup = '';
        this.AssistanceText = this.page.assistance_text__c;
        if(this.page.collaboration_group__c != null){
            CollaborationGroup[] groups = [select id from collaborationgroup where name = :this.page.collaboration_group__c];
            if(groups.size() == 1){
                this.CollaborationGroup = groups[0].id;
            }
        }
    }

    public string CollaborationText {get; set;}
    public string CollaborationGroup {get; set;}
    public string AssistanceText {get; set;}

    public Carousel_Item__c[] carousel {get; set;}
    public map<integer, carousel_item__c> carouselMap {get; set;}
    public Section__c section {get; set;}
    public string test {get; set;}
    public Page__c page {get; set;}
    
    public map<id, map<integer, carousel_item__c>> caroMap {get; set;}
    public map<id, page_content__c[]> rowMap {get; set;}
    public map<string, id> rowOrderMap {get; set;} 
    public String[] rowOrders {get; set;}
    public map<id, string> rowStyles {get; set;}
    public map<id, boolean> workaround {get; set;}
    public map<id, string> rowBGMap {get; set;}
    public map<id, string> rowEnforceMap {get; set;}
    
    public string FirstHeader {get; set;}
}