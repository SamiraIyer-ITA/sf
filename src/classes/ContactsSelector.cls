/*
	Author: Andrew La Russa
	Date: 08/12/19
	Name: ContactsSelector.cls
	Purpose: The implementation of IContactsSelector. The only place Contact queries should live.
 */
public class ContactsSelector extends fflib_SObjectSelector implements IContactsSelector {

	public static IContactsSelector newInstance() {
		return (IContactsSelector) fflibext_Application.Selector.newInstance(Contact.SObjectType);
	}

	public List<Contact> selectById(Set<Id> idSet) {
		return (List<Contact>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Contact.Id,
			Contact.AccountId,
			Contact.MailingStreet,
			Contact.MailingCity,
			Contact.MailingPostalCode,
			Contact.MailingCountryCode,
			Contact.MailingStateCode
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Contact.SObjectType;
	}
}