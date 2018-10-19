public interface ICustomInstructionSelector
    extends fflib_ISObjectSelector
{
    List<Custom_Instruction__c> selectById(Set<Id> idSet);
    List<Custom_Instruction__c> selectAllToLimit();
}