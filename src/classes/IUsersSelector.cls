public interface IUsersSelector {

	List<User> selectById(Set<Id> idSet);
	List<User> selectByName(Set<String> names);
}