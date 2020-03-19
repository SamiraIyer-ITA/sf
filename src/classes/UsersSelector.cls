/*
	Author: Andrew La Russa
	Date: 08/21/19
	Name: UsersSelector.cls
	Purpose: The implementation of IUsersSelector. The only place User queries should live.
 */
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

	public List<User> selectById(Set<Id> idSet, Schema.FieldSet fieldSet) {
		return
			(List<User>)
				Database.query(
					newQueryFactory()
						.selectFieldSet(fieldSet)
						.setCondition('Id IN :idSet')
						.toSOQL()
				);
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