/*********************************************************************************************
* Purpose:
* --------
* Encapsulate Opportunity-related business functions.
* To be called from the Opportunity.trigger
*
* TestClasses:
* ------------
* - OpportunityTriggerHandlerTest.cls
*
* History:
* --------
* VERSION  CHANGE DATE  AUTHOR              VERSION COMMENTS / Release Task
* 1.0      2018-11-15   Pavel Makarets      Initial Version
*********************************************************************************************/

public class OpportunityTriggerHandler {
    public static void handleTrigger(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities, System.TriggerOperation triggerEvent) {
        switch on triggerEvent {
            when BEFORE_DELETE {

                try {
                    delete [SELECT Id, (SELECT Id FROM Opportunities__r Opportunities WHERE Id IN :oldOpportunities) FROM Web_Order__c];
                } catch (DmlException e) {}

            }
            when BEFORE_INSERT {

                List<Web_Order__c> webOrders = new List<Web_Order__c>();
                for (Opportunity currentOpportunity : newOpportunities) {
                    webOrders.add(new Web_Order__c(
                            Name = currentOpportunity.Name,
                            Account__c = currentOpportunity.AccountId,
                            Status__c = currentOpportunity.StageName
                    ));
                }

                try {
                    insert webOrders;
                } catch (DmlException e) {}

                for (Opportunity currentOpportunity : newOpportunities) {
                    for (Web_Order__c currentWebOrder : webOrders) {
                        currentOpportunity.Web_Order__c = currentWebOrder.Id;
                    }
                }

            }
        }
    }
}