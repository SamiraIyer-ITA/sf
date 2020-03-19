public interface IUsersSelector {

	List<User> selectById(Set<Id> idSet);
	List<User> selectById(Set<Id> idSet, Schema.FieldSet fieldSet);
}