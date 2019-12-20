@IsTest(SeeAllData = true)
public with sharing class CP_LightningLoginFormControllerTest {

 @IsTest
 static void testLoginWithInvalidCredentials() {
  System.assertEquals('Argument 1 cannot be null', CP_LightningLoginFormController.login('testUser', 'fakepwd', null));
 }

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  CP_LightningLoginFormController controller = new CP_LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, CP_LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(true, CP_LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assert( ! String.isBlank(CP_LightningLoginFormController.getSelfRegistrationUrl()), 'No Registration URL Found');
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = CP_LightningLoginFormController.getAuthConfig();
   CP_LightningLoginFormController.setExperienceId('00000');
  System.assertNotEquals(null, authConfig);
 }
}