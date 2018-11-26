
@IsTest
private class Product2TriggerHandlerTest {

    @IsTest
    static void testCreateOneProduct2() {
        insert new Product2(
                Name = 'testProduct1',
                ProductCode = '00125'
        );

        Product2 newProduct2 = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name = 'testProduct1'];
        Web_Product__c newWebProduct = [SELECT Id, Name__c, Code__c FROM Web_Product__c WHERE Product__c = :newProduct2.Id];
        System.assertEquals(newProduct2.Name, newWebProduct.Name__c);
        System.assertEquals(newProduct2.ProductCode, newWebProduct.Code__c);
    }

    @IsTest
    static void testDeleteOneProduct2() {
        insert new Product2(
                Name = 'testProduct2',
                ProductCode = '00126'
        );
        Product2 newProduct2 = [SELECT Id, Name, ProductCode FROM Product2 WHERE Name = 'testProduct2'];
        delete newProduct2;

        Integer countNewWebProducts = [SELECT COUNT() FROM Web_Product__c WHERE Product__c = :newProduct2.Id];
        System.assertEquals(0, countNewWebProducts);
    }

    @IsTest
    static void testCreateManyProduct2() {
        List<Product2> newProduct2s = new List<Product2>();
        for (Integer i = 0;i < 100;i++) {
            Product2 currentProduct2 = new Product2(
                    Name = 'testProduct' + i,
                    ProductCode = '00' + i
            );
            newProduct2s.add(currentProduct2);
        }
        insert newProduct2s;

        Integer countNewProduct2s = [SELECT COUNT() FROM Product2 WHERE Name LIKE 'testProduct%'];
        Integer countNewWebProduct = [SELECT COUNT() FROM Web_Product__c];
        System.assertEquals(countNewProduct2s, countNewWebProduct);
    }

    @IsTest
    static void testDeleteManyProduct2() {
        List<Product2> newProduct2s = new List<Product2>();
        for (Integer i = 0;i < 100;i++) {
            Product2 currentProduct2 = new Product2(
                    Name = 'testProduct' + i,
                    ProductCode = '00' + i
            );
            newProduct2s.add(currentProduct2);
        }
        insert newProduct2s;

        delete [SELECT Id FROM Product2 WHERE Name LIKE 'testProduct%'];

        Integer countNewProduct2s = [SELECT COUNT() FROM Product2 WHERE Name LIKE 'testProduct%'];
        Integer countNewWebProduct = [SELECT COUNT() FROM Web_Product__c];
        System.assertEquals(countNewProduct2s, countNewWebProduct);
    }

}