@IsTest
public class TestUtils {
	private static Id adminProfileId = [SELECT Id FROM Profile WHERE Name=: 'System Administrator' LIMIT 1].Id;
    private static Id managerProfileId = [SELECT Id FROM Profile WHERE Name = :'ADCVD Manager' LIMIT 1].Id;
    private static UserRole ecRole = [SELECT Id, Name, DeveloperName FROM UserRole WHERE Name = 'E&C TANC'];
    private static Id testRoleId = [SELECT Id, Name, DeveloperName FROM UserRole WHERE Name = 'E&C TANC'].Id;

	public static Boolean messageFound(ApexPages.Severity severity, String msg) {
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		// Check that the error message you are expecting is in pageMessages
		Boolean messageFound = false;
		for(ApexPages.Message message : pageMessages) {
			if(message.getDetail() == msg
				&& message.getSeverity() == severity) {
				messageFound = true;
			}
		}

		return messageFound;
	}

	public static Page__c createPage(Boolean doInsert) {
        Page__c pg = new Page__c(Name = 'Test Home Page');
		if(doInsert) {
			insert pg;
		}
		return pg;
	}

	public static Row__c createRow(Boolean doInsert, Page__c pg) {
		Row__c r = new Row__c(
			Name= 'Test Row',
                Page__c = pg.Id
			);
		if(doInsert) {
			insert r;
		}
		return r;
	}

	public static Template_Page__c createTemplatePage(Boolean doInsert) {
		Template_Page__c tp = new Template_Page__c(
			Name = 'My Test Template',
			Description__c = 'My Test Description',
			Image__c = 'MyTestImage.png',
                isActive__c = true
			);
		if(doInsert) {
			insert tp;
		}
		return tp;
	}

	public static Template_Row__c createTemplateRow(Boolean doInsert, Template_Page__c pg) {
		Template_Row__c r = new Template_Row__c(
			Name= 'Test Row',
                Page__c = pg.Id
			);
		if(doInsert) {
			insert r;
		}
		return r;
	}

	public static Template_Page_Content__c createTemplatePageContent(Boolean doInsert, Template_Page__c pg, Template_Row__c tr) {
		//TODO implement schema utils
		Map<String, Id> recordTypeMap = new Map<String, Id>();
        for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Template_Page_Content__c']) {
            recordTypeMap.put(rt.DeveloperName, rt.Id);
		}
		Template_Page_Content__c tpc = new Template_Page_Content__c(
			Name= 'Test Page Content',
			RecordTypeId = recordTypeMap.get('Generic_Content'),
			Row__c = tr.Id,
			Page__c = pg.Id
			);
		if(doInsert) {
			insert tpc;
		}
		return tpc;
	}
	public static User createAdminUser(Boolean doInsert, String email, Integer i) {
		User u = new User();
		u.ProfileId = adminProfileId;
        u.IsActive = true;
		u.Alias = 'Alias' + i;
		u.LocaleSidKey = 'en_US';
		u.LanguageLocaleKey='en_US';
		u.LastName = 'LastName' + i;
		u.FirstName = 'FirstName' + i;
		u.EmailEncodingKey = 'ISO-8859-1';
		u.Email = email + i;
		u.TimeZoneSidKey = 'America/New_York';
		u.CommunityNickname = 'Ltest' + i;
        u.Username = email + '.test' + i;
        if (doInsert) {
            insert u;
        }
        return u;
    }
    public static User createStaffingUser(Boolean doInsert, String email, Integer i) {
        User u = new User();
        u.UserRoleId = testRoleId;
        u.Staffing_Role__c = 'Program Manager';
        u.UserRole = ecRole;
        u.ProfileId = managerProfileId;
        u.IsActive = true;
        u.Alias = 'Alias' + i;
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.LastName = 'LastName' + i;
        u.FirstName = 'FirstName' + i;
        u.EmailEncodingKey = 'ISO-8859-1';
        u.Email = email + i;
        u.TimeZoneSidKey = 'America/New_York';
        u.CommunityNickname = 'Ltest' + i;
        u.Username = email + '.test' + i;
		if(doInsert) {
			insert u;
		}
		return u;
	}
	public static Account createAccount(Boolean doInsert) {
		Account newRecord = new Account(
			Name='Acme',
			BillingStreet = '101 binary way',
			BillingCity = 'New York',
			BillingStateCode='NY',
			BillingPostalCode='10101'
			);
        if (doInsert) {
            insert newRecord;
        }
		return newRecord;
	}

    public static Account createAccount(String name, String url, Boolean doInsert) {
		Account a = new Account();
        a.Name = name;
        a.Website = url;
        if (doInsert) {
            insert a;
        }
		return a;
	}

