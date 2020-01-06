@IsTest(SeeAllData = true)
public with sharing class CP_LightningForgotPasswordControllerTest {

 /* Verifies that ForgotPasswordController handles invalid usernames appropriately */
 @IsTest
 static void testLightningForgotPasswordControllerInvalidUserName() {
  System.assertEquals(CP_LightningForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(CP_LightningForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(CP_LightningForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email);
  System.assertEquals(CP_LightningForgotPasswordController.setExperienceId(null), null);
  System.assertEquals(CP_LightningForgotPasswordController.setExperienceId('test error'), 'test error');
 }

 /* Verifies that null checkEmailRef url throws proper exception. */
 @IsTest
 static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
  System.assertEquals(CP_LightningForgotPasswordController.forgotPassword('a', null), 'Argument 1 cannot be null');
  System.assertEquals(CP_LightningForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null');
 }

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningForgotPasswordControllerInstantiation() {
  CP_LightningForgotPasswordController controller = new CP_LightningForgotPasswordController();
  System.assertNotEquals(controller, null);
 }
}