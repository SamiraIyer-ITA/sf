@isTest
public with sharing class TestUtils {
	public static ADCVD_Order__c createOrder(Boolean doInsert) {
		ADCVD_Order__c o = new ADCVD_Order__c();
		if(doInsert) {
			insert o;
		}
		return o;
	}

	private static Id adminProfileId = [SELECT Id FROM Profile WHERE Name=: 'System Administrator' LIMIT 1].Id;
	
	/*public static Staffing_Assignment__c createStaffingAssignment(Boolean doInsert, Segment__c seg, ADCVD_Order__c ord) {
		Staffing_Assignment__c sa = new Staffing_Assignment__c(Segment__c = seg.Id, ADCVD_Order__c = ord.Id);
		if(doInsert) {
			insert sa;
		}
		return sa;
	}*/
	public static Segment__c createSegment(Boolean doInsert, ADCVD_Order__c ord) {
		Segment__c seg = new Segment__c();
		if(ord != null && ord.Id != null) {
			seg.ADCVD_Order__c = ord.Id;
		}
		if(doInsert) {
			insert seg;
		}
		return seg;
	}

/*	/public static List<User> createStaffUsers(Boolean doInsert) {
		Integer i = 0;
		List<User> userList = new List<User>();
		for(String s: StaffingAssignmentController.userTitlesSet) {
			i++;
			User u = createAdminUser(false, 'test@test.tst', i);
            u.AD_CVD_Title__c = s;
            userList.add(u);
		}
		if(doInsert) {
			insert userList;	
		}
		return userList;
	}
*/	
	public static User createAdminUser(Boolean doInsert, String email, Integer i) {
		User u = new User();
		u.ProfileId = adminProfileId;
     	u.isActive = true;
    	u.Alias = 'Alias' + i;
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey='en_US';
        u.LastName = 'LastName' + i;
        u.FirstName = 'FirstName' + i;
        u.EmailEncodingKey = 'ISO-8859-1';
        u.Email = email + i;
        u.TimeZoneSidKey = 'America/New_York';
        u.CommunityNickname = 'Ltest' + i;
        u.UserName = email + '.test' + i;
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
            BillingState='NY',
            BillingPostalCode='10101'
            );
        if(doInsert) {insert newRecord;}
        return newRecord; 
    }
    
    public static Product2 createProduct(Boolean doInsert) {
        Product2 newRecord = new product2(
            Name='MyTestProduct', 
            IsActive = true
            );
        if(doInsert) {insert newRecord;}
        return newRecord; 
    }

        
    public static Asset createAsset(Account account, Product2 product, Boolean doInsert){
        Asset newRecord = new Asset(
            Name = Product.Name, 
            AccountId = account.Id, 
            Product2id = Product.Id, 
            Status='Installed'
            );
        if(doInsert) {insert newRecord;}
        return newRecord;
    }

    public static Attachment createAttachment(Id parentId, Boolean doInsert) {
        Attachment newRecord = new Attachment(
            ParentId = parentId,
            Name = 'mytestname',
            Body = Blob.valueOf('mystring')
            );
        if(doInsert) {insert newRecord;}
        return newRecord;
    }
    //create test Contact
    public static Contact createContact(String name, String accId , Boolean isInsert){
        Contact con = new Contact(LastName = name, accountId = accId, ownerId = UserInfo.getUserId());
        if(isInsert){
            insert con;
        }
        return con;
    }
    
    // create Case
    public static Case createCase(String sub, boolean isInsert){
        Case cs = new Case();
        cs.Subject = sub;
        if(isInsert) {
            insert cs;
        }  
        return cs;
    }
    
    
    // create Case
    public static Lead createLead(String firstName, String LastName,boolean isInsert){
        Lead lead = new Lead ();
        lead.firstName = firstName;
        lead.LastName = LastName;
        lead.Company = 'Test';
        if(isInsert) {
            insert lead;
        }
        return lead;
    }
            
    // create test Opportunity
    public static Opportunity createOpportunity(String accId, String conId, boolean isInsert){
        Opportunity opp = new Opportunity();
        opp.Name = 'opportunity';
        opp.AccountId = accId;
        opp.CloseDate = Date.Today();
        opp.stageName = 'Open';
        if(isInsert) {
            insert opp;
        }
        return opp;
    }
    
     public static User createGenericUser(string username, string email, String profileId) {
        User user = new User();
        user.ProfileId = profileId;
        user.isActive = true;
        user.Alias = 'Alias1';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey='en_US';
        user.LastName = 'LastName1';
        user.FirstName = 'FirstName1';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Email = email;
        user.TimeZoneSidKey = 'America/New_York';
        user.CommunityNickname = username+ 'nick87Test';
        user.UserName = username + '.test';
        //user.CallCenterId  = [select Id from CallCenter limit 1].Id;       
        //user.ContactId = conId;
        return user;
    }
}