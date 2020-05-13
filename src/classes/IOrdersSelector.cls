/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IOrdersSelector.cls
	Purpose:
		The interface that defines the methods to be implemented by whatever selector we define. These stubs clarify
		generic needs across our application. More than one class can use this selector to grab Orders by their ID.
		Only a single query need be defined in the implementation and only need be changed if fields are added,
		subtracted, or changed.
 */
public interface IOrdersSelector extends fflib_ISObjectSelector{

	List<Order> selectById(Set<Id> idSet);
	List<Order> selectByPaidNonPaidOnly(Set<Id> idSet, Boolean nonPaidOnly, Boolean paidOnly);
	List<Order> selectByContractId(Set<Id> idSet, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly);
}