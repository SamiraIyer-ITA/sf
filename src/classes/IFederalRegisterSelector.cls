public interface IFederalRegisterSelector extends fflib_ISObjectSelector {
    List<Federal_Register__c> selectById(Set<Id> idSet);
    List<Federal_Register__c> selectAllToLimit();
}