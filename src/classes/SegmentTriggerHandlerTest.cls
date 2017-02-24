@isTest
public class SegmentTriggerHandlerTest {
	private static Date segmentDate = System.today();
	private static Date testActual = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testCalculated = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			System.debug('User u: ' + u);
			return u;
		}
	}
	private static ADCVD_Order__c o{
		get{
			if (o == null) {
				o = [SELECT Id, Anniversary_Month__c FROM ADCVD_Order__c LIMIT 1];
			}
			return o;
		}
	}
	private static Segment__c adminSeg{
		get{
			if (adminSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
				adminSeg = [SELECT Id, RecordTypeId FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return adminSeg;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		List<Segment__c> sList = new List<Segment__c>();
		sList.add(adminSeg);
		SegmentTriggerHandler.initialize(sList, null);
		//TODO
		Test.stopTest();
	}
	


	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		ADCVD_Order__c order = TestUtils.createOrder(true);
		System.runAs(testUser) {
			Segment__c admin = TestUtils.createSegment(o, 'Administrative_Review', true);
			Segment__c newShipper = TestUtils.createSegment(o, 'New_Shipper_Review', true);
		}
	}
}