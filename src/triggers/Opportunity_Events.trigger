trigger Opportunity_Events on Opportunity (before insert, before update) {
    Opportunity_Events_Controller controller = new Opportunity_Events_Controller(trigger.new);
    if(trigger.isBefore){
        controller.checkOpenShoppingCarts();
    }else{
        controller.updateAssets();
    }
}