// This class serves as a wrapper for the NTM_Country object
// while adding aggregate statistical information that is
// calculated by the New to Market application.
public class NewToMarketImportStatistics implements Comparable {
    public Id country { get; set; }
    public Decimal country_us_avg { get; set; }
    public Decimal country_world_avg { get; set; }
    public Decimal country_us_share { get; set; }
    public Decimal region_us_avg { get; set; }
    public Decimal region_world_avg { get; set; }
    public Decimal region_us_share { get; set; }
    public Decimal share_gap { get; set; }
    public Decimal share_gap_value { get; set; }
    public Decimal world_cagr { get; set; }
    public Decimal world_cagr_alt { get; set; }
    public Decimal trade_projection { get; set; }
    public Decimal max_tariff { get; set; }
    public Decimal adjusted_tariff { get; set; }
    
    public Decimal trade_projection_index { get; set; }
    public Decimal historical_trade_index { get; set; }
    public Decimal tariff_index { get; set; }
    public Decimal import_costs_index { get; set; }
    public Decimal distance_index { get; set; }
    public Decimal contract_cost_index { get; set; }
    public Decimal rule_of_law_index { get; set; }
    public Decimal logistics_score_index { get; set; }
    public Boolean language_match { get; set; }
    public Decimal total_score { get; set; }
    
    public String name { get { return countryObject.Name; } }
    public Decimal contract_cost { get { return countryObject.Contract_Cost__c; } }
    public Decimal distance { get { return countryObject.Distance__c; } }
    public Boolean free_trade_agreement { get { return countryObject.Free_Trade_Agreement__c; } }
    public Decimal gdp { get { return countryObject.GDP__c; } }
    public Decimal import_costs { get { return countryObject.Import_Costs__c; } }
    public String iso_alpha_2 { get { return countryObject.ISO_Alpha_2__c; } }
    public Boolean landlocked { get { return countryObject.Landlocked__c; } }
    public String languages { get { return countryObject.Languages__c; } }
    public Id region { get { return countryObject.Region_Compare__c; } }
    public Id region_calculate { get { return countryObject.Region_Calculate__c; } }
    public Decimal rule_of_law { get { return countryObject.Rule_of_Law__c; } }
    public Decimal logistics_score { get { return countryObject.Logistics_Score__c; } }

    private NTM_Country__c countryObject;
    
    public NewToMarketImportStatistics(Id c) {
        country = c;
        countryObject = [SELECT Id, Name, Contract_Cost__c, Distance__c, Free_Trade_Agreement__c, GDP__c, Import_Costs__c, ISO_Alpha_2__c, Landlocked__c, Languages__c, Region_Calculate__c, Region_Compare__c, Rule_of_Law__c, Logistics_Score__c
                         FROM NTM_Country__c
                         WHERE Id = :c];
        language_match = false;
    }
    
    public NewToMarketImportStatistics(NTM_Country__c c) {
        country = c.Id;
        countryObject = c;                 
        language_match = false;
    }
    
    // Defines a relative order for this statistic object. In
    // order to print the list in descending order in Visualforce,
    // we must define the opposite comparisons.
    public Integer compareTo(Object compareTo) {
        NewToMarketImportStatistics other = (NewToMarketImportStatistics) compareTo;
        if(total_score < other.total_score) {
            return 1;
        } else if(total_score > other.total_score) {
            return -1;
        } else {
            return 0;
        }
    }
}