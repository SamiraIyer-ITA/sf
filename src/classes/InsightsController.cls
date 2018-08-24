public with sharing class InsightsController {

    public void doNothing() {
        //does nothing, but is used for component rerendering of the full page.
    }

    public void removeInsight() {
        this.Insight = null;
        this.InsightId = null;
    }



/* GET THE LIST OF INSIGHT RECORDS THAT THE RUNNING USER HAS ACCESS TO */
public Insight__c[] getInsights(){
    Insight__c[] tmp = [select id, name, name__c, (select id, atom__c from insight_atoms__r order by sort_order__c asc nulls last, createddate asc) from Insight__c order by name__c asc];
 
    //BUILD A LIST OF ARTICLE NAMES FROM THE LIST OF INSIGHT RECORDS
    string[] atoms = new string[]{};
    for(Insight__c ins : tmp)
        for(Insight_Atom__c atom : ins.insight_atoms__r){
            atoms.add(atom.atom__c);
        }
    //COMBINE THE LIST INTO A SINGLE COMMA-DELIMITED STRING
    String atomSearch = String.join( atoms, ', ' );

    //USE SOSL TO FIND ALL OF THE ATOMS IN THE LIST, RETURNING THE ID, TITLE, SUMMARY, AND URLNAME OF THE ARTICLES.
    if(atoms.size() != 0){
        Search.SearchResults searchResults = Search.find('FIND \''+atomSearch+'\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(id, title, summary, urlname, versionnumber, lastpublisheddate WHERE PublishStatus = \'Online\' AND Language = \'en_US\' and IsLatestVersion = true) WITH SNIPPET (target_length=120)');
        articleMap = new map<string, KnowledgeArticleVersion>(); 
        List<Search.SearchResult> articlelist = searchResults.get('KnowledgeArticleVersion');

        //ITERATE THROUGH THE SEARCH RESULTS AND BUILD A MAP OF URLNAME TO KNOWLEDGEARTICLEVERSION (ARTICLE) FOR USE IN THE VISUALFORCE PAGE.    
        for (Search.SearchResult searchResult : articleList) { 
            KnowledgeArticleVersion article = (KnowledgeArticleVersion) searchResult.getSObject(); 
            this.articleMap.put(article.urlName, article);
        }
    }            
    //RETURN THE LIST OF INSIGHT RECORDS THAT THIS USER HAS ACCESS TO.
    return tmp;
}

public map<string, KnowledgeArticleVersion> articleMap {get; set;}

//public Insight_Chapter__c InsightChapter {get;set;}
//public Insight_Atom__c InsightAtom {get; set;}

public Insight__c Insight {get; set;}
public string InsightId {get; set;}

public PageReference SelectInsight(){
    if(this.InsightId != null){
        this.Insight = this.getInsight();
    }
    return null;
}

public Insight__c getInsight(){
    return [select (select id, atom__c, lastmodifiedby.alias, lastmodifiedby.firstname, lastmodifiedby.lastname from insight_atoms__r order by sort_order__c asc nulls last, createddate asc), id, name__c, goals__c from Insight__c where id = :this.InsightId limit 1];
}

public string InsightAtomId {get; set;}

public pageReference removeArticle(){
    delete [select id from insight_atom__c where id = :this.InsightAtomId limit 1];
    this.Insight = this.getInsight();
    this.InsightAtomId = null;
    return null;
}

public pageReference sortArticleUp(){
    double i = 0;
    for(Insight_Atom__c ia : this.Insight.Insight_Atoms__r){
        if(i != 0 && ia.id == this.InsightAtomId){
            i = i - .5;
        }else{
            i = i + 1;
        }
        ia.sort_order__c = i;
    }
    update this.Insight.Insight_Atoms__r;
    this.Insight = getInsight();
    return null;
}

public pageReference sortArticleDown(){
    double i = 0;
    boolean incrementNext = false;
    for(Insight_Atom__c ia : this.Insight.Insight_Atoms__r){
        if(ia.id == this.InsightAtomId){
            incrementNext = true;
        }else{
            incrementNext = false;
        }
        ia.sort_order__c = i;
        if(incrementNext){
            i = i - .5;
        }else{
            i++;
        }
    }
    
    update this.Insight.Insight_Atoms__r;
    this.Insight = getInsight();
    return null;
}

/*
public PageReference buildInsightChapter(){
    if(this.insightChapterId != null){
        Insight_Chapter__c tmp = [select id, name, title__c, (select id, atom__c from insight_atoms__r order by sort_order__c asc nulls last, createddate asc) from Insight_Chapter__c where id = :this.insightChapterId limit 1];
        string[] atoms = new string[]{};
        for(Insight_Atom__c atom : tmp.insight_atoms__r){
            atoms.add(atom.atom__c);
        }

        String atomSearch = String.join( atoms, ', ' );
        Search.SearchResults searchResults = Search.find('FIND \''+atomSearch+'\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(id, title, summary, urlname WHERE PublishStatus = \'Online\' AND Language = \'en_US\') WITH SNIPPET (target_length=120)');
        articleMap = new map<string, KnowledgeArticleVersion>(); 
        List<Search.SearchResult> articlelist = searchResults.get('KnowledgeArticleVersion');
        
        for (Search.SearchResult searchResult : articleList) { 
            KnowledgeArticleVersion article = (KnowledgeArticleVersion) searchResult.getSObject(); 
            this.articleMap.put(article.urlName, article);
        }

        this.insightChapter = tmp;
    }
    return null;
}

public string insightChapterId {get; set;}
*/
}