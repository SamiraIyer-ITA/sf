@isTest
public class CustomInstructionSelectorTest {

    @IsTest
    static void testBehavior()
    {
        CustomInstructionSelector.newInstance().selectById(new Set<Id>());
        CustomInstructionSelector.newInstance().selectAllToLimit();
    }
}