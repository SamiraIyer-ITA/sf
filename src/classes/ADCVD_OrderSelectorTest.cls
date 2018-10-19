@isTest
public class ADCVD_OrderSelectorTest {

    @IsTest
    static void testBehavior()
    {
        ADCVD_OrderSelector.newInstance().selectById(new Set<Id>());
        ADCVD_OrderSelector.newInstance().selectAllToLimit();
    }
}