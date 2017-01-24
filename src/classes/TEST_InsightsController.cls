@isTest
private class TEST_InsightsController {

    static testMethod void myUnitTest() {
        
        Insight__c insight = new Insight__c();
        
        Insight_atom__c atom = new Insight_atom__c();
        atom.Atom__c = 'test';
        atom.Insight__c = insight.Id;
        insert(atom);
        
         Test.startTest();
            InsightsController controller = new InsightsController();
            controller.doNothing();
        	controller.Insight = insight;
        	controller.InsightId = insight.Id;
        	controller.InsightAtomId = atom.Id;
        
            controller.removeInsight();
            Insight__c[] insights = controller.getInsights();
            controller.SelectInsight();
        	//Insight__c insight2 = controller.getInsight();
            //controller.removeArticle();
            //controller.sortArticleUp();
            //controller.sortArticleDown();
            //system.assertEquals(null, null);         
        Test.stopTest();
    }
}