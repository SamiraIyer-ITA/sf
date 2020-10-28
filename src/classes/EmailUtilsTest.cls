@IsTest
private with sharing class EmailUtilsTest {
	@IsTest
	static void coverEmailUtils() {
		EmailUtils.sendTemplatedEmail(new List<String>{'test@trade.gov'}, new List<String>{'testcc@trade.gov'}, 'TestEvent', UserInfo.getUserId(), false, null, null, false, null);
	}

	@IsTest
	static void coverEmailUtils_NoTemplateException() {
		try {
			EmailUtils.sendTemplatedEmail(new List<String>{'test@trade.gov'}, new List<String>{'testcc@trade.gov'}, 'Fake_Template_Does_Not_Exist', UserInfo.getUserId(), false, null, null, false, null);
		} catch(Exception e) {
			System.assertEquals(e.getMessage(),'Unable to locate EmailTemplate using name: Fake_Template_Does_Not_Exist');
		}

	}
}