public without sharing class Profile_Controller {
	public String fatalError {get; set;}
	public Participation__c participation {get; set;}
	public String status {get; set;}  //Status of the Participation (e.g. Active or Inactive)
	public Boolean isActive {get; set;} //Whether the Partication is Active (true) or Inactive (false)
	public String inactiveReason {get; set;}
	public framework[] frameworks {get; set;}
	public Third_Party__c[] statutoryBodies {get; set;}
	public Third_Party__c[] HrResolutionProviders {get; set;}
	public Third_Party__c[] NonHrResolutionProviders {get; set;}
	public Map<String, Artifact__c[]> artifacts {get; set;}
	public Third_Party__c[] verifiers {get; set;}
	public Boolean hasHr {get; set;}
	public Boolean hasNonHr {get; set;}
	public Third_Party_Master_List__c verifier {get; set;}
	public Id participationId {get; set;}
	public Map<String, Asset> assets {get; set;}
	public List<Order> OrderList {get; set;}

	public Boolean getIsContact(){
		if (ApexPages.currentPage().getParameters().get('contact') != null) {
			return true;
		}
		return false;
	}

	public class framework {
		public String status {get; set;}
		public String inactive_reason {get; set;}
		public String framework {get; set;}
		public Boolean affirmation {get; set;}
		public String product {get; set;}
		public String purpose {get; set;}
		public Inactive_Period__c[] inactivePeriods {get; set;}
		public Boolean HRData {get; set;}
		public Boolean NonHRData {get; set;}
		public String SelfVerified {get; set;}
	}

	public String SelfVerified{get; set;}

	public Boolean HasEditAccess {get; set;}

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
		for (Asset a : [SELECT Status FROM Asset WHERE Participant__c = :THIS.participationId]) {
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
		this.assets = new Map<String, Asset>();
		Set<Id> ThirdParties = new Set<Id>();
		this.artifacts = new Map<String, Artifact__c[]>();
		Set<Id> ThirdPartyResolutionProviderIDs = new Set<Id>();
		Id verifierId = null;

		this.participation = [SELECT
							   Id, Name, Street__c, City__c, State__c, Postal_Code__c, Phone__c, Fax__c, Website__c, Organization__c, Public_Display_Name__c,
							   Level_of_Sales__c, Country__c, Number_of_Employees__c, Privacy_Programs__c, Program__c, Purpose__c, Claiming_Self_Verified__c,
							   (SELECT Id, First_Name__c, Last_Name__c, Email__c, Fax__c, Phone__c, Contact_Office__c, Title__c FROM Participant_Contacts__r WHERE Role__c = 'Organization Contact' ORDER BY LastModifiedDate DESC LIMIT 1) primary_contact,
							   (SELECT Id, NAME FROM covered_entities__r ORDER BY NAME ASC),
							   (SELECT Id FROM orders__r),
							   (SELECT Id, industry__c, sector__c, sub_sector__c FROM industries__r ORDER BY industry__c ASC, sector__c ASC, sub_sector__c ASC)
							   FROM Participation__c WHERE Id = :THIS.participationId LIMIT 1
							 ];

		this.OrderList = [SELECT
						Id, OrderNumber, TotalAmount, order.Status, EffectiveDate, Participant__c, AccountId, CreatedDate,
						(SELECT Id, PricebookEntry.Product2.Name FROM OrderItems),
						(SELECT Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c
						FROM Payments__r)
						FROM Order WHERE Participant__r.Id = :THIS.participationId];


		UserRecordAccess[] access = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :THIS.participationId];
		if(access.size() != 0){
			this.HasEditAccess = true;
		}

		for(Artifact__c artifact : [SELECT Id, Name, Effective_Date__c, Type__c, External_Artifact_URL__c, Description__c
							FROM Artifact__c
							WHERE Participation_Profile__c = :THIS.participationId AND isCurrent__c = TRUE
							ORDER BY Name ASC]){
				if(this.artifacts.get(artifact.Type__c) == null){
					this.artifacts.put(artifact.Type__c, new Artifact__c[]{});
				}
				this.artifacts.get(artifact.Type__c).add(artifact);
			}

		for(Asset a : [SELECT
					  Id, Account.id, Product2Id, HR_Data__c, Non_HR_Data__c, Inactive_Status_Reason__r.Description__c, Framework__r.Name, Status, Framework__r.Product__c,
					  Affirmation__c, InstallDate, Program__r.Name, PurchaseDate, UsageEndDate,
					  (SELECT Start_Date__c, End_Date__c FROM Inactive_Periods__r ORDER BY End_Date__c DESC NULLS FIRST LIMIT 1)
						  FROM Asset
						  WHERE Participant__c = :THIS.participationId]) {

			if(a.HR_Data__c){
				hasHr = true;
			}
			if(a.Non_HR_Data__c){
				hasNonHr = true;
			}

			framework f = new framework();
			f.framework = a.Framework__r.Name;
			f.status = a.Status;
			f.inactive_reason = a.Inactive_Status_Reason__r.Description__c;
			f.product = a.Framework__r.Product__c;
			f.inactivePeriods = a.Inactive_Periods__r;
			f.affirmation = a.Affirmation__c;
			f.HRData = a.HR_Data__c;
			f.NonHRData = a.Non_HR_Data__c;
			this.frameworks.add(f);

			if(a.Account.id == participation.Organization__c) {
				this.assets.put(a.Product2Id, a);
				this.inactiveReason = a.Inactive_Status_Reason__r.Description__c;
				if(a.Status == 'Active'){
					this.inactiveReason = '';
				}
			}
		}

		for(Third_Party__c party : [SELECT Id, NonHR_Data__c, HR_Data__c, RecordType.Name, RecordType.DeveloperName, Asset__r.Status, Asset__r.HR_Data__c, Asset__r.Non_HR_Data__c, Third_Party_Master_List__r.NonHR_Data__c, Third_Party_Master_List__r.HR_Data__c, Third_Party_Master_List__c, Third_Party_Master_List__r.Website__c, Third_Party_Master_List__r.Name
						  FROM Third_Party__c
						  WHERE Participation__c = :THIS.participationId
						  ORDER BY RecordType.Name ASC, Asset__c ASC NULLS LAST, Third_Party_Master_List__r.Name ASC]){
				if(party.RecordType.DeveloperName == 'Statutory_Body' && !ThirdParties.contains(party.Third_Party_Master_List__c)){
					this.statutoryBodies.add(party);
					ThirdParties.add(party.Third_Party_Master_List__c);
				}
				if(party.RecordType.DeveloperName == 'Resolution_Provider' && !ThirdPartyResolutionProviderIDs.contains(party.Third_Party_Master_List__c)){
					if(party.Third_Party_Master_List__c != null && party.Third_Party_Master_List__r != null) {
						if(party.Asset__r.Status == 'Active' && party.NonHR_Data__c && party.Asset__r.Non_HR_Data__c && party.Third_Party_Master_List__r.NonHR_Data__c) {
							NonHrResolutionProviders.add(party);
						}
						if(party.Asset__r.Status == 'Active' && party.HR_Data__c && party.Asset__r.HR_Data__c && party.Third_Party_Master_List__r.HR_Data__c) {
							HrResolutionProviders.add(party);
						}
					}
					if (party.Asset__r.Status == 'Active') {
						ThirdPartyResolutionProviderIDs.add(party.Third_Party_Master_List__c);
					}
				}
				if(party.RecordType.DeveloperName == 'Verification'){
					//only one verification method is required
					verifierId = party.Third_Party_Master_List__c;
					this.verifiers.add(party);
				}
			}

		System.debug('Verifier Id: ' + verifierId);
		if(verifierId != null){
			this.verifier = [SELECT Id, Name, Website__c FROM Third_Party_Master_List__c WHERE Id = :verifierId LIMIT 1];
		}
	}

}