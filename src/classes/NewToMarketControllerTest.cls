@isTest
private class NewToMarketControllerTest {
        
    static testMethod void weightsAddToOne() {
        NewToMarketController n = new NewToMarketController();
        Decimal sum = 0;
        for(Decimal weight : n.weights.values()) {
            sum += weight;
        }
        
        System.assertEquals(1, sum);
    }
    
    static testMethod void onlyPullSearchRegions() {
        NTM_Region__c r1 = new NTM_Region__c(Name='w_eur');
        NTM_Region__c r2 = new NTM_Region__c(Name='Caribbean');
        insert r1; insert r2;
        
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='w_eur'][0].get('Id');
        NTM_Country__c c = new NTM_Country__c(name='Test', ISO_Alpha_2__c='TE', Region_Compare__c=r, Languages__c='English');
        insert c;
        
        Id country = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='Test'][0].get('Id');
        Id region = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');
        NTM_Search_Region__c s = new NTM_Search_Region__c(Country__c=country, Region__c=region);
        insert s;
        
        NewToMarketController n = new NewToMarketController();
        List<SelectOption> options = n.getRegions();
        
        System.assertEquals(1, options.size());
        System.assertEquals('Caribbean', options.get(0).getLabel());
    }
    
    static testMethod void checkLanguageMatch() {
        NewToMarketController n = new NewToMarketController();
        NTM_Region__c r1 = new NTM_Region__c(Name='w_eur');
        insert r1;
        
        Set<String> languages = new Set<String>();
        languages.add('French');
        
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='w_eur'][0].get('Id');
        NTM_Country__c c1 = new NTM_Country__c(name='c1', ISO_Alpha_2__c='T1', Region_Compare__c=r, Languages__c='English');
        NTM_Country__c c2 = new NTM_Country__c(name='c2', ISO_Alpha_2__c='T2', Region_Compare__c=r, Languages__c='French');
        NTM_Country__c c3 = new NTM_Country__c(name='c3', ISO_Alpha_2__c='T3', Region_Compare__c=r, Languages__c='Spanish;French');
        NTM_Country__c c4 = new NTM_Country__c(name='c4', ISO_Alpha_2__c='T4', Region_Compare__c=r, Languages__c='Spanish');
        insert c1; insert c2; insert c3; insert c4;
        
        Id cId1 = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='c1'][0].get('Id');
        Id cId2 = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='c2'][0].get('Id');
        Id cId3 = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='c3'][0].get('Id');
        Id cId4 = (Id)[SELECT Id FROM NTM_Country__c WHERE Name='c4'][0].get('Id');
        NewToMarketImportStatistics s1 = new NewToMarketImportStatistics(cId1);
        NewToMarketImportStatistics s2 = new NewToMarketImportStatistics(cId2);
        NewToMarketImportStatistics s3 = new NewToMarketImportStatistics(cId3);
        NewToMarketImportStatistics s4 = new NewToMarketImportStatistics(cId4);
        
        Boolean match1 = n.isLanguageMatch(s1, languages);
        Boolean match2 = n.isLanguageMatch(s2, languages);
        Boolean match3 = n.isLanguageMatch(s3, languages);
        Boolean match4 = n.isLanguageMatch(s4, languages);
        
        System.assertEquals(true, match1);
        System.assertEquals(true, match2);
        System.assertEquals(true, match3);
        System.assertEquals(false, match4);
    }
    
    static testMethod void emptyList() {
        NewToMarketController n = new NewToMarketController();
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Brazil'};
        n.generateTradeResults();
        
        System.assertEquals(0, n.results.size());
    }
 
    static testMethod void pageLoad() {
        //Needs description here
        
        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Brazil'};
        n.userCountriesNew = new String[]{'Jamaica'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();
    }

    static testMethod void TEST_validateProducts() {
        newToMarketController ntm = new newToMarketController();
        NTM_Product__c product1 = new NTM_Product__c(name='012345',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        NTM_Product__c product2 = new NTM_Product__c(name='123456',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert new List<NTM_Product__c>{product1,product2};
        ntm.productsString = '012345,123456';
        ntm.validateProducts();
    }

    static testMethod void TEST_generateTradeResults() {
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Languages__c='English');
        insert c1;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;
        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id);
        insert ntmci;

        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Brazil'};
        n.userCountriesNew = new String[]{'Jamaica'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();

        n.generateTradeResults();
    }
    
    static testMethod void TEST_generateTradeResults_InvalidProduct() {
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Languages__c='English');
        insert c1;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;
        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id);
        insert ntmci;

        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'99999'};
        n.userCountriesExisting = new String[]{'Brazil'};
        n.userCountriesNew = new String[]{'Jamaica'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();

        n.generateTradeResults();
        
        System.assertEquals('At least one product must be selected.',n.errorMessage);
    }    

    static testMethod void TEST_generateStatistics() {
        //Generate Statistics with Insufficient Products
        
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Languages__c='English');
        insert c1;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;

        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id);
        insert ntmci;

        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Brazil'};
        n.userCountriesNew = new String[]{'Jamaica'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();

        n.generateStatistics(m2,m3); 
    
    }
    
    static testMethod void TEST_generateStatisticsWithSufficientData() {
        //Generate Statistics with sufficient Products for a comparison, but not enough to generate statistics
        
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        NTM_Region__c r2 = new NTM_Region__c(Name='South America');
        insert r2;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');
        Id rb = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='South America'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='English', Contract_Cost__c = 50.2, Distance__c= 2549.896, GDP__c = 0.891914013, Import_Costs__c=996, Logistics_Score__c=2.400214, Rule_of_Law__c =-0.251835763);
        insert c1;
        NTM_Country__c c2 = new NTM_Country__c(name='Brazil', ISO_Alpha_2__c='BR', Region_Compare__c=rb, Region_Calculate__c=rb, Languages__c='Portuguese', Contract_Cost__c = 22, Distance__c= 7694.307, GDP__c = -1.004859078, Import_Costs__c=1076.5, Logistics_Score__c=3.087984, Rule_of_Law__c = -0.08087071);
        insert c2;
        NTM_Country__c c3 = new NTM_Country__c(name='Dominican Republic', ISO_Alpha_2__c='DR', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='Spanish', Contract_Cost__c = 40.9, Distance__c= 2508.955, GDP__c = 6.503848319, Import_Costs__c=619, Logistics_Score__c=2.62728, Rule_of_Law__c = -0.28849715);
        insert c3;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;

        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id,Tariff__c=1,US_1__c=83641,US_2__c=53956.17733,US_3__c=85847.73576,US_4__c=42402.42221,US_5__c=45367.104,World_1__c=83641,World_2__c=53956.17733,World_3__c=85847.73576,World_4__c=42420.42221,World_5__c=45369.104);
        insert ntmci;
        NTM_Country_Import__c ntmci2 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c2.Id,Tariff__c=2,US_1__c=73526.06545,US_2__c=31632.58638,US_3__c=28111.9663,US_4__c=3821314.624,US_5__c=2833830.188,World_1__c=3833952,World_2__c=2865681,World_3__c=4146336,World_4__c=5354433.177,World_5__c=3899353.202);
        insert ntmci2;
        NTM_Country_Import__c ntmci3 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c3.Id,Tariff__c=3,US_1__c=57100,US_2__c=90350,US_3__c=41200,US_4__c=180859.4826,US_5__c=88940.40201,World_1__c=63550,World_2__c=90350,World_3__c=50825,World_4__c=318422.6375,World_5__c=128981.081);
        insert ntmci3;
        
        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Dominican Republic'};
        n.userCountriesNew = new String[]{'Jamaica','Brazil'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        n.productsString = '000000';
        n.validateProducts();
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        
        System.assertEquals(2,m1.values().size());
        
        n.generateTradeResults();      
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        System.debug('m2 queryCountries '+n.userGeography+' number of results: '+m2.values().size());
        n.generateTradeResults();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();
        System.debug('m3 queryCountries '+n.userGeography+' number of results: '+m3.values().size());
        n.generateTradeResults();
    }

    static testMethod void TEST_UpdateWeights() {
        //Cover updateweights function
        
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        NTM_Region__c r2 = new NTM_Region__c(Name='South America');
        insert r2;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');
        Id rb = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='South America'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='English', Contract_Cost__c = 50.2, Distance__c= 2549.896, GDP__c = 0.891914013, Import_Costs__c=996, Logistics_Score__c=2.400214, Rule_of_Law__c =-0.251835763);
        insert c1;
        NTM_Country__c c2 = new NTM_Country__c(name='Brazil', ISO_Alpha_2__c='BR', Region_Compare__c=rb, Region_Calculate__c=rb, Languages__c='Portuguese', Contract_Cost__c = 22, Distance__c= 7694.307, GDP__c = -1.004859078, Import_Costs__c=1076.5, Logistics_Score__c=3.087984, Rule_of_Law__c = -0.08087071);
        insert c2;
        NTM_Country__c c3 = new NTM_Country__c(name='Dominican Republic', ISO_Alpha_2__c='DR', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='Spanish', Contract_Cost__c = 40.9, Distance__c= 2508.955, GDP__c = 6.503848319, Import_Costs__c=619, Logistics_Score__c=2.62728, Rule_of_Law__c = -0.28849715);
        insert c3;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;

        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id,Tariff__c=1,US_1__c=83641,US_2__c=53956.17733,US_3__c=85847.73576,US_4__c=42402.42221,US_5__c=45367.104,World_1__c=83641,World_2__c=53956.17733,World_3__c=85847.73576,World_4__c=42420.42221,World_5__c=45369.104);
        insert ntmci;
        NTM_Country_Import__c ntmci2 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c2.Id,Tariff__c=2,US_1__c=73526.06545,US_2__c=31632.58638,US_3__c=28111.9663,US_4__c=3821314.624,US_5__c=2833830.188,World_1__c=3833952,World_2__c=2865681,World_3__c=4146336,World_4__c=5354433.177,World_5__c=3899353.202);
        insert ntmci2;
        NTM_Country_Import__c ntmci3 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c3.Id,Tariff__c=3,US_1__c=57100,US_2__c=90350,US_3__c=41200,US_4__c=180859.4826,US_5__c=88940.40201,World_1__c=63550,World_2__c=90350,World_3__c=50825,World_4__c=318422.6375,World_5__c=128981.081);
        insert ntmci3;
        
        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Dominican Republic'};
        n.userCountriesNew = new String[]{'Jamaica','Brazil'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        n.productsString = '000000';
        n.validateProducts();
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        Map<Id, AggregateResult> m1 = n.queryCountries();
        
        System.assertEquals(2,m1.values().size());
        
        n.generateTradeResults();      
        n.userGeography = 'country';
        Map<Id, AggregateResult> m2 = n.queryCountries();
        System.debug('m2 queryCountries '+n.userGeography+' number of results: '+m2.values().size());
        n.generateTradeResults();
        n.userGeography = 'region';
        Map<Id, AggregateResult> m3 = n.queryCountries();
        System.debug('m3 queryCountries '+n.userGeography+' number of results: '+m3.values().size());
        n.generateTradeResults();

        //currently generates null set
        List<newToMarketImportStatistics> ntmis = n.generateStatistics(m2,m3);

        n.addIndices(ntmis);
        //n.recalculateTotalScore(ntmis);
        n.updateWeights();
    }
    
    static testMethod void TEST_GenerateCSV() {
        //Generate Statistics and then generate CSV
        
        NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        NTM_Region__c r2 = new NTM_Region__c(Name='South America');
        insert r2;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');
        Id rb = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='South America'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='English', Contract_Cost__c = 50.2, Distance__c= 2549.896, GDP__c = 0.891914013, Import_Costs__c=996, Logistics_Score__c=2.400214, Rule_of_Law__c =-0.251835763);
        insert c1;
        NTM_Country__c c2 = new NTM_Country__c(name='Brazil', ISO_Alpha_2__c='BR', Region_Compare__c=rb, Region_Calculate__c=rb, Languages__c='Portuguese', Contract_Cost__c = 22, Distance__c= 7694.307, GDP__c = -1.004859078, Import_Costs__c=1076.5, Logistics_Score__c=3.087984, Rule_of_Law__c = -0.08087071);
        insert c2;
        NTM_Country__c c3 = new NTM_Country__c(name='Dominican Republic', ISO_Alpha_2__c='DR', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='Spanish', Contract_Cost__c = 40.9, Distance__c= 2508.955, GDP__c = 6.503848319, Import_Costs__c=619, Logistics_Score__c=2.62728, Rule_of_Law__c = -0.28849715);
        insert c3;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;

        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id,Tariff__c=1,US_1__c=83641,US_2__c=53956.17733,US_3__c=85847.73576,US_4__c=42402.42221,US_5__c=45367.104,World_1__c=83641,World_2__c=53956.17733,World_3__c=85847.73576,World_4__c=42420.42221,World_5__c=45369.104);
        insert ntmci;
        NTM_Country_Import__c ntmci2 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c2.Id,Tariff__c=2,US_1__c=73526.06545,US_2__c=31632.58638,US_3__c=28111.9663,US_4__c=3821314.624,US_5__c=2833830.188,World_1__c=3833952,World_2__c=2865681,World_3__c=4146336,World_4__c=5354433.177,World_5__c=3899353.202);
        insert ntmci2;
        NTM_Country_Import__c ntmci3 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c3.Id,Tariff__c=3,US_1__c=57100,US_2__c=90350,US_3__c=41200,US_4__c=180859.4826,US_5__c=88940.40201,World_1__c=63550,World_2__c=90350,World_3__c=50825,World_4__c=318422.6375,World_5__c=128981.081);
        insert ntmci3;
        
        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Dominican Republic'};
        n.userCountriesNew = new String[]{'Jamaica','Brazil'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        n.productsString = '000000';
        n.validateProducts();
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        String csv = n.csvData;
        System.assertEquals(csv, '');
        
        n.userGeography = 'all';
        n.generateTradeResults();      
        csv = n.csvData;
    }
    
    static testMethod void TEST_Coverage_USEAC() {
        //provide coverage to uncoverable class USEAC, async not supported in test w/o mock http callout (to-do, replace this)        
        NewToMarketController n = new NewToMarketController();
        n.USEAC_Info = new List<NewToMarketController.USEAC>();
        NewToMarketController.USEAC myUSEAC = new NewToMarketController.USEAC();
        myUSEAC.Id = '0';
        myUSEAC.post = '0';
        myUSEAC.zip_code = '0';
        myUSEAC.zip_city = '0';
        myUSEAC.state = '0';
        myUSEAC.office_name = '0';
        myUSEAC.address = new String[] {'0','0'};
        myUSEAC.country = '0';
        myUSEAC.post_city = '0';
        myUSEAC.email = '0';
        myUSEAC.fax = '0';
        myUSEAC.mail_instructions = '0';
        myUSEAC.phone = '0';
        n.USEAC_Info.add(myUSEAC);
        System.assertEquals(1,n.USEAC_Info.size());
    }
    
    static testMethod void TEST_BlankZip() {
    	//test zip code rejection
    	NTM_Region__c r1 = new NTM_Region__c(Name='Caribbean');
        insert r1;
        NTM_Region__c r2 = new NTM_Region__c(Name='South America');
        insert r2;
        Id r = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='Caribbean'][0].get('Id');
        Id rb = (Id)[SELECT Id FROM NTM_Region__c WHERE Name='South America'][0].get('Id');

        NTM_Country__c c1 = new NTM_Country__c(name='Jamaica', ISO_Alpha_2__c='T1', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='English', Contract_Cost__c = 50.2, Distance__c= 2549.896, GDP__c = 0.891914013, Import_Costs__c=996, Logistics_Score__c=2.400214, Rule_of_Law__c =-0.251835763);
        insert c1;
        NTM_Country__c c2 = new NTM_Country__c(name='Brazil', ISO_Alpha_2__c='BR', Region_Compare__c=rb, Region_Calculate__c=rb, Languages__c='Portuguese', Contract_Cost__c = 22, Distance__c= 7694.307, GDP__c = -1.004859078, Import_Costs__c=1076.5, Logistics_Score__c=3.087984, Rule_of_Law__c = -0.08087071);
        insert c2;
        NTM_Country__c c3 = new NTM_Country__c(name='Dominican Republic', ISO_Alpha_2__c='DR', Region_Compare__c=r, Region_Calculate__c=r, Languages__c='Spanish', Contract_Cost__c = 40.9, Distance__c= 2508.955, GDP__c = 6.503848319, Import_Costs__c=619, Logistics_Score__c=2.62728, Rule_of_Law__c = -0.28849715);
        insert c3;
        NTM_Product__c product1 = new NTM_Product__c(name='000000',HS2_Description__c='desc2', HS4_Description__c='desc4', HS6_Description__c='desc6');
        insert product1;

        NTM_Country_Import__c ntmci = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c1.Id,Tariff__c=1,US_1__c=83641,US_2__c=53956.17733,US_3__c=85847.73576,US_4__c=42402.42221,US_5__c=45367.104,World_1__c=83641,World_2__c=53956.17733,World_3__c=85847.73576,World_4__c=42420.42221,World_5__c=45369.104);
        insert ntmci;
        NTM_Country_Import__c ntmci2 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c2.Id,Tariff__c=2,US_1__c=73526.06545,US_2__c=31632.58638,US_3__c=28111.9663,US_4__c=3821314.624,US_5__c=2833830.188,World_1__c=3833952,World_2__c=2865681,World_3__c=4146336,World_4__c=5354433.177,World_5__c=3899353.202);
        insert ntmci2;
        NTM_Country_Import__c ntmci3 = new NTM_Country_Import__c(Product__c=product1.Id,Country__c=c3.Id,Tariff__c=3,US_1__c=57100,US_2__c=90350,US_3__c=41200,US_4__c=180859.4826,US_5__c=88940.40201,World_1__c=63550,World_2__c=90350,World_3__c=50825,World_4__c=318422.6375,World_5__c=128981.081);
        insert ntmci3;
        
        PageReference pageRef = Page.NewToMarket;
        Test.setCurrentPage(pageRef);
        
        NewToMarketController n = new NewToMarketController();
        
        n.userProducts = new String[]{'000000'};
        n.userCountriesExisting = new String[]{'Dominican Republic'};
        n.userCountriesNew = new String[]{'Jamaica','Brazil'};
        n.userRegionsNew = new String[]{'Caribbean'};
        n.errorMessage = 'This is an error';
        n.weightsError = 'This is a weights error';
        n.productsString = '000000';
        n.zipCode = '';
        n.validateProducts();
        List<SelectOption> l1 = n.getCountries();
        List<SelectOption> l2 = n.getProducts();
        List<SelectOption> l3 = n.getRegions();
        
        n.generateTradeResults();
        System.assertEquals('Please enter a valid zip code',n.zipError);
    }
    
}