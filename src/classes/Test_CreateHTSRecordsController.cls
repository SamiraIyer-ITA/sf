/*************************************
*  This is a test class for the CreateHTSRecordsController class.   
*  1. This test class populates the Scope (scope.txt attachment) with a multi-line string for both  
*     ADCVD Order and Suspension Agreement objects and saves it.   
*  2. It checks for valid and invalid Harmonized Tariff Schedule (HTS) Numbers on both objects. 
*  3. It checks the neccessary HTS records created for both ADCVD Order and Suspension Agreement objects.  
*
*  Author: Samira Iyer
*  Created On: 1/23/2018
***************************************/

@isTest
private class Test_CreateHTSRecordsController {
	//Set the variables
    static ADCVD_Order__c o {
        get {
            if (o == null) {
                o = [SELECT Id FROM ADCVD_Order__c LIMIT 1];
            }
            return o;
        } set;
    }
    static Suspension_Agreement__c s {
        get {
            if (s == null) {
                s = [SELECT Id FROM Suspension_Agreement__c LIMIT 1];
            }
            return s;
        } set;
    }
    
	static AttachmentWriterController ext;
    static CreateHTSRecordsController htsRecord;
  	static PageReference pageRef;
  	static ApexPages.StandardController con;
    
    // Test Method for creating HTS Numbers for Orders
 	@isTest static void createCreateHTSRecords_OrderTest() {
        Test.startTest();
		orderSetup();
        /* Test to ensure that lits of valid HTS numbers is created when body is populated*/ 
        ext.edit = true;     
		ext.attachmentBody = 'Prior to January 1, 2017, subject merchandise was classifiable under the \n' +
                             'following HTSUS numbers which have been deleted or discontinued: \n' +
                             '7208.40.3060, 5407.9505, \n'+
                             '612.3960, 7409.29';       
        ext.saveAttachment();             
        
        // Extract HTS Numbers from Scope.txt
        List <string> htsStringList = htsRecord.getHTSNumber(ext.attachmentBody);
        List<String> expHTSNumList = new List<String>();
        expHTSNumList.add('7208.40.3060');
        expHTSNumList.add('5407.9505'); 
        expHTSNumList.add('7409.29');
        
        //AssertEquals for the expected HTS Numbers List      
        System.assertEquals(expHTSNumList, htsStringList); 		        
        
        //AssertNotEquals for the non-expected HTS Numbers List 
        List<String> nonExpHTSNumList = new List<String>();
        nonExpHTSNumList.add('612.3960'); 
        nonExpHTSNumList.add('2017');
 		System.assertNotEquals(nonExpHTSNumList, htsStringList); 

        //Create HTS Numbers List
		Map <string, string> htsNumMap = htsRecord.getHTSNumMap(htsStringList);
        
        //AssertEquals for the expected HTS Numbers Map
        Map<String, String> expHTSNumMap = new Map<String,String>();
        expHTSNumMap.put('7208.40.3060', '7208403060');
        expHTSNumMap.put('5407.9505', '54079505'); 
        expHTSNumMap.put('7409.29', '740929');
        For(string hts:htsNumMap.keyset()){
			System.assert(expHtsNumMap.containsKey(hts));
            System.assertEquals(expHtsNumMap.get(hts), htsNumMap.get(hts));
        }    
        
        // Assert if HTS Number Records are created for the Order
        List<ADCVD_Order__c> ordersWithHts = [select  Id, (Select Id, HTS_Number_Formatted__c, ADCVD_Order__c FROM Harmonized_Tariff_Schedules__r) from ADCVD_Order__c];
        For (ADCVD_Order__c ord: ordersWithHts)    
        { 
            Integer i = 0;
        	String orderId = ord.Id;
            //System.debug('#1 TestClass: HTS Records Size(Order) Size is : ' + ord.Harmonized_Tariff_Schedules__r.size());
        	For (Harmonized_Tariff_Schedule__c htsNum :ord.Harmonized_Tariff_Schedules__r)
        	{     	
            	//System.debug('#2 TestClass: HTS Record ' + (i+1) +' for Order is: ' + htsNum);
                String htsActNum = htsNum.HTS_Number_Formatted__c.replaceAll('\\.', '').trim();
                String htsExpNum = htsStringList.get(i).replaceAll('\\.', '').trim();
                System.assertEquals(orderId, htsNum.ADCVD_Order__c);
                System.assertEquals(htsExpNum, htsActNum);
				i++; 
        	}
    	}
        Test.stopTest();        
	}   

