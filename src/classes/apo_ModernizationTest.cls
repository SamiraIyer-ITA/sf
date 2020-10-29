@IsTest
public class apo_ModernizationTest {


    @IsTest static void apo_Modernization_Test() {

        Test.startTest();

        Boolean CheckPermission = apo_Modernization.doesRunningUserHavePermission();

        System.assertEquals(CheckPermission, false);

        Test.stopTest();
    }
}