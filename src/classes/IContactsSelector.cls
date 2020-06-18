/*
	Author: Andrew La Russa
	Date: 08/12/19
	Name: IContactsSelector.cls
	Purpose:
		The interface that defines the methods to be implemented by whatever selector we define. These stubs clarify
		generic needs across our application. More than one class can use this selector to grab Contacts by their ID.
		Only a single query need be defined in the implementation and only need be changed if fields are added,
		subtracted, or changed.
 */
public interface IContactsSelector {

	List<Contact> selectById(Set<Id> idSet);

}