    // Test Method for creating HTS Numbers for Suspension Agreement  
 	@isTest static void createCreateHTSRecords_SuspAgrmentTest() {
        Test.startTest();
		suspensionAgreementSetup();
        /* Test to ensure that lits of valid HTS numbers is created when body is populated*/ 
        ext.edit = true;     
		ext.attachmentBody = 'Prior to January 1, 2017, subject merchandise was classifiable under the \n' +
                             'following HTSUS numbers which have been deleted or discontinued: \n' +
                             '7208.40.3060, 5407.9505, \n'+
                             '612.3960, 7409.29';       
        ext.saveAttachment();             
        
        // Extract HTS Numbers from Scope.txt
        List <string> htsStringList = htsRecord.getHTSNumber(ext.attachmentBody);
        List<String> expHTSNumList = new List<String>();
        expHTSNumList.add('7208.40.3060');
        expHTSNumList.add('5407.9505'); 
        expHTSNumList.add('7409.29');
        
        //AssertEquals for the expected HTS Numbers List      
        System.assertEquals(expHTSNumList, htsStringList); 		        
        
        //AssertNotEquals for the non-expected HTS Numbers List 
        List<String> notExpHTSNumList = new List<String>();
        notExpHTSNumList.add('612.3960'); 
        notExpHTSNumList.add('2017');
 		System.assertNotEquals(notExpHTSNumList, htsStringList); 

        //Create HTS Numbers List
		Map <string, string> htsNumMap = htsRecord.getHTSNumMap(htsStringList);
        
        //AssertEquals for the expected HTS Numbers Map
        Map<String, String> expHTSNumMap = new Map<String,String>();
        expHTSNumMap.put('7208.40.3060', '7208403060');
        expHTSNumMap.put('5407.9505', '54079505'); 
        expHTSNumMap.put('7409.29', '740929');
        For(string hts:htsNumMap.keyset()){
			System.assert(expHtsNumMap.containsKey(hts));
            System.assertEquals(expHtsNumMap.get(hts), htsNumMap.get(hts));
        }    
        
        // Assert if HTS Number Records are created for the Suspension Agreement
        List<Suspension_Agreement__c> suspAggmtWithHts = [select Id, (Select Id, HTS_Number_Formatted__c, Suspension_Agreement__c FROM Harmonized_Tariff_Schedules__r) from Suspension_Agreement__c];
        For (Suspension_Agreement__c suspAgg: suspAggmtWithHts)    
        { 
            Integer j = 0;
        	String suspAggId = suspAgg.Id;
            //System.debug('#3 TestClass: HTS Records Size(SuspAgreement) Size is : ' + suspAgg.Harmonized_Tariff_Schedules__r.size());
        	For (Harmonized_Tariff_Schedule__c htsNum :suspAgg.Harmonized_Tariff_Schedules__r)
        	{     	
            	//System.debug('#4 TestClass: HTS Record ' + (j+1) +' for SuspAgreement is: ' + htsNum);
                String htsActNum = htsNum.HTS_Number_Formatted__c.replaceAll('\\.', '').trim();
                String htsExpNum = htsStringList.get(j).replaceAll('\\.', '').trim();
                System.assertEquals(suspAggId, htsNum.Suspension_Agreement__c);
                System.assertEquals(htsExpNum, htsActNum);
				j++; 
        	}
    	}
        Test.stopTest();        
	}       
    
    // Create Test Data
    @testSetup static void dataSetup() {
        Test.startTest();
        Petition__c testADPetition = TestUtils.createPetition(System.today().addDays(-280), 'AD ME', true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testADPetition, true);
        o = TestUtils.createOrder(testADinvestigation, true);
        s = TestUtils.createSuspensionAgreement(testADinvestigation, System.today(), true);
    } 
    
    // Order Setup
    private static void orderSetup(){
		pageRef = Page.OrderAttachmentWriter;
        pageRef.getParameters().put('id', o.id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(o);
    	ext = new AttachmentWriterController(con);
        htsRecord = new CreateHTSRecordsController(ext);
	}
    
    // Order Setup
    private static void suspensionAgreementSetup(){
        pageRef = Page.OrderAttachmentWriter;
        pageRef.getParameters().put('id', s.id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(s);
        ext = new AttachmentWriterController(con);
        htsRecord = new CreateHTSRecordsController(ext);
    } 
}