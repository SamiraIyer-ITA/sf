@isTest
private class AttachmentWriterControllerTest {
    /************************************************
    * This class performs unit tests on the AttachmentWriterController
    * under these condititions.
    * 1. Test to ensure that no attachment is created when body is null
    * 2. Test to ensure that attachment is created when body is populated
    * 3. Test to ensure that edit mode went back to false
    * 4. Test to ensure that the attachment was re-queried
    * 5. Test to ensure that it updated the same attachment
    *************************************************/
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
  	static PageReference pageRef;
  	static ApexPages.StandardController con;

	@isTest static void nullTest() {
        Test.startTest();
	    orderSetup();
		/* Test to ensure that no attachment is created when body is null*/
    	ext.saveAttachment();
    	List<Attachment> attachmentList = [SELECT Id FROM Attachment];

        Test.stopTest();
    	System.assertEquals(attachmentList.size(), 0);
	}
	@isTest static void orderTest() {
        Test.startTest();
		orderSetup();
		/* Test to ensure that attachment is created when body is populated*/
		ext.edit = true;
		ext.attachmentBody = 'My Test Attachment Body';
    	ext.saveAttachment();
    	List<Attachment> attachmentList = [SELECT Id FROM Attachment];
    	System.assertEquals(attachmentList.size(), 1);
    	/* assertEquals edit mode went back to false */
    	System.assertEquals(ext.edit, false);
    	/* assertEquals that the attachment was re-queried */
    	System.assertNotEquals(ext.attachmentId, null);
    	/* save again and ensure that it updated the same attachment */
    	ext.toggleEdit();
    	ext.attachmentBody = 'My New Test Attachment Body';
    	ext.saveAttachment();
    	attachmentList = [SELECT Id FROM Attachment];

        Test.stopTest();
    	System.assertEquals(attachmentList.size(), 1);
    	System.assertEquals(ext.attachmentBody, 'My New Test Attachment Body');
    	/* assertEquals edit mode went back to false */
    	System.assertEquals(ext.edit, false);
	}
    @isTest static void suspensionAgreementTest() {
        Test.startTest();
        orderSetup();
        /* Test to ensure that attachment is created when body is populated*/
        ext.edit = true;
        ext.attachmentBody = 'My Test Attachment Body';
        ext.saveAttachment();
        List<Attachment> attachmentList = [SELECT Id FROM Attachment];
        System.assertEquals(attachmentList.size(), 1);
        /* assertEquals edit mode went back to false */
        System.assertEquals(ext.edit, false);
        /* assertEquals that the attachment was re-queried */
        System.assertNotEquals(ext.attachmentId, null);
        /* save again and ensure that it updated the same attachment */
        ext.toggleEdit();
        ext.attachmentBody = 'My New Test Attachment Body';
        ext.saveAttachment();
        attachmentList = [SELECT Id FROM Attachment];

        Test.stopTest();
        System.assertEquals(attachmentList.size(), 1);
        System.assertEquals(ext.attachmentBody, 'My New Test Attachment Body');
        /* assertEquals edit mode went back to false */
        System.assertEquals(ext.edit, false);
    }
	
	@testSetup static void dataSetup() {
        Test.startTest();
        Petition__c testADPetition = TestUtils.createPetition(System.today().addDays(-280), 'AD ME', true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testADPetition, true);
        o = TestUtils.createOrder(testADinvestigation, true);
        s = TestUtils.createSuspensionAgreement(testADinvestigation, System.today(), true);
    } 
    private static void orderSetup(){
		pageRef = Page.OrderAttachmentWriter;
        pageRef.getParameters().put('id', o.id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(o);
    	ext = new AttachmentWriterController(con);
	}
    private static void suspensionAgreementSetup(){
        pageRef = Page.OrderAttachmentWriter;
        pageRef.getParameters().put('id', s.id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(s);
        ext = new AttachmentWriterController(con);
    }
	
}