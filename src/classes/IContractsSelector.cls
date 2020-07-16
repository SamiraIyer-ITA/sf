public interface IContractsSelector extends fflib_ISObjectSelector{

	List<Contract> selectById(Set<Id> idSet);

}