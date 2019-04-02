public without sharing class ps_enhanced_controller {

	public PageReference redirectPSEnhanced(){
		if(this.participation.Assets__r.size() == 0){
			PageReference pr = Page.PS_Enhanced;
			pr.getParameters().put('program', this.getProgram().Id);
			pr.setRedirect(true);
			return pr;
		}
		return null;
	}

	public String record { get; set; }

	public PageReference back() {
		if(ApexPages.currentPage().getParameters().get('CurrentStep') != null){
			this.CurrentStep = ApexPages.currentPage().getParameters().get('CurrentStep');
		}
		getCurrentOrderItem();
		return null;
	}

	public String SelectedDoor {get; set;}
	public String SelectedFrameworkId {get; set;}

	public Asset getAsset(){
		//the assumption is that if you are viewing doors you have an asset already.
		return this.participation.Assets__r[0];
	}

	public PageReference AddFramework(){
		System.debug('SELECTED FRAMEWORK:  '+this.SelectedFrameworkId);
		System.debug('PRODUCT:  '+this.getFrameworkProductIdMap().get(this.SelectedFrameworkId));

		Boolean OrderExists = true;
		//if an order doesn't exist, create one associated to the program
		if(this.order == null){
			this.order = new Order(AccountId = this.account.id, Status = 'In Progress', EffectiveDate=Date.today(), Pricebook2Id = this.PriceBook.Id);
		}

		if(this.order.Id == null){
			insert this.order;
			OrderExists = false;
		}

		if(this.SelectedDoor == 'addition'){
			System.debug('@@'+this.SelectedFrameworkId);
			if(!OrderExists){
				insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = ProductPriceMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId)), PricebookEntryId = ProductPriceBookEntryMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId))));
			}else{
				Boolean ItemExists = false;
				//check to see if the product is already on the order
				for(OrderItem item : this.order.OrderItems){
					if(item.Product2Id == getFrameworkProductIdMap().get(this.SelectedFrameworkId)){
						System.debug('ALREADY EXISTS');
						ItemExists = true;
						break;
					}
				}

				if(!ItemExists){
					insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = ProductPriceMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId)), PricebookEntryId = ProductPriceBookEntryMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId))));
				}
			}
			this.order = [SELECT Id, Participant__c, Pricebook2Id, TotalAmount, (SELECT Id, Product2Id, Product2.Name, PricebookEntry.Product2Id, HR_Data__c, UnitPrice, Confirm_HR_Compliance__c, Non_HR_Data__c, PricebookEntry.UnitPrice, Affirmation__c FROM OrderItems ORDER BY Product2.Name ASC) FROM Order WHERE Id = :THIS.order.Id LIMIT 1];
			this.calculatePrices();
		}

		if(this.SelectedDoor == 'recertify'){

			//business requirement:  if they don't have an asset for a product that is set to inactive for withdrawal or affirming, create an order item for it.
			//do not allow for opt-out

			if(!OrderExists){
				for(Asset asset : this.participation.Assets__r){
					//insert a new order for each Active product
					if(asset.Status == 'Active'){
						insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = ProductPriceMap.get(asset.Product2Id), PricebookEntryId = ProductPriceBookEntryMap.get(asset.Product2Id)));
					}else if(asset.Status == 'Inactive' && asset.Affirmation__c == true){
						insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = 200, Affirmation__c = asset.Affirmation__c, PricebookEntryId = ProductPriceBookEntryMap.get(asset.Product2Id)));
					}
				}
			}else{
				//make sure that existing items
				for(Asset asset : this.participation.Assets__r){
					Boolean ItemExists = false;
					System.debug(asset.Product2Id);
					for(OrderItem item : this.order.OrderItems){
						System.debug(asset.Product2Id + ' = ' + item.PricebookEntry.Product2Id);
						if(asset.Product2Id == item.PricebookEntry.Product2Id){
							ItemExists = true;
							break;
						}
					}
					System.debug('Exists:  '+ItemExists);
					if(!ItemExists){
						System.debug('ProductPriceBookEntryMap:  '+ProductPriceBookEntryMap);
						System.debug(asset.Product2Id);
						if(asset.Status == 'Active'){
							insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = ProductPriceMap.get(asset.Product2Id), PricebookEntryId = ProductPriceBookEntryMap.get(asset.Product2Id)));
						}else if(asset.Status == 'Inactive' && asset.Affirmation__c == true){
							insert (new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = 200, Affirmation__c = asset.Affirmation__c, PricebookEntryId = ProductPriceBookEntryMap.get(asset.Product2Id)));
						}
					}
				}
			}
			this.order = [SELECT Id, Participant__c, Pricebook2Id, TotalAmount, (SELECT Id, Product2Id, Product2.Name, PricebookEntry.Product2Id, HR_Data__c, UnitPrice, Confirm_HR_Compliance__c, Non_HR_Data__c, PricebookEntry.UnitPrice, Affirmation__c FROM OrderItems ORDER BY Product2.Name ASC) FROM Order WHERE Id = :THIS.order.Id LIMIT 1];
			this.calculatePrices();
		}

		PageReference pr = Page.ps_enhanced;
		pr.getParameters().put('program', this.getProgram().Id);
		pr.getParameters().put('door', this.SelectedDoor);
		pr.getParameters().put('step', this.SelectedDoor == 'addition' ? 'Step_5' : 'Step_1');

		pr.setRedirect(true);
		return pr;
	}

	public Set<Id> getAffirmations(){
		Set<Id> output = new Set<Id>();
		for(Asset asset: this.participation.Assets__r){
			if(asset.Affirmation__c){
				output.add(asset.Product2Id);
			}
		}
		return output;
	}

	public PageReference jumpTo(String stepNo){
		this.CurrentStep = stepNo;
		if(stepNo.contains('Step_5')){
			//for Step_5 and Step_5A we need to get the CurrentItem.
			this.getCurrentOrderItem();
		}
		if(this.currentItem == null){
			if(this.order.OrderItems.size() != 0){
				this.currentItem = this.order.OrderItems[0];
			}
		}
		return null;
	}

	public String getProgress(){
		Map<String, String> progressMap = new Map<String, String>();
			progressMap.put('welcome', '0');
			progressMap.put('Step_1', '10');
			progressMap.put('Step_2', '20');
			progressMap.put('Step_3', '30');
			progressMap.put('Step_4', '40');
			progressMap.put('Step_5', '50');
			progressMap.put('Step_5A', '55');
			progressMap.put('Step_6', '60');
			progressMap.put('Step_7', '70');
			progressMap.put('Step_8', '80');

			return progressMap.get(this.CurrentStep);
	}

	public void step5(){
		Boolean hasNonHRThirdParty = false;
		for(Third_Party__c tp : this.getResolutionProviders()){
			if(tp.NonHR_Data__c == true){
				hasNonHRThirdParty = true;
				break;
			}
		}

		if(this.currentItem.HR_Data__c && !this.currentItem.Confirm_HR_Compliance__c){
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'HR Data requires confirmation.'));
		}else if(!this.currentItem.HR_Data__c && !this.currentItem.Non_HR_Data__c){
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must select at least one type of data to proceed.'));
		}else if(this.participation.Purpose__c == null || this.participation.Purpose__c.trim() == ''){
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must provide the purpose of data collection to proceed.'));
		}else if(this.currentItem.Non_HR_Data__c == true && !hasNonHRThirdParty){
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must indicate your Recourse Mechanism for Non-HR compliance concerns.'));
		}else{
			this.save();
			this.processHRCompliance();
			//if this is an EU AND an SW app, and the current product is EU, take the user to Step 5A, otherwise take them to step 6.
			if(this.CurrentStep == 'Step_5' && this.currentItem.Product2.Name.contains('EU') && this.getIsEUApp() && this.getIsSWApp()){
				this.CurrentStep = 'Step_5A';
				this.getCurrentOrderItem();
			}else{
				this.CurrentStep = 'Step_6';
			}
		}
	}

	public void step6(){
		if(String.isBlank(this.participation.Claiming_Self_Verified__c)){
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must indicate your compliance verification method to proceed.'));
		}else{
			if((this.participation.Claiming_Self_Verified__c == 'Outside Compliance Review' && this.getVerifiers().size() != 0) || this.participation.Claiming_Self_Verified__c != 'Outside Compliance Review'){
				if(this.getStatutoryBodyId() != null){
						this.CurrentStep = 'Step_7';
				}else{
					this.showErrors = true;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must provide which U.S. Statutory Body you will use to proceed.'));
				}
			}else{
				this.showErrors = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must provide your outside compliance reviewer to proceed.'));
			}
		}
	}

	public PageReference step7(){
		if(this.door == 'edit'){
			PageReference pr = Page.door;
			pr.getParameters().put('program', this.getProgram().Id);
			pr.setRedirect(true);
			return pr;
		}
		if(getDoesPrivacyPolicyExist()){
			this.CurrentStep = 'Step_8';
			this.getAgencyTrackingId();
		}else{
			this.showErrors = true;
		}
		return null;
	}

	public PageReference doNothing(){return null;}

	public User u {get; set;}
	public Account account {get; set;}
	public Participation__c participation {get; set;}
	public Order order {get; set;}
	public List<Order> orders {get; set;}

	public List<String> PreviouslySelectedFrameworks = new List<String>();
	public Map<String, String> FrameworkProductMap {get; set;}
	public Map<String, String> ProductPriceBookEntryMap {get; set;}
	public Map<String, Decimal> ProductPriceMap {get; set;}

	public Boolean showErrors {get; set;}
	public String CurrentStep {get; set;}
	public Pricebook2 PriceBook {get; set;}

	public ps_enhanced_controller(){
		this.CurrentStep = 'welcome'; //INITIAL 'SECTION' THAT THE FORM OPENS TO
		//SET THE AVAILABLE RECORD TYPES FOR THIRD_PARTY__C RECORDS
		for(RecordType rt : [SELECT Id, DeveloperName, Name FROM RecordType WHERE DeveloperName IN ('Verification', 'Resolution_Provider')]){
			if(rt.DeveloperName == 'Resolution_Provider'){
				this.DRPType = rt.Id;
			}
			if(rt.DeveloperName == 'Verification'){
				this.VerifierType = rt.Id;
			}
		}
		this.init();  //INITIALIZE THE PAGE DATA
		if(ApexPages.currentPage().getParameters().get('step') != null){
			this.jumpTo(ApexPages.currentPage().getParameters().get('step'));
		}
		if(ApexPages.currentPage().getParameters().get('door') != null){
			this.door = ApexPages.currentPage().getParameters().get('door');
		}
	}

	public String door {get; set;}

	public void init(){
		this.PreviouslySelectedFrameworks.clear();
		this.SelectedFrameworks.clear();
		this.FrameworkProductMap = new Map<String, String>();
		this.ProductPriceBookEntryMap = new Map<String, String>();
		this.ProductPriceMap = new Map<String, Decimal>();
		Id userId = UserInfo.getUserId();
		this.industry = new Industry__c();
		this.entity = new Covered_Entity__c();
		this.entities = new List<Covered_Entity__c>();
		this.Verifier = new Third_Party__c();
		this.contacts = new List<Participant_Contact__c>();

		this.PriceBook = [SELECT Id, Name, (SELECT Id, Name, Product2Id, UnitPrice FROM PricebookEntries) FROM Pricebook2 WHERE Program__c = :THIS.getProgram().Id];
		for(PricebookEntry pbe : this.PriceBook.PricebookEntries){
			this.ProductPriceBookEntryMap.put(pbe.Product2Id, pbe.Id);
			this.ProductPriceMap.put(pbe.Product2Id, pbe.UnitPrice);
		}

			this.u = [SELECT Id, ContactId, Contact.AccountId, FirstName, LastName, Email, Phone, Fax FROM User WHERE Id = :userId LIMIT 1];

			this.account = [SELECT
				id, name, billingcity, billingstatecode, billingstate,
				billingstreet, billingpostalcode, Privacy_Shield_Disabled__c,
				(SELECT Id FROM Participations__r
					WHERE Program__c = :THIS.getProgram().Id ORDER BY createddate DESC LIMIT 1),
				(SELECT Id FROM Orders WHERE Status = 'In Progress' AND Participant__r.Program__c = :THIS.getProgram().Id LIMIT 1)
				FROM Account WHERE id = :THIS.u.Contact.AccountId LIMIT 1];

			//Check to see if there is an existing order

			if(this.account.orders.size() == 1){
				this.order = [SELECT Id, Participant__c, Pricebook2Id, TotalAmount, (SELECT Id, Product2Id, Product2.Name, PricebookEntry.Product2Id, HR_Data__c, Confirm_HR_Compliance__c, Non_HR_Data__c, UnitPrice, PricebookEntry.UnitPrice, Affirmation__c FROM OrderItems ORDER BY Product2.Name ASC) FROM Order WHERE Id = :THIS.account.orders[0].Id LIMIT 1];
			}else{
				this.order = new Order(AccountId = this.account.id, Status = 'In Progress', EffectiveDate=Date.today(), Pricebook2Id = this.PriceBook.Id);
			}
			if(this.participation != null){
				this.orders = [SELECT
							Id, OrderNumber, TotalAmount, order.Status, EffectiveDate, Participation__c, AccountId, CreatedDate,
							(SELECT Id, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, PricebookEntry.UnitPrice, Affirmation__c FROM OrderItems),
							(SELECT Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c
							 FROM Payments__r)
							 FROM Order WHERE Order_Paid__c = TRUE AND Participant__c = :THIS.participation.Id];
			}else{
				this.orders = new List<Order>();
			}
			for(Framework__c framework : this.getProgram().Frameworks__r){
				this.FrameworkProductMap.put(framework.Id, framework.Product__c);
			}

			//if the Order currently has products, set the SelectedFrameworks
			if(this.order.OrderItems.size() != 0){
				for(Framework__c framework : this.getProgram().Frameworks__r){
					for(OrderItem OrderItem : this.order.OrderItems){
						if(OrderItem.Product2Id == framework.Product__c){
							this.PreviouslySelectedFrameworks.add(framework.Id);
						}
					}
				}
				this.setSelectedFrameworks(this.PreviouslySelectedFrameworks);
			}
			//Check to see if there is an existing participation
			if(this.account.Participations__r.size() != 0){
				this.participation = [SELECT
					Id, Organization__c, Name, Public_Display_Name__c, City__c, Street__c, Privacy_Programs__c,
					State__c, Postal_Code__c, Level_of_Sales__c, Number_of_Employees__c, Purpose__c, Claiming_Self_Verified__c,
					(SELECT Id, Product2.Name, Framework__r.Name, Status, Product2Id, HR_Data__c, Non_HR_Data__c, Inactive_Status_Reason__r.Description__c, Framework__r.Product__c,
					  Affirmation__c, InstallDate, Program__r.Name, PurchaseDate, UsageEndDate FROM Assets__r),
					(SELECT Id, First_Name__c, Last_Name__c, Email__c, Role__c, Contact_Office__c, Phone__c, Contact__c, Fax__c, Title__c FROM Participant_Contacts__r),
					(SELECT Id, Name FROM Covered_Entities__r)
					FROM Participation__c WHERE Id = :THIS.account.participations__r[0].id];
				this.contacts = this.participation.Participant_Contacts__r;
				this.entities = this.participation.Covered_Entities__r;
				//If the Order has a null ID, make sure that it has this record as its participant__c value
				if(this.order.Participant__c == null){
					this.order.Participant__c = this.participation.Id;
				}
			}else{
				this.participation = new Participation__c(
					Program__c = this.getProgram().Id, Organization__c = this.account.id, Name = this.account.name, Public_Display_Name__c = this.account.name,
					City__c = this.account.billingcity, State__c = this.account.billingstate, Postal_Code__c = this.account.billingpostalcode);
			}
	}

	public PageReference RedirectToErrorPage(){
		//checks to see if the Account has 'Privacy Shield Disabled' checkbox set to TRUE and displays the 'forbidden' VFP if they do.
		if(this.account.Privacy_Shield_Disabled__c == true){
			PageReference oops = new PageReference('/apex/pageforbidden');
			oops.setRedirect(true);
			return oops;
		}
		return null;
	}

	//PROGRAM SELECTION METHODS AND VARIABLES
	public Program__c getProgram(){
		if(ApexPages.currentPage().getParameters().get('program') != null){
			try{
				return [SELECT Id, Name, (SELECT Id, Name, Product__c FROM Frameworks__r ORDER BY Name ASC)
						 FROM Program__c WHERE Id = :ApexPages.currentPage().getParameters().get('program') LIMIT 1];
			}catch(Exception e){
				System.debug(e);
				this.showErrors = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'INVALID PROGRAM PROVIDED'));
			}
		}
		return new Program__c();
	}

	public List<String> SelectedFrameworks = new List<String>();
	public List<String> getSelectedFrameworks(){
		return SelectedFrameworks;
	}

	public void setSelectedFrameworks(List<String> frameworks){
		this.SelectedFrameworks = frameworks;
	}

	public Map<String, Id> getFrameworkProductIdMap(){
		Map<String, Id> output = new Map<String, Id>();
		for(Framework__c framework : this.getProgram().Frameworks__r){
			output.put(framework.Name, framework.Product__c);
		}
		return output;
	}

	public Map<String, Asset> getAvailableFrameworkMap(){
		Map<String, Asset> output = new Map<String, Asset>();
		for(Framework__c framework : this.getProgram().Frameworks__r){
			output.put(framework.Name, new Asset());
		}

		for(Asset asset : this.participation.Assets__r){
			output.put(asset.Framework__r.Name, asset);
		}
		return output;
	}

	public List<SelectOption> getAvailableFrameworks(){
		List<SelectOption> output = new List<SelectOption>();
		for(Framework__c framework : this.getProgram().Frameworks__r){
			output.add( new SelectOption(framework.Id, framework.Name));
		}
		return output;
	}

	public Boolean isNewParticipation {get; set;}

	public PageReference start(){
		if(this.SelectedFrameworks == null || this.SelectedFrameworks.size() == 0){
			this.CurrentStep = 'welcome';
			this.showErrors = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'You must select at least one framework that you are applying for to continue.'));
		}else{
			//logic to insert Participation__c, Order as needed
			if(this.participation.Id == null){
				try{
					insert this.participation;
					this.order.Participant__c = this.participation.Id;
				}catch(Exception e){
					this.showErrors = true;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				}
			}
			if(this.order != null && this.order.Id == null){
				try{
					insert this.order;
				}catch(Exception e){
					this.showErrors = true;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				}
			}

			//Logic to insert Participation_Contacts as Needed
			if(this.contacts.size() == 0){
				List<Participant_Contact__c> initialContacts = new List<Participant_Contact__c>();
				initialContacts.add(new Participant_Contact__c(
					First_Name__c = this.u.FirstName,
					Last_Name__c = this.u.LastName,
					Email__c = this.u.Email,
					Phone__c = this.u.Phone,
					Fax__c = this.u.Fax,
					Participant__c = this.participation.Id,
					Role__c = 'Portal Administrator',
					Contact__c = this.u.ContactId
				));
				initialContacts.add(new Participant_Contact__c(
					First_Name__c = this.u.FirstName,
					Last_Name__c = this.u.LastName,
					Email__c = this.u.Email,
					Phone__c = this.u.Phone,
					Fax__c = this.u.Fax,
					Participant__c = this.participation.Id,
					Role__c = 'Organization Contact',
					Contact__c = this.u.ContactId
				));
				showErrors = !SafeDMLHandler.safeInsert(initialContacts, true);
				this.isNewParticipation = true;
				if(!showErrors){
					this.contact = initialContacts[1];
				}
			}

			//Logic to manage OrderItem[] list
			List<OrderItem> OrderItemsToDelete = new List<OrderItem>();
			List<OrderItem> OrderItemsToAdd = new List<OrderItem>();
			//loop through the list of selected frameworks.
			for(String selectedFramework : this.SelectedFrameworks){
				//if the selected framework does not already exist in PreviouslySelectedFrameworks, create a new Order Item for it.
				Boolean exists = false;
				for(String PreviouslySelectedFramework : this.PreviouslySelectedFrameworks){
					if(selectedFramework == PreviouslySelectedFramework){
						exists = true;
						break;
					}
				}
				if(!exists){
					//The starting price for all products should be 0 until the Level of Sales question is answered.
					OrderItemsToAdd.add( new OrderItem(OrderId = this.order.Id, Quantity = 1, UnitPrice = ProductPriceMap.get(FrameworkProductMap.get(selectedFramework)), PricebookEntryId = ProductPriceBookEntryMap.get(FrameworkProductMap.get(selectedFramework))));
				}
			}

			if(OrderItemsToAdd.size() != 0){
				try{
					upsert(OrderItemsToAdd);
				}catch(Exception e){
					this.showErrors = true;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				}
			}

			//build a map of existing frameworks and the orderItem representing them.
			Map<String, OrderItem> FrameworkOrderItemMap = new Map<String, OrderItem>();
			for(String framework : this.FrameworkProductMap.keySet()){
				for(OrderItem item : this.order.OrderItems){
					if(FrameworkProductMap.get(framework) == item.Product2Id){
						FrameworkOrderItemMap.put(framework, item);
						break;
					}
				}
			}

			//loop through the list of PreviouslySelectedFrameworks
			for(String PreviouslySelectedFramework : this.PreviouslySelectedFrameworks){
				//if the Framework is not currently selected, delete it
				Boolean ProductContinues = false;
				for(String selectedFramework : this.SelectedFrameworks){
					if(selectedFramework == PreviouslySelectedFramework){
						ProductContinues = true;
						break;
					}
				}
				if(!ProductContinues){
					OrderItemsToDelete.add(FrameworkOrderItemMap.get(PreviouslySelectedFramework));
				}
			}

			if(OrderItemsToDelete.size() != 0){
				try{
					delete(OrderItemsToDelete);
				}catch(Exception e){
					this.showErrors = true;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				}
			}
			if(this.order != null && this.order.Id != null){
				this.order = [SELECT Id, Participant__c, Pricebook2Id, TotalAmount, (SELECT Id, Product2Id, Product2.Name, HR_Data__c, Confirm_HR_Compliance__c, Non_HR_Data__c, UnitPrice, PricebookEntry.UnitPrice, PricebookEntry.Product2Id, Affirmation__c FROM OrderItems ORDER BY Product2.Name ASC) FROM Order WHERE Id = :THIS.order.Id LIMIT 1];
			}
			//get the calculated price
/*            if(this.account.orders.size() != 0){
				this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, hr_data__c, Confirm_HR_Compliance__c, unitprice, non_hr_data__c from OrderItems order by product2.name asc) from Order where Id = :this.account.orders[0].id limit 1];
			}            */
			this.calculatePrices();
			this.CurrentStep = 'Step_1';
			this.init();
		}
		return null;
	}
	//END PROGRAM SELECTION METHODS AND VARIABLES

	//ORGANIZATION PROFILE METHODS
	public PageReference Step1(){
		showErrors = !SafeDMLHandler.safeUpsert(this.participation, true);
		if(!showErrors){
			this.CurrentStep = 'Step_2';
		}
		return null;
	}

	public PageReference save(){
		this.showErrors = !SafeDMLHandler.safeUpsert(this.participation, true);
		if(this.participation.Level_of_Sales__c != null && this.participation.Level_of_Sales__c != '' && this.CurrentStep == 'Step_3'){
		//If you are saving in Step_3, recalculate the price of the order items based on level of sales.
		//If not step 3, ignore this logic because the price may have ben manually set by an internal user.
			if(this.door != 'edit'){
				this.calculatePrices();
			}
			update(this.order.OrderItems);
			this.order = [SELECT Id, Participant__c, Pricebook2Id, TotalAmount, (SELECT Id, Product2Id, Product2.Name, HR_Data__c, UnitPrice, Confirm_HR_Compliance__c, Non_HR_Data__c, PricebookEntry.UnitPrice, PricebookEntry.Product2Id, Affirmation__c FROM OrderItems ORDER BY Product2.Name ASC) FROM Order WHERE Id = :THIS.order.Id LIMIT 1];
		}
		return null;
	}
	//END ORGANIZATION PROFILE METHODS

	//ORGANIZATION CONTACT VARIABLES AND METHODS
	public Participant_Contact__c[] contacts {get; set;}
	public Participant_Contact__c contact {get{System.debug('GET:  '+this.contact); return this.contact;} set{System.debug('SET:  '+value); this.contact = value;}}
	public Boolean showContactEdit {get; set;}

	public String currentSection {get; set;}

	public void hideContactEdit(){
		this.currentSection = null;
		this.contact = null;
		this.showContactEdit = false;
	}

	public PageReference deleteContact(){
		this.getContactFromList();
		if(this.contact.Id != null){
			//there is a contact to delete
			try{
				delete this.contact;
				this.contact = new Participant_Contact__c();
				this.contacts = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Contact_Office__c, Phone__c, Role__c, Contact__c, Fax__c, Title__c
					FROM Participant_Contact__c WHERE Participant__c = :THIS.participation.Id
				];
				this.currentSection = null;
				this.isNewParticipation = false;
			}catch(Exception e){
				System.debug(e);
			}
		}
		return null;
	}

	public PageReference saveContact(){
		System.debug(this.contact);
		if(this.contact.Role__c == 'Organization Corporate Officer'){
			Participant_Contact__c[] cs = [SELECT Id, Role__c FROM Participant_Contact__c WHERE Participant__c = :THIS.participation.Id AND Role__c = 'Organization Corporate Officer' AND Id != :THIS.contact.Id];

			for(Participant_Contact__c c : cs){
				c.Role__c = 'Organization Contact';
			}
			if(contacts.size() != 0) {
				this.showErrors = !SafeDMLHandler.safeUpdate(cs, true);
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Whoops!'));
			}
		}

		this.showErrors = !SafeDMLHandler.safeUpsert(this.contact, true);
		this.contacts = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Contact_Office__c, Phone__c, Role__c, Contact__c, Fax__c, Title__c
			FROM Participant_Contact__c WHERE Participant__c = :THIS.participation.Id
		];
		this.showContactEdit = false;
		this.isNewParticipation = false;
		this.currentSection = null;
		return null;
	}

	public void getContactFromList(){
		if(ApexPages.currentPage().getParameters().get('contactId') != null){
			for(Participant_Contact__c c : this.contacts){
				if(c.Id == ApexPages.currentPage().getParameters().get('contactid')){
					this.contact = c;
					break;
				}
			}
		}
		System.debug(this.contact);
		this.showContactEdit = true;
		this.isNewParticipation = false;
	}

	public PageReference createContact() {
		this.contact = new Participant_Contact__c();
		this.contact.Participant__c = this.participation.Id;
		this.showContactEdit = true;
		this.currentSection = null;
		return null;
	}

	public Boolean getHasContacts(){
		Boolean output = false;
			Boolean hasCO = false;
			Boolean hasPC = false;
		for(Participant_Contact__c pc : this.contacts){
			if (pc.Role__c == 'Organization Contact') {
				hasPC = true;
			}
			if (pc.Role__c == 'Organization Corporate Officer') {
				hasCO = true;
			}
		}
		if (hasPC && hasCO) {
			output = true;
		}
		return output;
	}
	//END ORGANIZATION CONTACT VARIABLES AND METHODS

	//ORGANIZATION INDUSTRY METHODS AND VARIABLES
	public Boolean showEditIndustry {get; set;}

	public PageReference deleteIndustry(){
		if(ApexPages.currentPage().getParameters().get('entityId') != null){
			for(Industry__c v : this.getIndustries()){
				if(v.Id == ApexPages.currentPage().getParameters().get('entityId')) {
					this.showErrors = !SafeDMLHandler.safeDelete(v, true);
					this.showEditIndustry = false;
				}
			}
		}
		return null;
	}

	public PageReference saveIndustry(){
		this.industry.Participant__c = this.participation.Id;
		this.showErrors = !SafeDMLHandler.safeUpsert(this.industry, true);
		this.industry = new Industry__c();
		this.industry.Participant__c = this.participation.Id;
		this.showEditIndustry = false;
		return null;
	}

	public Industry__c industry {get; set;}
		public Industry__c getIndustry(){
			if(this.industry == null){
				this.industry = new Industry__c();
			}
			return this.industry;
		}

	public Industry__c[] getIndustries(){
		if (this.participation.Id != null) {
			return [SELECT Id, Industry__c, Sector__c, Sub_Sector__c FROM Industry__c WHERE Participant__c = :THIS.participation.Id ORDER BY Industry__c ASC];
		}
		return new Industry__c[]{};
	}

	public void ShowIndustryEdit(){
		this.showEditIndustry = true;
	}

	public void HideIndustryEdit(){
		this.showEditIndustry = false;
	}

	public PageReference selectIndustry(){
		if(ApexPages.currentPage().getParameters().get('industryId') != null){
			for(Industry__c ind : this.getIndustries()){
				if(ind.Id == ApexPages.currentPage().getParameters().get('industryId')){
					this.industry = ind;
					this.showEditIndustry = true;
					break;
				}
			}
		}
		return null;
	}
	//END ORGANIZATION INDUSTRY METHODS AND VARIABLES

	//COVERED ENTITIES METHODS AND VARIABLES
	public Boolean showEditEntity {get; set;}
	public Covered_Entity__c entity {get; set;}
	public Covered_Entity__c[] entities {get; set;}

	public PageReference deleteEntity(){
		System.debug('deleting');
		if(ApexPages.currentPage().getParameters().get('entityId') != null){
			System.debug(ApexPages.currentPage().getParameters().get('entityId'));
			for(Covered_Entity__c ent : this.entities){
				if (ent.Id == ApexPages.currentPage().getParameters().get('entityId')) {
					showErrors = !SafeDMLHandler.safeDelete(ent, true);
				}
			}
		}
		this.entities = [SELECT Id, Name FROM Covered_Entity__c WHERE Participant__c = :THIS.participation.Id];
		this.showEditEntity = false;
		return null;
	}

	public void cancelEntity(){
		this.showEditEntity = false;
	}

	public PageReference addEntity(){
		this.entity = new Covered_Entity__c();
			this.entity.Participant__c = this.participation.Id;
		this.showEditEntity =  true;
		return null;
	}

	public PageReference saveEntity(){
		if(this.entity.Name != null && this.entity.Name.trim() != ''){
			if (this.entity.Participant__c == null) {
				this.entity.Participant__c = this.participation.Id;
			}
			showErrors = !SafeDMLHandler.safeInsert(this.entity, true);
			this.entities.add(this.entity);
		}
		this.entity = new Covered_Entity__c();
			this.entity.Participant__c = this.participation.Id;
		this.showEditEntity =  false;
		return null;
	}
	//END COVERED ENTITIES METHODS AND VARIABLES


	//THIRD PARTY METHODS AND VARIABLES
	public Boolean getIsEUApp(){
		for(Asset item : this.participation.Assets__r){
			//if the asset for EU already exists, this is an EU app already no matter the asset status (per Michelle)
			if(item.Product2.Name.contains('EU')){
				return true;
			}
		}
		for(OrderItem item : this.order.OrderItems){
			if(item.Product2.Name.contains('EU')){
				return true;
			}
		}
		return false;
	}

	public Boolean getIsSWApp(){
		for(OrderItem item : this.order.OrderItems){
			if(item.Product2.Name.contains('SW')){
				return true;
			}
		}
		return false;
	}

	public Boolean step5HR {get; set;}
	public Boolean step5NonHR {get; set;}


	//STATUTORY BODY PROVIDERS
		public Third_Party_Master_List__c[] getAvailableStatutoryBodies() {
			return [SELECT Id, Name FROM Third_Party_Master_List__c WHERE Type__c = 'U.S. Statutory Body'];
		}

		public PageReference setStatutoryBody(){
			showErrors = !SafeDMLHandler.safeDelete([SELECT Id FROM Third_Party__c WHERE Participation__c = :THIS.participation.Id AND RecordType.DeveloperName = 'Statutory_Body'], true);
			Third_Party__c stat = new Third_Party__c();
				stat.RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Third_Party__c' AND DeveloperName = 'Statutory_Body' LIMIT 1].Id;
				stat.Name = ApexPages.currentPage().getParameters().get('statBodyName');
				stat.Participation__c = this.participation.Id;
				stat.Third_Party_Master_List__c = ApexPages.currentPage().getParameters().get('statBodyId');
			showErrors = !SafeDMLHandler.safeInsert(stat, true);
			return null;
		}

		public Id getStatutoryBodyId(){
			if(this.participation != null && this.participation.Id != null){
				Third_Party__c[] sb = [SELECT Third_Party_Master_List__c FROM Third_Party__c WHERE Participation__c = :THIS.participation.Id AND RecordType.DeveloperName = 'Statutory_Body' LIMIT 1];
				if(sb.size() == 1){
					return sb[0].Third_Party_Master_List__c;
				}
			}
			return null;
		}
	//END STATUTORY BODY PROVIDERS

	//DISPUTE RESOLUTION PROVIDERS
		public OrderItem currentItem {get; set;}

		public Boolean newDRP {get; set;}
		public void CreateDRP(){
			this.DRP = new Third_Party__c();
			this.newDRP = true;
		}

		public void CancelDRP(){
			this.newDRP = false;
		}

		public PageReference saveDRP(){
			this.DRP.RecordTypeId = this.DRPType;
			this.DRP.NonHR_Data__c = true;
			this.DRP.Participation__c = this.participation.Id;
			this.DRP.Order_Product__c = this.currentItem.Id;
			this.showErrors = !SafeDMLHandler.safeUpsert(this.DRP, true);
			this.DRP = new Third_Party__c();
				this.DRP.Order_Product__c = this.currentItem.Id;
			this.newDRP = false;
			return null;
		}

		public void UpdateOrderItem(){
			try{
				System.debug(this.currentItem);
				update this.currentItem;
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				this.showErrors = true;
			}
		}

		public void getCurrentOrderItem(){
			if(this.getIsEUApp() && this.CurrentStep == 'Step_5' && this.door != 'addition'){
				for(OrderItem item : this.order.OrderItems){
					if(item.Product2.Name.contains('EU')){
						this.currentItem = item;
						break;
					}
				}
			}else{
				for(OrderItem item : this.order.OrderItems){
					if(item.Product2.Name.contains('SW')){
						this.currentItem = item;
						break;
					}
				}
			}
		}

		public Id DRPType {get; set;}

		public Third_Party__c[] getResolutionProviders(){
			if (this.participation == null || this.participation.Id == null) {
				return new Third_Party__c[]{
				};
			}

			return [SELECT Id, Name, Website__c, NonHR_Data__c, HR_Data__c, Third_Party_Master_List__c FROM Third_Party__c WHERE RecordType.DeveloperName = 'Resolution_Provider' AND Order_Product__c = :THIS.currentItem.Id];
		}

		public Third_Party__c DRP {get; set;}

		public Third_Party_Master_List__c[] getAvailable_DRPs(){
			Set<Id> AvailableThirdParties = new Set<Id>();
			for(Third_Party_Master_List_Framework__c TPML : [SELECT Id, Third_Party_Master_List__c FROM Third_Party_Master_List_Framework__c WHERE Third_Party_Master_List__r.NonHR_Data__c = TRUE AND Framework__r.Product__c = :THIS.currentItem.Product2Id]){
				AvailableThirdParties.add(TPML.Third_Party_Master_List__c);
			}
			if(AvailableThirdParties.size() != 0){
				//if there are Third_Party_Master_List_Framework records, only display those.  Otherwise display all Third Party Master List records
				return [SELECT Id, Name  FROM Third_Party_Master_List__c WHERE Type__c = 'Dispute Resolution Provider' AND NonHR_Data__c = TRUE AND Id IN :AvailableThirdParties];
			}
			return [SELECT Id, Name FROM Third_Party_Master_List__c WHERE Type__c = 'Dispute Resolution Provider' AND NonHR_Data__c = TRUE]; //only display the NonHR DRPs
		}

		public PageReference useSelectedDRP(){
			if(this.DRP == null){
				this.DRP = new Third_Party__c();
			}
			Boolean DRPAlreadyExists = false;
			for(Third_Party__c ExistingThirdParty : this.getResolutionProviders()){
				if(ApexPages.currentPage().getParameters().get('SelectedDRP') == ExistingThirdParty.Third_Party_Master_List__c){
					DRPAlreadyExists = true;
					this.DRP.Id = ExistingThirdParty.Id;
					break;
				}
			}
			this.DRP.Name = ApexPages.currentPage().getParameters().get('SelectedDRPName');
			this.DRP.NonHR_Data__c = true;
			if(!DRPAlreadyExists){
				this.DRP.RecordTypeId = this.DRPType;
				this.DRP.Participation__c = this.participation.Id;
				this.DRP.Order_Product__c = this.currentItem.Id;
				this.DRP.Third_Party_Master_List__c = ApexPages.currentPage().getParameters().get('SelectedDRP');
			}
			try{
				upsert(this.DRP);
			}catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
				this.showErrors = true;
			}
			this.DRP = new Third_Party__c();
			return null;
		}
 
		 public PageReference deleteDRP(){
			if(ApexPages.currentPage().getParameters().get('entityId') != null){
				for(Third_Party__c drp : this.getResolutionProviders()){
					if(drp.Id == ApexPages.currentPage().getParameters().get('entityId')) {
						this.showErrors = !SafeDMLHandler.safeDelete(drp, true);
					}
				}

			}
			return null;
		}

	public PageReference processHRCompliance(){
		System.debug('IN PROCESS HR');
		List<Third_Party__c> toInsert = new List<Third_Party__c>();
		Third_Party__c[] ExistingHRRecords = [SELECT Id, HR_Data__c FROM Third_Party__c WHERE Order_Product__c = :THIS.currentItem.Id AND Third_Party_Master_List__c != NULL AND Third_Party_Master_List__r.HR_Data__c = TRUE];
		Boolean exists = ExistingHRRecords.size() != 0;
		System.debug('CURRENT ITEM:  '+this.currentItem);
		System.debug('EXISTS:  '+exists);
		if(this.currentItem.HR_Data__c && exists && ExistingHRRecords[0].HR_Data__c != true){
			//If the record has the HR Res Provider already, but it's not HR selected, select HR and update the TP record.
			ExistingHRRecords[0].HR_Data__c = true;
			update ExistingHRRecords[0];
		}

		if(this.currentItem.HR_Data__c && !exists){
			Set<Id> AvailableThirdParties = new Set<Id>();
			Third_Party_Master_List__c[] HRThirdPartyMasterList = [SELECT Id, Name FROM Third_Party_Master_List__c WHERE HR_Data__c = TRUE AND Type__c = 'Dispute Resolution Provider'];
			for(Third_Party_Master_List_Framework__c TPML : [SELECT Id, Third_Party_Master_List__c FROM Third_Party_Master_List_Framework__c WHERE Third_Party_Master_List__r.HR_Data__c = TRUE AND Framework__r.Product__c = :THIS.currentItem.Product2Id]){
				AvailableThirdParties.add(TPML.Third_Party_Master_List__c);
			}
			System.debug('AvailableThirdParties:  '+AvailableThirdParties);
			if(AvailableThirdParties.size() != 0){
				//if there are Third_Party_Master_List_Framework records, only display those.  Otherwise display all Third Party Master List records
				HRThirdPartyMasterList = [SELECT Id, Name  FROM Third_Party_Master_List__c WHERE Type__c = 'Dispute Resolution Provider' AND HR_Data__c = TRUE AND Id IN :AvailableThirdParties];
			}
			System.debug('HR TPML:  '+HRThirdPartyMasterList);
			if(HRThirdPartyMasterList.size() != 0){
				Third_Party__c HRComplianceThirdParty = new Third_Party__c(
					HR_Data__c = true,
					RecordTypeId = getHRDRPRecordTypeId(),
					Name = HRThirdPartyMasterList[0].Name,
					Order_Product__c = this.currentItem.Id,
					Third_Party_Master_List__c = HRThirdPartyMasterList[0].Id,
					Participation__c = this.participation.Id
				);
				toInsert.add(HRComplianceThirdParty);
			}
		}
		System.debug('INSERTING:  '+toInsert);
		if(toInsert.size() != 0){
			insert(toInsert);
		}
		return null;
	}

	public static String getHRDRPRecordTypeId(){
		return [SELECT Id FROM RecordType WHERE SobjectType = 'Third_Party__c' AND DeveloperName ='Resolution_Provider' LIMIT 1].Id;
	}
	//END DISPUTE RESOLUTION PROVIDERS

	//VERIFIERS
		public Id VerifierType {get; set;}
		public Third_Party__c Verifier {get; set;}

		public Boolean newVerifier {get; set;}
		public void createVerifier(){
			this.Verifier = new Third_Party__c();
			this.newVerifier = true;
		}
		public void cancelVerifier(){
			this.newVerifier = false;
		}

		public Third_Party_Master_List__c[] getAvailable_Verifiers(){
			return [SELECT Id, Name FROM Third_Party_Master_List__c WHERE Type__c = 'Verification Provider'];
		}

		public PageReference saveVerifier(){
			this.Verifier.RecordTypeId = this.VerifierType;
			this.Verifier.Participation__c = this.participation.Id;
			showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
			this.Verifier = new Third_Party__c();
			this.newVerifier = false;
			return null;
		}

		public PageReference useSelectedVerifier() {
			this.Verifier.RecordTypeId = this.VerifierType;
			this.Verifier.Participation__c = this.participation.Id;
			this.Verifier.Third_Party_Master_List__c = ApexPages.currentPage().getParameters().get('SelectedVerifier');
			this.Verifier.Name = ApexPages.currentPage().getParameters().get('SelectedVerifierName');
			showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
			this.Verifier = new Third_Party__c();
			this.newVerifier = false;
			return null;
		}

		public Third_Party__c[] getVerifiers(){
			if (this.participation == null || this.participation.Id == null) {
				return new Third_Party__c[]{
				};
			}
			return [SELECT Id, Name, Website__c FROM Third_Party__c WHERE RecordType.DeveloperName = 'Verification' AND Participation__c = :THIS.participation.Id];
		}

		public PageReference deleteVerifier(){
			if(ApexPages.currentPage().getParameters().get('entityId') != null){
				for(Third_Party__c v : this.getVerifiers()){
					if(v.Id == ApexPages.currentPage().getParameters().get('entityId')) {
						showErrors = !SafeDMLHandler.safeDelete(v, true);
					}
				}
			}
			this.newVerifier = false;
			return null;
		}
	//END VERIFIERS
	//END THIRD PARTY METHODS AND VARIABLES

	//ARTIFACTS METHODS AND VARIABLES
	public Boolean getDoesPrivacyPolicyExist(){
		Boolean hasHR = false;
		Boolean hasNonHR = false;
		Boolean needsHR = false;
		Boolean needsNonHR = false;
		for(OrderItem item : this.order.OrderItems){
			if(item.HR_Data__c){
				needsHR = true;
			}
			if(item.Non_HR_Data__c){
				needsNonHR = true;
			}
		}
		for(Artifact__c artifact : this.getArtifacts()){
			if(artifact.Type__c == 'HR and Non-HR' && artifact.isCurrent__c){
				hasHR = true;
				hasNonHR = true;
			}
			if(artifact.Type__c == 'HR' && artifact.isCurrent__c){
				hasHR = true;
			}
			if(artifact.Type__c == 'Non-HR' && artifact.isCurrent__c){
				hasNonHR = true;
			}
		}

		if(needsHR){
			if(! hasHR){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must provide a Privacy Policy that covers HR Data.'));
			}
		}

		if(needsNonHR){
			if(! hasNonHR){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You must provide a Privacy Policy that covers Non-HR Data.'));
			}
		}

		if (((needsHR && hasHR) || (! needsHR)) && ((needsNonHR && hasNonHR) || (! needsNonHR))) {
			ApexPages.getMessages().clear();
			this.showErrors = false;
			return true;
		}


		return false;

	}

	public Artifact__c[] getArtifacts(){
		return [SELECT Id, Name, isCurrent__c, Effective_Date__c, Description__c, External_Artifact_URL__c, Type__c, Participation_Number__c,
				  (SELECT Id, CreatedDate, Name, Description, CreatedById, ParentId
				  FROM Attachments
				  WHERE IsDeleted=FALSE ORDER BY CreatedDate DESC LIMIT 1)
				FROM Artifact__c
				WHERE Participation_Profile__c = :THIS.participation.Id];
	}
	//END ARTIFACTS METHODS AND VARIABLES

	//PAYMENT METHODS AND VARIABLES

	public void calculatePrices(){
		Boolean applyDiscount = false;
		for(Asset asset : this.participation.Assets__r){
			System.debug('Asset:  '+asset);
			if(asset.Product2.Name.contains('EU')){ //if the asset already exists for EU-US, apply the discount to all products.
				applyDiscount = true;
			}
		}
		for(OrderItem item : this.order.OrderItems){
			if(item.Product2.Name.contains('EU')){
				applyDiscount = true;
			}
		}

		System.debug('Discount:  '+applyDiscount);
		System.debug('Level:  '+this.participation.Level_of_Sales__c);
		System.debug('Participation__c:  '+this.participation.Id);
		System.debug('Price Breakpoint:  '+CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c));
		System.debug('Order Items:  '+this.order.OrderItems);
		System.debug('Assets:  '+this.participation.Assets__r);
		List<OrderItem> toUpdate = new List<OrderItem>();
		for(OrderItem item : this.order.OrderItems){
			if(CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c) != null){
			//first, check to see if there is only one product selected...
				if(this.order.OrderItems.size() == 1 && !applyDiscount){
					//if it's SW, use the SW pricing
					if(item.Product2.Name.contains('SW')){
						item.UnitPrice = CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price_SW__c;
					}else{
						//otherwise use the standard price
						item.UnitPrice = CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price__c;
					}
				}else{
					System.debug('For product '+item.Product2.Name);
					System.debug('IsEUApp:  '+this.getIsEUApp());
					//If there is more than 1 product selected, use the standard price for the first EU product, then use 50% of the price for all other products
					if(!item.Product2.Name.contains('EU') && this.getIsEUApp()){
						//if it's SW, assume that there is always a standard EU product purchased as well
						System.debug('Price SW:  '+CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price_SW__c * .5);
						item.UnitPrice = CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price_SW__c * .5;
					}else{
						System.debug('Price:  '+CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price__c);
						item.UnitPrice = CertificationPricePoints__c.getAll().get(this.participation.Level_of_Sales__c).Price__c;
					}
				}
			}else{
				System.debug('YOU HAVE A NULL VALUE FOR THIS LEVEL OF SALES!');
				if(this.order.OrderItems.size() > 1){
					if(!item.Product2.Name.contains('EU') && this.getIsEUApp()){
						item.UnitPrice = item.PricebookEntry.UnitPrice *.5;
					}
				}else{
					item.UnitPrice = item.PricebookEntry.UnitPrice;
				}
			}
			if(this.getAffirmations().contains(item.PricebookEntry.Product2Id)){
				item.UnitPrice = 200.00;
			}

			toUpdate.add(item);
		}
		update(toUpdate);
	}

	public String agencyTrackingId {get;set;}
	public Id paymentId {get;set;}

	public void getAgencyTrackingId() {
		RecordLog.push('ps_enhanced_controller.getAgencyTrackingId');
		Payment payment = new Payment();
		RecordLog.message('Getting the Agency Tracking Id and Payment Id');
		//payment.getAgencyTrackingId will call RecordLog.emit()
		Payment.PaymentValueObject pvo = payment.getAgencyTrackingId(this.order.Id);
		this.agencyTrackingId = pvo.agencyTrackingId;
		this.paymentId = pvo.paymentId;
	}

	public Boolean paymentCancelled {get;set;}
	private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').Value__c;
	private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').Value__c;
	private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').Value__c;
	private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').Value__c;

	public PageReference privacyShieldPayment() {
		if (agencyTrackingId != null && !agencyTrackingId.trim().equals('')) {
				return payment(PRIVACY_SHIELD_APP_ID, PRIVACY_SHIELD_APP);
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Agency Tracking Id is empty'));
			this.showErrors = true;
				//ERROR -- Agency Tracking Id must be populated first
				return null;
		}
	}

	@TestVisible private String getBaseUrl() {
		return 'https://' + ApexPages.currentPage().getHeaders().get('Host');
	}

	private PageReference payment(String tcs_app_id, String application) {
		RecordLog.push('ps_enhanced_controller.payment');
		Payment payment = new Payment();
		String transaction_type = 'Sale';
		String url_success = getBaseUrl() + '/apex/PaymentConfirmation?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.Id;
		RecordLog.message('Success URL: ' + url_success);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'url_success:  '+url_success));
		String url_cancel = getBaseUrl() + '/apex/Payment?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.Id;
		RecordLog.message('Cancel URL: ' + url_cancel);
		System.debug('Agency Tracking Id = ' + agencyTrackingId);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Agency Tracking Id:  '+agencyTrackingId));
		RecordLog.message('Getting pay.gov token');
		//payment.getToken calls RecordLog.emit()
		String token = payment.getToken(this.paymentId, this.agencyTrackingId, tcs_app_id, transaction_type, String.valueOf(this.order.TotalAmount), url_success, url_cancel );
		RecordLog.message('Pay.gov token = ' + token);
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'token:  '+token));
		this.showErrors = true;
		//Redirect to Pay.gov
		RecordLog.message('Redirect to Pay.gov');
		//payment.redirectToPayGov calls RecordLog.emit()
		PageReference pageRef = payment.redirectToPayGov(this.paymentId, token, tcs_app_id);
		pageRef.setRedirect(true);
		return pageRef;
	}
	//END PAYMENT METHODS AND VARIABLES
}