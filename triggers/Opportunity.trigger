
trigger Opportunity on Opportunity (before delete, before insert) {
    if(TriggerHelper.toRunTrigger) {
        OpportunityTriggerHandler.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType);
    }
}