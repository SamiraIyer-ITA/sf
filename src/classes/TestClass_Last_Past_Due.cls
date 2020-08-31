@IsTest
private class TestClass_Last_Past_Due {
@isTest static void testMethod1() {
Lead objLead = new Lead(LastName='Test',Company='Test',email='Test@test.com');
insert objLead;

Lead_Past_Due_Controller.getStatus(objLead.Id);
}
}