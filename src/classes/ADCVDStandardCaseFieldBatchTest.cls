@isTest
public class ADCVDStandardCaseFieldBatchTest {

    static ADCVD_Case__c adcvdCase{
        get{
            if(adcvdCase == null){
                adcvdCase = [SELECT Id, ADCVD_Case_Type__c, Country__c, Commodity__c, Product__c, Product_Short_Name__c,
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Petitions__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Investigations__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM ADCVD_Orders__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Segments__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Suspension_Agreements__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Litigation__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Federal_Registers__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Harmonized_Tariff_Schedules__r),
                            (SELECT Id,ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Staffing_Assignments__r),
                            (SELECT Id, ADCVD_Case__c, ADCVD_Case_Type_Text__c, Country_Text__c, Commodity_Text__c, Product_Text__c, Product_Short_Name_Text__c FROM Custom_Instructions__r) FROM ADCVD_Case__c];
            }
            return adcvdCase;
        }
        set;
    }

    @isTest static void testInitialRecordSetup(){
        //Records in the dataSetup method were all created with a specific field values
        adcvdCase = null;
        System.debug(adcvdCase);
        System.debug(adcvdCase.Petitions__r);
        //Assert petition standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Petitions__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert investigation standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Investigations__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert adcvd order standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert segment standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Segments__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Segments__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Segments__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Segments__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Segments__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert suspension agreement standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert litigation standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Litigation__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert HTS standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert federal register standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Federal_Registers__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert custom instruction standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Product_Text__c, adcvdCase.Product__c);

    }

    @isTest static void testCaseFieldsChange(){
        adcvdCase = null;
        //Update case fields
        adcvdCase.ADCVD_Case_Type__c = 'AD NME';
        adcvdCase.Commodity__c = 'Minerals';
        adcvdCase.Country__c = 'Colombia';
        adcvdCase.Product__c = 'New Product Name';
        adcvdCase.Product_Short_Name__c = 'NPN';
        update adcvdCase;

        Test.startTest();
        Database.executeBatch(new ADCVDStandardCaseFieldsBatch(new List<ADCVD_Case__c>{adcvdCase}));
        Test.stopTest();

        //Assert changes
        adcvdCase = null;
        //Assert petition standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Petitions__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Petitions__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert investigation standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Investigations__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Investigations__r[0].Product_Text__c, adcvdCase.Product__c);
       
        //Assert adcvd order standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.ADCVD_Orders__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert segment standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Segments__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Segments__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Segments__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Segments__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Segments__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert suspension agreement standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Suspension_Agreements__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert litigation standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Litigation__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Litigation__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert HTS standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Harmonized_Tariff_Schedules__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert federal register standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Federal_Registers__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Federal_Registers__r[0].Product_Text__c, adcvdCase.Product__c);

        //Assert custom instruction standardized case fields match adcvd case fields
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Commodity_Text__c, adcvdCase.Commodity__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Country_Text__c, adcvdCase.Country__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
        System.assertEquals(adcvdCase.Custom_Instructions__r[0].Product_Text__c, adcvdCase.Product__c);


        //Assert staffing assignment standardized case fields match adcvd case fields
        for(Staffing_Assignment__c staffingAssignment: adcvdCase.Staffing_Assignments__r){
            System.assertEquals(staffingAssignment.ADCVD_Case_Type_Text__c, adcvdCase.ADCVD_Case_Type__c);
            System.assertEquals(staffingAssignment.Commodity_Text__c, adcvdCase.Commodity__c);
            System.assertEquals(staffingAssignment.Country_Text__c, adcvdCase.Country__c);
            System.assertEquals(staffingAssignment.Product_Short_Name_Text__c, adcvdCase.Product_Short_Name__c);
            System.assertEquals(staffingAssignment.Product_Text__c, adcvdCase.Product__c);
        }

    }

    @testSetup static void dataSetup(){
        //create test data
       User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);

        System.runAs(testUser) {
            Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
            AppConfig__c ac = TestUtils.createAppConfig('ADCVDStandardCaseFieldsBatch', true, true);
            //create test data
         Account testAccount = TestUtils.createAccount(true);
       
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);

            Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
        
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
        Suspension_Agreement__c suspensionAgreement = TestUtils.createSuspensionAgreement(testADinvestigation, Date.today(), true);
        Segment__c segment = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
        Litigation__c litigation = TestUtils.createLitigation(testADPetition.Id, 'Petition__c', Date.today(), 'International_Litigation', true);
        Test.startTest();
        Federal_Register__c federalRegister = TestUtils.createFR(testADOrder.Id, 'ADCVD_Order__c', Date.today(), 'Order', true);
        Related_Organization__c relatedOrganization = TestUtils.createRelatedOrg(testADPetition, false);
        relatedOrganization.ADCVD_Entity_Name__c = 'test entity';
        relatedOrganization.Account__c = testAccount.Id;
        relatedOrganization.ADCVD_Case__c = testADCase.Id;
       // insert relatedOrganization;
        //HTS records are created through the Controller on their parents object page, in order to have all the standardized case fields filled
        //The records in this test class need to be created through the same controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(testADOrder);
        AttachmentWriterController newAttachmentWriterController = new AttachmentWriterController(standardController);
        newAttachmentWriterController.attachmentBody = 'This is the hts number 3425.3525';
        CreateHTSRecordsController htsRecordsController = new CreateHTSRecordsController(newAttachmentWriterController);
        Custom_Instruction__c customInstruction = TestUtils.createCustomInstruction('Investigation__c', testADinvestigation.Id, true);
        Test.stopTest();
        }

    }

}