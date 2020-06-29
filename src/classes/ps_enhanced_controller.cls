public without sharing class ps_enhanced_controller {

  public Boolean ableToRecertify {get;set;}
  public Boolean mustCheckbeforeProceeding {get;set;}
  public pageReference redirectPSEnhanced(){
    if(this.participation.assets__r.size() == 0){
      PageReference pr = Page.PS_Enhanced;
      pr.getParameters().put('program', this.getProgram().id);
      pr.setRedirect(true);
      return pr;
    }
    return null;
  }

  public String record { get; set; }

  public PageReference back() {
    System.debug('CALLING BACK?????????');
    if(ApexPages.currentPage().getParameters().get('CurrentStep') != null){
      this.CurrentStep = ApexPages.CurrentPage().getParameters().get('CurrentStep');
    }
    getCurrentOrderItem();
    return null;
  }

  public String SelectedDoor {get; set;}
  public String SelectedFrameworkId {get; set;}

  public asset getAsset(){
    //the assumption is that if you are viewing doors you have an asset already.
    return this.participation.assets__r[0];
  }

  public PageReference AddFramework(){
    system.debug('SELECTED FRAMEWORK:  '+this.SelectedFrameworkId);
    system.debug('PRODUCT:  '+this.getFrameworkProductIdMap().get(this.SelectedFrameworkId));

    boolean OrderExists = true;
    //if an order doesn't exist, create one associated to the program
    if(this.order == null){
      this.order = new Order(AccountId = this.account.id, status = 'In Progress', EffectiveDate=Date.today(), Pricebook2Id = this.PriceBook.id);
    }

    if(this.order.id == null){
      insert this.order;
      OrderExists = false;
    }

    if(this.SelectedDoor == 'addition'){
      system.debug('@@'+this.SelectedFrameworkId);
      if(!OrderExists){
        insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = ProductPriceMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId)), pricebookentryid = ProductPriceBookEntryMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId))));
      }else{
        boolean ItemExists = false;
        //check to see if the product is already on the order
        for(orderItem item : this.order.orderItems){
          if(item.product2Id == getFrameworkProductIdMap().get(this.SelectedFrameworkId)){
            system.debug('ALREADY EXISTS');
            ItemExists = true;
            break;
          }
        }

        if(!ItemExists){
          insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = ProductPriceMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId)), pricebookentryid = ProductPriceBookEntryMap.get(getFrameworkProductIdMap().get(this.SelectedFrameworkId))));
        }
      }
      this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, pricebookentry.product2id, hr_data__c, unitprice, Confirm_HR_Compliance__c, non_hr_data__c, pricebookentry.unitprice, affirmation__c from OrderItems order by product2.name asc) from Order where Id = :this.order.id limit 1];
      this.calculatePrices();
    }

    if(this.SelectedDoor == 'recertify'){

      //business requirement:  if they don't have an asset for a product that is set to inactive for withdrawal or affirming, create an order item for it.
      //do not allow for opt-out

      if(!OrderExists){
        for(Asset asset : this.participation.assets__r){
          //insert a new order for each Active product
          if(asset.status == 'Active'){
            insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = ProductPriceMap.get(asset.product2id), pricebookentryid = ProductPriceBookEntryMap.get(asset.product2id)));
}else if(asset.status == 'Inactive'){
            insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = 200, affirmation__c = asset.affirmation__c, pricebookentryid = ProductPriceBookEntryMap.get(asset.product2id)));
          }
        }
      }else{
        //make sure that existing items
        for(Asset asset : this.participation.assets__r){
          boolean ItemExists = false;
          system.debug(asset.product2id);
          for(OrderItem item : this.order.orderItems){
            system.debug(asset.product2Id + ' = ' + item.pricebookentry.product2id);
            if(asset.product2Id == item.pricebookentry.product2id){
              ItemExists = true;
              break;
            }
          }
          system.debug('Exists:  '+ItemExists);
          if(!ItemExists){
            system.debug('ProductPriceBookEntryMap:  '+ProductPriceBookEntryMap);
            system.debug(asset.product2id);
            if(asset.status == 'Active'){
              insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = ProductPriceMap.get(asset.product2id), pricebookentryid = ProductPriceBookEntryMap.get(asset.product2id)));
}else if(asset.status == 'Inactive'){
              insert (new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = 200, affirmation__c = asset.affirmation__c, pricebookentryid = ProductPriceBookEntryMap.get(asset.product2id)));
            }
          }
        }
      }
      this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, pricebookentry.product2id, hr_data__c, unitprice, Confirm_HR_Compliance__c, non_hr_data__c, pricebookentry.unitprice, affirmation__c from OrderItems order by product2.name asc) from Order where Id = :this.order.id limit 1];
      this.calculatePrices();
    }

    PageReference pr = Page.ps_enhanced;
    pr.getParameters().put('program', this.getProgram().id);
    pr.getParameters().put('door', this.selectedDoor);
    pr.getParameters().put('step', this.selectedDoor == 'addition' ? 'Step_5' : 'Step_1');

    pr.setRedirect(true);
    return pr;
  }

  public Set<id> getAffirmations(){
    Set<id> output = new Set<id>();
    for(asset asset: this.participation.assets__r){
      if(asset.affirmation__c){
        output.add(asset.product2Id);
      }
    }
    return output;
  }

  public PageReference jumpTo(string stepNo){
    this.CurrentStep = stepNo;
    if(stepNo.contains('Step_5')){
      //for Step_5 and Step_5A we need to get the CurrentItem.
      this.getCurrentOrderItem();
    }
    if(this.currentItem == null){
      if(this.order.orderItems.size() != 0){
        this.currentItem = this.order.orderItems[0];
      }
    }
    return null;
  }

  public string getProgress(){
    map<string, string> progressMap = new map<string, string>();
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

    return progressMap.get(this.currentStep);
  }

  public void step5(){
    try {
      System.debug('Getting current order item!!!!!!!!!!!!!!!!!!!!!!');
      this.getCurrentOrderItem();
      System.debug('ITEM FOUND!!!!!');
    } catch (Exception e){
      System.debug('FAILED');
    }

    boolean hasNonHRThirdParty = false;
    for(Third_Party__c tp : this.getResolutionProviders()){
      if(tp.NonHR_Data__c == true){
        hasNonHRThirdParty = true;
        break;
      }
    }

    if(this.currentItem.hr_data__c && !this.currentItem.confirm_hr_compliance__c){
      this.showErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'HR Data requires confirmation.'));
    }else if(!this.currentItem.hr_data__c && !this.currentItem.non_hr_data__c){
      this.showErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must select at least one type of data to proceed.'));
    }else if(this.participation.purpose__c == null || this.participation.purpose__c.trim() == ''){
      this.showErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must provide the purpose of data collection to proceed.'));
    }else if(this.currentItem.Non_HR_Data__c == true && !hasNonHRThirdParty){
      this.showErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must indicate your Recourse Mechanism for Non-HR compliance concerns.'));
    }else{
      this.save();
      this.processHRCompliance();
      //if this is an EU AND an SW app, and the current product is EU, take the user to Step 5A, otherwise take them to step 6.
      if(this.currentStep == 'Step_5' && this.currentItem.product2.name.contains('EU') && this.getIsEUApp() && this.getIsSWApp()){
        this.currentStep = 'Step_5A';
        this.getCurrentOrderItem();
      }else{
        this.currentStep = 'Step_6';
      }
    }
  }

  public void step6(){
    if(String.isBlank(this.participation.Claiming_Self_Verified__c)){
      this.showErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must indicate your compliance verification method to proceed.'));
    }else{
      if((this.participation.Claiming_Self_Verified__c == 'Outside Compliance Review' && this.getVerifiers().size() != 0) || this.participation.Claiming_Self_Verified__c != 'Outside Compliance Review'){
        if(this.getStatutoryBodyId() != null){
          this.currentStep = 'Step_7';
        }else{
          this.showErrors = true;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must provide which U.S. Statutory Body you will use to proceed.'));
        }
      }else{
        this.showErrors = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must provide your outside compliance reviewer to proceed.'));
      }
    }
  }

  public PageReference step7(){
    if(this.door == 'edit'){
      PageReference pr = Page.door;
      pr.getParameters().put('program', this.getProgram().id);
      pr.setRedirect(true);
      return pr;
    }
    if(getDoesPrivacyPolicyExist()){
      this.currentStep = 'Step_8';
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
  public list<Order> orders {get; set;}

  public List<string> PreviouslySelectedFrameworks = new List<string>();
  public map<string, string> FrameworkProductMap {get; set;}
  public map<string, string> ProductPriceBookEntryMap {get; set;}
  public map<string, decimal> ProductPriceMap {get; set;}

  public boolean showErrors {get; set;}
  public string CurrentStep {get; set;}
  public PriceBook2 PriceBook {get; set;}

  public ps_enhanced_controller(){
    mustCheckbeforeProceeding = false;
    this.CurrentStep = 'welcome'; //INITIAL 'SECTION' THAT THE FORM OPENS TO
    //SET THE AVAILABLE RECORD TYPES FOR THIRD_PARTY__C RECORDS
    for(RecordType rt : [SELECT id, DeveloperName, name FROM RecordType WHERE DeveloperName in ('Verification', 'Resolution_Provider')]){
      if(rt.DeveloperName == 'Resolution_Provider'){
        this.DRPType = rt.id;
      }
      if(rt.DeveloperName == 'Verification'){
        this.VerifierType = rt.id;
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

  public string door {get; set;}

  public void init(){
    this.PreviouslySelectedFrameworks.clear();
    this.SelectedFrameworks.clear();
    this.FrameworkProductMap = new map<string, string>();
    this.ProductPriceBookEntryMap = new map<string, string>();
    this.ProductPriceMap = new map<string, decimal>();
    Id userId = UserInfo.getUserId();
    this.industry = new Taxonomy_Tagging__c();
    this.industry.RecordTypeId = getIndustryRecordType();
    this.entity = new Covered_Entity__c();
    this.entities = new list<covered_entity__c>();
    this.Verifier = new Third_Party__c();
    this.contacts = new list<participant_contact__c>();

    this.PriceBook = [select id, name, (select id, name, product2Id, unitprice from pricebookentries) from PriceBook2 where program__c = :this.getProgram().id];
    for(PriceBookEntry pbe : this.PriceBook.pricebookentries){
      this.ProductPriceBookEntryMap.put(pbe.product2Id, pbe.id);
      this.ProductPriceMap.put(pbe.product2Id, pbe.unitprice);
    }

    this.u = [SELECT id, contactid, contact.accountid, firstname, lastname, email, phone, fax FROM User WHERE id = :userId LIMIT 1];

    this.account = [SELECT
        id, name, billingcity, billingstatecode, billingstate,
        billingstreet, billingpostalcode, Privacy_Shield_Disabled__c,
    (SELECT Id FROM Participations__r
    WHERE Program__c = :this.getProgram().id ORDER BY createddate desc LIMIT 1),
    (SELECT Id from Orders WHERE Status = 'In Progress' and Participant__r.Program__c = :this.getProgram().id limit 1)
    FROM account WHERE id = :this.u.contact.accountid LIMIT 1];

    //Check to see if there is an existing order

    if(this.account.orders.size() == 1){
      this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, pricebookentry.product2id, hr_data__c, Confirm_HR_Compliance__c, non_hr_data__c, unitprice, pricebookentry.unitprice, affirmation__c from OrderItems order by product2.name asc) from Order where Id = :this.account.orders[0].id limit 1];
    }else{
      this.order = new Order(AccountId = this.account.id, status = 'In Progress', EffectiveDate=Date.today(), Pricebook2Id = this.PriceBook.id);
    }
    if(this.participation != null){
      this.orders = [select
          id, ordernumber, TotalAmount, order.status, effectivedate, participation__c, accountid, createddate,
      (select id, Pricebookentry.Product2.Name, pricebookentry.product2id, pricebookentry.unitprice, affirmation__c from orderitems),
      (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c
      FROM Payments__r)
      from order where order_paid__c = true and participant__c = :this.participation.id];
    }else{
      this.orders = new list<order>();
    }
    for(Framework__c framework : this.getProgram().frameworks__r){
      this.FrameworkProductMap.put(framework.id, framework.product__c);
    }

    //if the Order currently has products, set the SelectedFrameworks
    if(this.Order.OrderItems.size() != 0){
      for(Framework__c framework : this.getProgram().frameworks__r){
        for(OrderItem OrderItem : this.Order.OrderItems){
          if(OrderItem.Product2Id == framework.Product__c){
            this.PreviouslySelectedFrameworks.add(framework.id);
          }
        }
      }

      this.setSelectedFrameworks(this.PreviouslySelectedFrameworks);
    }
    //Check to see if there is an existing participation
    if(this.account.Participations__r.size() != 0){
      this.participation = [select
          id, organization__c, name, public_display_name__c, city__c, street__c, Privacy_Programs__c,
          state__c, postal_code__c, level_of_sales__c, number_of_employees__c, purpose__c, Claiming_Self_Verified__c,
      (select id, product2.name, framework__r.name, status, product2Id, hr_data__c, non_hr_data__c, inactive_status_reason__r.description__c, framework__r.product__c,
          affirmation__c, installdate, program__r.name, purchasedate, usageenddate from assets__r),
      (select id, first_name__c, last_name__c, email__c, role__c, Contact_Office__c, phone__c, Contact__c, fax__c, title__c from participant_contacts__r),
      (select id, name from covered_entities__r)
      from participation__c where id = :this.account.participations__r[0].id];
      this.Contacts = this.participation.participant_contacts__r;
      this.entities = this.participation.covered_entities__r;
      //If the Order has a null ID, make sure that it has this record as its participant__c value
      if(this.order.Participant__c == null){
        this.order.Participant__c = this.participation.id;
      }
    }else{
      this.participation = new Participation__c(
          program__c = this.getProgram().id, organization__c = this.account.id, name = this.account.name, public_display_name__c = this.account.name,
          city__c = this.account.billingcity, state__c = this.account.billingstate, postal_code__c = this.account.billingpostalcode);
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
    if(ApexPages.CurrentPage().getParameters().get('program') != null){
      try{
        return [select id, name, (select id, name, product__c from frameworks__r order by name asc)
        from program__c where id = :ApexPages.currentPage().getParameters().get('program') limit 1];
      }catch(Exception e){
        system.debug(e);
        this.showErrors = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'INVALID PROGRAM PROVIDED'));
      }
    }
    return new Program__c();
  }

  public List<String> SelectedFrameworks = new List<string>();
  public list<string> getSelectedFrameworks(){
    return SelectedFrameworks;
  }

  public void setSelectedFrameworks(list<String> frameworks){
    this.SelectedFrameworks = frameworks;
  }

  public map<string, id> getFrameworkProductIdMap(){
    map<string, id> output = new map<string, id>();
    for(Framework__c framework : this.getProgram().frameworks__r){
      output.put(framework.name, framework.product__c);
    }
    return output;
  }

  public map<string, asset> getAvailableFrameworkMap(){
    map<string, asset> output = new map<string, asset>();
    for(Framework__c framework : this.getProgram().frameworks__r){
      output.put(framework.name, new Asset());
    }

    ableToRecertify = false;
    for(asset asset : this.participation.assets__r){
      output.put(asset.framework__r.name, asset);
            if(asset.status == 'Active' || (asset.status == 'Inactive')) {
          ableToRecertify = true;
      }
    }
    return output;
  }

  public List<SelectOption> getAvailableFrameworks(){
    List<SelectOption> output = new List<SelectOption>();
    for(Framework__c framework : this.getProgram().frameworks__r){
      output.add( new SelectOption(framework.id, framework.name));
    }
    return output;
  }

  public boolean isNewParticipation {get; set;}

  public PageReference start(){
    if(this.mustCheckbeforeProceeding == false) {
      this.ShowErrors = true;
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Before Proceeding, You must confirm that you have reviewed the Privacy Shield.'));
    }
    else {
      if(this.SelectedFrameworks == null || this.SelectedFrameworks.size() == 0){
        this.CurrentStep = 'welcome';
        this.ShowErrors = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'You must select at least one framework that you are applying for to continue.'));
      }else{
        //logic to insert Participation__c, Order as needed
        if(this.participation.id == null){
          try{
            insert this.participation;
            this.order.participant__c = this.participation.id;
          }catch(Exception e){
            this.ShowErrors = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
          }
        }
        if(this.Order != null && this.Order.Id == null){
          try{
            insert this.Order;
          }catch(Exception e){
            this.ShowErrors = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
          }
        }

        //Logic to insert Participation_Contacts as Needed
        if(this.contacts.size() == 0){
          list<Participant_Contact__c> initialContacts = new list<Participant_Contact__c>();
          initialContacts.add(new Participant_Contact__c(
              First_Name__c = this.u.firstname,
              Last_Name__c = this.u.lastname,
              Email__c = this.u.email,
              Phone__c = this.u.phone,
              Fax__c = this.u.fax,
              Participant__c = this.participation.id,
              Role__c = 'Portal Administrator',
              Contact__c = this.u.ContactId
          ));
          initialContacts.add(new Participant_Contact__c(
              First_Name__c = this.u.firstname,
              Last_Name__c = this.u.lastname,
              Email__c = this.u.email,
              Phone__c = this.u.phone,
              Fax__c = this.u.fax,
              Participant__c = this.participation.id,
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
        list<OrderItem> OrderItemsToDelete = new list<OrderItem>();
        list<OrderItem> OrderItemsToAdd = new list<OrderItem>();
        //loop through the list of selected frameworks.
        for(string selectedFramework : this.SelectedFrameworks){
          //if the selected framework does not already exist in PreviouslySelectedFrameworks, create a new Order Item for it.
          boolean exists = false;
          for(string PreviouslySelectedFramework : this.PreviouslySelectedFrameworks){
            if(selectedFramework == PreviouslySelectedFramework){
              exists = true;
              break;
            }
          }
          if(!exists){
            //The starting price for all products should be 0 until the Level of Sales question is answered.
            OrderItemsToAdd.add( new OrderItem(OrderId = this.order.id, quantity = 1, UnitPrice = ProductPriceMap.get(FrameworkProductMap.get(selectedFramework)), pricebookentryid = ProductPriceBookEntryMap.get(FrameworkProductMap.get(selectedFramework))));
          }
        }

        if(OrderItemsToAdd.size() != 0){
          try{
            upsert(OrderItemsToAdd);
          }catch(Exception e){
            this.showErrors = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
          }
        }

        //build a map of existing frameworks and the orderItem representing them.
        map<string, OrderItem> FrameworkOrderItemMap = new map<string, OrderItem>();
        for(String framework : this.FrameworkProductMap.keySet()){
          for(OrderItem item : this.Order.OrderItems){
            if(FrameworkProductMap.get(framework) == item.product2id){
              FrameworkOrderItemMap.put(framework, item);
              break;
            }
          }
        }

        //loop through the list of PreviouslySelectedFrameworks
        for(string PreviouslySelectedFramework : this.PreviouslySelectedFrameworks){
          //if the Framework is not currently selected, delete it
          boolean ProductContinues = false;
          for(string selectedFramework : this.SelectedFrameworks){
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
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
          }
        }
        if(this.order != null && this.order.id != null){
          this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, hr_data__c, Confirm_HR_Compliance__c, non_hr_data__c, unitprice, pricebookentry.unitprice, pricebookentry.product2id, affirmation__c from OrderItems order by product2.name asc) from Order where Id = :this.order.id limit 1];
        }
        //get the calculated price
        /*      if(this.account.orders.size() != 0){
                this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, hr_data__c, Confirm_HR_Compliance__c, unitprice, non_hr_data__c from OrderItems order by product2.name asc) from Order where Id = :this.account.orders[0].id limit 1];
              }      */
        this.calculatePrices();
        this.CurrentStep = 'Step_1';
        this.init();
      }
    }

    return null;
  }
  //END PROGRAM SELECTION METHODS AND VARIABLES

  //ORGANIZATION PROFILE METHODS
  public pageReference Step1(){
    showErrors = !SafeDMLHandler.safeUpsert(this.participation, true);
    if(!showErrors){
      this.CurrentStep = 'Step_2';
    }
    return null;
  }

  public pageReference save(){
    this.showErrors = !SafeDMLHandler.safeUpsert(this.participation, true);
    if(this.participation.level_of_sales__c != null && this.participation.level_of_sales__c != '' && this.currentStep == 'Step_3'){
      //If you are saving in Step_3, recalculate the price of the order items based on level of sales.
      //If not step 3, ignore this logic because the price may have ben manually set by an internal user.
      if(this.door != 'edit'){
        this.calculatePrices();
      }
      update(this.Order.OrderItems);
      this.order = [select id, participant__c, pricebook2Id, TotalAmount, (select id, product2Id, product2.name, hr_data__c, unitprice, Confirm_HR_Compliance__c, non_hr_data__c, pricebookentry.unitprice, pricebookentry.product2id, affirmation__c from OrderItems order by product2.name asc) from Order where Id = :this.order.id limit 1];
    }
    return null;
  }
  //END ORGANIZATION PROFILE METHODS

  //ORGANIZATION CONTACT VARIABLES AND METHODS
  public Participant_Contact__c[] contacts {get; set;}
  public Participant_Contact__c contact {get{system.debug('GET:  '+this.contact); return this.contact;} set{system.debug('SET:  '+value); this.contact = value;}}
  public boolean showContactEdit {get; set;}

  public string currentSection {get; set;}

  public void hideContactEdit(){
    this.currentSection = null;
    this.contact = null;
    this.showContactEdit = false;
  }

  public pageReference deleteContact(){
    this.getContactFromList();
    if(this.contact.id != null){
      //there is a contact to delete
      try{
        delete this.contact;
        this.contact = new Participant_Contact__c();
        this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
        FROM Participant_Contact__c WHERE Participant__c = :this.participation.id
        ];
        this.currentSection = null;
        this.isNewParticipation = false;
      }catch(Exception e){
        system.debug(e);
      }
    }
    return null;
  }

  public pageReference saveContact(){
    system.debug(this.contact);
    if(this.contact.role__c == 'Organization Corporate Officer'){
      Participant_Contact__c[] cs = [SELECT id, role__c FROM participant_contact__c WHERE Participant__c = :this.participation.id AND role__c = 'Organization Corporate Officer' AND id != :this.contact.id];

      for(participant_contact__c c : cs){
        c.role__c = 'Organization Contact';
      }
      if(contacts.size() != 0) {
        this.showErrors = !SafeDMLHandler.safeUpdate(cs, true);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Whoops!'));
      }
    }

    this.showErrors = !SafeDMLHandler.safeUpsert(this.contact, true);
    this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
    FROM Participant_Contact__c WHERE Participant__c = :this.participation.id
    ];
    this.showContactEdit = false;
    this.isNewParticipation = false;
    this.currentSection = null;
    return null;
  }

  public void getContactFromList(){
    if(ApexPages.currentPage().getParameters().get('contactId') != null){
      for(Participant_Contact__c c : this.contacts){
        if(c.id == ApexPages.currentPage().getParameters().get('contactid')){
          this.contact = c;
          break;
        }
      }
    }
    system.debug(this.contact);
    this.showContactEdit = true;
    this.isNewParticipation = false;
  }

  public PageReference createContact() {
    this.contact = new Participant_Contact__c();
    this.contact.Participant__c = this.participation.id;
    this.showContactEdit = true;
    this.currentSection = null;
    return null;
  }

  public boolean getHasContacts(){
    boolean output = false;
    boolean hasCO = false;
    boolean hasPC = false;
    for(Participant_Contact__c pc : this.contacts){
      if(pc.role__c == 'Organization Contact')
        hasPC = true;
      if(pc.role__c == 'Organization Corporate Officer')
        hasCO = true;
    }
    if(hasPC && hasCO)
      output = true;
    return output;
  }
  //END ORGANIZATION CONTACT VARIABLES AND METHODS

  //ORGANIZATION INDUSTRY METHODS AND VARIABLES
  public Taxonomy_Tagging__c industry {get; set;}
  public boolean showEditIndustry {get; set;}

  private Id industryRecordId;

  public pageReference deleteIndustry(){
    if(ApexPages.currentPage().getParameters().get('entityId') != null){
      for(Taxonomy_Tagging__c industryToDelete : this.getIndustries()){
        if(industryToDelete.id == ApexPages.currentPage().getParameters().get('entityId')) {
          this.showErrors = !SafeDMLHandler.safeDelete(industryToDelete, true);
          this.showEditIndustry = false;
        }
      }
    }
    return null;
  }

  public pageReference saveIndustry(){
    // insert industry
    this.industry.Related_Application__c = this.participation.Id;
    this.showErrors = !SafeDMLHandler.safeUpsert(this.industry, true);
    // TODO: Find out why we recreate this object and reassigns the application id
    this.industry = new Taxonomy_Tagging__c();
    this.industry.RecordTypeId = getIndustryRecordType();
    this.industry.Related_Application__c = this.participation.Id;
    this.showEditIndustry = false;
    return null;
  }

  public Taxonomy_Tagging__c getIndustry(){
  if(this.industry == null){
    this.industry = new Taxonomy_Tagging__c();
    }
    return this.industry;
  }

  public Taxonomy_Tagging__c[] getIndustries(){
    if(this.participation.id != null)
      return [SELECT id, industry__c, sector__c, sub_sector__c FROM Taxonomy_Tagging__c WHERE Related_Application__c = :this.participation.id ORDER BY Industry__c ASC];
    return new Taxonomy_Tagging__c[]{};
  }

  public void ShowIndustryEdit(){
    this.showEditIndustry = true;
  }

  public void HideIndustryEdit(){
    this.showEditIndustry = false;
  }

  public pageReference selectIndustry(){
    if(ApexPages.currentPage().getParameters().get('industryId') != null){
      for(Taxonomy_Tagging__c ind : this.getIndustries()){
        if(ind.id == ApexPages.currentPage().getParameters().get('industryId')){
          this.industry = ind;
          this.showEditIndustry = true;
          break;
        }
      }
    }
    return null;
  }
  private Id getIndustryRecordType(){
      if(industryRecordId == null) {
          industryRecordId = Schema.SObjectType.Taxonomy_Tagging__c.getRecordTypeInfosByDeveloperName().get('Industry').getRecordTypeId();
        }
        return industryRecordId;
      }
  //END ORGANIZATION INDUSTRY METHODS AND VARIABLES

  //COVERED ENTITIES METHODS AND VARIABLES
  public boolean showEditEntity {get; set;}
  public covered_entity__c entity {get; set;}
  public covered_entity__c[] entities {get; set;}

  public pageReference deleteEntity(){
    system.debug('deleting');
    if(ApexPages.currentPage().getParameters().get('entityId') != null){
      system.debug(ApexPages.currentPage().getParameters().get('entityId'));
      for(Covered_Entity__c ent : this.entities){
        if(ent.id == ApexPages.currentPage().getParameters().get('entityId'))
          showErrors = !SafeDMLHandler.safeDelete(ent, true);
      }
    }
    this.entities = [SELECT id, name FROM covered_entity__c WHERE Participant__c = :this.participation.id];
    this.showEditEntity = false;
    return null;
  }

  public void cancelEntity(){
    this.showEditEntity = false;
  }

  public pageReference addEntity(){
    this.entity = new Covered_Entity__c();
    this.entity.Participant__c = this.participation.id;
    this.showEditEntity =  true;
    return null;
  }

  public pageReference saveEntity(){
    if(this.entity.name != null && this.entity.name.trim() != ''){
      if(this.entity.Participant__c == null)
        this.entity.Participant__c = this.participation.id;
      showErrors = !SafeDMLHandler.safeInsert(this.entity, true);
      this.entities.add(this.entity);
    }
    this.entity = new Covered_Entity__c();
    this.entity.Participant__c = this.participation.id;
    this.showEditEntity =  false;
    return null;
  }
  //END COVERED ENTITIES METHODS AND VARIABLES


  //THIRD PARTY METHODS AND VARIABLES
  public boolean getIsEUApp(){
    for(Asset item : this.participation.assets__r){
      //if the asset for EU already exists, this is an EU app already no matter the asset status (per Michelle)
      if(item.product2.name.contains('EU')){
        return true;
      }
    }
    for(OrderItem item : this.Order.OrderItems){
      if(item.product2.name.contains('EU')){
        return true;
      }
    }
    return false;
  }

  public boolean getIsSWApp(){
    for(OrderItem item : this.Order.OrderItems){
      if(item.product2.name.contains('SW')){
        return true;
      }
    }
    return false;
  }

  public boolean step5HR {get; set;}
  public boolean step5NonHR {get; set;}


  //STATUTORY BODY PROVIDERS
  public third_party_master_list__c[] getAvailableStatutoryBodies() {
    return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'U.S. Statutory Body'];
  }

  public pageReference setStatutoryBody(){
    showErrors = !SafeDMLHandler.safeDelete([SELECT id FROM third_party__c WHERE participation__c = :this.participation.id AND RecordType.DeveloperName = 'Statutory_Body'], true);
    Third_Party__c stat = new Third_Party__c();
    stat.recordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Third_Party__c' AND DeveloperName = 'Statutory_Body' LIMIT 1].id;
    stat.name = ApexPages.currentPage().getParameters().get('statBodyName');
    stat.participation__c = this.participation.id;
    stat.third_party_master_list__c = ApexPages.currentPage().getParameters().get('statBodyId');
    showErrors = !SafeDMLHandler.safeInsert(stat, true);
    return null;
  }

  public Id getStatutoryBodyId(){
    if(this.participation != null && this.participation.id != null){
      third_party__c[] sb = [SELECT third_party_master_list__c FROM third_party__c WHERE participation__c = :this.participation.id AND recordtype.DeveloperName = 'Statutory_Body' LIMIT 1];
      if(sb.size() == 1){
        return sb[0].third_party_master_list__c;
      }
    }
    return null;
  }
  //END STATUTORY BODY PROVIDERS

  //DISPUTE RESOLUTION PROVIDERS
  public OrderItem currentItem {get; set;}

  public boolean newDRP {get; set;}
  public void CreateDRP(){
    this.DRP = new Third_Party__c();
    this.newDRP = true;
  }

  public void CancelDRP(){
    this.newDRP = false;
  }

  public pageReference saveDRP(){
    this.DRP.recordtypeId = this.DRPType;
    this.DRP.NonHR_Data__c = true;
    this.DRP.Participation__c = this.participation.id;
    this.DRP.Order_Product__c = this.currentItem.id;
    this.showErrors = !SafeDMLHandler.safeUpsert(this.DRP, true);
    this.DRP = new Third_Party__c();
    this.DRP.Order_Product__c = this.currentItem.id;
    this.newDRP = false;
    return null;
  }

  public void UpdateOrderItem(){
    try{
      system.debug(this.currentItem);
      update this.currentItem;
    }catch(Exception e){
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
      this.showErrors = true;
    }
  }

  public void getCurrentOrderItem(){
    System.debug('BEFORE GETCURRENTORDERITEM HAS ' + this.Order + ' AND ' + this.Order.OrderItems);
    if(this.getIsEUApp() && this.currentStep == 'Step_5' && this.door != 'addition'){
      for(OrderItem item : this.Order.OrderItems){
        if(item.product2.name.contains('EU')){
          this.currentItem = item;
          break;
        }
      }
    }else{
      for(OrderItem item : this.Order.OrderItems){
        if(item.product2.name.contains('SW')){
          this.currentItem = item;
          break;
        }
      }
    }
  }

  public Id DRPType {get; set;}

  public Third_Party__c[] getResolutionProviders(){
    if(this.participation == null || this.participation.id == null)
      return new third_party__c[]{};

    return [SELECT id, name, website__c, NonHR_Data__c, HR_Data__c, Third_Party_Master_List__c FROM third_party__c WHERE RecordType.DeveloperName = 'Resolution_Provider' AND Order_Product__c = :this.CurrentItem.id];
  }

  public Third_Party__c DRP {get; set;}

  public Third_Party_Master_List__c[] getAvailable_DRPs(){
    set<id> AvailableThirdParties = new set<id>();
    for(Third_Party_Master_List_Framework__c TPML : [select id, Third_Party_Master_List__c from Third_Party_Master_List_Framework__c where third_party_master_list__r.NonHR_Data__c = true AND framework__r.product__c = :this.currentItem.Product2Id]){
      AvailableThirdParties.add(TPML.Third_Party_Master_List__c);
    }
    if(AvailableThirdParties.size() != 0){
      //if there are Third_Party_Master_List_Framework records, only display those.  Otherwise display all Third Party Master List records
      return [SELECT id, name  FROM third_party_master_list__c WHERE type__c = 'Dispute Resolution Provider' and NonHR_Data__c = true and id in :AvailableThirdParties];
    }
    return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'Dispute Resolution Provider' and NonHR_Data__c = true]; //only display the NonHR DRPs
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
    this.DRP.name = ApexPages.currentPage().getParameters().get('SelectedDRPName');
    this.DRP.NonHR_Data__c = true;
    if(!DRPAlreadyExists){
      this.DRP.recordtypeId = this.DRPType;
      this.DRP.Participation__c = this.participation.id;
      this.DRP.Order_Product__c = this.CurrentItem.id;
      this.DRP.third_party_master_list__c = ApexPages.currentPage().getParameters().get('SelectedDRP');
    }
    try{
      upsert(this.DRP);
    }catch(Exception e){
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
      this.showErrors = true;
    }
    this.DRP = new Third_Party__c();
    return null;
  }

  public pageReference deleteDRP(){
    if(ApexPages.currentPage().getParameters().get('entityId') != null){
      for(Third_Party__c drp : this.getResolutionProviders()){
        if(drp.id == ApexPages.currentPage().getParameters().get('entityId')) {
          this.showErrors = !SafeDMLHandler.safeDelete(drp, true);
        }
      }

    }
    return null;
  }

  public pageReference processHRCompliance(){
    system.debug('IN PROCESS HR');
    list<Third_Party__c> toInsert = new list<Third_Party__c>();
    Third_Party__c[] ExistingHRRecords = [select id, hr_data__c from third_party__c where order_product__c = :this.currentItem.id and third_party_master_list__c != null and third_party_master_list__r.HR_Data__c = true];
    boolean exists = ExistingHRRecords.size() != 0;
    system.debug('CURRENT ITEM:  '+this.currentItem);
    system.debug('EXISTS:  '+exists);
    if(this.currentItem.hr_data__c && exists && ExistingHRRecords[0].hr_data__c != true){
      //If the record has the HR Res Provider already, but it's not HR selected, select HR and update the TP record.
      ExistingHRRecords[0].hr_data__c = true;
      update ExistingHRRecords[0];
    }

    if(this.currentItem.hr_data__c && !exists){
      set<id> AvailableThirdParties = new set<id>();
      Third_Party_Master_List__c[] HRThirdPartyMasterList = [select id, name from third_party_master_list__c where HR_Data__c = true and type__c = 'Dispute Resolution Provider'];
      for(Third_Party_Master_List_Framework__c TPML : [select id, Third_Party_Master_List__c from Third_Party_Master_List_Framework__c where third_party_master_list__r.hr_Data__c = true AND framework__r.product__c = :this.currentItem.Product2Id]){
        AvailableThirdParties.add(TPML.Third_Party_Master_List__c);
      }
      system.debug('AvailableThirdParties:  '+AvailableThirdParties);
      if(AvailableThirdParties.size() != 0){
        //if there are Third_Party_Master_List_Framework records, only display those.  Otherwise display all Third Party Master List records
        HRThirdPartyMasterList = [SELECT id, name  FROM third_party_master_list__c WHERE type__c = 'Dispute Resolution Provider' and HR_Data__c = true and id in :AvailableThirdParties];
      }
      system.debug('HR TPML:  '+HRThirdPartyMasterList);
      if(HRThirdPartyMasterList.size() != 0){
        Third_Party__c HRComplianceThirdParty = new Third_Party__c(
            HR_Data__c = true,
            recordtypeid = getHRDRPRecordTypeId(),
            name = HRThirdPartyMasterList[0].name,
            Order_Product__c = this.currentItem.id,
            third_party_master_list__c = HRThirdPartyMasterList[0].id,
            Participation__c = this.participation.id
        );
        toInsert.add(HRComplianceThirdParty);
      }
    }
    system.debug('INSERTING:  '+toInsert);
    if(toInsert.size() != 0){
      insert(toInsert);
    }
    return null;
  }

  public static string getHRDRPRecordTypeId(){
    return [select id from recordType where sObjectType = 'Third_Party__c' and developername ='Resolution_Provider' limit 1].id;
  }
  //END DISPUTE RESOLUTION PROVIDERS

  //VERIFIERS
  public Id VerifierType {get; set;}
  public third_party__c Verifier {get; set;}

  public boolean newVerifier {get; set;}
  public void createVerifier(){
    this.Verifier = new third_party__c();
    this.newVerifier = true;
  }
  public void cancelVerifier(){
    this.newVerifier = false;
  }

  public Third_Party_Master_List__c[] getAvailable_Verifiers(){
    return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'Verification Provider'];
  }

  public pageReference saveVerifier(){
    this.Verifier.recordtypeId = this.VerifierType;
    this.Verifier.Participation__c = this.participation.id;
    showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
    this.Verifier = new Third_Party__c();
    this.newVerifier = false;
    return null;
  }

  public PageReference useSelectedVerifier() {
    this.Verifier.recordtypeId = this.VerifierType;
    this.Verifier.Participation__c = this.participation.id;
    this.Verifier.third_party_master_list__c = ApexPages.currentPage().getParameters().get('SelectedVerifier');
    this.Verifier.name = ApexPages.currentPage().getParameters().get('SelectedVerifierName');
    showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
    this.Verifier = new Third_Party__c();
    this.newVerifier = false;
    return null;
  }

  public Third_Party__c[] getVerifiers(){
    if(this.participation == null || this.participation.id == null)
      return new third_party__c[]{};
    return [SELECT id, name, website__c FROM third_party__c WHERE RecordType.DeveloperName = 'Verification' AND Participation__c = :this.participation.id];
  }

  public pageReference deleteVerifier(){
    if(ApexPages.currentPage().getParameters().get('entityId') != null){
      for(Third_Party__c v : this.getVerifiers()){
        if(v.id == ApexPages.currentPage().getParameters().get('entityId')) {
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
    boolean hasHR = false;
    boolean hasNonHR = false;
    boolean needsHR = false;
    boolean needsNonHR = false;
    for(OrderItem item : this.Order.OrderItems){
      if(item.HR_Data__c){
        needsHR = true;
      }
      if(item.Non_HR_Data__c){
        needsNonHR = true;
      }
    }
    for(artifact__c artifact : this.getArtifacts()){
      if(artifact.type__c == 'HR and Non-HR' && artifact.isCurrent__c){
        hasHR = true;
        hasNonHR = true;
      }
      if(artifact.type__c == 'HR' && artifact.isCurrent__c){
        hasHR = true;
      }
      if(artifact.type__c == 'Non-HR' && artifact.isCurrent__c){
        hasNonHR = true;
      }
    }

    if(needsHR){
      if(! hasHR){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must provide a Privacy Policy that covers HR Data.'));
      }
    }

    if(needsNonHR){
      if(! hasNonHR){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'You must provide a Privacy Policy that covers Non-HR Data.'));
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
    return [SELECT id, name, isCurrent__c, Effective_Date__c, Description__c, External_Artifact_URL__c, Type__c, Participation_Number__c,
    (SELECT id, createdDate, name, description, CreatedById, ParentId
    FROM Attachments
    WHERE isDeleted=false ORDER BY createdDate desc LIMIT 1)
    FROM Artifact__c
    WHERE participation_profile__c = :this.participation.id];
  }
  //END ARTIFACTS METHODS AND VARIABLES

  //PAYMENT METHODS AND VARIABLES

  public void calculatePrices(){
    boolean applyDiscount = false;
    for(Asset asset : this.participation.assets__r){
      system.debug('Asset:  '+asset);
      if(asset.product2.name.contains('EU')){ //if the asset already exists for EU-US, apply the discount to all products.
        applyDiscount = true;
      }
    }
    for(OrderItem item : this.Order.OrderItems){
      if(item.product2.name.contains('EU')){
        applyDiscount = true;
      }
    }

    system.debug('Discount:  '+applyDiscount);
    system.debug('Level:  '+this.participation.level_of_sales__c);
    system.debug('Participation__c:  '+this.participation.id);
    system.debug('Price Breakpoint:  '+CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c));
    system.debug('Order Items:  '+this.order.orderItems);
    system.debug('Assets:  '+this.participation.assets__r);
    list<OrderItem> toUpdate = new list<OrderItem>();
    for(OrderItem item : this.Order.OrderItems){
      if(CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c) != null){
        //first, check to see if there is only one product selected...
        if(this.Order.OrderItems.size() == 1 && !applyDiscount){
          //if it's SW, use the SW pricing
          if(item.product2.name.contains('SW')){
            item.unitprice = CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).Price_SW__c;
          }else{
            //otherwise use the standard price
            item.unitPrice = CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).price__c;
          }
        }else{
          system.debug('For product '+item.product2.name);
          system.debug('IsEUApp:  '+this.getIsEuApp());
          //If there is more than 1 product selected, use the standard price for the first EU product, then use 50% of the price for all other products
          if(!item.product2.name.contains('EU') && this.getIsEUApp()){
            //if it's SW, assume that there is always a standard EU product purchased as well
            system.debug('Price SW:  '+CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).Price_SW__c * .5);
            item.unitPrice = CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).Price_SW__c * .5;
          }else{
            system.debug('Price:  '+CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).Price__c);
            item.unitPrice = CertificationPricePoints__c.getAll().get(this.participation.level_of_sales__c).price__c;
          }
        }
      }else{
        system.debug('YOU HAVE A NULL VALUE FOR THIS LEVEL OF SALES!');
        if(this.Order.OrderItems.size() > 1){
          if(!item.product2.name.contains('EU') && this.getIsEUApp()){
            item.unitPrice = item.pricebookentry.unitprice *.5;
          }
        }else{
          item.unitPrice = item.pricebookentry.unitprice;
        }
      }
      if(this.getAffirmations().contains(item.pricebookentry.product2id)){
        item.unitPrice = 200.00;
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
    payment.PaymentValueObject pvo = payment.getAgencyTrackingId(this.order.Id);
    this.agencyTrackingId = pvo.agencyTrackingId;
    this.paymentId = pvo.paymentId;
  }

  public boolean paymentCancelled {get;set;}
  private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
  private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
  private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
  private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;

  public PageReference privacyShieldPayment() {
    if (agencyTrackingId != null && !agencyTrackingId.trim().equals('')) {
      return payment(PRIVACY_SHIELD_APP_ID, PRIVACY_SHIELD_APP);
    } else {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Agency Tracking Id is empty'));
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
    String url_success = getBaseUrl() + '/apex/PaymentConfirmation?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.id;
    RecordLog.message('Success URL: ' + url_success);
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'url_success:  '+url_success));
    String url_cancel = getBaseUrl() + '/apex/Payment?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.id;
    RecordLog.message('Cancel URL: ' + url_cancel);
    System.debug('Agency Tracking Id = ' + agencyTrackingId);
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Agency Tracking Id:  '+agencyTrackingId));
    RecordLog.message('Getting pay.gov token');
    //payment.getToken calls RecordLog.emit()
    String token = payment.getToken(this.paymentId, this.agencyTrackingId, tcs_app_id, transaction_type, String.valueOf(this.order.totalamount), url_success, url_cancel );
    RecordLog.message('Pay.gov token = ' + token);
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'token:  '+token));
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