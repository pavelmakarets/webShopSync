
trigger WebOrder on Web_Order__c (before delete, after insert, after update) {
    if(TriggerHelper.toRunTrigger) {
        WebOrderTriggerHandler.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType);
    }
}