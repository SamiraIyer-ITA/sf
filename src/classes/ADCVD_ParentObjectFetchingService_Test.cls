@IsTest
private class ADCVD_ParentObjectFetchingService_Test
{
    @IsTest
    static void fetchPetition()
    {
        ID id = fflib_IDGenerator.generate(Petition__c.SObjectType);
        new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id});
    }

    @IsTest
    static void fetchInvestigation()
    {
        ID id = fflib_IDGenerator.generate(Investigation__c.SObjectType);
        new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id});
    }

    @IsTest
    static void fetchAdcvdOrder()
    {
        ID id = fflib_IDGenerator.generate(ADCVD_Order__c.SObjectType);
        new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id});
    }

    @IsTest
    static void fetchSegment()
    {
        ID id = fflib_IDGenerator.generate(Segment__c.SObjectType);
        new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id});
    }

    @IsTest
    static void fetchRelatedOrganization()
    {
        ID id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType);
        new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id});
    }

    @IsTest
    static void fetchWithNonhomogenousIdSet()
    {
        ID id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType);
        ID anotherId = fflib_IDGenerator.generate(Petition__c.SObjectType);

        try
        {
            new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id> {id, anotherId});
            System.assert(false);
        }
        catch (Exception exc)
        {
            // as expected
        }
    }

    @IsTest
    static void fetchInvalidSObjectType()
    {
        ID id = fflib_IDGenerator.generate(Account.SObjectType);
        try
        {
            new ADCVD_ParentObjectFetchingServiceImpl().selectById(new Set<Id>{
                    id
            });
            System.assert(false);
        }
        catch (Exception exc)
        {
            // as expected
        }
    }
}