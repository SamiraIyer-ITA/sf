public class participant_search_controller {

    public String SelectedDataType { get; set; }

    public SelectOption[] getAvailablePrograms() {
        SelectOption[] output = new SelectOption[]{};
        output.add(new selectOption('', '-- NO FILTER --'));
        string query = 'select id, name from framework__c where isActive__c = true';
        if(ApexPages.currentPage().getParameters().get('program') != null)
            query += ' and program__r.name = \''+ApexPages.currentPage().getParameters().get('program')+'\'';
        query += ' order by name asc';
        for(Framework__c framework : database.query(query)){
            output.add(new selectOption(framework.id, framework.name));
        }
        return output;
    }
    
    private string ActiveParticipantsQuery {get; set;}
    private string ActiveParticipantAccountsQuery {get; set;}
    
    public Integer getTotalOrgCount() {
        system.debug(this.ActiveParticipantsQuery );
        participant__c[] ActiveParticipants =  database.Query(this.ActiveParticipantsQuery );
        
        //Get the list of accounts that contain an asset matching the program provided
        if (this.ActiveParticipantAccountsQuery != null) {  //This query will be null if no framework or program is selected
            system.debug(this.ActiveParticipantAccountsQuery);
            Account[] ActiveParticipantAccounts = database.Query(this.ActiveParticipantAccountsQuery );
            return ActiveParticipantAccounts.size();
        } else {
            return ActiveParticipants.size();
        }
    }

    public String serviceProvider {get; set;}    
    public map<string, string> serviceProviderMap {get;set;}

    public SelectOption[] getServiceProviders(){
        SelectOption[] output = new SelectOption[]{};
        output.add(new SelectOption('', '-- NO FILTER --'));
        for(Third_Party_Master_List__c provider : [select id, name from third_party_master_list__c where type__c = 'Dispute Resolution Provider' order by name asc]){
            output.add(new SelectOption(provider.id, provider.name));
            this.serviceProviderMap.put(provider.id, provider.name);
        }
        return output;
    }

    public String selectedProgram { get; set; }

    public participant_search_controller(){
        this.offset = 0;
        this.serviceProviderMap = new map<string, string>();
        if(ApexPages.currentPage().getParameters().get('status') != null){
            this.status = ApexPages.currentPage().getParameters().get('status');
        }        
        if(ApexPages.currentPage().getParameters().get('search') != null){
            this.searchTerm = ApexPages.currentPage().getParameters().get('search');
        }
        if(ApexPages.currentPage().getParameters().get('provider') != null){
            this.serviceProvider = ApexPages.currentPage().getParameters().get('provider');
        }
    }

    public String status {
        get{
            if(this.status == null)
                this.status = 'Active';
            return this.status;
        }
        set; 
    }
    
    public string[] getCouldStartWith(){
        return new string[]{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    } 
    
    public string startsWith {get; set;}

    public String searchTerm {get; set;}

    public string getReferencedProgram(){
    if(ApexPages.currentPage().getParameters().get('program') != null)    
        return ApexPages.currentPage().getParameters().get('program');
    return null;
    }

    public integer offset {get; set;}
    public integer getLimit(){
        return 10;
    }

    public void search() {
        this.ActiveParticipantsQuery = 'SELECT id, participant__r.organization__c FROM Participant__c WHERE Status__c =\'Active\'';
        this.ActiveParticipantAccountsQuery = null;
    
        if(ApexPages.currentPage().getParameters().get('offsetChange') != null){
            this.offset += Integer.valueOf(ApexPages.currentPage().getParameters().get('offsetChange'));
        }
        if(ApexPages.currentPage().getParameters().get('startsWith') != null){
            this.startsWith = ApexPages.currentPage().getParameters().get('startsWith')+'%';
        }
                
        string query = 'select id, name, participant__c, framework__r.name, HR_Data__c, Non_HR_Data__c, participant__r.Public_Display_Name__c, participant__r.Organization__c, participant__r.city__c, participant__r.state__c, participant__r.name, (select id, type__c from artifacts__r), (select id, third_party_master_list__c from third_parties__r where third_party_master_list__r.type__c = \'Dispute Resolution Provider\') from participant__c where framework__r.isActive__c = true and status__c=\''+this.status+'\'';
        if(this.selectedProgram != null && this.selectedProgram != ''){
            query += 'and framework__c = \''+this.selectedProgram+'\'';
            this.ActiveParticipantsQuery += ' and framework__c = \''+this.selectedProgram+'\'';
            //this.ActiveParticipantAccountsQuery = 'select accountid from asset where name = \''+this.selectedProgram+'\'';
        }        
        if(this.startsWith != null){
            query += ' and participant__r.name like \''+this.startsWith+'\'';
        }
        if(this.searchTerm != null){
            query += ' and participant__r.name like \'%'+this.searchTerm+'%\'';
        }
        
        if(ApexPages.currentPage().getParameters().get('program') != null){
            query += ' and framework__r.program__r.name = \''+ApexPages.currentPage().getParameters().get('program')+'\'';
            this.ActiveParticipantsQuery += ' and framework__r.program__r.name = \''+ApexPages.currentPage().getParameters().get('program');
            this.ActiveParticipantAccountsQuery = 'select account from asset where program__r.name == \''+ApexPages.currentPage().getParameters().get('program')+'\'';
        }
        query += ' order by participant__r.name asc limit '+this.getLimit()+' offset '+this.offset;
        this.searchResults = new map<id, participating>();
        this.participants = database.query(query);
        Set<Id> AccountSet = new Set<Id>();
        for(Participant__c p: this.participants){ 
            AccountSet.add(p.participant__r.Organization__c);
        }
        Set<Id> AccountsWithAssets = new Set<Id>();
        for(Account a: [SELECT Id, (SELECT Id FROM Assets) FROM Account WHERE Id IN: AccountSet]) {
            if(a.Assets.size() > 0) {
                AccountsWithAssets.add(a.Id);
            }
        }

        for(Participant__c p : this.participants){
            system.debug(p.name+' - '+p.participant__r.Organization__c);
            system.debug(!AccountsWithAssets.contains(p.participant__r.Organization__c));
            if(!AccountsWithAssets.contains(p.participant__r.Organization__c)) {continue;}
            system.debug(this.searchResults.get(p.participant__c) == null);
            if(this.searchResults.get(p.participant__c) == null){
                system.debug('create new participating');
                participating part = new participating();
                    part.name = p.participant__r.Public_Display_Name__c;
                    part.id = p.participant__c;
                    part.city = p.participant__r.city__c;
                    part.state = p.participant__r.state__c;
                    part.programs = new string[]{};
                    part.coveredData = new string[]{};
                    part.coveredDataTypes = new set<string>();
                    if(p.HR_Data__c) {
                        part.coveredData.add('HR');
                        part.coveredDataTypes.add('HR');
                    }
                    if(p.Non_HR_Data__c) {
                        part.coveredData.add('Non-HR');
                        part.coveredDataTypes.add('Non-HR');
                    }
                    part.coveredEntities = new string[]{};
                    part.resolutionProviders = new set<string>();
                this.searchResults.put(p.participant__c, part);
            }
            system.debug(this.searchResults);
            set<string> programs = new set<string>();
            set<string> coveredData = new set<string>();
            for(string art : searchResults.get(p.participant__c).coveredData){
                coveredData.add(art);
            }
            for(string program : searchResults.get(p.participant__c).programs){
                programs.add(program);
            }
            /*for(artifact__c art : p.artifacts__r){
                if(!coveredData.contains(art.type__c)){
                    searchResults.get(p.participant__c).coveredData.add(art.type__c);
                    searchResults.get(p.participant__c).coveredDataTypes.add(art.type__c);
                    coveredData.add(art.type__c);
                }
            }*/
            for(third_party__c tp : p.third_parties__r){
                searchResults.get(p.participant__c).resolutionProviders.add(tp.third_party_master_list__c);
            }
            if(!programs.contains(p.framework__r.name)){
                searchResults.get(p.participant__c).programs.add(p.framework__r.name);
            }
        }
        for(participation__c p : [select id, (select id, name from Covered_Entities__r order by name asc) from participation__c where id in :searchResults.keySet()]){
            for(Covered_Entity__c ce : p.Covered_Entities__r){
                searchResults.get(p.id).coveredEntities.add(ce.name);
            }
        }
        if(this.serviceProvider != null && this.serviceProvider != ''){
            for(id key : searchResults.keySet()){
                if(!searchResults.get(key).resolutionProviders.contains(this.serviceProvider)){
                    searchResults.remove(key);
                }
            }
        }
        if(this.SelectedDataType != null && this.SelectedDataType != ''){
            for(id key : searchResults.keySet()){
                if(!searchResults.get(key).coveredDataTypes.contains(this.SelectedDataType)){
                    searchResults.remove(key);
                }
            }
        }
        participant__c[] limitedList = new participant__c[]{};
        system.debug(searchResults);
        system.debug(searchResults.keySet());
        for(participant__c p :this.participants){
            system.debug(p.participant__c);
            if(searchResults.keySet().contains(p.participant__c)){
                limitedList.add(p);
                system.debug(p);
            }
        }
        system.debug(this.participants);
        this.participants = limitedList;
        this.queryString = query;
        system.debug(this.participants);
        system.debug(this.queryString);
    }
    
    public string queryString {get; set;}
    public Participant__c[] participants {get; set;}

    public map<id, participating> searchResults {get; set;}
    
    public class participating{
        public string name {get; set;}
        public string id {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string[] programs {get; set;}
        public string[] coveredData {get; set;}
        public string[] coveredEntities {get; set;}
        public set<string> coveredDataTypes {get; set;}
        public set<string> resolutionProviders {get; set;}
    }
    
    public boolean getShowResolutionProviders(){
        return ApexPages.currentPage().getParameters().get('showDRP') != null;
    }
}