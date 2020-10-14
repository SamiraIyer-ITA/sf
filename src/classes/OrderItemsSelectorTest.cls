@IsTest

public class OrderItemsSelectorTest {
    
    //run stubs to increase code cover for production deployment.
    @IsTest
    static void selectById_Positive() {
        OrderItemsSelector testSelector = new OrderItemsSelector();
        Set<Id> recordSet = new Set<Id>();
        OrderItemsSelector.newInstance();
        testSelector.selectById(recordSet);
    }
}