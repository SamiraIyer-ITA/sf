public interface ADCVD_IRelatedOrganizationSelector
    extends fflibext_ISObjectSelector
{
    List<Related_Organization__c> selectAll();
    List<Related_Organization__c> selectById(Set<Id> idSet);
    List<Related_Organization__c> selectBySObjectId(Set<Id> idSet);
}