public class ADCVD_ParentObjectFetchingService
{
    private static ADCVD_IParentObjectFetchingService service()
    {
        return (ADCVD_IParentObjectFetchingService) fflibext_Application.Service.newInstance(ADCVD_IParentObjectFetchingService.class);
    }

    public static List<SObject> selectById(Set<Id> idSet)
    {
        return service().selectById(idSet);
    }
}