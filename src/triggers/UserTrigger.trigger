trigger UserTrigger on User (before insert, before update) {
	UserTriggerHelper.UpdateEmailAndFederationId(Trigger.New);
    if(Trigger.isBefore && Trigger.IsUpdate) {
        UserTriggerHelper.SetActiveFlag(Trigger.New, Trigger.OldMap);
        UserTriggerHelper.SendInstructions(Trigger.New, Trigger.OldMap);
        UserTriggerHelper.PreventReadOnlyUpdate(Trigger.New, Trigger.OldMap); 
        UserTriggerHelper.preventADProcessTZUpdate(Trigger.New, Trigger.OldMap);
    }
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        CreateTaxonomyOnUserHelper.createTaxonomy(Trigger.New);
    }
}