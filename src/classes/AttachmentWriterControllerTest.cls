@isTest
private class AttachmentWriterControllerTest {
	static ADCVD_Order__c o;
	static AttachmentWriterController ext;
  	static PageReference pageRef;
  	static ApexPages.StandardController con;
	@isTest static void test_method_one() {
		setup();
		/* Test to ensure that no attachment is created when body is null*/
    	ext.saveAttachment();
    	List<Attachment> attachmentList = [SELECT Id FROM Attachment];
    	system.assert(attachmentList.size() == 0);
	}
	@isTest static void test_method_two() {
		setup();
		/* Test to ensure that attachment is created when body is populated*/
		ext.edit = true;
		ext.attachmentBody = 'My Test Attachment Body';
    	ext.saveAttachment();
    	List<Attachment> attachmentList = [SELECT Id FROM Attachment];
    	system.assert(attachmentList.size() == 1);
    	/* assert edit mode went back to false */
    	system.assert(ext.edit == false);
    	/* assert that the attachment was re-queried */
    	system.assert(ext.attachmentId != null);
    	/* save again and ensure that it updated the same attachment */
    	ext.toggleEdit();
    	ext.attachmentBody = 'My New Test Attachment Body';
    	ext.saveAttachment();
    	attachmentList = [SELECT Id FROM Attachment];
    	system.assert(attachmentList.size() == 1);
    	system.assert(ext.attachmentBody == 'My New Test Attachment Body');
    	/* assert edit mode went back to false */
    	system.assert(ext.edit == false);
	}
	
	private static void setup(){
		o = testUtils.createOrder(true);
		pageRef = Page.OrderAttachmentWriter;
        pageRef.getParameters().put('id', o.id);
        test.setCurrentPage(pageRef);
        con = new ApexPages.StandardController(o);
    	ext = new AttachmentWriterController(con);
	}
	
}