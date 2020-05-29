/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IOrders.cls
	Purpose: Order interface that will be used as an FFLIB domain object.
 */
public interface IOrders extends fflib_ISObjectDomain {

    void updatePayments(List<Order> existingOrders);
    void updateSystemSearchString(List<Order> ordersToUpdate);

}