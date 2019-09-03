/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: OrdersService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Order object or as
		a result of the Order object being updated. Which implementation is used is determined by custom
		metadata. See OrdersServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class OrdersService {

	private static IOrdersService service(){
		return (IOrdersService) fflibext_Application.Service.newInstance(IOrdersService.class);
	}

	public static void updatePayments(List<Order> ordersList) {
		service().updatePayments(ordersList);
	}

	public static void updateOrderContactAndOfficer(List<Order> ordersList) {
		service().updateOrderContactAndOfficer(ordersList);
	}

	public class OrdersServiceException extends Exception {}

}