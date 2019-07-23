@IsTest
public class FederalRegisterSelectorTest {

    @IsTest
    static void testBehavior(){
        FederalRegisterSelector.newInstance().selectById(new Set<Id>());
        FederalRegisterSelector.newInstance().selectAllToLimit();
    }
}