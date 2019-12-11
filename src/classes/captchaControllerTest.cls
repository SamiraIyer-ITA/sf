@IsTest(SeeAllData = false)
public class captchaControllerTest {
    
    @IsTest
 static void testValidSite() {
     captchaController test = new captchaController();
     String url = test.getURL();
     system.assert(!String.isBlank(URL), 'URL NOT GENERATED');
     system.assert(URL.length() > 25, 'Url is malformed');
     
 }
}