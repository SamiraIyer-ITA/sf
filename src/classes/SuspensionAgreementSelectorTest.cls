@isTest
public class SuspensionAgreementSelectorTest {

    @IsTest
    static void testBehavior()
    {
        SuspensionAgreementSelector.newInstance().selectById(new Set<Id>());
        SuspensionAgreementSelector.newInstance().selectAllToLimit();
    }
}