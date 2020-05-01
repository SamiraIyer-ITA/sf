trigger Order_Events on Order (after insert, after update) {
    Order_Events_Controller controller = new Order_Events_Controller(trigger.new, trigger.oldMap, trigger.newMap);
    controller.updateAssets();
    controller.updateThirdParties();
}
