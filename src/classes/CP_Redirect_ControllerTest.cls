@IsTest
public class CP_Redirect_ControllerTest{
    public static PageReference pg;
    public static CP_Redirect_Controller test;
    @IsTest static void redirectControllerTests() {
        CP_Redirect_Controller test = new CP_Redirect_Controller();
        pg = test.redirectToPage();
 }
}