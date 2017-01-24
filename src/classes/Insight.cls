public with sharing Class Insight {
  
    public Insight(){
        this.record = new Insight__c();
    }
  
    public string Title {get; set;}
    public string Summary {get; set;}
    public string RecordId {get; set;}
    public string SelectedBoard {get;set;}
    
    public Insight__c record {get; set;}
    
    public Insight__c[] getRecords(){
        return [select id, name, name__c, goals__c from Insight__c where isdeleted = false order by name__c asc];
    }   

    public map<string, string> getMostRecent(){
        map<string, string> output = new map<string, string>();
        for(Insight_Atom__c atom : [select id, Insight__c, insight__r.name__c from Insight_Atom__c where createddate = last_n_days:30 and insight__c != null order by createddate desc limit 1000]){
            if(output.size() < 3){
                output.put(atom.insight__c, atom.insight__r.name__c);
            }else{
                return output;
            }
        }
        return output;
    }
    
    public void pin(){
        Insight_Atom__c atom = new Insight_Atom__c();
        atom.Atom__c = this.RecordId;
        atom.Insight__c = this.SelectedBoard;
        system.debug(atom);
        try{
            insert atom;
            system.debug(atom);
        }catch(Exception e){
            system.debug(e);
            ApexPages.addMessages(e);
        }
    }
    
    public void doNothing(){
        //do nothing
    }

    public void remove(){
        try{
            delete this.record;
        }catch(Exception e){
              ApexPages.addMessages(e);
        }    
    }

    public void save(){
        try{
            upsert this.record;
            this.record = new Insight__c();
        }catch(Exception e){
              ApexPages.addMessages(e);
        }
    }

    public void create(){
        system.debug('create record');
        try{
            system.debug('@@'+this.record);
            insert this.record;
            this.record = new Insight__c();
        }catch(Exception e){
            system.debug(e);
            ApexPages.addMessages(e);
        }
    }
}