public class NewToMarketController {
    public String productsString { get; set; }
    public String resultLimit {get; set; }

    //USEAC
    public String zipCode { get; set; }
    public String zipError {get; set; }

    public List<USEAC> USEAC_Info {get;set;}
    public class USEAC {
        public String id {get; set; }
        public String post {get; set; }
        public String zip_code {get; set; }
        public String zip_city {get; set; }
        public String state {get; set; }
        public String office_name {get; set; }
        public List<String> address {get;set;}
        public String country {get; set; }
        public String post_city {get; set; }
        public String email {get; set; }
        public String fax {get; set; }
        public String mail_instructions {get; set; }
        public String phone {get; set; }        
    }

    public String[] userCountriesExisting { get; set; }
    public String[] userCountriesNew { get; set; }
    public String[] userRegionsNew { get; set; }
    public String userGeography { get; set; }
    public List<NTM_Product__c> selectedProducts { get; set; }
    public List<NewToMarketImportStatistics> results { get; set; }
    public String errorMessage { get; set; }
    public String weightsError { get; set; }
    public String currentWeights { get; set; }
    public String productsError { get; set; }
    @TestVisible public String[] userProducts { get {
        if(String.isEmpty(productsString)) {
            return null;
        } else {
            return productsString.split('[,\\s;|]+');
        }
    }}
    public String csvData { get {
        if(csv == null) {
            csv = generateCSV();
        }
        return EncodingUtil.base64Encode(Blob.valueof(csv));
    }}
    private String csv;
    private Boolean validProducts = false;


    // Weights
    public Decimal weightTrade { get; set; }
    public Decimal weightHistoric { get; set; }
    public Decimal weightTariff { get; set; }
    public Decimal weightImportCosts { get; set; }
    public Decimal weightDistance { get; set; }
    public Decimal weightRuleOfLaw { get; set; }
    public Decimal weightLogistics { get; set; }
    public Decimal weightLanguage { get; set; }
    public Decimal weightFTA { get; set; }
    public Decimal weightLandlocked { get; set; }
    public Decimal weightContracts { get; set; }
    @TestVisible private Map<String, Decimal> weights { get; set; }

    public void rejectZip() {
        zipError = 'Please enter a valid zip code.';
        USEAC_Info = null;
    }
    
    public void rejectZipUnable() {
        zipError = 'No response from USEAC zip code service.';
        USEAC_Info = null;
    }
    
    public void rejectZipNotFound() {
        zipError = 'Unable to display U.S Commercial Service Office for this zip code. Please use a different zip code or leave the zip code field blank and try again.';
        USEAC_Info = null;
    }
    
