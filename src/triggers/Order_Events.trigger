trigger Order_Events on Order (after insert, after update) {

    /*
     * SM-133: Order: Update Triggers by Record Type
     *
     * Legacy functionality.
     */
    Id legacyRecordTypeId = Schema.SObjectType.Order
        .getRecordTypeInfosByDeveloperName().get('Legacy').getRecordTypeId();
    // Privacy Shield 1.0 record type records orders and maps
    List<Order> legacyOrders = new List<Order>();
    Map<Id, Order> legacyOrdersOldMap = new Map<Id, Order>();
    Map<Id, Order> legacyOrdersNewMap = new Map<Id, Order>();
    // Add Trigger.new Legacy record type records
    for (Order order: Trigger.new) {
        if (order.RecordTypeId == legacyRecordTypeId) {
            legacyOrders.add(order);
        }
    }
    // Add Trigger.oldMap Legacy record type records
    if (Trigger.isUpdate) {
        // Add Trigger.oldMap Legacy record type records
        for (Id orderId : Trigger.oldMap.keySet()) {
            Order order = Trigger.oldMap.get(orderId);
            if (order.RecordTypeId == legacyRecordTypeId) {
                legacyOrdersOldMap.put(orderId, order);
            }
        }
    }
    // Add Trigger.newMap Legacy record type records
    for (Id orderId: Trigger.newMap.keySet()) {
        Order order = Trigger.newMap.get(orderId);
        if (order.RecordTypeId == legacyRecordTypeId) {
            legacyOrdersNewMap.put(orderId, order);
        }
    }
    // Call trigger handler class and methods
    if (legacyOrders.size() > 0) {
        Order_Events_Controller controller =
            new Order_Events_Controller(legacyOrders, legacyOrdersOldMap, legacyOrdersNewMap);
        controller.updateAssets();
        controller.updateThirdParties();
    }
}