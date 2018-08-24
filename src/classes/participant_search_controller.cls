public class participant_search_controller {

    public pageReference advancedSearch() {
        this.offset = 0;
        system.debug('Advanced Search');
        this.search();
        return null;
    }


    public String SelectedDataType { get; set; }
    public String tempQuery {get; set;}    //For debugging
    public String tempString {get; set;}   //For debugging

    public string tmpQuery {get; set;}

    public String selectedOffset {get; set;}
    public Integer getSelectedOffsetInteger(){
        if(this.selectedOffset == null){
            return 10;
        }
        return Integer.valueOf(this.selectedOffset);
    }

    public List<SelectOption> getOffsetOptions(){
        List<SelectOption> output = new List<SelectOption>();
        output.add(new SelectOption('10', '10'));
        output.add(new SelectOption('25', '25'));
        output.add(new SelectOption('50', '50'));
        return output;
    }

    public SelectOption[] getAvailablePrograms() {
        SelectOption[] output = new SelectOption[]{};
        output.add(new selectOption('', '-- NO FILTER --'));
        string query = 'SELECT Id, Name FROM Framework__c WHERE isActive__c = true';
        if(ApexPages.currentPage().getParameters().get('program') != null)
            query += ' and name = \''+ApexPages.currentPage().getParameters().get('program')+'\'';
        query += ' ORDER BY Name ASC';
        for(Framework__c f : database.query(query)){
            output.add(new selectOption(f.id, f.name));
        }
        return output;
    }

    private string ActiveParticipantsQuery {get{return 'SELECT id, participant__c, accountid FROM asset WHERE status = \'Active\' AND Framework__r.isActive__c = true and participant__r.program__r.name = \'Privacy Shield\'';}}
    
    public Integer getTotalOrgCount() {
        system.debug(this.ActiveParticipantsQuery );
        asset[] ActiveParticipants =  database.Query(this.ActiveParticipantsQuery );
        return ActiveParticipants.size();
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
        if (ApexPages.currentPage().getParameters().get('program') != null) {
            this.selectedProgram = ApexPages.currentPage().getParameters().get('program');
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
    
    //private boolean isActive { get{if (this.status=='Active') {return true;} else { return false;}}}
    
    public string[] getCouldStartWith(){
        return new string[]{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
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
        return this.getSelectedOffsetInteger();
    }

    public integer totalFilteredParticipants{get; set;}

    public pageReference search() {
        system.debug('Searching...');
        system.debug(ApexPages.currentPage().getParameters().get('searchMethod'));
        this.searchResults = new map<id, participating>();
        if(ApexPages.currentPage().getParameters().get('searchMethod') == 'StartingLetter'){
            this.searchTerm = null;
        }
        if(ApexPages.currentPage().getParameters().get('searchMethod') == 'SearchTerm'){
            this.startsWith = null;
        }    
        if(ApexPages.currentPage().getParameters().get('offsetChange') != null){
            this.offset += Integer.valueOf(ApexPages.currentPage().getParameters().get('offsetChange'));
        }
        if(ApexPages.currentPage().getParameters().get('startsWith') != null){
            this.startsWith = ApexPages.currentPage().getParameters().get('startsWith')+'%';
        }
        if(!String.isBlank(this.searchTerm)) {
            if (this.searchTerm.length() > 1) {
                this.searchTerm = '%' + this.searchTerm.trim()+'%';
            } else {
                this.searchTerm = this.searchTerm.trim()+'%';
            }
        }

        //Status is determined by the Asset, so query for all assets first.
        Set<Id> ParticipationsByAsset = new Set<Id>();
        Set<Id> AssetIds = new Set<Id>();
        
        if(this.selectedProgram == null){
            System.debug('Selected Program is null');
            System.debug('Asset Status: ' + this.status);
            for(asset asset : [select id, participant__c from asset where status = :this.status and participant__r.program__r.name = 'Privacy Shield']){
                ParticipationsByAsset.add(asset.participant__c);
                AssetIds.add(asset.id);
            }
        }else{
            System.debug('Selected Program: ' + this.selectedProgram);
            for(asset asset : [select id, participant__c from asset where status = :this.status and framework__c = :this.selectedProgram and participant__r.program__r.name = 'Privacy Shield']){
                ParticipationsByAsset.add(asset.participant__c);
                AssetIds.add(asset.id);
            }
        }

        System.debug('Participations by Asset: ' + ParticipationsByAsset.size());
        system.debug('DATA TYPE:  '+this.selectedDataType);

        if(!String.IsBlank(this.SelectedDataType)){
            for(Asset asset : [select id, participant__c, hr_data__c, non_hr_data__c from asset where id in :AssetIds]){
                if(this.SelectedDataType == 'HR Data' && asset.hr_data__c == false){
                    ParticipationsByAsset.remove(asset.Participant__c);
                }
                if(this.SelectedDataType == 'Non-HR Data' && asset.non_hr_data__c == false){
                    ParticipationsByAsset.remove(asset.participant__c);
                }
            }
        }

        Set<Id> FilteredParticipations = new Set<Id>();
        Set<Id> ParticipationsBySearchTerm = new Set<Id>();

        if(!String.IsBlank(this.searchTerm)){
            system.debug('Searching CEs using Search Term: \'' + this.searchTerm + '\'');
            List<Covered_Entity__c> CEList = [select id, participant__c from Covered_Entity__c where Name like :this.searchTerm OR participant__r.name like :this.searchTerm OR participant__r.public_display_name__c like :this.searchTerm order by participant__r.public_display_name__c asc limit 1000];
            for(Covered_Entity__c ce : CEList){
                ParticipationsBySearchTerm.add(ce.participant__c);
            }
            for(Participation__c p : [select id from participation__c where id in :ParticipationsByAsset AND (name like :this.searchTerm OR public_display_name__c like :this.searchTerm) order by public_display_name__c asc limit 1000]){
                ParticipationsBySearchTerm.add(p.id);            
            }
        }

        if(!String.IsBlank(this.startsWith)){
            system.debug('Searching Applications using startsWith: \'' + this.startsWith+ '\'');
//            List<Covered_Entity__c> CEList = [select id, participant__c from Covered_Entity__c where Name like :this.startsWith OR participant__r.name like :this.startsWith OR participant__r.public_display_name__c like :this.startsWith order by participant__r.public_display_name__c asc limit 1000];
//            for(Covered_Entity__c ce : CEList){
//                ParticipationsBySearchTerm.add(ce.participant__c);
//            }
            for(Participation__c p : [select id from participation__c where id in :ParticipationsByAsset AND /*(name like :this.startsWith OR */ public_display_name__c like :this.startsWith /*)*/ order by public_display_name__c asc limit 1000]){
                ParticipationsBySearchTerm.add(p.id);            
            }
        }

        //loop through the search results and the assets to make sure that there are matching records
        if(ParticipationsBySearchTerm.size() != 0){
            system.debug('ParticipationsBySearchTerm is not 0.');
            for(Id filterResult : ParticipationsBySearchTerm){
                if(ParticipationsByAsset.contains(filterResult)){
                    FilteredParticipations.add(filterResult);
                }
            }
        }else{  //otherwise if there are no search terms, use the list of participations by status.
        
            system.debug('Term:  '+String.isEmpty(this.searchTerm));
            system.debug('Start:  '+String.isEmpty(this.startsWith));

            if(!String.isEmpty(this.searchTerm) || !String.isEmpty(this.startsWith)){
                system.debug('ParticipationsBySearchTerm is 0 and there should be no results.');            
            }else{
                system.debug('ParticipationsBySearchTerm is 0.');
                FilteredParticipations = ParticipationsByAsset;
            }
        }
        

        if(this.serviceProvider != null && this.serviceProvider != ''){
            system.debug('Service Provider...' + this.serviceProvider);
            Set<Id> ProviderListResults = new Set<Id>();
            for(Third_Party__c tp : [select id, participation__c, third_party_master_list__c from third_party__c where third_party_master_list__c = :this.serviceProvider AND participation__c in :FilteredParticipations]){
                ProviderListResults.add(tp.participation__c);
            }
            FilteredParticipations = ProviderListResults;
        }

        this.totalFilteredParticipants = FilteredParticipations.size();

        this.participants = [select id, public_display_name__c, city__c, state__c, 
            (select id, hr_data__c, non_hr_data__c,  usageenddate, framework__r.name from assets__r WHERE status = :this.Status and Framework__r.isActive__c = true ORDER BY framework__r.name asc),
            (select id, type__c from artifacts__r),
            (select id, name from Covered_Entities__r order by name asc),
            (select id, third_party_master_list__c from third_parties__r where third_party_master_list__r.type__c = 'Dispute Resolution Provider')
            from participation__c where id in :FilteredParticipations order by public_display_name__c asc limit :this.getSelectedOffsetInteger() offset:this.offset ];
        System.debug('Participants size:' + this.participants.size());
        for(Participation__c p : this.participants){
            if(this.searchResults.get(p.id) == null){
                participating part = new participating();
                    part.name = p.Public_Display_Name__c;
                    part.id = p.id;
                    part.city = p.city__c;
                    part.state = p.state__c;
                    part.programs = new string[]{};
                    part.coveredData = new string[]{};
                    part.coveredDataTypes = new set<string>();
                    boolean hasHr = false;
                    boolean hasNonHr = false;
                    set<string> ProgramSet = new set<string>();
                    for(asset a: p.assets__r){
                        if (a.HR_Data__c&& !hasHr){ 
                            part.coveredData.add('HR');
                            part.coveredDataTypes.add('HR');
                            hasHr = true;
                        }
                        if (a.Non_HR_Data__c && !hasNonHr){
                            part.coveredData.add('Non-HR');
                            part.coveredDataTypes.add('Non-HR');
                            hasNonHr = true;
                        }
                        if(!programSet.contains(a.framework__r.name)){
                            part.programs.add(a.framework__r.name);
                            programSet.add(a.framework__r.name);   
                        }
                    }
                    part.coveredEntities = new string[]{};
                    for(Covered_Entity__c ce : p.Covered_Entities__r){
                        part.coveredEntities.add(ce.name);
                    }

                this.searchResults.put(p.id, part);
            }        
        }
        return null;
    }
        
    public string queryString {get; set;}
    public Participation__c[] participants {get; set;}

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