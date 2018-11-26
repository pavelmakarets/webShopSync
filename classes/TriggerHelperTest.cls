/*********************************************************************************************
* Purpose:
* --------
* Testing TriggerHelper.cls
*
* History:
* --------
* VERSION  CHANGE DATE  AUTHOR              VERSION COMMENTS / Release Task
* 1.0      2018-11-23   Pavel Makarets      Initial Version
*********************************************************************************************/

@IsTest
private class TriggerHelperTest {

    @isTest
    static void testAvoidingRecursion() {

        System.assertEquals(true, TriggerHelper.toRunTrigger);
        System.assertEquals(false, TriggerHelper.toRunTrigger);
    }

    @IsTest
    static void testUpdateOpportunity() {

        Map<Id, Id> opportunityIdsToQuoteIds = new Map<Id, Id>();

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(10);
        try {
            insert opportunities;
        } catch (DmlException e) {
            System.debug(e.getLineNumber());
            for (Integer i = 0;i < e.getNumDml();i++) {
                System.debug(e.getDmlMessage(i));
            }
        }

        List<Quote> quotes = TestDataFactory.createQuotes(opportunities);
        try {
            insert quotes;
        } catch (DmlException e) {
            System.debug(e.getLineNumber());
            for (Integer i = 0;i < e.getNumDml();i++) {
                System.debug(e.getDmlMessage(i));
            }
        }

        for (Quote currentQuote : quotes) {
            opportunityIdsToQuoteIds.put(currentQuote.OpportunityId, currentQuote.Id);
        }

        Test.startTest();
            TriggerHelper.updateOpportunity(opportunityIdsToQuoteIds);
        Test.stopTest();

        List<Opportunity> updatedOpportunities = [SELECT SyncedQuoteId FROM Opportunity WHERE Id IN :opportunityIdsToQuoteIds.keySet()];
        Boolean flag = true;
        for (Opportunity currentOpportunity : updatedOpportunities) {
            if (currentOpportunity.SyncedQuoteId != opportunityIdsToQuoteIds.get(currentOpportunity.Id)) {
                flag = false;
            }
        }
        System.assert(flag);
    }

}