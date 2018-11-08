@isTest
private class NewToMarketImportStatisticsTest {

    static testMethod void checkSort() {
        NTM_Region__c region = new NTM_Region__c(name='Foo');
        insert region;
        
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Foo'][0].get('Id');
        NTM_Country__c country = new NTM_Country__c(name='Test', ISO_Alpha_2__c='TE', Region_Compare__c=r, Languages__c='English');
        insert country;

        Id c = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='Test'][0].get('Id');
        List<NewToMarketImportStatistics> testList = new List<NewToMarketImportStatistics>();
        NewToMarketImportStatistics s1 = new NewToMarketImportStatistics(c);
        NewToMarketImportStatistics s2 = new NewToMarketImportStatistics(c);
        
        s1.total_score = 80;
        s2.total_score = 90;
        
        testList.add(s1);
        testList.add(s2);
        testList.sort();
        
        System.assertEquals(90, testList.get(0).total_score);
        System.assertEquals(80, testList.get(1).total_score);
    }
    
    static testMethod void getAndSetVariables() {
        NTM_Region__c region = new NTM_Region__c(name='Foo');
        insert region;
        
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Foo'][0].get('Id');
        NTM_Country__c country = new NTM_Country__c(name='Test', ISO_Alpha_2__c='TE', Region_Compare__c=r, Languages__c='English');
        insert country;

        Id c = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='Test'][0].get('Id');
        NewToMarketImportStatistics s1 = new NewToMarketImportStatistics(c);
        
        s1.country_us_avg = 0;
        s1.country_world_avg = 0;
        s1.country_us_share = 0;
        s1.region_us_avg = 0;
        s1.region_world_avg = 0;
        s1.region_us_share = 0;
        s1.share_gap = 0;
        s1.share_gap_value = 0;
        s1.world_cagr = 0;
        s1.world_cagr_alt = 0;
        s1.trade_projection = 0;
        s1.max_tariff = 0;
        s1.adjusted_tariff = 0;
        
        NewToMarketController n = new NewToMarketController();
        n.addIndices(new NewToMarketImportStatistics[]{s1});
    }
}