public class print_article_controller {

public string atom {get; set;}
public string url {get; set;}
public string title {get; set;}
public string summary {get; set;}
public string references {get; set;}
public string published {get; set;}
public string id {get; set;}
public boolean isSectionalNav {get; set;}
public boolean isStaticNav {get; set;}

public string publication {get; set;}
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
    public string atom {get; set;}
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

public print_article_controller(){
    if(ApexPages.CurrentPage().getParameters().get('id') != null){
        string art = ApexPages.CurrentPage().getParameters().get('id');
        isSectionalNav = false;
        isStaticNav = false;
        this.id = art;
        this.url = art;
        this.navObjects = new navObject[]{};
        KnowledgeArticleVersion[] articleVersions = [select articleType from knowledgearticleversion where urlname = :art and publishStatus = 'Online' and language = 'en_US'];
        if(articleVersions.size() != 0){
            KnowledgeArticleVersion article = articleVersions[0];
            this.navigation = new map<string, map<string, map<string, string>>>();
            for(chapter_section__c a : [select id, name, chapter__r.name, Publication_Template__c from chapter_section__c where (chapter__r.Publication_Template__r.name = :article.articleType or Publication_Template__r.name = :article.articleType) order by chapter__r.sort_order__c, sort_order__c asc nulls last]){
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
            string query = 'select id, articlenumber, title, atom__c, references__c, series__r.name, level_2__c, level_1__c, summary, lastpublisheddate from '+article.articleType+' where urlname = \''+art+'\' and publishStatus = \'Online\' and language=\'en_US\' order by level_1__c asc nulls last limit 1';
            sObject[] articles = database.query(query);
            if(articles.size() == 1){
                this.id = (string) articles[0].get('id');
                this.atom = (string) articles[0].get('atom__c');
                    this.atom = this.atom.replaceAll('/servlet/rtaImage', 'https://tradesites.secure.force.com/platform/servlet/rtaImage');
                this.summary = (string) articles[0].get('summary');
                this.title = (string) articles[0].get('title');
                this.references = (string) articles[0].get('references__c');
                DateTime dt = (datetime) articles[0].get('lastpublisheddate');
                this.published = dt.Month()+'/'+dt.Day()+'/'+dt.Year();
                this.publication = (string) articles[0].get('series__c');
                if(articles[0].get('level_1__c') != null){
                this.chapter = (string) articles[0].get('level_1__c');
                    if(this.chapter.split(': ').size() != 1)
                        this.chapter = this.chapter.split(': ')[1];
                }
                this.section = (string) articles[0].get('level_2__c');
                if(this.publication != null){
                    Series__c publication = [select id, name, type__c from Series__c where id = :this.publication limit 1];
                    this.publication = publication.name;
                    if(publication.type__c == 'Country Commercial'){
                        this.country = publication.name.split(' Country')[0];
                    }
                    string navigationQuery = 'select urlname, title, level_1__c, level_2__c, atom__c, summary from '+article.articleType+' where series__c =  \''+publication.id+'\' and publishStatus = \'Online\' and language=\'en_US\' order by level_1__c asc nulls last';
                    sObject[] navArticles = database.query(navigationQuery);
                    if(navArticles.size() != 0){
                        for(sObject nav : navArticles){
                            string ch = (string) nav.get('level_1__c');
                            if(ch != null){
                                if(ch.split(': ').size() != 1)
                                    ch = ch.split(': ')[1];
                            }
                            if(nav.get('level_1__c') != null && nav.get('level_2__c') != null){
                                //only build the chapter layout if the chapter is set on the Article.
                                boolean exists = false;
                                string chap = (string) nav.get('level_1__c');
                                if(chap.split(': ').size() != 1)
                                    chap = chap.split(': ')[1];
                                for(navObject n : this.navObjects){
                                    if(n.text == chap){
                                        exists = true;
                                        break;
                                    }
                                }
                                if(!exists){
                                    navObject tmpNavObject = new navObject();
                                        tmpNavObject.text = ch;
                                        tmpNavObject.links = new navObject[]{};
                                    this.navObjects.add(tmpNavObject);
                                }
                                if(nav.get('level_2__c') != null){
                                    for(navObject n : this.navObjects){
                                        if(n.text == chap){
                                            boolean el = false;
                                            for(navObject l : n.links){
                                                if(l.text == nav.get('level_2__c')){
                                                    el = true;
                                                    break;
                                                }
                                            }
                                            if(!el){
                                                navObject tmpL = new navObject();
                                                tmpL.text = (string) nav.get('level_2__c');
                                                tmpL.links = new navObject[]{};
                                                n.links.add(tmpL);
                                            }
                                            boolean ea = false;
                                            for(navObject a : n.links){
                                                if(a.text == nav.get('title')){
                                                    ea = true;
                                                    break;
                                                }
                                                if(!ea && a.text == (string) nav.get('level_2__c')){
                                                    navObject tmpA = new navObject();
                                                    tmpA.text = (string) nav.get('title');
                                                    tmpA.url = (string) nav.get('urlname');
                                                    tmpA.id = (string) nav.get('id');
                                                    tmpA.summary = (string) nav.get('summary');
                                                    tmpA.atom = (string) nav.get('atom__c');
                                                    n.empty = false;
                                                    a.empty = false;
                                                    tmpA.links = new navObject[]{};
                                                    a.links.add(tmpA);
                                                }
                                            }
                                        }
                                    }
                                }
                            }else if(nav.get('level_2__c') != null){
                                isSectionalNav = true;
                                //section no chapter goes here
                                boolean exists = false;
                                for(navObject n : this.navObjects){
                                    if(n.text == nav.get('level_2__c')){
                                        exists = true;
                                        break;
                                    }
                                }
                                if(!exists){
                                    navObject tmpNavObject = new navObject();
                                        tmpNavObject.text = (string) nav.get('level_2__c');
                                        tmpNavObject.links = new navObject[]{};
                                    this.navObjects.add(tmpNavObject);
                                }
                                for(navObject n : this.navObjects){
                                    if(n.text == (string) nav.get('level_2__c')){
                                        navObject tmpA = new navObject();
                                        tmpA.text = (string) nav.get('title');
                                        tmpA.url = (string) nav.get('urlname');
                                        tmpA.id = (string) nav.get('id');
                                        tmpA.summary = (string) nav.get('summary');
                                        tmpA.atom = (string) nav.get('atom__c');
                                        n.empty = false;
                                        
                                        system.debug('@@ '+ tmpA);
                                        n.links.add(tmpA);
                                        system.debug(n.links);
                                   }
                                }
                            }else if(nav.get('level_1__c') != null && nav.get('level_2__c') == null){
                                isSectionalNav = true;
                                //section no chapter goes here
                                boolean exists = false;
                                for(navObject n : this.navObjects){
                                    if(n.text == nav.get('level_1__c')){
                                        exists = true;
                                        break;
                                    }
                                }
                                if(!exists){
                                    navObject tmpNavObject = new navObject();
                                        tmpNavObject.text = (string) nav.get('level_1__c');
                                        tmpNavObject.links = new navObject[]{};
                                    this.navObjects.add(tmpNavObject);
                                }
                                for(navObject n : this.navObjects){
                                    if(n.text == (string) nav.get('level_1__c')){
                                        navObject tmpA = new navObject();
                                        tmpA.text = (string) nav.get('title');
                                        tmpA.url = (string) nav.get('urlname');
                                        tmpA.id = (string) nav.get('id');
                                        tmpA.summary = (string) nav.get('summary');
                                        tmpA.atom = (string) nav.get('atom__c');
                                        n.empty = false;
                                        
                                        system.debug('@@ '+ tmpA);
                                        n.links.add(tmpA);
                                        system.debug(n.links);
                                   }
                                }
                            }else{
                                //no navigation goes here
                                isStaticNav = true;
                                navObject tmp = new navObject();
                                    tmp.text = (string) nav.get('title');
                                    tmp.url = (string) nav.get('urlname');
                                    tmp.id = (string) nav.get('id');
                                    tmp.summary = (string) nav.get('summary');
                                    tmp.atom = (string) nav.get('atom__c');
                                    tmp.links = new navObject[]{};
                                    this.navObjects.add(tmp);
                            }
                        }
                    }
                }
            }
        }else{
            this.title = 'Page Not Found';
            Date dt = Date.today();
            this.published = dt.Month()+'/'+dt.Day()+'/'+dt.Year();
            this.atom = 'We\'re sorry, this page does not exist.';
        }
    }
}
}