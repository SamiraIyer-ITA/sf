public interface IAccountSelector extends fflib_ISObjectSelector {

	List<Account> selectById(Set<Id> idSet);

}