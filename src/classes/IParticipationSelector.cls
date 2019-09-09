public interface IParticipationSelector extends fflib_ISObjectSelector{

	List<Participation__c> selectById(Set<Id> idSet);

}