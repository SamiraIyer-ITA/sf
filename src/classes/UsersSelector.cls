public class UsersSelector extends fflib_SObjectSelector implements IUsersSelector {

	public static IUsersSelector newInstance(){
		return (IUsersSelector) fflibext_Application.Selector.newInstance(User.SObjectType);
	}

	public List<User> selectById(Set<Id> idSet) {
		fflib_QueryFactory usersQueryFactory = newQueryFactory();

		new ContactsSelector().
			configureQueryFactoryFields(usersQueryFactory, 'Contact');

		return (List<User>) Database.query(
			usersQueryFactory.setCondition('id in :idSet').toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			User.Id,
			User.Name,
			User.Username,
			User.Email,
			User.ContactId
		};
	}

	private Schema.SObjectType getSObjectType() {
		return User.SObjectType;
	}

}