/*     public static Issue__c createIssue(string name, string description, string url, Boolean doInsert){
		Issue__c issue = new Issue__c();
		issue.name = name;
		issue.description__c = description;
		issue.link__c = url;
		 if(doInsert) {insert issue;}
		return issue;
	}

	 public static Regulation__c createRegulation(string name, string url, Boolean doInsert){
		Regulation__c regulation = new Regulation__c();
		regulation.name = name;
		regulation.url__c = url;
		 if(doInsert) {insert regulation;}
		return regulation;
	}
*/    
	public static Product2 createProduct(Boolean doInsert) {
        Product2 newRecord = new Product2(
			Name='MyTestProduct',
			IsActive = true
			);
        if (doInsert) {
            insert newRecord;
        }
		return newRecord;
	}

    public static Product2 createProduct(String name, String description, String url, Boolean doInsert) {
		Product2 product = new Product2();
        product.Name = name;
        product.Description = description;
        product.DisplayUrl = url;
        product.IsActive = true;
        if (doInsert) {
            insert product;
        }
		return product;
	}

    public static Pricebook2 createPricebook(String name, Boolean isActive, Boolean doInsert) {
		Pricebook2 pb= new Pricebook2();
        pb.Name = name;
        pb.IsActive = isActive;
        if (doInsert) {
            insert pb;
        }
		return pb;
	}

	public static PricebookEntry createPricebookEntry(String pricebookId, String productId, Boolean doInsert){
		PricebookEntry pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.UnitPrice = 4.99;
		pbe.Pricebook2Id = pricebookId;
		pbe.Product2Id = productId;
        if (doInsert) {
            insert pbe;
        }
		return pbe;
	}

	public static Payment2__c createPayment2(Boolean doInsert, String recordType){
		Payment2__c payment2 = new Payment2__c();
		payment2.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get(recordType);
		if(doInsert) {insert payment2;}
		return payment2;
	}
	public static Collection_Fulfillment__c createCollectionFulfillment(Boolean doInsert, String post, string orgCode){
		Collection_Fulfillment__c cf = new Collection_Fulfillment__c();
		cf.Post__c = post;
		cf.Org_Code__c = orgCode;
		if(doInsert) {insert cf;}
		return cf;
	}

	public static Order createStandardOrder(Boolean doInsert, Id accountId, Id priceBookId){
		Order standardOrder = new Order();
		standardOrder.EffectiveDate = system.today();
		standardOrder.Status = 'Draft';
		standardOrder.AccountId = accountId;
		standardOrder.Pricebook2Id = priceBookId;
		if(doInsert) {insert standardOrder;}
		return standardOrder;
	}

	public static OrderItem createStandardOrderItem(Boolean doInsert, Id orderId, Id pbeId){
		OrderItem standardOrderItem = new OrderItem();
		standardOrderItem.OrderId = orderId;
		standardOrderItem.Quantity = 1;
		standardOrderItem.UnitPrice = 1000;
		standardOrderItem.PricebookEntryId = pbeId;
		if(doInsert) {insert standardOrderItem;}
		return standardOrderItem;
	}
	public static Quote createQuote(Boolean doInsert, Id oppId, Id priceBookId, String quoteName){
		Quote standardQuote = new Quote();
		standardQuote.OpportunityId = oppId;
		standardQuote.Name = quoteName;
		standardQuote.Pricebook2Id = priceBookId;
		if(doInsert) {insert standardQuote;}
		return standardQuote;
	}
	public static QuoteLineItem createQuoteLineItem(Boolean doInsert, Id product2Id, Id quoteId, Id pbeId){
		QuoteLineItem standardQuoteLineItem = new QuoteLineItem();
		standardQuoteLineItem.Product2Id = product2Id;
		standardQuoteLineItem.QuoteId = quoteId;
		standardQuoteLineItem.PricebookEntryId = pbeId;
		standardQuoteLineItem.Quantity = 1;
		standardQuoteLineItem.UnitPrice = 1000;
		if(doInsert) {insert standardQuoteLineItem;}
		return standardQuoteLineItem;
	}

	public static Contract createContract(Boolean doInsert, Id accountId){
		Contract c = new Contract();
		c.AccountId = accountId;
		if(doInsert){insert c;}
		return c;
	}

	public static Asset createAsset(Account account, Product2 product, Boolean doInsert){
		return createAsset('Installed', account, product, doInsert);
	}

	public static Asset createAsset(String status, Account account, Product2 product, Boolean doInsert){
		return createAsset(status, account, product, doInsert, true, true, null, null);
	}

	public static Asset createAsset(String status, Account account, Product2 product, Boolean doInsert, Boolean hasHrData, Boolean hasNonHrData, Framework__c framework, Participation__c app){
		Asset newRecord = new Asset(
                Name = product.Name,
			AccountId = account.Id,
                Product2Id = product.Id,
			Status=status,
			HR_Data__c = hasHrData,
			Non_HR_Data__c = hasNonHrData
			);
		if (framework != null) {
            newRecord.Framework__c = framework.Id;
		}
		if (app != null) {
			newRecord.Participant__c = app.Id;
		}
        if (doInsert) {
            insert newRecord;
        }
		return newRecord;
	}

	public static Attachment createAttachment(Id parentId, Boolean doInsert) {
		Attachment newRecord = new Attachment(
			ParentId = parentId,
			Name = 'mytestname',
			Body = Blob.valueOf('mystring')
			);
        if (doInsert) {
            insert newRecord;
        }
		return newRecord;
	}
	//create test Contact
	public static Contact createContact(String name, String accId , Boolean isInsert){
        Contact con = new Contact(LastName = name, AccountId = accId, OwnerId = UserInfo.getUserId());
		if(isInsert){
			insert con;
		}
		return con;
	}

	// create Case
    public static Case createCase(String sub, Boolean isInsert) {
		Case cs = new Case();
		cs.Subject = sub;
		if(isInsert) {
			insert cs;
		}
		return cs;
	}

	// create ADCVD Case

    public static ADCVD_Case__c createADCVDCase(String caseName, String caseType, User u, Boolean doInsert) {
        ADCVD_Case__c testCase = new ADCVD_Case__c(
                Name = caseName,
                ADCVD_Case_Number__c = caseName,
                ADCVD_Case_Type__c = caseType,
                CBP_Case_Number__c = caseName,
                Commodity__c = 'Foodstuffs',
                Country__c = 'Argentina',
                Product__c = 'Tacos - Full',
                Product_Short_Name__c = 'Tacos',
                Program_Manager__c = u.Id
        );
        if (doInsert) {
            insert testCase;
        }
        return testCase;
    }

    public static ADCVD_Case__c createADCVDCase(String caseName, String caseType, Boolean doInsert) {
		ADCVD_Case__c testCase = new ADCVD_Case__c(
			Name = caseName,
			ADCVD_Case_Number__c = caseName,
			ADCVD_Case_Type__c = caseType,
			CBP_Case_Number__c = caseName,
			Commodity__c = 'Foodstuffs',
			Country__c = 'Argentina',
			Product__c = 'Tacos - Full',
			Product_Short_Name__c = 'Tacos'
		);
		if(doInsert) {
			insert testCase;
		}
		return testCase;
	}

	//create custom settings object controlling ADCVD App triggers
	public static AppConfig__c createAppConfig(String name, Boolean triggersEnabled, Boolean doInsert) {
		AppConfig__c app = new AppConfig__c();
		app.Name = name;
		app.Primary_Admin__c = 'sandip.menon@trade.gov';
		app.ADCVD_Admin__c = 'joshua.moody@trade.gov';
		app.TriggersEnabled__c = triggersEnabled;
		app.AppEnabled__c = true;
		app.Batch_Size__c = 200;
		app.Go_Live_Date__c = Date.newInstance(2018, 2, 15);
        app.ChronExp_LitigationSegement__c = ' 0 ' + String.valueOf((System.now().addMinutes(30)).minute()) + ' ' + String.valueOf((System.now().addMinutes(30)).hour()) + ' ' + String.valueOf(System.today().day()) + ' ' + String.valueOf(System.today().month()) + ' ?';
        System.debug('app.ChronExp_LitigationSegement__c = ' + app.ChronExp_LitigationSegement__c);
        app.ChronExpr_PetitionInvestigation__c = '0 0 1 ' + String.valueOf((System.today().addDays(1)).day()) + ' ' + String.valueOf(System.today().addDays(1).month()) + ' ?';
        System.debug('ChronExpr_PetitionInvestigation__c = ' + app.ChronExpr_PetitionInvestigation__c);
		if (doInsert) {
			insert app;
		}
		return app;
	}

	//create Federal Register
	public static Federal_Register__c createFR(Id parentId, String parentLookupField, Date publishedDate, String frType, Boolean doInsert) {
		Federal_Register__c fr = new Federal_Register__c();
		fr.put(parentLookupField, parentId);
		fr.Type__c = frType;
		fr.Published_Date__c = publishedDate;
		if(doInsert) {
			insert fr;
		}
		return fr;
	}

	//create Investigation
	public static Investigation__c createInvestigation(Petition__c p, Boolean doInsert) {
		Investigation__c i = new Investigation__c();
		i.Petition__c = p.Id;
		if (doInsert) {
			insert i;
		}
		return i;
	}

	// create Lead
    public static Lead createLead(String firstName, String LastName, Boolean isInsert) {
		Lead lead = new Lead ();
        lead.FirstName = firstName;
		lead.LastName = LastName;
		lead.Company = 'Test';
		if(isInsert) {
			insert lead;
		}
		return lead;
	}

	//create litigation
	public static Litigation__c createLitigation(Date requestFiled, String recordTypeName, Boolean doInsert) {
		Litigation__c lit = new Litigation__c();
        lit.RecordTypeId = Utils.getRecordTypeIdMap('Litigation__c').get(recordTypeName);
		if (recordTypeName == 'Remand') {
			lit.Expected_Final_Signature_Before_Ext__c = requestFiled;
		} else {
		lit.Request_Filed__c = requestFiled;
		}
		if(doInsert) {
			insert lit;
		}
		return lit;
	}

	//create litigation with a parent
	public static Litigation__c createLitigation(Id parentId, String parentLookupField, Date requestFiled, String recordTypeName, Boolean doInsert) {
		Litigation__c lit = new Litigation__c();
		lit.put(parentLookupField, parentId);
        lit.RecordTypeId = Utils.getRecordTypeIdMap('Litigation__c').get(recordTypeName);
		if (recordTypeName == 'Remand') {
			lit.Expected_Final_Signature_Before_Ext__c = requestFiled.addDays(42);
		} else {
			lit.Request_Filed__c = requestFiled;
		}
		if(doInsert) {
			insert lit;
		}
		return lit;
	}

	//create Master Automation record which controls validation rules and workflow rules for adcvd
	public static Master_Automation__c createMasterAutomation(Boolean vr, Boolean wfr, Boolean doInsert) {
		Master_Automation__c ma = new Master_Automation__c();
		ma.ValidationRulesEnabled__c = vr;
		ma.WorkflowRulesEnabled__c = wfr;
		if (doInsert) {
			insert ma;
		}
		return ma;
	}

	// create test Opportunity
    public static Opportunity createOpportunity(String accId, String conId, Boolean isInsert) {
		Opportunity opp = new Opportunity();
		opp.Name = 'opportunity';
		opp.AccountId = accId;
        opp.CloseDate = Date.today();
        opp.StageName = 'Open';
		if(isInsert) {
			insert opp;
		}
		return opp;
	}

	// create test order
	public static ADCVD_Order__c createOrder(Investigation__c i, Boolean doInsert) {
		ADCVD_Order__c o = new ADCVD_Order__c();
		o.Investigation__c = i.Id;
		Datetime tempDatetime = System.now();
		o.Anniversary_Month__c = tempDatetime.format('MMMMM');
		if(doInsert) {
			insert o;
		}
		return o;
	}

	// create test Petition
	public static Petition__c createPetition(ADCVD_Case__c c, Date petitionDate, Boolean doInsert){
		Petition__c petition = new Petition__c();
		petition.ADCVD_Case__c = c.Id;
		petition.Petition_Filed__c = petitionDate;
		//added for testing purposes
		petition.Initiation_Extension_of_days__c = 3;
		if(doInsert){
			insert petition;
		}
		return petition;
	}

	//create test Primary Recusal
	public static Recusal__c createRecusal(Id userId, Date startDate, Date endDate, Boolean doInsert) {
		Recusal__c r = new Recusal__c();
		r.RecordTypeId = Utils.getRecordTypeIdMap('Recusal__c').get('Primary');
		r.User__c = userId;
		r.Start_Date__c = startDate;
		r.End_Date__c = endDate;
		if (doInsert) {
			insert r;
		}
		return r;
	}
	//create test Harmonized Tarrif Schedule with ADCVD Order
	public static List<Harmonized_Tariff_Schedule__c> createHTS(ADCVD_Order__c order, Integer count, Boolean doInsert){
		List<Harmonized_Tariff_Schedule__c> htsList = new List<Harmonized_Tariff_Schedule__c>();
		Integer htsNumber = 1111111111;
		for(Integer i = 0; i < count; i++){
			Harmonized_Tariff_Schedule__c hts = new Harmonized_Tariff_Schedule__c(
				ADCVD_Order__c = order.Id,
				HTS_Number__c = String.valueOf(htsNumber+i)
			);
			htsList.add(hts);
		}
		if(doInsert) insert htsList;
		return htsList;
	}
	//create test Harmonized Tarrif Schedule with Suspension Agreement
	public static List<Harmonized_Tariff_Schedule__c> createHTS(Suspension_Agreement__c SA, Integer count, Boolean doInsert){
		List<Harmonized_Tariff_Schedule__c> htsList = new List<Harmonized_Tariff_Schedule__c>();
		Integer htsNumber = 1111111111;
		for(Integer i = 0; i < count; i++){
			Harmonized_Tariff_Schedule__c hts = new Harmonized_Tariff_Schedule__c(
				Suspension_Agreement__c = SA.Id,
				HTS_Number__c = String.valueOf(htsNumber+i)
			);
			htsList.add(hts);
		}
		if(doInsert) insert htsList;
		return htsList;
	}
	//create test Related Recusal
	public static Recusal__c createRecusal(Id primaryRecusalId, Id parentId, String parentObjectName, Boolean doInsert) {
		Recusal__c r = new Recusal__c();
		r.RecordTypeId = Utils.getRecordTypeIdMap('Recusal__c').get('Related');
		r.Primary_Recusal_Aligned_To__c = primaryRecusalId;
		r.put(parentObjectName, parentId);
		if (doInsert) {
			insert r;
		}
		return r;
	}

	//create test segment
	public static Segment__c createSegment(ADCVD_Order__c ord, String recordTypeName, Boolean doInsert) {
		Segment__c seg = new Segment__c();
        seg.RecordTypeId = Utils.getRecordTypeIdMap('Segment__c').get(recordTypeName);
		if(ord != null && ord.Id != null) {
			seg.ADCVD_Order__c = ord.Id;
		}
		//added for testing purposes
		Date tempDate = System.today();
		seg.Final_Date_of_Anniversary_Month__c = tempDate.toStartOfMonth().addDays(Date.daysInMonth(tempDate.year(), tempDate.month()) - 1);
		if(doInsert) {
			insert seg;
		}
		return seg;
	}

	//create test segment
	public static Segment__c createSegment(Suspension_Agreement__c sa, String recordTypeName, Boolean doInsert) {
		Segment__c seg = new Segment__c();
        seg.RecordTypeId = Utils.getRecordTypeIdMap('Segment__c').get(recordTypeName);
		if(sa != null && sa.Id != null) {
			seg.Suspension_Agreement__c = sa.Id;
		}
		//added for testing purposes
		Date tempDate = System.today();
		seg.Final_Date_of_Anniversary_Month__c = tempDate.toStartOfMonth().addDays(Date.daysInMonth(tempDate.year(), tempDate.month()) - 1);
		if(doInsert) {
			insert seg;
		}
		return seg;
	}

	//create test staffing assignment
	public static Staffing_Assignment__c createStaff(SObject parent, String parentType, Boolean doInsert) {
		Staffing_Assignment__c sa = new Staffing_Assignment__c();
		if (parent != null && parent.Id != null) {
			sa.put(parentType, parent.Id);
		}
		if (doInsert) {
			insert sa;
		}
		return sa;
	}

	// create test suspension agreement
	public static Suspension_Agreement__c createSuspensionAgreement(Investigation__c i, Date suspensionDate, Boolean doInsert) {
		Suspension_Agreement__c sa = new Suspension_Agreement__c();
		sa.Suspension_Date__c = suspensionDate;
        sa.Investigation__c = i.Id;
		if(doInsert) {
			insert sa;
		}
		return sa;
	}

	//create test Tolling Day
	public static Tolling_Day__c createTollingDay(Date startDate, Date endDate, User u, Boolean doInsert){
		Tolling_Day__c td = new Tolling_Day__c();
		td.Start_Date__c = startDate;
		td.End_Date__c = endDate;
		td.Reason__c = 'Snow Day';
		if(doInsert){
			System.runAs(u){
				insert td;
			}
		}
		return td;
	}
	//create test Related_Organization__c with ADCVD Order parent
	public static Related_Organization__c createRelatedOrg(ADCVD_Order__c order, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(ADCVD_Order__c = order.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}
	//create test Related_Organization__c with Customs Instructions parent
	public static Related_Organization__c createRelatedOrg(Custom_Instruction__c customInstruction, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(Custom_Instruction__c = customInstruction.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}
	//create test Related_Organization__c with Investigation parent
	public static Related_Organization__c createRelatedOrg(Investigation__c investigation, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(Investigation__c = investigation.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}
	//create test Related_Organization__c with Litigation parent
	public static Related_Organization__c createRelatedOrg(Litigation__c litigation, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(Litigation__c = litigation.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}
	//create test Related_Organization__c with Petition parent
	public static Related_Organization__c createRelatedOrg(Petition__c petition, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(Petition__c = petition.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}
	//create test Related_Organization__c with Segment parent
	public static Related_Organization__c createRelatedOrg(Segment__c segment, Boolean doInsert){
		Related_Organization__c relatedOrg = new Related_Organization__c(Segment__c = segment.Id);
		if(doInsert) insert relatedOrg;
		return relatedOrg;
	}

	 public static Custom_Instruction__c createCustomInstruction(String parentObjectName, Id parentId, Boolean doInsert){
		Custom_Instruction__c customInstruction = new Custom_Instruction__c();
		customInstruction.put(parentObjectName, parentId);
		if(doInsert){
			insert customInstruction;
		}
		return customInstruction;
	 }

    public static User createGenericUser(String username, String email, String profileId) {
		User user = new User();
		user.ProfileId = profileId;
        user.IsActive = true;
		user.Alias = 'Alias1';
		user.LocaleSidKey = 'en_US';
		user.LanguageLocaleKey='en_US';
		user.LastName = 'LastName1';
		user.FirstName = 'FirstName1';
		user.EmailEncodingKey = 'ISO-8859-1';
		user.Email = email;
		user.TimeZoneSidKey = 'America/New_York';
		user.CommunityNickname = username+ 'nick87Test';
        user.Username = username + '.test';
		//user.CallCenterId  = [select Id from CallCenter limit 1].Id;
		//user.ContactId = conId;
		return user;
	}

    public static User createCommunityUser(String email, Id contactId) {
		User user = new User();
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Trade Community User' LIMIT 1].Id;
        user.IsActive = true;
		user.Alias = 'Alias1';
		user.LocaleSidKey = 'en_US';
		user.LanguageLocaleKey='en_US';
		user.LastName = 'LastName1';
		user.FirstName = 'FirstName1';
		user.EmailEncodingKey = 'ISO-8859-1';
		user.Email = email;
		user.ContactId = contactId;
		user.TimeZoneSidKey = 'America/New_York';
		user.CommunityNickname = email;
        user.Username = email;
		insert user;
		return user;
	}

    public static Program__c createProgram(String name, Boolean active) {
        Program__c program = new Program__c(Name = name, isActive__c = active);
		insert program;
		return program;
	}

    public static Product2 createProduct(String name, Boolean active) {
        Product2 product = new Product2(Name = name, IsActive = active);
		insert product;
		return product;
	}

    public static Pricebook2 createPricebook(Id ProgramId) {
        Pricebook2 pb = new Pricebook2(Name = 'Test PB', Program__c = ProgramId, IsActive = true);
		insert pb;
		return pb;
	}

    public static List<PricebookEntry> createPricebookEntries(List<Product2> products, List<Id> PricebookIds) {
        List<PricebookEntry> pbes = new PricebookEntry[]{
        };
        for (Id pb : PricebookIds) {
				for(Product2 product : products){
					pbes.add(new PricebookEntry(
						Pricebook2Id = pb,
                        Product2Id = product.Id,
                        UnitPrice = 5.00,
                        IsActive = true
					));
				}
			}
		insert pbes;
		return pbes;
	}

	public static List<PaymentSettings__c> createPaymentSettings(){
		PaymentSettings__c[] settings = new PaymentSettings__c[]{
                new PaymentSettings__c(Name = 'PRIVACY_SHIELD_APP_ID', Value__c = 'dummy'),
                new PaymentSettings__c(Name = 'PRIVACY_SHIELD_APP', Value__c = 'ps'),
                new PaymentSettings__c(Name = 'EVENTS_SERVICES_APP_ID', Value__c = 'dummy'),
                new PaymentSettings__c(Name = 'EVENTS_SERVICES_APP', Value__c = 'es'),
                new PaymentSettings__c(Name = 'PAY_GOV_TCS_ONLINE_URL', Value__c = 'http://pay.gov'),
                new PaymentSettings__c(Name = 'PAY_GOV_TCS_ONLINE_ENDPOINT', Value__c = 'http://pay.gov/TCS')
		};
		insert settings;
		return settings;
	 }

    public static List<Third_Party_Master_List__c> createTPMLs(List<Id> FrameworkIds) {
		 List<Third_Party_Master_List__c> TPML = new List<Third_Party_Master_List__c>();

		 for(Id framework : FrameworkIds){
            TPML.add(new Third_Party_Master_List__c(Name = 'DRP HR', Framework__c = framework, Type__c = 'Dispute Resolution Provider', Website__c = 'http://my.site', NonHR_Data__c = false, HR_Data__c = true));
            TPML.add(new Third_Party_Master_List__c(Name = 'DRP NonHR', Framework__c = framework, Type__c = 'Dispute Resolution Provider', Website__c = 'http://my.site', NonHR_Data__c = true, HR_Data__c = false));
		 }
        TPML.add(new Third_Party_Master_List__c(Name = 'DRP', Type__c = 'Dispute Resolution Provider', Website__c = 'http://my.site', NonHR_Data__c = true, HR_Data__c = false));
        TPML.add(new Third_Party_Master_List__c(Name = 'Verifier 1', Type__c = 'Verification Provider', Website__c = 'http://my.site'));
        TPML.add(new Third_Party_Master_List__c(Name = 'Verifier 2', Type__c = 'Verification Provider', Website__c = 'http://my.site'));
        TPML.add(new Third_Party_Master_List__c(Name = 'Statutory Body', Type__c = 'U.S. Statutory Body', Website__c = 'http://my.site'));

		insert TPML;
		return null;
	 }

    public static Order createOrder(Id accountId, Id participationId, Id programId, Id pricebookId) {
		 Order order = new Order();
        order.AccountId = accountId;
		 //order.participation__c = participationId;  //No longer used
        order.Participant__c = participationId;
        order.Program__c = programId;
        order.Pricebook2Id = pricebookId;
        order.EffectiveDate = Date.today();
        order.Status = 'Draft';
		 insert order;
		 return order;
	}

    public static Participation__c createApplication(Id accountId) {
		return createApplication(accountId, null);
	}

    public static Participation__c createApplication(Id accountId, Id programId) {
        Participation__c application = new Participation__c(Organization__c = accountId, Name = 'Application Name', Postal_Code__c = '99999');
	   if (programId != null) {
            application.Program__c = programId;
	   }
	   insert application;
	   return application;
	}

    public static Framework__c createFramework(String frameworkName, Id productId, Id programId, Boolean IsActive) {
        Framework__c framework = new Framework__c(Name = frameworkName, Product__c = productId, Program__c = programId, isActive__c = IsActive);
		insert framework;
		return framework;
	}

	public static Payment__c createPayment(Id orderId, String application) {
		Payment__c payment = new Payment__c(Order__c = orderId, Application__c = application,
											Pay_Gov_Tracking_Id__c = 'trackingId', Payment_Date__c = Date.today().addDays(-2),
											Payment_Type__c = 'PLASTIC_CARD', Transaction_Status__c = 'Success',
										   Transaction_Amount__c = 5.00, Transaction_Date__c = Datetime.now().addDays(-2));
		insert payment;
		return payment;
	}

	public static Covered_Entity__c createCoveredEntity(String entityName, Id applicationId) {
	   Covered_Entity__c ce = new Covered_Entity__c(Name = entityName, Participant__c = applicationId);
	   insert ce;
	   return ce;
	}

		public static Language__c createLanguage(String languageName, String direction, String iso) {
		Language__c l = new Language__c(Name = languageName, Direction__c = direction, ISO_639_1__c = iso);
		insert l;
		return l;
	}

	public static Translation__c createTranslation(String transName, Id productId, Id languageId) {
		Translation__c t = new Translation__c(Name = transName, Product__c = productId, Language__c = languageId);
		insert t;
		return t;
	}

	public static Content__c createContent(String contentName, String displayTitle, String typeName, Id recordTypeIdValue) {
        Content__c c = new Content__c(Name = contentName, Display_Title__c = displayTitle, Type__c = typeName, RecordTypeId = recordTypeIdValue);
		insert c;
		return c;
	}

	public static Web_Resource_Link__c createWebResourceLink(String displayName, String url, String status, String webResourceId) {
        Web_Resource_Link__c wrl = new Web_Resource_Link__c(DisplayName__c = displayName, URL__c = url, Status__c = status, Web_Resource__c = webResourceId);
		insert wrl;
		return wrl;
	}

	public static Related_Resource__c createRelatedResource(Id primaryWebResourceId, Id relatedWebResourceId, Id productId) {
		Related_Resource__c rr = new Related_Resource__c();
		rr.Primary_Web_Resource__c = primaryWebResourceId;
		rr.Related_Web_Resource__c = relatedWebResourceId;
		rr.Product__c = productId;
		insert rr;
		return rr;
	}
}