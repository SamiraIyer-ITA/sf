public without sharing class Profile_Controller {
    public Participation__c participant {get; set;}
    public participant__c[] participations {get; set;}
    public boolean isActive {get; set;}
    public string inactiveReason {get; set;}
    public framework[] frameworks {get; set;}
    public Third_Party__c[] statutoryBodies {get; set;}
    public Third_Party__c[] HrResolutionProviders {get; set;}
    public Third_Party__c[] NonHrResolutionProviders {get; set;}
    public map<string, Artifact__c[]> artifacts {get; set;}
    public Third_Party__c[] verifiers {get; set;}
    public Boolean hasHr {get; set;}
    public Boolean hasNonHr {get; set;}
    public Third_Party_Master_List__c verifier {get; set;}
    public Id participantId {get; set;}
    public map<string, asset> assets {get; set;}
    
    public boolean getIsContact(){
        if(ApexPages.currentPage().getParameters().get('contact') != null)
            return true;
        return false;
    }

    public class framework {
        public string status {get; set;}
        public string inactive_reason {get; set;}
        public string framework {get; set;}
        public string affirmation {get; set;}
        public string product {get; set;}
        public string purpose {get; set;}
        public string applicationStage {get; set;}
        public inactive_period__c[] inactivePeriods {get; set;}
        public boolean HRData {get; set;}
        public boolean NonHRData {get; set;}
        public string SelfVerified {get; set;}
    }

    public string SelfVerified{get; set;}

    public boolean HasEditAccess {get; set;}

    public Profile_Controller() {
        this.HasEditAccess = false;
        hasNonHr = false;
        hasHr = false;
        this.frameworks = new framework[]{};
        this.statutoryBodies = new Third_Party__c[]{};
        this.verifier = new Third_Party_Master_List__c();
        NonHrResolutionProviders = new Third_Party__c[]{};
        HrResolutionProviders = new Third_Party__c[]{};
        this.verifiers = new Third_Party__c[]{};
        this.assets = new map<string, asset>();
        this.participantId = ApexPages.currentPage().getParameters().get('Id');
        set<id> ThirdParties = new set<id>();
        this.artifacts = new map<string, Artifact__c[]>();
        set<id> ThirdPartyResolutionProviderIDs = new set<id>();
        Id verifierId = null;
            this.participant = [SELECT
                                Id, Name, street__c, city__c, state__c, postal_code__c, phone__c, fax__c, website__c, organization__c,
                                (SELECT id, status__c, inactive_status_reason__r.description__c, framework__r.name FROM Participations__r order by lastmodifieddate ASC),
                                (SELECT id, first_name__c, last_name__c, email__c, fax__c, phone__c, contact_office__c, title__c FROM participant_contacts__r WHERE role__c = 'Organization Contact' order by lastmodifieddate DESC LIMIT 1) primary_contact,
                                (SELECT id, name FROM covered_entities__r order by name ASC),
                                (select id from orders__r),
                                (SELECT id, industry__c, sector__c, sub_sector__c FROM industries__r order by industry__c ASC, sector__c ASC, sub_sector__c ASC)
                                FROM Participation__c WHERE id = :this.participantId LIMIT 1
                              ];

            this.OrderList = [select 
                            id, ordernumber, TotalAmount, order.status, effectivedate, participation__c, accountid, createddate,
                            (select id, Pricebookentry.Product2.Name from orderitems),
                            (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c 
                             FROM Payments__r)
                             from order where participant__c = :this.participant.Id];
            UserRecordAccess[] access = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :this.participant.id];
            if(access.size() != 0){
                this.HasEditAccess = true;
            }
            for(Participant__c p : [SELECT
                                    id, status__c, Claiming_Self_Verified__c, program__c, framework__r.name, framework__r.product__c, application_stage__c, 
                                    affirmation__r.product2id, purpose__c, hr_data__c, non_hr_data__c, Inactive_Status_Reason__c,
                                        (SELECT Start_Date__c, End_Date__c FROM Inactive_Periods__r order by end_date__c DESC nulls first),
                                        (SELECT id, recordtype.name, recordtype.DeveloperName, Third_Party_Master_List__c, 
                                                NonHR_Data__c, HR_Data__c, 
                                                Third_Party_Master_List__r.website__c, Third_Party_Master_List__r.name 
                                            FROM third_parties__r 
                                            order by recordtype.name ASC, Third_Party_Master_List__r.name ASC),
                                        (SELECT id, name, Effective_Date__c, type__c, External_Artifact_URL__c, description__c FROM Artifacts__r WHERE isCurrent__c = true order by name ASC)
                                    FROM participant__c 
                                    WHERE participant__c = :this.participant.id
                                  ]){
                if(p.hr_data__c) {hasHr = true;} //used for rendering HR block on VF page
                if(p.non_hr_data__c) {hasNonHr = true;}  
                framework f = new framework();
                    f.framework = p.framework__r.name;
                    f.status = p.status__c;
                    f.inactive_reason = p.inactive_status_reason__c;
                    f.product = p.framework__r.product__c;
                    f.applicationStage = p.application_stage__c;
                    f.inactivePeriods = p.inactive_periods__r;
                    f.affirmation = p.affirmation__r.product2id;
                    f.purpose = p.purpose__c;
                    f.HRData = p.hr_data__c;
                    f.NonHRData = p.non_hr_data__c;
                    this.SelfVerified = p.Claiming_Self_Verified__c;
                this.frameworks.add(f);
                for(third_party__c party : p.third_parties__r){
                    if(party.RecordType.DeveloperName == 'Statutory_Body' && !thirdParties.contains(party.Third_Party_Master_List__c)){
                        this.statutoryBodies.add(party);
                        thirdParties.add(party.Third_Party_Master_List__c);
                    }
                    if(party.RecordType.DeveloperName == 'Resolution_Provider' && !ThirdPartyResolutionProviderIDs.contains(party.Third_Party_Master_List__c)){
                        if(party.Third_Party_Master_List__c != null && party.Third_Party_Master_List__r != null) {
                            if(party.NonHR_Data__c) {
                                NonHrResolutionProviders.add(party);
                            }
                            if(party.Hr_Data__c) {
                                HrResolutionProviders.add(party);
                            }
                        }
                        ThirdPartyResolutionProviderIDs.add(party.Third_Party_Master_List__c);
                    }
                    if(party.RecordType.DeveloperName == 'Verification'){
                        //only one verification method is required
                        verifierId = party.Third_Party_Master_List__c;
                        this.verifiers.add(party);
                    }
                }
                for(Artifact__c artifact : p.artifacts__r){
                    if(this.artifacts.get(artifact.type__c) == null){
                        this.artifacts.put(artifact.type__c, new Artifact__c[]{});
                    }
                    this.artifacts.get(artifact.type__c).add(artifact);
                }
            }
            for(Asset asset : [SELECT id, product2Id, installdate, program__r.name, status, PurchaseDate, UsageEndDate FROM Asset WHERE accountId = :this.participant.organization__c]){
                this.Assets.put(asset.product2Id, asset);
            }                  
        this.isActive = false; //isActive defaults to false.  It only becomes Active if there is an active particpation in the program.
        for(Participant__c part : participant.Participations__r){
            this.inactiveReason = part.inactive_status_reason__r.description__c;
            if(part.status__c == 'Active'){
                this.isActive = true;
                this.inactiveReason = '';
                break;
            }
        }
        if(verifierId != null){
            this.verifier = [SELECT id, name, website__c FROM Third_Party_Master_List__c WHERE id = :verifierId LIMIT 1];
        }
    }
    
    public list<order> OrderList {get; set;}
    
    //TODO Remove the references to standard controller and update TEST_ECOMM
    public Profile_Controller(ApexPages.StandardController controller) {
        hasNonHr = false;
        hasHr = false;
        this.frameworks = new framework[]{};
        this.statutoryBodies = new Third_Party__c[]{};
        this.verifier = new Third_Party_Master_List__c();
        NonHrResolutionProviders = new Third_Party__c[]{};
        HrResolutionProviders = new Third_Party__c[]{};
        this.verifiers = new Third_Party__c[]{};
        this.assets = new map<string, asset>();
        this.participant = (Participation__c)controller.getRecord();
        set<id> ThirdParties = new set<id>();
        this.artifacts = new map<string, Artifact__c[]>();
        set<id> ThirdPartyResolutionProviderIDs = new set<id>();
        Id verifierId = null;
            this.participant = [SELECT
                                Id, Name, street__c, city__c, state__c, postal_code__c, phone__c, fax__c, website__c, organization__c,
                                (SELECT id, status__c, inactive_status_reason__r.description__c, framework__r.name FROM Participations__r order by lastmodifieddate ASC),
                                (SELECT id, first_name__c, last_name__c, email__c, fax__c, phone__c, contact_office__c, title__c FROM participant_contacts__r WHERE role__c = 'Organization Contact' order by lastmodifieddate DESC LIMIT 1) primary_contact,
                                (SELECT id, name FROM covered_entities__r order by name ASC),
                                (select id from orders__r),
                                (SELECT id, industry__c, sector__c, sub_sector__c FROM industries__r order by industry__c ASC, sector__c ASC, sub_sector__c ASC)
                                FROM Participation__c WHERE id = :this.participant.Id LIMIT 1
                              ];
                              
            this.OrderList = [select 
                            id, ordernumber, TotalAmount, order.status, effectivedate, participation__c, accountid, createddate,
                            (select id, Pricebookentry.Product2.Name from orderitems),
                            (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c 
                             FROM Payments__r)
                             from order where participant__c = :this.participant.Id];
                             
            for(Participant__c p : [SELECT
                                    id, status__c, program__c, inactive_status_reason__c, framework__r.name, framework__r.product__c, application_stage__c, affirmation__r.product2id, purpose__c, hr_data__c, non_hr_data__c,
                                        (SELECT Start_Date__c, End_Date__c, Inactive_Status_Reason__r.Description__c FROM Inactive_Periods__r order by end_date__c DESC nulls first),
                                        (SELECT id, recordtype.name, recordtype.DeveloperName, Third_Party_Master_List__c, NonHR_Data__c, HR_Data__c, 
                                                Third_Party_Master_List__r.HR_Data__c, Third_Party_Master_List__r.NonHR_Data__c, 
                                                Third_Party_Master_List__r.website__c, Third_Party_Master_List__r.name 
                                            FROM third_parties__r 
                                            order by recordtype.name ASC, Third_Party_Master_List__r.name ASC),
                                        (SELECT id, name, Effective_Date__c, type__c, External_Artifact_URL__c, description__c FROM Artifacts__r WHERE isCurrent__c = true order by name ASC)
                                    FROM participant__c 
                                    WHERE participant__c = :this.participant.id
                                  ]){
                if(p.hr_data__c) {hasHr = true;} //used for rendering HR block on VF page
                if(p.non_hr_data__c) {hasNonHr = true;}  
                framework f = new framework();
                    f.framework = p.framework__r.name;
                    f.status = p.status__c;
                    f.inactive_reason = p.inactive_status_reason__c;
                    f.product = p.framework__r.product__c;
                    f.applicationStage = p.application_stage__c;
                    f.inactivePeriods = p.inactive_periods__r;
                    f.affirmation = p.affirmation__r.product2id;
                    f.purpose = p.purpose__c;
                    f.HRData = p.hr_data__c;
                    f.NonHRData = p.non_hr_data__c;
                this.frameworks.add(f);
                for(third_party__c party : p.third_parties__r){
                    if(party.RecordType.DeveloperName == 'Statutory_Body' && !thirdParties.contains(party.Third_Party_Master_List__c)){
                        this.statutoryBodies.add(party);
                        thirdParties.add(party.Third_Party_Master_List__c);
                    }
                    if(party.RecordType.DeveloperName == 'Resolution_Provider' && !ThirdPartyResolutionProviderIDs.contains(party.Third_Party_Master_List__c)){
                        if(party.Third_Party_Master_List__c != null && party.Third_Party_Master_List__r != null) {
                            if(party.NonHR_Data__c) {
                                NonHrResolutionProviders.add(party);
                            }
                            if(party.Hr_Data__c) {
                                HrResolutionProviders.add(party);
                            }
                        }
                        ThirdPartyResolutionProviderIDs.add(party.Third_Party_Master_List__c);
                    }
                    if(party.RecordType.DeveloperName == 'Verification'){
                        //only one verification method is required
                        verifierId = party.Third_Party_Master_List__c;
                        this.verifiers.add(party);
                    }
                }
                for(Artifact__c artifact : p.artifacts__r){
                    if(this.artifacts.get(artifact.type__c) == null){
                        this.artifacts.put(artifact.type__c, new Artifact__c[]{});
                    }
                    this.artifacts.get(artifact.type__c).add(artifact);
                }
            }
            for(Asset asset : [SELECT id, product2Id, installdate, program__r.name, status, PurchaseDate, UsageEndDate FROM Asset WHERE accountId = :this.participant.organization__c]){
                this.Assets.put(asset.product2Id, asset);
            }                  
        this.isActive = false; //isActive defaults to false.  It only becomes Active if there is an active particpation in the program.
        for(Participant__c part : participant.Participations__r){
            this.inactiveReason = part.inactive_status_reason__r.description__c;
            if(part.status__c == 'Active'){
                this.isActive = true;
                this.inactiveReason = '';
                break;
            }
        }
        if(verifierId != null){
            this.verifier = [SELECT id, name, website__c FROM Third_Party_Master_List__c WHERE id = :verifierId LIMIT 1];
        }
    }
}