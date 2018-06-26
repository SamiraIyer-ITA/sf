public class ADCVD_ParentObjectFetchingServiceImpl
    implements ADCVD_IParentObjectFetchingService
{
    public List<SObject> selectById(Set<Id> idSet)
    {
        if (idSet == null || idSet.isEmpty()) return new List<SObject>();

        SObjectType sobjType = validateSetIsHomogenous(idSet);

        if (sobjType == Petition__c.SObjectType)
        {
            return ADCVD_PetitionSelector.newInstance().selectById(idSet);
        }
        else if(sobjType == Investigation__c.SObjectType)
        {
            return ADCVD_InvestigationSelector.newInstance().selectById(idSet);
        }
        else if(sobjType == ADCVD_Order__c.SObjectType)
        {
            return ADCVD_AdcvdOrderSelector.newInstance().selectById(idSet);
        }
        else if(sobjType == Segment__c.SObjectType)
        {
            return ADCVD_SegmentSelector.newInstance().selectById(idSet);
        }
        else if(sobjType == Related_Organization__c.SObjectType)
        {
            return ADCVD_RelatedOrganizationSelector.newInstance().selectById(idSet);
        }

        return new List<SObject>();
    }

    private Set<SObjectType> validSObjectTypes =
            new Set<SObjectType>
            {
                    Petition__c.SObjectType,
                    Investigation__c.SObjectType,
                    ADCVD_Order__c.SObjectType,
                    Segment__c.SObjectType,
                    Related_Organization__c.SObjectType
            };

    private SObjectType validateSetIsHomogenous(Set<Id> idSet)
    {
        List<Id> idList = new List<Id>(idSet);

        SObjectType t = idList.get(0).getSobjectType();

        if (!validSObjectTypes.contains(t))
        {
            throw new ADCVD_ParentObjectFetchingServiceException('The supplied Id set references SObjects that are not supported.');
        }

        for (Id i : idList)
        {
            if (t != i.getSobjectType())
            {
                throw new ADCVD_ParentObjectFetchingServiceException('The supplied Id set must reference only one SObject.');
            }
        }

        return t;
    }

    public class ADCVD_ParentObjectFetchingServiceException
        extends Exception
    {

    }
}