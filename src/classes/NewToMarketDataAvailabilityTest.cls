@isTest
public class NewToMarketDataAvailabilityTest {
    static testMethod void testDataAvailability(){
        //if this test fails the static resource is not set up
        Test.startTest();
        NewToMarketDataAvailabilityController ntmdac = new NewToMarketDataAvailabilityController();
        Test.stopTest();
    }
}