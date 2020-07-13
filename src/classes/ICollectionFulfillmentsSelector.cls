/*
	Author: Jeff Weyhrauch
	Date: 7-2-2020
	Name: ICollectionFulfillmentsSelector.cls
	Purpose:
		The interface that defines the methods to be implemented by whatever selector we define. These stubs clarify
		generic needs across our application. More than one class can use this selector to grab CollectionFulfillments by their ID.
		Only a single query need be defined in the implementation and only need be changed if fields are added,
		subtracted, or changed.
 */
public interface ICollectionFulfillmentsSelector extends fflib_ISObjectSelector{

	List<Collection_Fulfillment__c> selectById(Set<Id> idSet);

}