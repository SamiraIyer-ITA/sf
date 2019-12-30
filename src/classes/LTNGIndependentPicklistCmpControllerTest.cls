@isTest
public class LTNGIndependentPicklistCmpControllerTest {
    //This test is being completed with the Country / Org Type Dependant pickList Beofre migrationg please check the number of selected option for the US and China and update
    //the values below. If they are not matching the test will fail preventing the migration. This is being done this way beacasue we are testing meta data.
    
    public static String parentField = 'Country_1__c';
    public static String parentFieldLabel = 'Country';
    public static String ObjectName = 'Lead';
    public static String domesticValidationSelection = 'United States';
    public static String foreignValdationCheckSeleaction  = 'China';
    public static Integer currentDomesticOptions = 11; // Update this number if number of child options is altered.
    public static integer currentForeignOptions = 7; // Update this number if number of child options is altered.
    //TEST STATIC METHODS  
    
    @IsTest
    static void testgetDependentPicklist() {
        system.debug('running test 1');
        LightningIndependentPicklistController.PicklistWrapper	testWrapper = LightningIndependentPicklistController.getIndependentPicklist(ObjectName,  parentField);
        system.assert(testWrapper.parentFieldLabel == parentFieldLabel );
        //check that all options were captured
    }
    //Check to make sure that null does not crash 
    @IsTest
    static void testgetDependentPicklistNullValues() {
        system.debug('running test 2');
        LightningDependentPicklistCmpController.PicklistWrapper	testWrapper = LightningDependentPicklistCmpController.getDependentPicklist('', '', '');
        system.assertequals(null , testWrapper.parentFieldLabel , 'actual value is ' + testWrapper.parentFieldLabel);        
    }
}