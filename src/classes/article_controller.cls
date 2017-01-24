public class article_controller {

    public string atom {get; set;}
    public string url {get; set;}
    public boolean publicViewing {get; set;}
    public boolean customerViewing {get; set;}
    public string title {get; set;}
    public string mobileTitle {get; set;}
    public string summary {get; set;}
    public string references {get; set;}
    public string published {get; set;}
    public string created {get; set;}
    public string id {get; set;}
    public boolean isSectionalNav {get; set;}
    public boolean isStaticNav {get; set;}
    public String[] tags {get; set;}
    public String[] types {get; set;}
    public map<string, string> TagCategory {get; set;}
    public map<string, string> arts {get; set;}
    public String endpoint {get; set;}
    public String type {get; set;}
    public boolean pageError {get; set;}
    
    public boolean getLoggedIn(){
        if(UserInfo.getUserType() != 'Guest'){
            return true;
        }
        return false;
    }   

    public string publication {get; set;}
    
    public string l0 {get; set;}
    public string l1 {get; set;}
    public string l2 {get; set;}
    public string l3 {get; set;}
    public Article__DataCategorySelection[] categories {get; set;}
    
    public string chapter {get; set;}
    public string section {get; set;}
    public string country {get; set;}
    public map<string, map<string, map<string, string>>> navigation {get; set;}
    public navObject[] navObjects {get; set;}

    public class navObject{
        public string text {get; set;}
        public string id {get; set;}
        public string url {get; set;}
        public string summary {get; set;}
        public boolean empty {
            get{
                if(this.empty == null)
                    this.empty = true;
                return this.empty;
            }
            set;
        }
        public navObject[] links {get; set;}
    }

    public string articleType {get; set;}

    public pageReference SeriesRedirect(){
        if(this.navObjects.size() != 0){
            PageReference pr = Page.article2;
            pr.setRedirect(true);
            for(navObject n0 : this.navObjects){
                if(n0.links.size() != 0){
                    for(navObject n1 : n0.links){
                        if(n1.links.size() != 0){
                            for(navObject n2 : n1.links){
                                if(n2.links.size() != 0){
                                    for(navObject n3 : n2.links){
                                        if(n3.links.size() != 0){
                                            for(navObject n4 : n3.links){
                                                if(n4.url != null){
                                                    pr.getParameters().put('id', n4.url);
                                                    return pr;
                                                }
                                            }
                                        }else{
                                            if(n3.url != null){
                                                pr.getParameters().put('id', n3.url);
                                                return pr;
                                            }
                                        }
                                    }
                                }else{
                                    if(n2.url != null){
                                        pr.getParameters().put('id', n2.url);
                                        return pr;
                                    }
                                }
                            }
                        }else{
                            if(n1.url != null){
                                pr.getParameters().put('id', n1.url);
                                return pr;
                            }
                        }
                    }            
                }else{
                    if(n0.url != null){
                        pr.getParameters().put('id', n0.url);
                        return pr;
                    }
                }
            }
        }
        return null;
    }

    public boolean HideLastPulbished {get; set;}

    public class ArticleTag{
        public string Text {get; set;}
        public string Endpoint {get; set;}
        public string App {get; set;}
    }
    
    public List<ArticleTag> ArticleTags {get; set;}

    public article_controller(){
        Site__c site = [select Hide_Last_Published_Date__c, name, domain__c from site__c where 
                                domain__c = :System.URL.getSalesforceBaseUrl().getHost()
                                or UseAsDefault__c = true 
                            order by UseAsDefault__c asc limit 1];
        this.HideLastPulbished = site.Hide_Last_Published_Date__c;
        this.ArticleTags = new List<ArticleTag>();
        system.debug(ApexPages.currentPage().getParameters().get('series'));
        if(ApexPages.currentPage().getParameters().get('series') != null && ApexPages.currentPage().getParameters().get('type') != null){
            //if the 'series' is set, get the ID of any article in the series to build the navigation.  
            //After the ID is set, if 'series' is set redirect to the first element in the navigation.
            string articleQuery = 'select urlname from '+ApexPages.CurrentPage().getParameters().get('type')+' where series__c =  \''+ApexPages.currentPage().getParameters().get('series')+'\' and publishStatus = \'Online\' and language=\'en_US\' order by level_0__c asc, level_1__c asc, level_2__c asc, level_3__c asc nulls last limit 1';
            sObject[] articles = database.query(articleQuery);
            if(articles.size() != 0)
                ApexPages.CurrentPage().getParameters().put('id', (string) articles[0].get('urlname'));
        }
        if(ApexPages.CurrentPage().getParameters().get('id') != null){
            string art = ApexPages.CurrentPage().getParameters().get('id');
            this.id = art;
            this.url = art;
            this.navObjects = new navObject[]{};
            KnowledgeArticleVersion[] articleVersions = [select articleType 
                                                         from knowledgearticleversion 
                                                         where urlname = :art and publishStatus = 'Online' 
                                                         and language = 'en_US'];
            if(articleVersions.size() != 0 || ApexPages.currentPage().getParameters().get('type') != null){
                if(articleVersions.size() != 0){
                    KnowledgeArticleVersion article = articleVersions[0];
                    this.articleType = article.articleType;
                }else{
                    this.articleType = ApexPages.currentPage().getParameters().get('type');
                }
                for(level__c level : [select id, name, sort_order__c, Level_Number__c, Parent_Level__c from level__c where Series_Template__r.name = :this.articleType order by parent_level__c nulls first, parent_level__r.sort_order__c, sort_order__c asc]){
                    boolean exists = false;
                    if(level.level_number__c == 'Level 0'){
                        for(navObject n0 : this.navObjects){
                            if(n0.text == level.name){
                                exists = true;
                                break;
                            }
                        }
                        if(!exists){
                            navObject tmp = new navObject();
                                tmp.text = level.name;
                                tmp.links = new navObject[]{};
                            this.navObjects.add(tmp);
                        }
                    } else if(level.level_number__c == 'Level 1'){
                        for(navObject n0 : this.navObjects){
                            for(navObject n1 : n0.links){
                                if(n1.text == level.name){
                                    exists = true;
                                    break;
                                }
                            }
                            if(!exists){
                                navObject tmp = new navObject();
                                    tmp.text = level.name;
                                    tmp.links = new navObject[]{};
                                n0.links.add(tmp);
                            }
                        }                
                    } else if(level.level_number__c == 'Level 2'){
                        for(navObject n0 : this.navObjects){
                            for(navObject n1 : n0.links){
                                for(navObject n2 : n1.links){
                                    if(n2.text == level.name){
                                        exists = true;
                                        break;
                                    }
                                }
                                if(!exists){
                                    navObject tmp = new NavObject();
                                        tmp.text = level.name;
                                        tmp.links = new navObject[]{};
                                    n1.links.add(tmp);
                                }
                            }
                        }
                    } else if(level.level_number__c == 'Level 3'){
                        for(navObject n0 : this.navObjects){
                            for(navObject n1 : n0.links){
                                for(navObject n2 : n1.links){
                                    for(navObject n3 : n2.links){
                                        if(n3.text == level.name){
                                            exists = true;
                                            break;
                                        }
                                    }
                                    if(!exists){
                                        navObject tmp = new NavObject();
                                            tmp.text = level.name;
                                            tmp.links = new navObject[]{};
                                        n2.links.add(tmp);
                                    }
                                }
                            }
                        }
                    }
                }
    
                for(chapter_section__c a : [select id, name, chapter__r.name, Publication_Template__c 
                                            from chapter_section__c 
                                            where (chapter__r.Publication_Template__r.name = :this.articleType 
                                                   or Publication_Template__r.name = :this.articleType) 
                                            order by chapter__r.sort_order__c, sort_order__c asc nulls last]){
                    boolean exists = false;
                    if(a.chapter__c != null){
                        for(navObject n : this.navObjects){
                            if(n.text == a.chapter__r.name){
                                exists = true;
                                break;
                            }                   
                        }
                        if(!exists){
                            navObject tmp = new navObject();
                                tmp.text = a.chapter__r.name;
                                tmp.links = new navObject[]{};
                            this.navObjects.add(tmp);
                        }
                        for(navObject n : this.navObjects){
                            boolean ec = false;
                            for(navObject c : n.links){
                                if(c.text == a.name && a.chapter__r.name == n.text){
                                    ec = true;
                                    break;
                                }
                            }                   
                            if(!ec && a.chapter__r.name == n.text){
                                navObject tmp = new navObject();
                                    tmp.text = a.name;
                                    tmp.links = new navObject[]{};
                                n.links.add(tmp);
                            }
                        }                
                    }else{
                        navObject tmp = new navObject();
                            tmp.text = a.name;
                            tmp.links = new navObject[]{};
                        this.navObjects.add(tmp);
                    }
                }            
                
                string query = 'select id, knowledgearticleid, articlenumber, title,createddate, Mobile_Title__c, atom__c, IsVisibleInPkb, IsVisibleInCsp, references__c, series__r.name, level_3__c, level_2__c, level_1__c, level_0__c, summary, lastpublisheddate, (SELECT Id, DataCategoryName, DataCategoryGroupName FROM DataCategorySelections) from '+this.articleType+' where urlname = \''+art+'\' and publishStatus = \'Online\' and language=\'en_US\' order by level_0__c asc nulls last limit 1';
                string KAV = this.articleType;
                sObject[] articles = database.query(query);
                if(articles.size() == 1){
                    this.tags = new String[]{};
                    this.tagCategory = new map<string, string>();
                    string DataCategory = this.articleType.replace('kav', 'DataCategorySelection');
                    system.debug(DataCategory);
                    SObject[] selections = database.query('SELECT DataCategoryGroupName,DataCategoryName, Id,ParentId FROM '+DataCategory+' where parentId = \''+(string) articles[0].get('id')+'\'');

                    if(this.articleType != null && KnowledgeSearch__c.getAll() != null && KnowledgeSearch__c.getAll().get(this.articleType) != null ){
                        this.endpoint = KnowledgeSearch__c.getAll().get(this.articleType).endpoint__c;
                        this.type = KnowledgeSearch__c.getAll().get(this.articleType).type__c;
                    }else{
                        this.endpoint = '/search#/search/articles?q=';
                        this.type = 'ccgs';
                    }
                KnowledgeSearch__c[] KM = [select id, endpoint__c, type__c, app__c, KAV_or_Category__c from KnowledgeSearch__c where site__c = :site.domain__c];
                for(sObject selection : selections){
                    string tag = (string) selection.get('DataCategoryName');
                    string type = this.type;
                    tag = tag.replaceAll('_', ' ');
                    system.debug(tag);
                    this.tags.add(tag);
                    ArticleTag at = new ArticleTag();
                        at.Text = tag;
                        at.Endpoint = (string) selection.get('DataCategoryGroupName');
                        at.app = KAV;
                    for(KnowledgeSearch__c ks : KM){
                        if(ks.KAV_or_Category__c == KAV){
                            at.Endpoint = ks.endpoint__c;
                            at.app = ks.App__c;
                        }
                        if(ks.KAV_or_Category__c == (string) selection.get('DataCategoryGroupName')){
                            at.Endpoint = ks.type__c+ks.endpoint__c;
                            at.app = ks.app__c;
                        }
                    }
                    if(KnowledgeSearch__c.getAll().get((string) selection.get('DataCategoryGroupName')) != null){
                        this.tagCategory.put(tag, KnowledgeSearch__c.getAll().get((string) selection.get('DataCategoryGroupName')).endpoint__c);
                        this.tagCategory.put(type, KnowledgeSearch__c.getAll().get((string) selection.get('DataCategoryGroupName')).type__c);                        
                    }else{
                        this.tagCategory.put(tag, this.endpoint);
                    }

                    this.ArticleTags.add(at);
                }
    
                    string kmId = (string) articles[0].get('knowledgearticleid');                
                    DateTime dt = (datetime) articles[0].get('lastpublisheddate');
                    this.published = dt.Month()+'/'+dt.Day()+'/'+dt.Year();
                    DateTime cdt = (datetime) articles[0].get('createddate');
                    this.created = dt.Month()+'/'+dt.Day()+'/'+dt.Year();
                    this.publication = (string) articles[0].get('series__c');
                    this.id = (string) articles[0].get('id');
                    this.atom = (string) articles[0].get('atom__c');
                        this.atom = this.atom.replaceAll('https://tradesites.secure.force.com/platform/servlet/rtaImage', '/servlet/rtaImage');
                        this.atom = this.atom.replaceAll('_blank', '_self');
                    this.summary = (string) articles[0].get('summary');
                    this.publicViewing = (boolean)articles[0].get('IsVisibleInPkb');
                    this.customerViewing = (boolean)articles[0].get('IsVisibleInCsp');
                    this.title = (string) articles[0].get('title');
                    this.mobileTitle = String.isBlank((string) articles[0].get('Mobile_Title__c')) ? (string) articles[0].get('Title') : (string) articles[0].get('Mobile_Title__c');
                    this.references = (string) articles[0].get('references__c');
                    if(articles[0].get('level_0__c') != null){
                        this.chapter = (string) articles[0].get('level_0__c');
                        this.section = (string) articles[0].get('level_1__c');
                        this.l2 = (string) articles[0].get('level_2__c');
                        this.l3 = (string) articles[0].get('level_3__c');
                    }
                    if(articles[0].get('level_1__c') != null && this.chapter == null){
                        this.chapter = (string) articles[0].get('level_1__c');
                        this.section = (string) articles[0].get('level_2__c');
                        this.l2 = (string) articles[0].get('level_3__c');
                    }
                    this.l0 = this.chapter;
                    this.l1 = this.section;
                    if(this.publication != null){
                        Series__c publication = [select id, name, type__c from Series__c where id = :this.publication limit 1];
                        this.publication = publication.name;
                        if(publication.type__c == 'Country Commercial'){
                            this.country = publication.name.split(' Country')[0];
                        }
                        string navigationQuery = 'select urlname, title, level_0__c, level_1__c, level_2__c, level_3__c, summary from '+this.articleType+' where series__c =  \''+publication.id+'\' and publishStatus = \'Online\' and language=\'en_US\' order by level_0__c asc nulls last, level_1__c asc nulls last, level_2__c asc nulls last, level_3__c asc nulls last, title asc';
                        sObject[] navArticles = database.query(navigationQuery);
                        if(navArticles.size() != 0){
                            for(sObject nav : navArticles){
                                addToNav(nav);
                            }
                        }
                    }
                }
            }
            if(this.navObjects.size() == 0)
                this.isStaticNav = true;
            for(navObject no : this.navObjects){
                if(no.empty == false){
                    this.isStaticNav = false;
                    break;
                }else{
                    this.isStaticNav = true;
                }
            }   
            if(ApexPages.currentPage().getParameters().get('series') != null && ApexPages.currentPage().getParameters().get('type') != null){
                SeriesRedirect();
            }             
        }else{
            pageError = true;
        }
    }  
    
    public pageReference error(){
        PageReference errors= new PageReference('/apex/pagenotfound');
        PageReference p = new PageReference('login?inst=t'); 
        if(pageError == true){
            errors.setRedirect(true);
            return errors;
        }else if(publicViewing || customerViewing){
           return null;
        }else{
           p.getParameters().put('UnAuth', '1');  
           p.getParameters().put('retURL', '/article');  
           p.setRedirect(true);
           return p;
        }
    }
 
public void addToNav(sObject so){
    boolean e0 = false;
    for(navObject n0 : this.navObjects){
        if(so.get('level_0__c') != null){
            //this is a level_0 record
            if(so.get('level_0__c') == n0.text){
                e0 = true;
                break;
            }
        }else{
            //this is a level_1 record
            if(so.get('level_1__c') == n0.text){
                e0 = true;
                break;
            }
        }
    }
    if(!e0){
        navObject tmp0 = new navObject();
        tmp0.text = (string) so.get('title');                           
        tmp0.links = new navObject[]{};
        if((string) so.get('level_0__c') == null && (string) so.get('level_1__c') == null){
            tmp0.url = (string) so.get('urlname');
            tmp0.summary = (string) so.get('summary');
            tmp0.id = (string) so.get('id');
        }else{
            if(so.get('level_0__c') != null){
                tmp0.text = (string) so.get('level_0__c');
            }else{
                tmp0.text = (string) so.get('level_1__c');
            }
        }
        this.navObjects.add(tmp0);
    }
    //second tier
    for(navObject n0 : this.navObjects){
        if(so.get('level_0__c') != null){
            if((string) so.get('level_0__c') == n0.text){
                boolean e1 = false;
                for(navObject n1 : n0.links){
                    if(n1.text == (string) so.get('level_1__c')){
                        e1 = true;
                        break;
                    }
                }
                if(!e1){
                    navObject tmp1 = new navObject();
                    tmp1.text = (string) so.get('title');                           
                    tmp1.links = new navObject[]{};
                    if((string) so.get('level_1__c') == null && (string) so.get('level_2__c') == null){
                        n0.empty = false;
                        tmp1.url = (string) so.get('urlname');
                        tmp1.summary = (string) so.get('summary');
                        tmp1.id = (string) so.get('id');
                    }else{
                        tmp1.text = (string) so.get('level_1__c');
                    }
                    n0.links.add(tmp1);
                }
            }
        }else{
            if((string) so.get('level_1__c') == n0.text){
                boolean e1 = false;
                for(navObject n1 : n0.links){
                    if(n1.text == (string) so.get('level_2__c')){
                        e1 = true;
                        break;
                    }
                }
                if(!e1){
                    navObject tmp1 = new navObject();
                    tmp1.text = (string) so.get('title');                           
                    tmp1.links = new navObject[]{};
                    if((string) so.get('level_2__c') == null && (string) so.get('level_3__c') == null){
                        n0.empty = false;
                        tmp1.url = (string) so.get('urlname');
                        tmp1.summary = (string) so.get('summary');
                        tmp1.id = (string) so.get('id');
                    }else{
                        tmp1.text = (string) so.get('level_2__c');
                    }
                    n0.links.add(tmp1);
                }
            }
        }
    }    
    //third tier
    for(navObject n0 : this.navObjects){
        if(so.get('level_0__c') != null){
            if((string) so.get('level_0__c') == n0.text){
                for(navObject n1 : n0.links){
                    if(n1.text == (string) so.get('level_1__c')){
                        boolean e2 = false;
                        for(navObject n2 : n1.links){
                            if(n2.text == (string) so.get('level_2__c')){
                                e2 = true;
                                break;
                            }
                        }
                        if(!e2){
                            navObject tmp2 = new navObject();
                            tmp2.text = (string) so.get('title');                           
                            tmp2.links = new navObject[]{};
                            if((string) so.get('level_2__c') == null && (string) so.get('level_3__c') == null){
                                n0.empty = false;
                                n1.empty = false;
                                tmp2.url = (string) so.get('urlname');
                                tmp2.summary = (string) so.get('summary');
                                tmp2.id = (string) so.get('id');
                            }else{
                                tmp2.text = (string) so.get('level_2__c');
                            }
                            n1.links.add(tmp2);
                        }
                    }
                }
            }
        }else{
            if((string) so.get('level_1__c') == n0.text){
                for(navObject n1 : n0.links){
                    if(n1.text == (string) so.get('level_2__c')){
                        boolean e2 = false;
                        for(navObject n2 : n1.links){
                            if(n2.text == (string) so.get('level_3__c')){
                                e2 = true;
                                break;                            
                            }
                        }
                        if(!e2){
                            navObject tmp2 = new navObject();
                            tmp2.text = (string) so.get('title');                           
                            tmp2.links = new navObject[]{};
                            if((string) so.get('level_3__c') == null){
                                n0.empty = false;
                                n1.empty = false;
                                tmp2.url = (string) so.get('urlname');
                                tmp2.summary = (string) so.get('summary');
                                tmp2.id = (string) so.get('id');
                            }else{
                                tmp2.text = (string) so.get('level_3__c');
                            }
                            n1.links.add(tmp2);
                        }
                    }
                }
            }
        }    
    }
    //fourth tier
    for(navObject n0 : this.navObjects){
        if(so.get('level_0__c') != null){
            if((string) so.get('level_0__c') == n0.text){
                for(navObject n1 : n0.links){
                    if(n1.text == (string) so.get('level_1__c')){
                        for(navObject n2 : n1.links){
                            if(n2.text == (string) so.get('level_2__c')){
                                boolean e3 = false;
                                for(navObject n3 : n2.links){
                                    if(n3.text == (string) so.get('level_3__c') && so.get('level_3__c') != null){
                                        e3 = true;
                                        n0.empty = false;
                                        n1.empty = false;
                                        n2.empty = false;
                                        n3.empty = false;
                                        navObject tmp4 = new navObject();
                                        tmp4.text = (string) so.get('title');
                                        tmp4.url  = (string) so.get('urlname');
                                        tmp4.summary = (string) so.get('summary');
                                        tmp4.id = (string) so.get('id');
                                        n3.links.add(tmp4);             
                                        break;
                                    }
                                }
                                if(!e3){
                                    navObject tmp3 = new navObject();
                                    if(so.get('level_3__c') != null){
                                        tmp3.text = (string) so.get('level_3__c');
                                        tmp3.links = new navObject[]{};
                                        tmp3.empty = false;
                                        navObject tmp4 = new navObject();
                                        tmp4.url  = (string) so.get('urlname');
                                        tmp4.text = (string) so.get('title');
                                        tmp4.summary = (string) so.get('summary');
                                        tmp4.id = (string) so.get('id');
                                        tmp3.links.add(tmp4);
                                    }else{
                                        tmp3.url  = (string) so.get('urlname');
                                        tmp3.text = (string) so.get('title');
                                        tmp3.summary = (string) so.get('summary');
                                        tmp3.id = (string) so.get('id');
                                        tmp3.links = new navObject[]{};
                                    }
                                    n0.empty = false;
                                    n1.empty = false;
                                    n2.empty = false;
                                    n2.links.add(tmp3);             
                                }
                            }
                        }
                    }
                }
            }
        }    
    }
}
}