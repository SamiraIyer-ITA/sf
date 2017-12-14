@isTest
public class ADCVD_OrderSearchTest {

	private static Date orderDate = System.today();

	@isTest static void mainTest(){
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ADCVD_OrderSearchTestImpl());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ADCVD_OrderSearch/';
        req.httpMethod = 'POST'; 
        RestContext.request = req;
        RestContext.response = res;
        ADCVD_OrderSearch.doPost();
        Test.stopTest();
        
        ADCVD_OrderSearch.JsonOutput jsonResponse = (ADCVD_OrderSearch.JsonOutput)JSON.deserialize(res.responseBody.toString(), ADCVD_OrderSearch.JsonOutput.class);
        System.assertEquals(4, jsonResponse.adcvdOrders[0].segments.size());
        System.assertEquals('tacos', jsonResponse.adcvdOrders[0].productShortName);
        System.assertEquals(5, jsonResponse.adcvdOrders[0].htsNums.size());
    }


	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testADPetition = TestUtils.createPetition(orderDate.addDays(-280), 'AD ME', true);
		Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testADPetition, true);
		ADCVD_Order__c testOrder = TestUtils.createOrder(testADinvestigation, true);
		List<Harmonized_Tariff_Schedule__c> testHTS = TestUtils.createHtsNumbers(testOrder.Id, Decimal.valueOf('1000000000'), Decimal.valueOf('5'), true);
		Map<String,Segment__c> segsToInsert = new Map<String,Segment__c>();
		System.runAs(testUser) {
			for(String segRecordTypeName : Utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
				Segment__c testSeg = TestUtils.createSegment(testOrder, segRecordTypeName, false);
				if (segRecordTypeName != 'Sunset_Review') {
					testSeg = setStartDates(testSeg);
				} else {//90 day Sunset
					testSeg.Notice_of_intent_to_participate_Ips__c = 'No';
			        testSeg.Domestic_Party_File_Substan_Response__c = 'No';
			        testSeg.Review_to_address_zeroing_in_Segments__c = '';
			        testSeg.Respondent_File_Substantive_Response__c = '';
			        testSeg.Adequacy_of_Respondents_Submission__c = '';
				}
				segsToInsert.put(segRecordTypeName, testSeg);
			}
			insert segsToInsert.values();
			if (segsToInsert.get('Sunset_Review') != null) {
				Segment__c ssr = segsToInsert.get('Sunset_Review');
				Federal_Register__c testFR = TestUtils.createFR(ssr.Id, 'Segment__c', orderDate.addDays(120), 'Initiation', true);
			}
		}
	}

	private static Segment__c setStartDates(Segment__c s) {
		Map<String,String> recordTypeNameToStartDateMap = new Map<String,String>{
			'Administrative_Review'=>'Final_Date_of_Anniversary_Month__c',
			'Anti_Circumvention_Review'=>'Application_Accepted__c',
			'Changed_Circumstances_Review'=>'Request_Filed__c',
			'Expedited_Review'=>'Calculated_Initiation_Signature__c',
			'New_Shipper_Review'=>'Calculated_Initiation_Signature__c',
			'Scope_Inquiry'=>'Request_Filed__c'
		};
        s.put(recordTypeNameToStartDateMap.get(Utils.recordTypeIdToRecordTypeMap.get(s.RecordTypeId).DeveloperName), orderDate);
        return s;
    }
}