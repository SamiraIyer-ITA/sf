@isTest
private class ADCVD_SelectorsTest
{
    @isTest
    static void test()
    {
        ADCVD_AdcvdOrderSelector.newInstance().selectById(new Set<Id>());
        ADCVD_ConstantSelector.newInstance().selectDefault();
        ADCVD_FederalRegisterSelector.newInstance().selectAll();
        ADCVD_InvestigationSelector.newInstance().selectById(new Set<Id>());
        ADCVD_PetitionSelector.newInstance().selectById(new Set<Id>());
        ADCVD_RelatedOrganizationSelector.newInstance().selectAll();
        ADCVD_SegmentSelector.newInstance().selectById(new Set<Id>());
        ADCVD_StaffingAssignmentSelector.newInstance().selectAll();
    }
}