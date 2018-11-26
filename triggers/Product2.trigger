
trigger Product2 on Product2 (before delete, after insert) {
    Product2TriggerHandler.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType);
}