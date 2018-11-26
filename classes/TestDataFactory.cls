/*********************************************************************************************
* Purpose:
* --------
* Created Opportunities, Quote for tests.
* To be called from the TriggerHelpTest.cls
*
* History:
* --------
* VERSION  CHANGE DATE  AUTHOR              VERSION COMMENTS / Release Task
* 1.0      2018-11-23   Pavel Makarets      Initial Version
*********************************************************************************************/

public class TestDataFactory {

    public static List<Opportunity> createOpportunities(Integer numberOfOpportunities) {

        List<String> opportunityStageValues = new List<String>();
        for (Schema.PicklistEntry currentPickListValue : Opportunity.StageName.getDescribe().getPicklistValues()) {
            opportunityStageValues.add(currentPickListValue.getLabel());
        }

        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0;i < numberOfOpportunities;i++) {
            opportunities.add(new Opportunity(
                    Name = 'Opportunity' + (i + 1),
                    StageName = opportunityStageValues[Math.round(Math.random() * (opportunityStageValues.size() - 1))],
                    CloseDate = Date.today().addDays(30)
            ));
        }

        return opportunities;
    }

    public static List<Quote> createQuotes(List<Opportunity> opportunities) {

        List<Quote> quotes = new List<Quote>();
        for (Opportunity currentOpportunity : opportunities) {
            quotes.add(new Quote(
                    Name = currentOpportunity.Name + 'Quote',
                    OpportunityId = currentOpportunity.Id
            ));
        }

        return quotes;
    }

}