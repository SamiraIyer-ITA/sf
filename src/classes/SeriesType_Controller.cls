public class SeriesType_Controller {
    public string type {get; set;}
    public string recordID {get; set;}
    public string className {get; set;}
    
    public string getRecordType(){
        string output = '';
        output = KnowledgeMap__c.getAll().get(this.type).api__c;
        return output;
    }
    
    public SelectOption[] getTypes(){
        SelectOption[] output = new SelectOption[]{};
        output.add(new selectOption('', ' -- Select a Series -- '));
        Series__c[] seriesList = database.query('select id, name from Series__c where type__c = \''+this.type+'\' order by name asc');
        map<string, integer> counts = new map<string, integer>();
        for(series__c series : seriesList){
            counts.put(series.id, 0);
        }
        SObject[] articles = database.query('select series__c, count(id) from '+this.getRecordType()+' where publishStatus = \'online\' and language=\'en_US\' group by series__c');
        for(sObject article : articles){
            if(counts.get((string) article.get('series__c')) != null){
                string s = (string) article.get('series__c');
                counts.put(s, (integer) article.get('expr0'));
            }
        }
        for(Series__c series : seriesList){
            if(counts.get(series.id) != 0){
                output.add( new SelectOption(series.id, series.name) );
            }
        }
        return output;
    }
}