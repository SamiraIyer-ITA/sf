/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: ICasesSelector.cls
	Purpose:
		The interface that defines the methods to be implemented by whatever selector we define. These stubs clarify
		generic needs across our application. More than one class can use this selector to grab Cases by their ID.
		Only a single query need be defined in the implementation and only need be changed if fields are added,
		subtracted, or changed.
 */
public interface ICasesSelector extends fflib_ISObjectSelector{

	List<Case> selectById(Set<Id> idSet);

}