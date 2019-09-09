/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IOrdersService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Order object or as a result of the Order object being updated.
 */
public interface IOrdersService {

	void updatePayments(List<Order> ordersList);
	void updateOrderContactAndOfficer(List<Order> ordersList);

}