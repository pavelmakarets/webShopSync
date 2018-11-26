/*********************************************************************************************
* Purpose:
* --------
* Encapsulate Product2-related business functions.
* To be called from the Product2.trigger
*
* Testclasses:
* ------------
* - Product2TriggerHandlerTest.cls
*
* History:
* --------
* VERSION  CHANGE DATE  AUTHOR              VERSION COMMENTS / Release Task
* 1.0      2018-11-20   Pavel Makarets      Initial Version
*********************************************************************************************/

public class Product2TriggerHandler {

    public static void handleTrigger(List<Product2> newProduct2s, List<Product2> oldProduct2s, System.TriggerOperation triggerEvent) {
        switch on triggerEvent {
            when BEFORE_DELETE {
                try {
                    delete [SELECT Id FROM Web_Product__c WHERE Product__c IN :oldProduct2s];
                } catch (Exception e) {}
            }
            when AFTER_INSERT {
                List<Web_Product__c> webProducts = new List<Web_Product__c>();
                for (Product2 currentProduct2 : newProduct2s) {
                    Web_Product__c newWebProduct = new Web_Product__c(
                            Name = currentProduct2.Name,
                            Product__c = currentProduct2.Id
                    );
                    webProducts.add(newWebProduct);
                }
                try {
                    insert webProducts;
                } catch (Exception e) {}
            }
        }
    }

}