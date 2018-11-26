
public class WebOrderTriggerHandler {
    public static void handleTrigger(List<Web_Order__c> newWebOrders, List<Web_Order__c> oldWebOrders, System.TriggerOperation triggerEvent) {
        switch on triggerEvent {
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {

                List<Opportunity> opportunities = new List<Opportunity>();
                for (Web_Order__c currentWebOrder : newWebOrders) {
                    opportunities.add(new Opportunity(
                            Name = currentWebOrder.Name,
                            AccountId = currentWebOrder.Account__c,
                            StageName = currentWebOrder.Status__c,
                            CloseDate = Date.today().addDays(30),
                            Web_Order__c = currentWebOrder.Id
                    ));
                }

                try {
                    insert opportunities;
                } catch (DmlException e) {}

                Map<Id, Web_Order__c> webOrders = new Map<Id, Web_Order__c>(newWebOrders);
                List<Quote> quotes = new List<Quote>();
                for (Opportunity currentOpportunity : opportunities) {
                    quotes.add(new Quote(
                            Name = currentOpportunity.Name + 'Quote',
                            OpportunityId = currentOpportunity.Id,
                            Country__c = webOrders.get(currentOpportunity.Web_Order__c).Country__c,
                            City__c = webOrders.get(currentOpportunity.Web_Order__c).City__c,
                            Street__c = webOrders.get(currentOpportunity.Web_Order__c).Street__c
                    ));
                }

                try {
                    insert quotes;
                } catch (DmlException e) {}

                Map<Id, Id> OpportunityIdsToQuoteIds = new Map<Id, Id>();
                for (Quote currentQuote : quotes) {
                    OpportunityIdsToQuoteIds.put(currentQuote.OpportunityId, currentQuote.Id);
                }

                TriggerHelper.updateOpportunity(OpportunityIdsToQuoteIds);
            }
            when AFTER_UPDATE {

                List<Quote> quotes = [
                        SELECT
                                Opportunity.Web_Order__r.Country__c,
                                Opportunity.Web_Order__r.City__c,
                                Opportunity.Web_Order__r.Street__c
                        FROM Quote
                        WHERE Opportunity.Web_Order__c IN :newWebOrders
                ];

                for (Quote currentQuote : quotes) {
                    currentQuote.Country__c = currentQuote.Opportunity.Web_Order__r.Country__c;
                    currentQuote.City__c = currentQuote.Opportunity.Web_Order__r.City__c;
                    currentQuote.Street__c = currentQuote.Opportunity.Web_Order__r.Street__c;
                }

                try {
                    update quotes;
                } catch (DmlException e) {}
            }
        }
    }
}