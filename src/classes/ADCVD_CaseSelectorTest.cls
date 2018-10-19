@IsTest
private class ADCVD_CaseSelectorTest
{
    //TODO:work on creating tests with asserts
    @IsTest
    static void testBehavior()
    {
        ADCVD_CaseSelector.newInstance().selectByIdWithRelations(new Set<Id>());
        ADCVD_CaseSelector.newInstance().selectById(new Set<Id>());
    }

}