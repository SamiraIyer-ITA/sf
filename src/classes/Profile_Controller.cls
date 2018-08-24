public without sharing class Profile_Controller {
    public String fatalError {get; set;}
    public Participation__c participation {get; set;}
    public String status {get; set;}  //Status of the Participation (e.g. Active or Inactive)
    public boolean isActive {get; set;} //Whether the Partication is Active (true) or Inactive (false)
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
    public Id participationId {get; set;}
    public map<string, asset> assets {get; set;}
    public list<order> OrderList {get; set;}
    
    public boolean getIsContact(){
        if(ApexPages.currentPage().getParameters().get('contact') != null)
            return true;
        return false;
    }

    public class framework {
        public string status {get; set;}
        public string inactive_reason {get; set;}
        public string framework {get; set;}
        public boolean affirmation {get; set;}
        public string product {get; set;}
        public string purpose {get; set;}
        public inactive_period__c[] inactivePeriods {get; set;}
        public boolean HRData {get; set;}
        public boolean NonHRData {get; set;}
        public string SelfVerified {get; set;}
    }

    public string SelfVerified{get; set;}

    public boolean HasEditAccess {get; set;}

    public Profile_Controller() {
        this.isActive = true;  //Default to true        
        this.status = 'Active';     
        if(ApexPages.currentPage().getParameters().get('status') != null && ApexPages.currentPage().getParameters().get('status') == 'Inactive'){       
            this.isActive = false;      
            this.status = 'Inactive';       
        }
        
        this.participationId= ApexPages.currentPage().getParameters().get('Id');
        
        //Verify that the status parameter is valid
        Integer inactiveCount = 0;
        Integer activeCount = 0;
        for (Asset a : [SELECT Status FROM Asset WHERE Participant__c = :this.participationId]) {
            if (a.Status == 'Inactive') {
                inactiveCount += 1;
            } else if (a.Status == 'Active') {
                activeCount += 1;
            }
        }
        if (activeCount == 0 && inactiveCount == 0) {
            //This company has no inactive or active participations
            //Display an error message
            fatalError = 'Invalid status parameter in the URL.';
    		    return;
        } else if (this.status == 'Active' && activeCount == 0 && inactiveCount > 0) {
            //Change status to Inactive and display those records
            this.isActive = false;
            this.status = 'Inactive';
        } else if (this.status == 'Inactive' && activeCount > 0 && inactiveCount == 0) {
            //Change status to Active and display those records
            this.isActive = true;
            this.status = 'Active';
        } else {
            //Change nothing.  The status is ok.
            //This covers the following cases:
            //this.status == 'Active' && activeCount > 0
            //this.status == 'Inactive' && inactiveCount > 0
        }
        
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
        set<id> ThirdParties = new set<id>();
        this.artifacts = new map<string, Artifact__c[]>();
        set<id> ThirdPartyResolutionProviderIDs = new set<id>();
        Id verifierId = null;
        
        this.participation = [SELECT
                               Id, Name, street__c, city__c, state__c, postal_code__c, phone__c, fax__c, website__c, organization__c, public_display_name__c,
                               Level_of_Sales__c, Country__c, Number_of_Employees__c, Privacy_Programs__c, Program__c, Purpose__c, Claiming_Self_Verified__c,
                               (SELECT id, first_name__c, last_name__c, email__c, fax__c, phone__c, contact_office__c, title__c FROM participant_contacts__r WHERE role__c = 'Organization Contact' order by lastmodifieddate DESC LIMIT 1) primary_contact,
                               (SELECT id, name FROM covered_entities__r order by name ASC),
                               (select id from orders__r),
                               (SELECT id, industry__c, sector__c, sub_sector__c FROM industries__r order by industry__c ASC, sector__c ASC, sub_sector__c ASC)
                               FROM Participation__c WHERE id = :this.participationId LIMIT 1
                             ];
        
        this.OrderList = [select 
                        id, ordernumber, TotalAmount, order.status, effectivedate, participant__c, accountid, createddate,
                        (select id, Pricebookentry.Product2.Name from orderitems),
                        (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c 
                        FROM Payments__r)
                        FROM order WHERE Participant__r.id = :this.participationId];
                        
               
        UserRecordAccess[] access = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :this.participationId];
        if(access.size() != 0){
            this.HasEditAccess = true;
        }               
                          
        for(Artifact__c artifact : [SELECT id, name, Effective_Date__c, type__c, External_Artifact_URL__c, description__c 
                            FROM Artifact__c 
                            WHERE Participation_Profile__c = :this.participationId AND isCurrent__c = true 
                            ORDER BY name ASC]){
                if(this.artifacts.get(artifact.type__c) == null){
                    this.artifacts.put(artifact.type__c, new Artifact__c[]{});
                }
                this.artifacts.get(artifact.type__c).add(artifact);
            }
                              
        for(Asset a : [SELECT
                      id, account.id, product2Id, hr_data__c, non_hr_data__c, inactive_status_reason__r.description__c, framework__r.name, status, framework__r.product__c, 
                      affirmation__c, installdate, program__r.name, purchasedate, usageenddate,
                      (SELECT Start_Date__c, End_Date__c FROM Inactive_Periods__r ORDER BY end_date__c DESC NULLS FIRST LIMIT 1)               
                          FROM Asset
                          WHERE Participant__c = :this.participationId]) {
                
            if(a.hr_data__c){
                hasHR = true;
            }
            if(a.non_hr_data__c){
                hasNonHR = true;
            }
            
            framework f = new framework();
            f.framework = a.framework__r.name;
            f.status = a.status;
            f.inactive_reason = a.Inactive_Status_Reason__r.Description__c;
            f.product = a.framework__r.product__c;
            f.inactivePeriods = a.inactive_periods__r;
            f.affirmation = a.affirmation__c;
            f.HRData = a.hr_data__c;
            f.NonHRData = a.non_hr_data__c;
            this.frameworks.add(f);           

            if(a.account.id == participation.organization__c) {
                this.Assets.put(a.product2Id, a);
                this.inactiveReason = a.Inactive_Status_Reason__r.Description__c;
                if(a.status == 'Active'){
                    this.inactiveReason = '';
                }
            }
        } 
        
        for(third_party__c party : [SELECT id, NonHR_Data__c, HR_Data__c, recordtype.name, recordtype.DeveloperName, asset__r.status, asset__r.hr_data__c, asset__r.non_hr_data__c, third_party_master_list__r.nonhr_data__c, third_party_master_list__r.hr_data__c, Third_Party_Master_List__c, Third_Party_Master_List__r.website__c, Third_Party_Master_List__r.name
                          FROM Third_Party__c
                          WHERE Participation__c = :this.participationId
                          ORDER BY recordtype.name ASC, asset__c asc nulls last, Third_Party_Master_List__r.name ASC]){
                if(party.RecordType.DeveloperName == 'Statutory_Body' && !thirdParties.contains(party.Third_Party_Master_List__c)){
                    this.statutoryBodies.add(party);
                    thirdParties.add(party.Third_Party_Master_List__c);
                }
                if(party.RecordType.DeveloperName == 'Resolution_Provider' && !ThirdPartyResolutionProviderIDs.contains(party.Third_Party_Master_List__c)){
                    if(party.Third_Party_Master_List__c != null && party.Third_Party_Master_List__r != null) {
                        if(party.asset__r.status == 'Active' && party.nonhr_data__c && party.asset__r.non_hr_data__c && party.third_party_master_list__r.nonHR_Data__c) {
                            NonHrResolutionProviders.add(party);
                        }
                        if(party.asset__r.status == 'Active' && party.hr_data__c && party.asset__r.hr_data__c && party.third_party_master_list__r.HR_Data__c) {
                            HrResolutionProviders.add(party);
                        }
                    }
                    if(party.asset__r.status == 'Active')
                        ThirdPartyResolutionProviderIDs.add(party.Third_Party_Master_List__c);
                }
                if(party.RecordType.DeveloperName == 'Verification'){
                    //only one verification method is required
                    verifierId = party.Third_Party_Master_List__c;
                    this.verifiers.add(party);
                }
            }                       

        System.debug('Verifier Id: ' + verifierId);
        if(verifierId != null){
            this.verifier = [SELECT id, name, website__c FROM Third_Party_Master_List__c WHERE id = :verifierId LIMIT 1];
        }
    }
    
}