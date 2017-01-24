public class km_atom_controller {

public string atom {get; set;}
public string title {get; set;}
public string summary {get; set;}
public string references {get; set;}
public string published {get; set;}

public km_atom_controller(){
    if(ApexPages.CurrentPage().getParameters().get('id') != null){
        string art = ApexPages.CurrentPage().getParameters().get('id');
        system.debug('@@article:  '+ApexPages.CurrentPage().getParameters());
        KnowledgeArticleVersion[] articleVersions = [select articleType from knowledgearticleversion where urlname = :art and publishStatus = 'Online' and language = 'en_US'];
        if(articleVersions.size() != 0){
            KnowledgeArticleVersion article = articleVersions[0];
            string query = 'select id, articlenumber, title, atom__c, references__c, summary, lastpublisheddate from '+article.articleType+' where urlname = \''+art+'\' and publishStatus = \'Online\' and language=\'en_US\' limit 1';
            sObject[] articles = database.query(query);
            if(articles.size() == 1){
                this.atom = (string) articles[0].get('atom__c');
                    this.atom = this.atom.replaceAll('/servlet/rtaImage', 'https://tradesites.secure.force.com/platform/servlet/rtaImage');
                this.summary = (string) articles[0].get('summary');
                this.title = (string) articles[0].get('title');
                this.references = (string) articles[0].get('references__c');
                DateTime dt = (datetime) articles[0].get('lastpublisheddate');
                this.published = dt.Month()+'/'+dt.Day()+'/'+dt.Year();
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