/*********************************************************************************************
* Purpose:
* --------
* Helps avoid the recursion in the triggers and update opportunity in future method.
* To be called from the Opportunity.trigger, WebOrder.trigger
*
* TestClasses:
* ------------
* - TriggerHelperTest.cls
*
* History:
* --------
* VERSION  CHANGE DATE  AUTHOR              VERSION COMMENTS / Release Task
* 1.0      2018-11-21   Pavel Makarets      Initial Version
* 1.1      2018-11-22   Pavel Makarets      Added future method updateOpportunity
*********************************************************************************************/

public class TriggerHelper {

    public static Boolean toRunTrigger {
        get {
            if (toRunTrigger == null) {
                toRunTrigger = false;

                return true;
            } else {

                return toRunTrigger;
            }
        }
        private set;
    }

    @future
    public static void updateOpportunity(Map<Id, Id> opportunityIdsToQuoteIds) {

        List<Opportunity> opportunities = [SELECT SyncedQuoteId FROM Opportunity];
        for (Opportunity currentOpportunity : opportunities) {
            currentOpportunity.SyncedQuoteId = opportunityIdsToQuoteIds.get(currentOpportunity.Id);
        }

        try {
            update opportunities;
        } catch (DmlException e) {
            System.debug(e.getLineNumber());
            for (Integer i = 0;i < e.getNumDml();i++) {
                System.debug(e.getDmlMessage(i));
            }
        }

    }

}