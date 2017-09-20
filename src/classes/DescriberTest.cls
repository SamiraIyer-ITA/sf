/**
 *
 * written by cal smith, MIL Corp
 * 
 *
 */
@isTest
private class DescriberTest {
	
    static testMethod void getObjectNames() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);
		
    	system.runAs(u){
	    	list<SelectOption> objectNames = new list<SelectOption>();    		
	    	
	    	Test.startTest();
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
			
    		objectNames = con.initObjNames();
    		integer n = objectNames.size();
    		String name;
        	list<selectOption> sO = new list<selectOption>();
			SO.add( new selectOption('Account','Account'));
	        
        	system.debug('list length = ' + n);
	                
	    		
	        Test.stopTest();
			
	        Boolean Result = false;
	        For(selectOption oName:objectNames){
				integer i = 0;
				objectNames[i]=oName;
				if(oName.getValue() == sO[0].getValue()){ 
					Result = true;
					System.assert(objectNames[i].getValue() == sO[0].getValue());
				}
				
				i++;
	        }
	        //System.assert(con.objectNames.contains('Account'));

    	} //system.runAs();
		
    }
    
    static testMethod void getFieldsSelectedObject() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();

			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			integer n = objectNames.size();

	        String name;
        	list<selectOption> sO = new list<selectOption>();
			SO.add( new selectOption('Account','Account'));
	        system.debug('list length = ' + n);
	        integer s=0;
			selected = 'Account';
	        Boolean Result = false;

	        For(selectOption oName:objectNames){
				integer i = 0;
				objectNames[i]=oName;
				if(oName.getValue() == sO[0].getValue()){ 
					Result = true;
					System.assert(objectNames[i].getValue() == sO[0].getValue());
				}
				
				i++;
	        }

			
       		con.selectedObject = objectNames[s].getValue();
			con.showFields();
			integer k = con.pairFields.size();
			
			//con.FillAllFields = true;
			
			//con.descrSObject = (con.globalDescribe.get(objectNames[s].getValue())).getDescribe();

			//con.createSObject(string.valueOf(con.globalDescribe.get(objectNames[s].getValue())));
			
	        //Test.stopTest();
			/*
			for(integer i=0;i<k;i++){
				system.debug('field value =' + con.pairFields[i].val);
			}			    	
	        
			
			for(integer i=0;i<k;i++){
				system.debug('field value =' + con.fields[i].val);
			}			    	
	        */
			//Schema.SObjectType token = con.globalDescribe.get(con.selectedObject);
			//SObject selectedObject = token.newSObject();
			
										
	        //for(Schema.SObjectField f : con.globalDescribe.globalDescribe.get(objectNames[s].getValue()).getDescribe().fields) { 
	      /*  Map<String, Schema.SObjectField> fieldMap = token.getDescribe().fields.getMap();
	        For(Schema.SObjectField f : fieldMap.values()) {
	        
	        	system.debug('Label = ' + f);
	        	
	        } */
	        Test.stopTest();
	        
	        
        } //system.runAs();
        
    }

    static testMethod void getPermSetsAndProfiles() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	//list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
	    	Describer con = new Describer();
	    	
	    	list<PermissionSet>allPerms = con.allPerms;
	    	
			system.debug(allPerms.size());
			
	    	list<PermissionSet>permsInProfiles = con.permsInProfiles;
	    	
			system.debug(permsInProfiles.size());

			for(PermissionSet ps:permsInProfiles){
			
				system.debug(ps.Name);	
			}
			
	    	list<PermissionSet>permsNotInProfiles = con.permsNotInProfiles;
	    	
			system.debug(permsNotInProfiles.size());
			
			for(PermissionSet ps:permsNotInProfiles){
			
				system.debug(ps.Name);	
			}
			
			set<PermissionSet>nonProfilePerms = new set<PermissionSet>();

			nonProfilePerms.addAll(allPerms);
			
			nonProfilePerms.removeAll(permsInProfiles);
			
			system.debug(nonProfilePerms.size());
			
			for(PermissionSet ps:nonProfilePerms){
			
				system.debug(ps.Name);	
			}
			
			/*
	    	list<ObjectPermissions>addedObjPerms = con.addedObjPerms;
	    	
			system.debug(addedObjPerms.size());
			
	    	list<ObjectPermissions>objPermsFromProfiles = con.objPermsFromProfiles;

			system.debug(objPermsFromProfiles.size());
			*/
			
			list<Profile>allUserProfiles = con.allUserProfiles;
			
			
	    	Test.stopTest();
	    	
	    	

    	}//runAs    
    }
    
        static testMethod void getCRUD() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			integer n = objectNames.size();

			con.selectedObject = 'Account';
			
			con.showFields();

			//con.FillAllFields = true;

	    	system.debug(con.selectedObject);
	    	
	    	set<string>crudObjkeys = con.objectToCRUDPerms.keyset();
	    	for(string key:crudObjkeys){ 
	    	
	    		map<string,string>crudmap = con.objectToCRUDPerms.get(key);
	    		set<string>crudkeys = crudmap.keyset();
				for(string k:crudkeys){
					system.debug(k + ' : ' + crudmap.get(k));				
				
				}
	    	}
			
	    	Test.stopTest();
	    	
				    	

    	}//runAs    
    }

        static testMethod void getRecortTypesByName() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			integer n = objectNames.size();

			con.selectedObject = 'Account';
			
			con.showFields();
			//con.FillAllFields = true;
			
	    	Test.stopTest();
	    	
	    	system.debug(con.selectedObject);
	    	
	    	map<String,string>recordTypeMapByName = con.recordTypeMapByName;
	    	set<string>recordTypeKeys = recordTypeMapByName.keyset();
	    	
			for(string key:recordTypeKeys){
				system.debug(key + ' : ' + recordTypeMapByName.get(key));				
				
			}
			
				    	

    	}//runAs    
    }

        static testMethod void getChildRelationships() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			integer n = objectNames.size();

			con.selectedObject = 'Account';
			
			con.showFields();
			//con.FillAllFields = true;
			
			boolean hasChildren = con.hasChildRelationships(con.selectedObject);
			
	    	Test.stopTest();
	    	
	    	system.debug(con.selectedObject);
	    	
	    	map<String,string>recordTypeMapByName = con.recordTypeMapByName;
	    	set<string>recordTypeKeys = recordTypeMapByName.keyset();
	    	
			for(string key:recordTypeKeys){
				system.debug(key + ' : ' + recordTypeMapByName.get(key));				
				
			}
			
			for(string key:con.childRelFieldName2FieldType.keyset()){
				system.debug(key + ' : ' + con.childRelFieldName2FieldType.get(key));
			}
				    	

    	}//runAs    
    }

        static testMethod void getSelObjectFields() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			con.selectedObject = 'Account';
			con.showFields();
			// con.FillAllFields = true;
			
			boolean hasChildren = con.hasChildRelationships(con.selectedObject);

			// con.excludedFields();
			//map<string, Schema.SObjectField> fieldMap = con.fieldMapFor(con.selectedObject);
			// con.isUpdateable();
						
	    	Test.stopTest();
	    	
	    	system.debug(con.selectedObject);
	    	
	    	map<String,string>recordTypeMapByName = con.recordTypeMapByName;
	    	set<string>recordTypeKeys = recordTypeMapByName.keyset();
	    	
			for(string key:recordTypeKeys){
				system.debug(key + ' : ' + recordTypeMapByName.get(key));				
				
			}
			
			for(string key:con.childRelFieldName2FieldType.keyset()){
				system.debug(key + ' : ' + con.childRelFieldName2FieldType.get(key));
			}
				    	

    	}//runAs    
    }

        static testMethod void getGroupings() {
    	Profile SysAdminProfile = [Select Id from Profile where Name = 'System Administrator' limit 1];
    	User u = TestUtils.createAdminUser(true, 'test.admin1@trade.gov', 1);

    	system.runAs(u){

	    	list<SelectOption> objectNames = new list<SelectOption>();	
	    				
	    	Test.startTest();
	    	
			String selected;
			
	    	PageReference pageRef = new PageReference('apex/Describer_Development');
			Describer con = new Describer();
    		objectNames = con.initObjNames();			
			con.selectedObject = 'Account';
			system.debug(con.selectedObject);
			con.showFields();
			//con.createFieldGroupings(con.fieldMap);
			
			// boolean hasChildren = con.hasChildRelationships(con.selectedObject);

			//
			
			// system.debug('size = ' + con.areIncludedFields.size());
			//con.excludedFields();
			
			//con.isIncluded();
/*			
			
			integer i=0;
			for(Describer.pair fieldDesr:con.areExcludedFields){
				
				system.debug('Excluded Field key : ' + fieldDesr.key);
				system.debug('Excluded Field val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areNillableFields){
				
				system.debug('nillField key : ' + fieldDesr.key);
				system.debug('nillField val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}
		
			i=0;	
			for(Describer.pair fieldDesr:con.areIncludedFields){
				
				system.debug('inclField Name key : ' + fieldDesr.key);
				system.debug('inclField Name val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areUpdateableFields){
				
				system.debug('updateable val : ' + fieldDesr.key);
				system.debug('updateable key : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areAccessibleFields){
				
				system.debug('accessible key : ' + fieldDesr.key);
				system.debug('accessible val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areAutoNumberFields){
				
				system.debug('autoNumber key : ' + fieldDesr.key);
				system.debug('autoNumber val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areCalculatedFields){
				
				system.debug('calculated key : ' + fieldDesr.key);
				system.debug('calculated val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}


			i=0;	
			for(Describer.pair fieldDesr:con.areReadOnlyFields){
				
				system.debug('readOnly key : ' + fieldDesr.key);
				system.debug('readOnly val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areIdLookupFields){
				
				system.debug('idLookup key : ' + fieldDesr.key);
				system.debug('idLookup val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areNamePointingFields){
				
				system.debug('namePointing key : ' + fieldDesr.key);
				system.debug('namePointing val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areDefaultedOnCreateFields){
				
				system.debug('defaultedOnCreate key : ' + fieldDesr.key);
				system.debug('defaultedOnCreate val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areUniqueFields){
				
				system.debug('unique key : ' + fieldDesr.key);
				system.debug('unique val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}

			i=0;	
			for(Describer.pair fieldDesr:con.areExternalIdFields){
				
				system.debug('externalId key : ' + fieldDesr.key);
				system.debug('externalId val : ' + fieldDesr.val);
				system.debug('count : ' + i);
				i++;
			}


*/	
			integer i = 0;
			for(string key:con.pairFieldkey2FieldDescribe.keyset()){
				//system.debug('pairFieldkey : ' + key.getName() );
				try{
					system.debug('fieldDescribe key : ' + key);
					system.debug('field Name : ' + con.pairFieldkey2FieldDescribe.get(key).getName());
					system.debug('field Type : ' + con.pairFieldkey2FieldDescribe.get(key).getType());
					system.debug('field Label : ' + con.pairFieldkey2FieldDescribe.get(key).getLabel());
					system.debug('field : ' + i);
				}catch(nullpointerexception e){
					system.debug('nullpointer field : ' + i);
				}
				i++;	
			}
						
	    	Test.stopTest();
	    	
			//system.debug('pairs size : ' + con.pairFields.size());
				
		/*	for(Describer.pair pairfield:con.pairFields){
				
				system.debug('pairField key : ' + pairfield.key);
				system.debug('pairField value : ' + pairfield.val);
				system.debug('count : ' + i);
				i++;
			}
		*/	
			//i=0;
	
			//system.debug('Nillable pairs size : ' + con.areNillableFields.size());
	    	
	    	
			// for(string key:recordTypeKeys){
			//	system.debug(key + ' : ' + recordTypeMapByName.get(key));				
				
			// }
			
			// for(string key:con.childRelFieldName2FieldType.keyset()){
			//	system.debug(key + ' : ' + con.childRelFieldName2FieldType.get(key));
			// }
			
			
			
			//system.debug('size = ' + con.areIncludedFields.size());
			
			//system.debug('size = ' + con.areExcludedFields.size());
			
			//system.debug('size = ' + con.areUpdateableFields.size());
			
			//system.debug('size = ' + con.areAccessibleFields.size());
			
			//system.debug('size = ' + con.areAutoNumberFields.size());
			
			//system.debug('size = ' + con.areCalculatedFields.size());
			
			//system.debug('size = ' + con.areIdLookupFields.size());
			
			//system.debug('size = ' + con.areNamePointingFields.size());
			
			//system.debug('size = ' + con.areDefaultedOnCreateFields.size());
			
			//system.debug('size = ' + con.areUniqueFields.size());
			
			//system.debug('size = ' + con.areExternalIdFields.size());
			
			//system.debug('size = ' + con.areNillableFields.size());
			

			//for(string a:con.areCreateableFields.keyset()){
			//	system.debug(a + ' : '  + con.areCreateableFields.get(a));
			//}				    	

			//for(string a:con.areUpdateableFields.keyset()){
			//	system.debug(a + ' : ' + con.areUpdateableFields.get(a));
			//}				    	
/*
			for(string a:con.areAccessibleFields.keyset()){
				system.debug(a + ' : ' + con.areAccessibleFields.get(a));
			}				    	

			for(string a:con.areAutoNumberFields.keyset()){
				system.debug(a + ' : ' + con.areAutoNumberFields.get(a));
			}				    	

			for(string a:con.areCalculatedFields.keyset()){
				system.debug(a + ' : ' + con.areCalculatedFields.get(a));
			}				    	

			for(string a:con.areIdLookupFields.keyset()){
				system.debug(a + ' : ' + con.areIdLookupFields.get(a));
			}				    	

			for(string a:con.areNamePointingFields.keyset()){
				system.debug(a + ' : ' + con.areNamePointingFields.get(a));
			}				    	

			for(string a:con.areDefaultedOnCreateFields.keyset()){
				system.debug(a + ' : ' + con.areDefaultedOnCreateFields.get(a));
			}				    	

			for(string a:con.areUniqueFields.keyset()){
				system.debug(a + ' : '  + con.areUniqueFields.get(a));
			}				    	

			for(string a:con.areExternalIdFields.keyset()){
				system.debug(a + ' : ' + con.areExternalIdFields.get(a));
			}				    	

			for(string a:con.areNillableFields.keyset()){
				system.debug(a + ' : ' + con.areNillableFields.get(a));
			}				    	
			
			for(string a:con.areExcludedFields.keyset()){
				system.debug(a + ' : ' + con.areExcludedFields.get(a));
			}				    	

			for(string a:con.areIncludedFields.keyset()){
				system.debug(a + ' : ' + con.areIncludedFields.get(a));
			}				    	
			*/

    	}//runAs    
    }

    
}

			//** ‘name’ was a specific field in my example. fields.getMap() returns a Map<String,Schema.SObjectField>
			// you can grab that and iterate via normal map methods like keySet()
			// or .get(someStringVariable)
 			// get the SObjectField from the map, then call it’s getDescribe() to get the DescribeFieldResult

	    	//**Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
	        
	        //Schema.SObjectType tobjectType = con.globalDescribe.get(selectedObject);
	        
	        //**Schema.DescribeFieldResult dfr = Schema.SObjectType.Account.fields.Name;
	        
	        //Schema.DescribeFieldResult dfr = con.string.ValueOf(tobjectType).fields.Name;
	        
	        //**Schema.DescribeFieldResult dfr = Account.Description.getDescribe();
	        
	        //con.globalDescribe.get(selectedObject).fields.Name = Description.getDescribe();
	        
	        //**Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();
	        
	        //**Schema.DescribeSObjectResult dsr = Schema.SObjectType.Account;
	        
	        //**Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
	        
	        // Schema.sObjectType token = globalDescribe.get(objectType);
	        
	        // SObject obj = token.newSObject();
	        
	        // sObject types to describe

			/*String[] types = new String[]{'Account','Merchandise__c'};
			
			// Make the describe call
			Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
			
			System.debug('Got describe information for ' + results.size() + ' sObjects.');
			
			// For each returned result, get some info
			for(Schema.DescribeSobjectResult res : results) {
			    System.debug('sObject Label: ' + res.getLabel());
			    System.debug('Number of fields: ' + res.fields.getMap().size());
			    System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
			    // Get child relationships
			    Schema.ChildRelationship[] rels = res.getChildRelationships();
			    if (rels.size() > 0) {
			        System.debug(res.getName() + ' has ' + rels.size() + ' child relationships.');
			    }
			}
			*/

	        //Schema.DescribeFieldResult fieldDescribe
	        //Schema.SObjectField field.keySet()
	        //field.getDescribe()
	        //fieldDescribe.getType()
	        //fieldDescribe.getName()
	        //referenceObjectType
	           	
	    	
	    	// want to get relationships with other objects where is either a parent of the object,
	    	// is a child of the object, or there's a lookup relationship of some kind to a field 
	    	// on the other object that relates to a field of the 2nd object.
	    	
	    	// If M-D, is there a cascade delete?
	    	
	    	// If field is a formula field, field is read-only. Want to get a list of all read-only fields.
	    	
	    	// Is there a "default on create"? Want to know the value and the field.
	    	
	    	// Is there an Autonumber field? Is it read-only (typical)? Is it the Name field?
	    	
	    	// Is object updatable? If so, which fields are updatable too?
	    	
	    	// List of system fields that are only updated by the system?
	    	
	    	//