    public void validateZip() {
        String zip = zipCode + '';
        if(zip == '') {
            rejectZip();
            return;
        }
        zipError = 'Loading...';
        HttpRequest req = new HttpRequest();
        try {
            req.setEndpoint('https://api.trade.gov/ita_zipcode_to_post/search?api_key=ng3TqSiGapB0sNe14ro5_Qo6&zip_codes='+zipCode.deleteWhitespace());
            req.setMethod('GET');      
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to get USEAC Zip info: \n'+e.getMessage()));
            System.debug('Unable to get USEAC Zip info: \n'+e.getMessage()+'\n'+e.getStackTraceString());
            rejectZipUnable();
            return;
        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Map<String, Object> item = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        if(JSON.serialize(item.get('results')) == '[]') {
            rejectZip();
            return;
        }
        
        try {
            USEAC_Info = (List<USEAC>)JSON.deserialize(JSON.serialize(item.get('results')), List<USEAC>.class);
        } catch(Exception e) {
            rejectZipNotFound();
            return;
        }
        zipError = null; 
    }

    public NewToMarketController() {
        results = new List<NewToMarketImportStatistics>();

        //New Weights Updated 06/2018
        weightTrade = 0.1;
        weightHistoric = 0.5;
        weightTariff = 0.025;
        weightImportCosts = 0.075;
        weightDistance = 0.05;
        weightRuleOfLaw = 0.05;
        weightLogistics = 0.025;
        weightLanguage = 0.025;
        weightFTA = 0.05;
        weightLandlocked = 0.075;
        weightContracts = 0.025;

        weights = new Map<String, Decimal>{
            'Trade Growth' => weightTrade,
            'Historic Trade' => weightHistoric,
            'Tariff' => weightTariff,
            'Import Costs' => weightImportCosts,
            'Distance' => weightDistance,
            'Rule of Law' => weightRuleOfLaw,
            'Logistics Performance' => weightLogistics,
            'Language' => weightLanguage,
            'FTA' => weightFTA,
            'Landlocked' => weightLandlocked,
            'Enforcing Contracts' => weightContracts
        };

        calculateWeights();
    }
    
    // Validate that all of the product codes supplied
    // by the user are found in the database.
    public void validateProducts() {
        productsError = null;
        if(String.isEmpty(productsString)) {
            return;
        }
        
        selectedProducts = [SELECT ID, Name, HS4_HS6_Description__c FROM NTM_Product__c WHERE Name IN :userProducts];
        if(selectedProducts.size() != userProducts.size()) {
            productsError = '';
            Set<String> productsSet = new Set<String>();
            for(NTM_Product__c p : selectedProducts) {
                productsSet.add(p.Name);
            }
            for(String prod : userProducts) {
                if(!productsSet.contains(prod)) {
                    if (prod.length() == 6) {
                        productsError += 'No products found for HS ' + prod + '.<br/>';
                    } else {
                        productsError += 'Invalid HS code format for ' + prod + '.<br/>';
                    }
                }
            }
            validProducts = false;
        } else {
            validProducts = true;
        }
    }

    // Return a list of Products for the user to select
    public List<SelectOption> getProducts() {
        List<SelectOption> options = new List<SelectOption>();
        for(NTM_Product__c p : [SELECT Id, Name, Full_Description__c
                                FROM NTM_Product__c
                                ORDER BY Name ASC]){
            options.add(new SelectOption(p.Name, p.Full_Description__c));
        }
        return options;
    }
    
    // Return a list of Countries for the user to select
    public List<SelectOption> getCountries() {
        List<SelectOption> options = new List<SelectOption>();
        for(NTM_Country__c c : [SELECT Id, Name, ISO_Alpha_2__c
                                FROM NTM_Country__c
                                WHERE Contract_Cost__c != null AND Distance__c != null
                                AND GDP__c != null AND Import_Costs__c != null
                                AND Logistics_Score__c != null AND Rule_of_Law__c != null
                                ORDER BY Name ASC]){
            options.add(new SelectOption(c.Name, c.Name));
        }
        return options;
    }
    
    // Return a list of Regions for the user to select
    public List<SelectOption> getRegions() {
        List<SelectOption> options = new List<SelectOption>();
        for(NTM_Region__c r : [SELECT Id, Name
                                FROM NTM_Region__c
                                WHERE Id IN
                                    (SELECT Region__c
                                     FROM NTM_Search_Region__c)
                                ORDER BY Name ASC]){
            options.add(new SelectOption(r.Name, r.Name));
        }
        return options;
    }
    
    // Given the products selected and countries excluded by
    // the user, generate trade statistics. The results should
    // be sorted and placed in the :results variable for the
    // Visualforce to access.
    public PageReference generateTradeResults() {
        DateTime initialTime = DateTime.Now();

        results.clear();
        csv = null;
        errorMessage = null;
        weightsError = null;
        validateProducts();
        validateZip();
        String userGeographyToLog = '';
        
        if(userGeography == null || userGeography == '' || userGeography == 'all') {  
            userGeographyToLog = 'All';
        } else if(userGeography == 'country') {
            userGeographyToLog = 'Country: ' + String.join(userCountriesNew,', ');
        } else if(userGeography == 'region') {
            userGeographyToLog = 'Region: ' + String.join(userRegionsNew,', ');
        }

        if(userProducts == null || userProducts.size() == 0) {
            errorMessage = 'At least one product must be selected.';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);
            return null;
        }
        if(!validProducts) {
            errorMessage = 'There was a problem validating at least one of the Product Numbers provided.';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);
            return null;
        }
        if(userCountriesExisting == null || userCountriesExisting.size() == 0) {
            errorMessage = 'At least one country must be selected where you are already exporting to.';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);            
            return null;
        }
        if(userProducts.size() >= 25) {
            errorMessage = 'Please select fewer than 25 products to evalutate.';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);            
            return null;
        }
        
        
        Map<Id, AggregateResult> country_aggregate = queryCountries();
        Map<Id, AggregateResult> region_aggregate = new Map<Id, AggregateResult>([
            SELECT Country__r.Region_Calculate__c Id, SUM(Avg_US__c) Region_US_Avg, SUM(Avg_World__c) Region_World_Avg
            FROM NTM_Country_Import__c
            WHERE Product__r.Name IN :userProducts
            AND Data_Years__c >= 3
            AND Country__r.Region_Calculate__c != null
            GROUP BY Country__r.Region_Calculate__c
        ]);
        
        // Test for data sufficiency
        List<sObject> tariffTest = [SELECT Id FROM NTM_Country_Import__c WHERE Product__r.Name IN :userProducts AND Country__r.Name IN :userCountriesExisting LIMIT 1];
        if(tariffTest.isEmpty() || country_aggregate.isEmpty()) {
            errorMessage = 'There is not enough trade data for the selected products and countries/regions to complete the calculation';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);
            return null;
        }
        
        List<NewToMarketImportStatistics> stats = generateStatistics(country_aggregate, region_aggregate);
        if(stats.isEmpty()) {
            // This state will happen if the only countries that contain
            // import data and match our geography filter are unable to
            // match with a region and are skipped during calculations.
            // For example this will be null if a country has a
            // region_compare, but no other countries have that region
            // listed as region_calculate.
            errorMessage = 'There is not enough trade data for the selected products and countries/regions to complete the calculation';
            NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ','),DateTime.Now().getTime()-initialTime.getTime(),0,productsString,initialTime,zipCode);
            return null;
        }

        stats = addIndices(stats);
        stats.sort();

        if (resultLimit != 'all') {
            Integer iResultLimit = Integer.valueOf(resultLimit);
            if (iResultLimit > stats.size()) {
                //Desired limit is greater than result size so get all results
                results = stats;
            } else {
                //Get only a limited number of results
                Integer count = 0;
                do {
                    results.add(stats[count]);
                    count++;
                } while (count < iResultLimit);
            }
        } else {
            //Get all results
            results = stats;
        }

        NewToMarketSearchLog.createSearchLog(userGeographyToLog,String.join(userCountriesExisting, ', '),DateTime.Now().getTime()-initialTime.getTime(),results.size(),productsString,initialTime,zipCode);
        return null;
    }
    
    // Given the list of products selected by the user, calculate the
    // average imports for countries where those products are imported
    @TestVisible private Map<Id, AggregateResult> queryCountries() {
        if(userGeography == 'country') {
            try {
                return new Map<Id, AggregateResult>([
                    SELECT Country__c Id, MIN(Year_First__c) Year_First, MIN(Year_Last__c) Year_Last, MAX(Tariff__c) Max_Tariff, SUM(Avg_US__c) US_Avg, SUM(Avg_World__c) World_Avg
                    FROM NTM_Country_Import__c
                    WHERE Product__r.Name IN :userProducts
                    AND Data_Years__c >= 3
                    AND Country__r.Name IN :userCountriesNew
                    AND Country__r.Name NOT IN :userCountriesExisting
                    AND Country__r.Contract_Cost__c != null
                    AND Country__r.Distance__c != null
                    AND Country__r.GDP__c != null
                    AND Country__r.Import_Costs__c != null
                    AND Country__r.Logistics_Score__c != null
                    AND Country__r.Rule_of_Law__c != null
                    GROUP BY Country__c
                    HAVING Sum(Avg_World__c) > 0
                ]);
            } catch(Exception e) {
                System.debug('Unable to query country results: \n'+e.getMessage()+'\n'+e.getStackTraceString());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to query country results: \n'+e.getMessage()));
                return new Map<Id, AggregateResult>();
            }
        }
        if(userGeography == 'region') {
            try {
                return new Map<Id, AggregateResult>([
                    SELECT Country__c Id, MIN(Year_First__c) Year_First, MIN(Year_Last__c) Year_Last, MAX(Tariff__c) Max_Tariff, SUM(Avg_US__c) US_Avg, SUM(Avg_World__c) World_Avg
                    FROM NTM_Country_Import__c
                    WHERE Product__r.Name IN :userProducts
                    AND Data_Years__c >= 3
                    AND Country__c IN
                        (SELECT Country__c FROM NTM_Search_Region__c
                         WHERE Region__r.Name IN :userRegionsNew)
                    AND Country__r.Name NOT IN :userCountriesExisting
                    AND Country__r.Contract_Cost__c != null
                    AND Country__r.Distance__c != null
                    AND Country__r.GDP__c != null
                    AND Country__r.Import_Costs__c != null
                    AND Country__r.Logistics_Score__c != null
                    AND Country__r.Rule_of_Law__c != null
                    GROUP BY Country__c
                    HAVING Sum(Avg_World__c) > 0
                ]);
            } catch(Exception e) {
                System.debug('Unable to query country results: \n'+e.getMessage()+'\n'+e.getStackTraceString());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to query country results: \n'+e.getMessage()));
                return new Map<Id, AggregateResult>();
            }           
        }
        
        try {
        // Else: all geographies are selected
            return new Map<Id, AggregateResult>([
                SELECT Country__c Id, MIN(Year_First__c) Year_First, MIN(Year_Last__c) Year_Last, MAX(Tariff__c) Max_Tariff, SUM(Avg_US__c) US_Avg, SUM(Avg_World__c) World_Avg
                FROM NTM_Country_Import__c
                WHERE Product__r.Name IN :userProducts
                AND Data_Years__c >= 3
                AND Country__r.Name NOT IN :userCountriesExisting
                AND Country__r.Contract_Cost__c != null
                AND Country__r.Distance__c != null
                AND Country__r.GDP__c != null
                AND Country__r.Import_Costs__c != null
                AND Country__r.Logistics_Score__c != null
                AND Country__r.Rule_of_Law__c != null
                GROUP BY Country__c
                HAVING Sum(Avg_World__c) > 0
            ]);
        } catch(Exception e) {
            System.debug('Unable to query country results: \n'+e.getMessage()+'\n'+e.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to query country results: \n'+e.getMessage()));
            return new Map<Id, AggregateResult>();
        }
    }
    
    // Calculate the variety of trade statistics for each country
    @TestVisible private List<NewToMarketImportStatistics> generateStatistics(Map<Id, AggregateResult> country_aggregate, Map<Id, AggregateResult> region_aggregate) {
        // Used to calculate non-linear scaling adjusted tariff.
        // Reference value is maximum tariff from countries already
        // exporting to.
        Decimal tariff_current;
        try {
            tariff_current = (Decimal) [SELECT MAX(Tariff__c) Max_Tariff FROM NTM_Country_Import__c 
                                            WHERE Country__r.Name IN :userCountriesExisting
                                            AND Product__r.Name IN :userProducts][0].get('Max_Tariff');
        } catch(Exception e) {
            //Could not generate Statistics
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to generate trade statistics: \n'+e.getMessage()));
            System.debug('Unable to generate trade statistics: \n'+e.getMessage()+'\n'+e.getStackTraceString());
            tariff_current = 0; 
        }

        // Used to determine if a prospective country uses a
        // language spoken in a country the user is already
        // exporting to.
        Set<String> languages_current = new Set<String>();
        List<NTM_Country__c> languages_full = [SELECT Languages__c FROM NTM_Country__c WHERE Name IN :userCountriesExisting];
        for(NTM_Country__c country_lang : languages_full) {
            List<String> langs = country_lang.Languages__c.split(';');
            languages_current.addAll(langs);
        }
        
        // Jeff W - Fix for issue(s) related to previous developer's failure to adhere to best practices regarding SOQL queries in for loops.
        Map<Id,NTM_Country__c> idToCountryMap = new Map<Id,NTM_Country__c>();
        try {
        for(NTM_Country__c thisCountry : [SELECT Id, Name, Contract_Cost__c, Distance__c, Free_Trade_Agreement__c, GDP__c, Import_Costs__c, ISO_Alpha_2__c, Landlocked__c, Languages__c, Region_Calculate__c, Region_Compare__c, Rule_of_Law__c, Logistics_Score__c
                         FROM NTM_Country__c]) {
            idToCountryMap.put(thisCountry.Id,thisCountry);
        }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to generate trade statistics: \n'+e.getMessage()));
            System.debug('Unable to generate trade statistics: \n'+e.getMessage()+'\n'+e.getStackTraceString());
        }
        Map<Id,AggregateResult> countryIdToImportMap = new Map<Id,AggregateResult>();
        try {
            for(AggregateResult thisImport : [SELECT Country__c, SUM(World_1__c) W1, SUM(World_2__c) W2, SUM(World_3__c) W3, SUM(World_4__c) W4, SUM(World_5__c) W5 FROM NTM_Country_Import__c WHERE Product__r.Name IN :userProducts GROUP BY Country__c]) {
                countryIdToImportMap.put((Id)thisImport.get('Country__c'),thisImport);
            }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to generate trade statistics: \n'+e.getMessage()));
            System.debug('Unable to generate trade statistics: \n'+e.getMessage()+'\n'+e.getStackTraceString());    
        }

        // Arbitrary JOINs cannot be done in SOQL that are not related to an
        // explicit Salesforce object relationship. To combine country and region
        // details, we can build the associations and calculate the statistics
        // in a separate structure.
        List<NewToMarketImportStatistics> stats = new List<NewToMarketImportStatistics>();
        for(Id countryId : country_aggregate.keySet()) {
            NewToMarketImportStatistics stat = new NewToMarketImportStatistics(idToCountryMap.get(countryId));
            AggregateResult country = country_aggregate.get(countryId);
            AggregateResult region = region_aggregate.get(stat.region);
            if(region == null) {
                // This will be null if a country has a region_compare,
                // but no other countries have that region listed as
                // region_calculate. We must skip those countries
                // because we wouldn't be able to calculate the share
                // gap or trade growth.
                continue;
            }

            stat.country_us_avg = (Decimal) country.get('US_Avg');
            stat.country_world_avg = (Decimal) country.get('World_Avg');
            stat.region_us_avg = (Decimal) region.get('Region_US_Avg');
            stat.region_world_avg = (Decimal) region.get('Region_World_Avg');
            stat.max_tariff = (Decimal) country.get('Max_Tariff');
            
            stat.adjusted_tariff = tariff_current > stat.max_tariff ? 
                                   math.pow((Double) (tariff_current - stat.max_tariff), (Double) 2) :
                                   -1 * math.pow((Double) (tariff_current - stat.max_tariff), (Double) 2);
            
            // Don't compare a country against itself. Remove the country from
            // the region averages
            //Commenting code per UX-1274
            /*Boolean country_within_region = stat.region_calculate == stat.region;
            if(country_within_region) {
                if(stat.region_world_avg - stat.country_world_avg == 0) {
                    stat.region_us_share = 0;
                } else {
                    stat.region_us_share = (stat.region_us_avg - stat.country_us_avg) / (stat.region_world_avg - stat.country_world_avg);
                }
            } else {*/
                stat.region_us_share = stat.region_world_avg == 0 ? 0 : stat.region_us_avg / stat.region_world_avg;
            //}
            
            stat.country_us_share = stat.country_world_avg == 0 ? 0 : stat.country_us_avg / stat.country_world_avg;
            stat.share_gap = stat.country_us_share < stat.region_us_share ? stat.region_us_share - stat.country_us_share : 0;
            stat.share_gap_value = stat.share_gap * stat.country_world_avg;
            
            // For the import data, every product for a country should share
            // the same years of data availability. The country query returns
            // the year ordinal for the first and last years of data
            // availability, which can help us calculate the growth rate.
            Decimal year_first = (Decimal) country.get('Year_First');
            Decimal year_last = (Decimal) country.get('Year_Last');
            if(year_first != 0 && year_last != 0 && year_first != year_last) {
                // Aggregate import amounts for the first and last years of trade data
                // for the selected products. We don't need to re-filter for data
                // sufficiency because we're specifing pulling for a country that has
                // been determined to have enough data.
                
                /*
                String q = 'SUM(World_' + year_first + '__c) World_First, SUM(World_' + year_last + '__c) World_Last';
                SObject cagr = Database.query('SELECT Country__c, '+q+' FROM NTM_Country_Import__c WHERE Country__c = :countryId AND Product__r.Name IN :userProducts GROUP BY Country__c');
                Decimal world_first = (Decimal) cagr.get('World_First');
                Decimal world_last = (Decimal) cagr.get('World_Last');
                */
                try {
                    SObject cagr = countryIdToImportMap.get(countryId);
                    Decimal world_first = (Decimal) cagr.get('W'+year_first);
                    Decimal world_last = (Decimal) cagr.get('W'+year_last);
                    
                    // Because here year 1 is the latest and 5 is the oldest, we need to flip
                    // the subtraction in the exponent for CAGR.
                    if(world_first == 0) {
                        stat.world_cagr = 0;
                    } else {
                        stat.world_cagr = math.pow((Double)(world_last / world_first), (Double)(1 / (year_first - year_last))) - 1;
                    }
                    if(stat.country_world_avg == 0) {
                        stat.world_cagr_alt = 0;
                    } else {
                        stat.world_cagr_alt = math.pow((Double)(world_last / stat.country_world_avg), (Double) 0.5) - 1;
                    }
                    
                    stat.trade_projection = (
                                             (stat.country_us_avg + stat.share_gap_value) * 
                                             (1+((stat.world_cagr + stat.world_cagr_alt)/2)) *
                                             (1+(stat.gdp/100))
                                            )
                                            - stat.country_us_avg;
                } catch(Exception e) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Unable to generate trade statistics: \n'+e.getMessage()));
                    System.debug('Unable to generate trade statistics: \n'+e.getMessage()+'\n'+e.getStackTraceString());
                }
            }
            
            stat.language_match = isLanguageMatch(stat, languages_current);
            stats.add(stat);
        }
        return stats;
    }
    
    // Determine whether a particular country has a language in
    // common with existing export markets. Returns true if a
    // language is shared or the country speaks English.
    @TestVisible private Boolean isLanguageMatch(NewToMarketImportStatistics stat, Set<String> languages_current) {
        List<String> languages = stat.languages.split(';');
        for(String language : languages) {
            if(languages_current.contains(language) || language.equalsIgnoreCase('English')) {
                return true;
            }
        }
        return false;
    }
    
    // Iterate through all of the country statistics to create a normalized
    // index value for a number of statistics
    @TestVisible private List<NewToMarketImportStatistics> addIndices(List<NewToMarketImportStatistics> stats) {
        Decimal minTradeProjection;
        Decimal maxTradeProjection;
        Decimal minAvgUS;
        Decimal maxAvgUS;
        Decimal minAdjTariff;
        Decimal maxAdjTariff;
        Decimal minImportCosts;
        Decimal maxImportCosts;
        Decimal minDistance;
        Decimal maxDistance;
        Decimal minContractCost;
        Decimal maxContractCost;
        Decimal minRuleOfLaw;
        Decimal maxRuleOfLaw;
        Decimal minLogisticsScore;
        Decimal maxLogisticsScore;
        
        for(NewToMarketImportStatistics stat : stats) {
            minTradeProjection = (minTradeProjection == null || stat.trade_projection < minTradeProjection) ? stat.trade_projection : minTradeProjection;
            maxTradeProjection = (maxTradeProjection == null || stat.trade_projection > maxTradeProjection) ? stat.trade_projection : maxTradeProjection;
            
            minAvgUS = (minAvgUS == null || stat.country_us_avg < minAvgUS) ? stat.country_us_avg : minAvgUS;
            maxAvgUS = (maxAvgUS == null || stat.country_us_avg > maxAvgUS) ? stat.country_us_avg : maxAvgUS;

            minAdjTariff = (minAdjTariff == null || stat.adjusted_tariff < minAdjTariff) ? stat.adjusted_tariff : minAdjTariff;
            maxAdjTariff = (maxAdjTariff == null || stat.adjusted_tariff > maxAdjTariff) ? stat.adjusted_tariff : maxAdjTariff;
            
            minImportCosts = (minImportCosts == null || stat.import_costs < minImportCosts) ? stat.import_costs : minImportCosts;
            maxImportCosts = (maxImportCosts == null || stat.import_costs > maxImportCosts) ? stat.import_costs : maxImportCosts;
            
            minDistance = (minDistance == null || stat.distance < minDistance) ? stat.distance : minDistance;
            maxDistance = (maxDistance == null || stat.distance > maxDistance) ? stat.distance : maxDistance;
            
            minContractCost = (minContractCost == null || stat.contract_cost < minContractCost) ? stat.contract_cost : minContractCost;
            maxContractCost = (maxContractCost == null || stat.contract_cost > maxContractCost) ? stat.contract_cost : maxContractCost;
            
            minRuleOfLaw = (minRuleOfLaw == null || stat.rule_of_law < minRuleOfLaw) ? stat.rule_of_law : minRuleOfLaw;
            maxRuleOfLaw = (maxRuleOfLaw == null || stat.rule_of_law > maxRuleOfLaw) ? stat.rule_of_law : maxRuleOfLaw;
            
            minLogisticsScore = (minLogisticsScore == null || stat.logistics_score < minLogisticsScore) ? stat.logistics_score : minLogisticsScore;
            maxLogisticsScore = (maxLogisticsScore == null || stat.logistics_score > maxLogisticsScore) ? stat.logistics_score : maxLogisticsScore;
        }
        
        // Looping through the list of statistics twice isn't great. However,
        // the number of countries we're iterating through should generally
        // be small, and breaking out these calculations from the prior
        // method simplifies the logic.
        for(NewToMarketImportStatistics stat : stats) {
            // Calculated (x-Min)/(Max-Min)
            stat.trade_projection_index = maxTradeProjection == minTradeProjection ? 1 : (stat.trade_projection - minTradeProjection) / (maxTradeProjection - minTradeProjection);
            stat.historical_trade_index = maxAvgUS == minAvgUS ? 1 : (stat.country_us_avg - minAvgUS) / (maxAvgUS - minAvgUS);
            stat.tariff_index = maxAdjTariff == minAdjTariff ? 1 : (stat.adjusted_tariff - minAdjTariff) / (maxAdjTariff - minAdjTariff);
            stat.rule_of_law_index = maxRuleOfLaw == minRuleOfLaw ? 1 : (stat.rule_of_law - minRuleOfLaw) / (maxRuleOfLaw - minRuleOfLaw);
            stat.logistics_score_index = maxLogisticsScore == minLogisticsScore ? 1 : (stat.logistics_score - minLogisticsScore) / (maxLogisticsScore - minLogisticsScore);

            // Calculated (Max-x)/(Max-Min)
            stat.import_costs_index = maxImportCosts == minImportCosts ? 1 : (maxImportCosts - stat.import_costs) / (maxImportCosts - minImportCosts);
            stat.distance_index = maxDistance == minDistance ? 1 : (maxDistance - stat.distance) / (maxDistance - minDistance);
            stat.contract_cost_index = maxContractCost == minContractCost ? 1 : (maxContractCost - stat.contract_cost) / (maxContractCost - minContractCost);

            stat.total_score = getTotalScore(stat);
        }
        
        return stats;
    }
    
    // This function is separate from the function to add the Total Score
    // so that we can avoid an extra loop of all statistics, while also
    // allowing the Total Score function to be called when the weights
    // are adjusted.
    private Decimal getTotalScore(NewToMarketImportStatistics stat) {
        /**
         * Weight Key Names:
         *
         * 'Trade Growth'
         * 'Historic Trade'
         * 'Tariff'
         * 'Import Costs'
         * 'Distance'
         * 'Rule of Law'
         * 'Logistics Performance'
         * 'Language'
         * 'FTA'
         * 'Landlocked'
         * 'Enforcing Contracts'
         **/
        try {
            return 100 * (
                   (weights.get('Trade Growth') * stat.trade_projection_index) +
                   (weights.get('Historic Trade') * stat.historical_trade_index) +
                   (weights.get('Tariff') * stat.tariff_index) +
                   (weights.get('Import Costs') * stat.import_costs_index) +
                   (weights.get('Distance') * stat.distance_index) +
                   (weights.get('Rule of Law') * stat.rule_of_law_index) +
                   (weights.get('Logistics Performance') * stat.logistics_score_index) +
                   (weights.get('Enforcing Contracts') * stat.contract_cost_index) +
                   (stat.landlocked ? 0 : weights.get('Landlocked')) +
                   (stat.free_trade_agreement ? weights.get('FTA') : 0) +
                   (stat.language_match ? weights.get('Language') : 0)
                   );
        } catch(Exception e) {
            return null;
        }
    }
    
    // Based on the weights of each index, generate a total score
    // for each country.
    private List<NewToMarketImportStatistics> recalculateTotalScore(List<NewToMarketImportStatistics> stats) {
        for(NewToMarketImportStatistics stat : stats) {
            stat.total_score = getTotalScore(stat);
        }
        return stats;
    }

    public void calculateWeights() {
        Decimal total = weightTrade + weightHistoric + weightTariff +
                weightImportCosts + weightDistance + weightRuleOfLaw +
                weightLogistics + weightLanguage + weightFTA +
                weightLandlocked + weightContracts;
        currentWeights = 'Current total: ' + total;
    }

    // Given user-updated weights, recalculate the existing
    // results list.
    public PageReference updateWeights() {
        weightsError = null;
        Decimal total = weightTrade + weightHistoric + weightTariff +
                        weightImportCosts + weightDistance + weightRuleOfLaw +
                        weightLogistics + weightLanguage + weightFTA +
                        weightLandlocked + weightContracts;
        if(total != 1) {
            weightsError = 'Current total: ' + total + '. Total must equal 1.';
            return null;
        }
        if(weightTrade < 0 || weightHistoric < 0 || weightTariff < 0 ||
           weightImportCosts < 0 || weightDistance < 0 || weightRuleOfLaw < 0 ||
           weightLogistics < 0 || weightLanguage < 0 || weightFTA < 0 ||
           weightLandlocked < 0 || weightContracts < 0) {

           weightsError = 'All weights must be a positive decimal between 0 and 1.';
           return null;
        }
        
        weights = new Map<String, Decimal>{
            'Trade Growth' => weightTrade,
            'Historic Trade' => weightHistoric,
            'Tariff' => weightTariff,
            'Import Costs' => weightImportCosts,
            'Distance' => weightDistance,
            'Rule of Law' => weightRuleOfLaw,
            'Logistics Performance' => weightLogistics,
            'Language' => weightLanguage,
            'FTA' => weightFTA,
            'Landlocked' => weightLandlocked,
            'Enforcing Contracts' => weightContracts
        };
        if(!results.isEmpty()) {
            results = recalculateTotalScore(results);
            results.sort();
        }
        calculateWeights();
        return null;
    }
    
    // Generate a CSV file from the results list
    private String generateCSV() {
        if(results.isEmpty()) {
            return '';
        }

        String footer = '"Trade Data: United Nations Comtrade Database, United Nations Commodity Trade Statistics Database, Department of Economic and Social Affairs/Statistics."\n"Tariff Data: For countries with which the United States does not have a Free Trade Agreement, tariff schedules provided to the World Trade Organization by individual members were used. World Trade Organization, Tariff Analysis Online facility provides access to the WTO\'s Integrated Database (IDB) and Consolidated Tariff Schedules (CTS)."\n"Gross Domestic Product: World Development Indicators, The World Bank, GDP (current US$) (NY.GDP.MKTP.CD)."\n"Distance: GeoDist Database, Centre d\'Etudes Prospectives et d\'Informations Internationales. Bilateral US file, ""dist"" indicator."\n"Cost to Import (Border Compliance and Documentary Compliance): Doing Business, The World Bank, Trading Across Borders, Cost to Import: Border Compliance (USD) and Cost to Import: Documentary Compliance (USD)."\n"Enforcing Contracts: Doing Business, The World Bank, Enforcing Contracts, Cost (% of claim)."\n"Rule of Law: Worldwide Governance Indicators, The World Bank, Rule of Law: Estimate."\n"International Logistics Performance Index: Logistics Performance Index, The World Bank, International LPI Global Ranking and LPI Score."\n"Language Data: The World Factbook. Washington, DC: Central Intelligence Agency, 2017."';

        String str = line(new String[]{
            format('Country'),
            format('Total Score'),
            format('Average Imports from the U.S.'),
            format('Maximum Average Tariff'),
            format('Average Imports from the World'),
            format('U.S. Import Share'),
            format('Import Share Gap'),
            format('Import Growth'),
            format('GDP Growth'),
            format('Distance'),
            format('Cost to Import'),
            format('Enforcing Contracts (Cost as % of Claim)'),
            format('Rule of Law'),
            format('International Logistics Performance Index Score'),
            format('Language Match'),
            format('Free Trade Agreement with US'),
            format('Landlocked')
            });
        
        for(NewToMarketImportStatistics stat : results) {
            str += line(new String[] {
                format(stat.name),
                format(stat.total_score),
                format(stat.country_us_avg),
                format(stat.max_tariff),
                format(stat.country_world_avg),
                format(stat.country_us_share * 100),
                format(stat.share_gap * 100),
                format(stat.world_cagr * 100),
                format(stat.gdp),
                format(stat.distance),
                format(stat.import_costs),
                format(stat.contract_cost),
                format(stat.rule_of_law, 2),
                format(stat.logistics_score, 2),
                format(stat.language_match),
                format(stat.free_trade_agreement),
                format(stat.landlocked)
               });
        }
        
        if(!String.isEmpty(footer)) {
            str += '\n\n'+footer;
        }
        
        return str;
    }
    
    private String line(String[] cells) {
        return String.join(cells, ',') + '\n';
    }
    private String format(String s) {
        return s != null ? '"' + s + '"' : '""';
    }
    private String format(Decimal d, Integer scale) {
        return d != null ? String.valueOf(d.setScale(scale)) : '';
    }
    private String format(Decimal d) {
        return format(d, 1);
    }
    private String format(Boolean b) {
        if (b) {
            return 'YES';
        } else if (!b) {
            return 'NO';
        } else {
            return '';
        }

    }
}
