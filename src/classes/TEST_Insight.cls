@isTest
private class TEST_Insight {

    static testMethod void myUnitTest() {
        
        Test.startTest();
        Insight insight = new Insight();
        insight.pin();
        insight.getMostRecent();
        insight.create();
        insight.save();
        insight.remove();
        insight.doNothing();
        insight.getRecords();
        insight.title = 'Title';
        insight.summary = 'Summary';
        System.assertEquals(insight.summary, 'Summary'); 
        Test.stopTest();
    }
    
}