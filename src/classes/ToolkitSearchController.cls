public without sharing class ToolkitSearchController {

    /*
    Step 1: Populate classes defined in this controller from the database.  The data from the SOQL Queries is cached in these classes, so the database is only queried on the first visit to the page.
    
    Step 2: Determine the groupings of checkboxes used for filters.
    
    Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
    
    Step 4: Determine the results, based off the filter selections and using the cached data from Step 1.
    
    Step 5: Get the UI Labels
    
    */
    
    public String temp {get; set;} //{get{ if (temp == null) {temp = '';} return temp;} set;}  //Used for debugging
    public Integer tempInt {get{ if (tempInt == null) {tempInt = 0;} return tempInt;} set;}  //Used for debugging
    
    
    //Objects for Step 1
    public static final String OPTION_DELIMITER_1 = '~';  //Delimiters are used between Select Option values.  The format is ItemType~Id|Name
    public static final String OPTION_DELIMITER_2 = '|';  //Two delimiters are used to make it easier to parse the name on the page  
    
    public List<SelectOption> languageOptions {get{ if (languageOptions == null) {languageOptions = new List<SelectOption>();} return languageOptions ;} set;}  //The list of languages to display in the dropdown on the page
    public String selectedLanguage {get; set;}  //The selected language
    public String selectedLanguageDirection {get; set;}  //RTL or LTR
    
    public String programId {get; set;}  //The Id of the Program.  Passed in via parameter.  Used to determine which toolkit should display on the page.
    public String toolkitName {get; set;}  //Program__c.name.  Displayed in the UI.
    public Boolean hasTranslations {get; set;}  //Program__c.Has_Translations__c.  Whether or not translations into languages other than English are allow for this program.
    public String toolkitDescription {get; set;}  //Program__c.Toolkit_Search_Description__c.  Displayed in the UI.
    public String disclaimerText {get; set;}  //Program__c.Disclaimer_Text__c.  Displayed in the UI.
    
    //Label values in the UI.  These can be translated.
    public String searchLabel {get; set;}
    public String usSolutionProviderLabel {get; set;}
    public String searchByProviderNameLabel {get; set;}
    public String providesTheseSolutionsLabel {get; set;}
    public String solutionLabel {get; set;}
    public String selectAnOptionLabel {get; set;}
    public String filterUsProvidersLabel {get; set;}
    public String noResultsForCriteriaLabel {get; set;}
    public String totalProvidersLabel {get; set;}
    
    //Sort order of dropdowns
    public Integer classSortOrder {get; set;}
    public Integer categorySortOrder {get; set;}
    public Integer offeringSortOrder {get; set;}
    public Integer primaryWebResourceSortOrder {get; set;}
    public Integer relatedWebResourceSortOrder {get; set;}
    public Integer solutionSortOrder {get; set;}
    
    public List<ToolkitAsset> toolkitAssets = new List<ToolkitAsset>();
    
    public class ToolkitAsset {
        Product product;
        Application application;
    }
    
    public class Application {
        public String id {get; set;}
        public String name {get; set;}
        public String displayName {get; set;}
        public String translatedDisplayName {get{ if (translatedDisplayName == null) {translatedDisplayName = '';} return translatedDisplayName;} set;}
        public String website {get; set;}
        public String city {get; set;}
        public String state {get; set;}
    }
    
    public class Program {
        public String id;
        public String name;
    }
    
    public class Product {
        public String id {get; set;}
        public String name {get; set;}
        public String productClass {get; set;}
        public String productCategory {get; set;}
        public String productOffering {get; set;}  //Equip, Prod, Service
        public List<WebResource> webResources {get{ if (webResources == null) {webResources = new List<WebResource>();} return webResources;} set;}
    }
    
    public class WebResource {
        public Atom primaryAtom {get; set;}
        public Atom secondaryAtom {get; set;}
    }
    
    public class Atom {
        public String id {get; set;}
        public String name {get; set;}
        public String title {get; set;}
        public String summary {get; set;}
        public String atomType {get; set;}   //Issue, Regulation, Use, Phase
        public List<AtomLink> atomLinks {get{ if (atomLinks == null) {atomLinks = new List<AtomLink>();} return atomLinks;} set;}
    }
    
    public class AtomLink {
        public String id {get; set;}  //Used for translations
        public String name {get; set;}  //display Name
        public String url {get; set;}
    }
    
    public class Translation {
        public String name {get; set;}
        public String translation {get; set;}
        public String language {get; set;}
        public String languageDirection {get; set;}
        public String languageIso {get; set;}
    }
    
    public static final String PRODUCT_CLASS = 'Product Class';
    public static final String PRODUCT_CATEGORY = 'Product Category';
    public static final String PRODUCT_OFFERING = 'Offering';
    public static final String SOLUTION = 'Solution';
    public static final String RESOURCE = 'Resource';
    
    //Variables used with SOQL queries
    private transient Set<Id> productIds; //= new Set<Id>();
    private transient  Set<Id> applicationIds; //= new Set<Id>();
    private transient Set<Id> webResourceIds; //= new Set<Id>();
    private transient Set<Id> webResourceLinkIds; //= new Set<Id>();
    private transient Map<Id, Related_Resource__c[]> productRRMap;
    private transient Map<Id, Web_Resource_Link__c[]> webResourceWithLinksMap;
    
    //Objects for Step 2
    
    public class FilterItem implements Comparable {
        //Comparable is implemented to allow sorting
        public String id {get; set;} //If the Filter Group is type RESOURCE, then this is Content__c.id.  Otherwise, it's the Product Id.
        public Set<String> productIds {get{ if (productIds == null) {productIds = new Set<String>();} return productIds;} set;}  //If the Filter Group is type RESOURCE, then this is one or more Product2.id.  Otherwise, it's a single Product2.id.
        public String name {get; set;}
        
        public String summary {get; set;}
        public List<AtomLink> links {get{ if (links == null) {links = new List<AtomLink>();} return links;} set;}
        public Integer linksSize {get{ return links.size();} set;}
        
        //Add the equals and hashCode methods to weed out duplicates when this is used in a Set
        public Boolean equals(Object obj) {
            if (obj instanceof FilterItem) {
                FilterItem fi = (FilterItem)obj;
                return (this.name == fi.name);
            }
            return false;
        }
    
        public Integer hashCode() {
            return System.hashCode(this.name);
        }
        
        //Sorting is done by Filter Item Name
        public Integer compareTo(Object objToCompare) {
            FilterItem fi = (FilterItem)objToCompare;
            //return(this.name.toUpperCase().compareTo(fi.name.toUpperCase()));
            return(this.name.compareTo(fi.name));
        }
        
    }
    
    public Boolean hasResourceFilterGroup {get; set;}  //Used in the UI to determine whether or not to show non-product results
    
    public class FilterGroup implements Comparable {
        public String name {get; set;}  //This value can be in English or translated
        public String filterGroupType {get; set;}
        public Integer sortOrder {get; set;}  //The order in which this grouping should appear on the page
        public Set<FilterItem> filterItems {get{ if (filterItems == null) {filterItems = new Set<FilterItem>();} return filterItems;} set;}
        public List<FilterItem> filterItemList {get {return new List<FilterItem>(filterItems);} set;}  //This variable exists because a Visualforce repeat cannot use a Set for a custom class
        public List<SelectOption> availableOptions {get{ if (availableOptions == null) {availableOptions = new List<SelectOption>();} return availableOptions;} set;}
        public List<String> selectedOptions {get{ if (selectedOptions== null) {selectedOptions = new List<String>();} return selectedOptions;} set;}  //This is a List, but only 0 or 1 values will be populated here because each filter only allows 1 item to be selected.
        public List<FilterItem> filterItemResults {get; set;}  //A non-duplicate list that is used to display results in the UI
        public Boolean hasSelectedOption {get{if (selectedOptions.isEmpty()) {return false;} return true;} set;}
        public Boolean hasFilterGroupResults {get{ if (filterItemResults == null) {return false;} return !filterItemResults.isEmpty();} set;}  //Used by the UI to know if there are any results to display for this Filter Group
        
        public Integer hashCode() {
            return System.hashCode(this.name);
        }
        
        //Sorting is done by sortOrder
        public Integer compareTo(Object objToCompare) {
            FilterGroup fg = (FilterGroup)objToCompare;
            if (this.sortOrder == fg.sortOrder) {
                return 0;
            } else if (this.sortOrder > fg.sortOrder) {
                return 1;
            } else {
                return -1;
            }
        }
    }
    
    public List<FilterGroup> filterGroups {get{ if (filterGroups == null) {filterGroups = new List<FilterGroup>();} return filterGroups;} set;}
    public Map<String,FilterGroup> filterGroupMap = new Map<String,FilterGroup>();
    public Integer filterGroupCount = 0;    
    
    //Objects for Step 3
    
    public class SelectedItem {
        public String id;
        public String itemType;
        public String name;
    }
    
    Set<String> filteredProductIds {get; set;}  //A set of product ids that have been chosen.  A Resource-type filter group can add more than 1 product id to it.
    Set<SelectedItem> selectedItems {get; set;}  //All the select options that have been selected
    String selectedProductId;  //If a productId has been selected from a non-RESOURCE-type filter group, this is the product id
    Boolean isDuplicateOption;  //Used to avoid duplicates in filterGroup.availableOptions
        
    //Objects for Step 4
    public class AppProductResult implements Comparable {
        //Comparable is implemented to allow sorting
        
        public List<Product> products {get{ if (products == null) {products = new List<Product>();} return products;} set;}  //The application results to display
        public Application application {get; set;}
        
        //Sorting is done by Application Display Name
        public Integer compareTo(Object objToCompare) {
            AppProductResult apr = (AppProductResult )objToCompare;
            return(application.displayName.compareTo(apr.application.displayName));
        }
            
    }

    public Map<String, AppProductResult> appProductResultMap {get{ if (appProductResultMap == null) {appProductResultMap = new Map<String, AppProductResult>();} return appProductResultMap ;} set;} 
    public List<AppProductResult> appProductResults {get{ if (appProductResults == null) {appProductResults = new List<AppProductResult>();} return appProductResults ;} set;} 
    public Integer appProductResultsSize {get{ return appProductResults.size();} set;} 
    public Boolean hasProductResults {get{ return ! appProductResults.isEmpty();} set;}  //Used by the UI to know if there are any Product results to display
    private Boolean addedProduct = false;  
    
    public String searchString {get; set;}
    
    public Boolean filterSelected {get {if (String.isNotBlank(searchString) || ! selectedItems.isEmpty()) {return true;} else {return false;} } set;}
    
    //End Objects
    
    private void setupEnglishLanguage() {
        //Setup Languages.  Hardcode English and default to English    
        
        languageOptions = new List<SelectOption>();
        SelectOption englishOption = new SelectOption('en', 'English');
        languageOptions.add(englishOption);
        
        selectedLanguage = 'en';
        selectedLanguageDirection = 'ltr';
    }
    
    public ToolkitSearchController() {
        
        //The Program Id is passed in.  All data is based of the chosen program.
        if (String.isBlank(ApexPages.currentPage().getParameters().get('program'))) {
            return;
        }
        
        //Default the page to English
        setupEnglishLanguage();
        
        if (programId != ApexPages.currentPage().getParameters().get('program')) {
            programId = ApexPages.currentPage().getParameters().get('program');
            
            //Step 1: Populate classes defined in this controller from the database.  The data from the SOQL Queries is cached in these classes, so the database is only queried on the first visit to the page.
            getDataFromSalesforce();
            
            //Step 2: Determine the filter groupings and filters for the page
            getFilterData();
            
            //Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
            //refreshFilters();
            
            //Step 4: Provide the results based on the search string
            //There is no need to get results on the page load because results will not be shown until a filter is selected
            //getResults();
            
            //Step 5: Get the UI Labels
            getUILabels(toolkitName + ' en');  //Get the UI Labels in English 
        }
  
    }
    
    public void refreshChoices() {
        //A filter has been selected
    
        //Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
        refreshFilters();
        
        //Step 4: Provide the results based on the filters
        //getResults();
        
    }
    
    public void getResultsForTextSearch() {
        //The user is searching for results based on a search string
        //The value of searchString is already known when this method is called
        //It is possible the search string could be blank.  This occurs when there was a search string and then the user deletes it.  Filters still need to be updated and results provided.
        
        //Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
        //Step 4: Provide the results based on the search string
        refreshChoices();
                
    
    }
    
    public PageReference deselectFilterItem() {
        String filterItemValue = System.currentPageReference().getParameters().get('optionToRemove');
        Integer i;
        for (FilterGroup filterGroup : filterGroups) {
            i = 0;
            while (i < filterGroup.selectedOptions.size()) {
                if (filterGroup.selectedOptions.get(i) == filterItemValue) {
                    filterGroup.selectedOptions.remove(i);                    
                } else {
                    i++;
                }
            }
        }
        
        //Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
        //Step 4: Provide the results based on the search string
        refreshChoices();
        
        return null;
        
    }
    
    private void getDataFromSalesforce() {
        
        //Step 1: Populate classes defined in this controller from the database.  The data from the SOQL Queries is cached in these classes, so the database is only queried on the first visit to the page.
        
        //Initiatize variables
        toolkitAssets = new List<ToolkitAsset>();
        productIds = new Set<Id>();
        applicationIds = new Set<Id>();
        webResourceIds = new Set<Id>();
        webResourceLinkIds = new Set<Id>();
        productRRMap = new Map<Id, Related_Resource__c[]>();
        webResourceWithLinksMap = new Map<Id, Web_Resource_Link__c[]>();
        
            
        List<Asset> assetData = [SELECT Product2.Id, Product2.Name, Product2.Class__c,
                Product2.Category__c, Product2.ProductOffering__c, Participant__r.Id, Participant__r.Name,
                Participant__r.Public_Display_Name__c, Participant__r.Website__c, Participant__r.City__c, Participant__r.State__c, Program__r.Id, Program__r.Name,
                Program__r.Has_Translations__c, Program__r.Toolkit_Search_Description__c, Program__r.Disclaimer_Text__r.Content__c
                FROM Asset
                WHERE Program__c = :programId AND Status='Active' AND Product2.IsActive = True
                ORDER BY Product2.Name
                //limit 50 //@@DAN
        ];

        //Gather all the Product Ids for use in getting the Web Resources and Translations    
        for (Asset a: assetData) {            
            productIds.add(a.product2.id);
            applicationIds.add(a.participant__r.id);
        }

        List<Related_Resource__c> webResourceData = [SELECT Id, Product__c,
            Primary_Web_Resource__r.Id, Primary_Web_Resource__r.Name, Primary_Web_Resource__r.Display_Title__c, Primary_Web_Resource__r.Summary__c, Primary_Web_Resource__r.Type__c,
            Related_Web_Resource__r.Id, Related_Web_Resource__r.Name, Related_Web_Resource__r.Display_Title__c, Related_Web_Resource__r.Summary__c, Related_Web_Resource__r.Type__c    
            FROM Related_Resource__c
            WHERE Product__c IN :productIds
            ORDER BY Primary_Web_Resource__r.Type__c, Related_Web_Resource__r.Type__c, Primary_Web_Resource__r.Display_Title__c, Related_Web_Resource__r.Display_Title__c
        ];
        
        //Gather all the Web Resource Ids for use in getting the Web Resource Links        
        for (Related_Resource__c rr: webResourceData) {
            if (String.isNotBlank(rr.Primary_Web_Resource__r.Id)) {
                webResourceIds.add(rr.Primary_Web_Resource__r.Id);
            }
            if (String.isNotBlank(rr.Related_Web_Resource__r.Id)) {            
                WebResourceIds.add(rr.Related_Web_Resource__r.Id);
            }
            if(!productRRMap.keySet().contains(rr.product__c)){
                productRRMap.put(rr.product__c, new Related_Resource__c[]{});
            }
            productRRMap.get(rr.product__c).add(rr);
        }
        
        List<Web_Resource_Link__c> wrLinkData = [SELECT DisplayName__c, URL__c, Web_Resource__r.Id, Sort_Order__c
            FROM Web_Resource_Link__c
            WHERE Web_Resource__c IN :webResourceIds AND Status__c = 'Published'
            ORDER BY Sort_Order__c NULLS LAST, DisplayName__c
        ];
        
        for (Web_Resource_Link__c wrl: wrLinkData) {
            if (String.isNotBlank(wrl.Id)) {
                webResourceLinkIds.add(wrl.Id);
                
                //Get a map of the Web Resources with their links
                if(!webResourceWithLinksMap.keySet().contains(wrl.Web_Resource__r.Id)){
                    webResourceWithLinksMap.put(wrl.Web_Resource__r.Id, new Web_Resource_Link__c[]{});
                }
                webResourceWithLinksMap.get(wrl.Web_Resource__r.Id).add(wrl);
            }
        }
        
        //Determine the languages
        //Determine the available languages, based off whether there is a product, web resource, or web resource link that has a translation
        if (languageOptions.size() == 1) {
            //This is the first time this method has been called.  The only available option is English.
            //This method could be called a 2nd time if the user selects a non-English language and then selects English again.
            List<AggregateResult> translations = [SELECT Language__r.Name, Language__r.ISO_639_1__c
                FROM Translation__c
                WHERE Product__c IN :productIds OR Atom__c IN :webResourceIds
                OR Web_Resource_Link__c IN :webResourceLinkIds OR Participation__c in :applicationIds
                GROUP BY Language__r.Name, Language__r.ISO_639_1__c
                ORDER BY Language__r.Name
            ];
            
            for (AggregateResult ar: translations) {
                SelectOption translationOption = new SelectOption((String)ar.get('ISO_639_1__c'), (String)ar.get('Name'));
                languageOptions.add(translationOption);
            }
        }
                        
        //Populate all the data objects.  English is used as the default, so no translations at this point.
        Boolean firstRecordInLoop = true;
        for (Asset a: assetData) {
            if (firstRecordInLoop) {
                //These values are the same in every record so only get them from the first record in the loop
                hasTranslations = a.Program__r.Has_Translations__c;
                toolkitDescription = a.Program__r.Toolkit_Search_Description__c;
                disclaimerText = a.Program__r.Disclaimer_Text__r.Content__c;
                toolkitName = a.Program__r.Name;
                firstRecordInLoop = false;
            }
            //Populate the Asset Object
            ToolkitAsset ta = new ToolkitAsset();
            
            //Product
            Product p = new Product();
            p.id = a.product2.id;
            p.name = a.product2.name;
            //p.description = a.product2.description;
            p.productClass = a.product2.Class__c;
            p.productCategory = a.product2.Category__c;
            //p.block = a.product2.block__c;
            //p.shore = a.product2.shore__c;
            p.productOffering = a.product2.productOffering__c;
            
            //WebResource wr = new WebResource();
            //Primary Web Resource
            if (productRRMap.get(a.product2Id) != null) {
                //Get the Web Resources for this product
                for(Related_Resource__c rr : ProductRRMap.get(a.product2id)) {
                    WebResource wr = new WebResource();
                    Atom primaryAtom = new Atom();
                    primaryAtom.id = rr.Primary_Web_Resource__r.id;
                    primaryAtom.name = rr.Primary_Web_Resource__r.name;
                    primaryAtom.title = rr.Primary_Web_Resource__r.display_title__c;
                    primaryAtom.summary = rr.Primary_Web_Resource__r.summary__c;
                    primaryAtom.atomType = rr.Primary_Web_Resource__r.type__c;

                    if (webResourceWithLinksMap.get(rr.Primary_Web_Resource__r.id) != null) {
                        //for(Related_Resource__c rr : ProductRRMap.get(a.product2id)) {
                        for(Web_Resource_Link__c wrl : webResourceWithLinksMap.get(rr.Primary_Web_Resource__r.id)) {
            
                        //for (Web_Resource_Link__c wrl: wrPrimaryLinkData) {
                            if (wrl.Web_Resource__r.Id == rr.Primary_Web_Resource__r.Id) {
                                //This is a link for this Web Resource
                                AtomLink al = new AtomLink();
                                //Determine the name of the link.  Should be the first one of the following that has a value: 1: Web_Resource_Link.DisplayName, 2: Atom.DisplayTitle, 3: Atom.Name
                                if (String.isNotBlank(wrl.DisplayName__c)) {
                                    al.name = wrl.DisplayName__c;
                                } else if (String.isNotBlank(rr.Primary_Web_Resource__r.display_title__c)) {
                                    al.name = rr.Primary_Web_Resource__r.display_title__c;
                                } else if (String.isNotBlank(rr.Primary_Web_Resource__r.name)) {
                                    al.name = rr.Primary_Web_Resource__r.name;
                                } else {
                                    al.name = 'Unknown link title';  //This case should never happen
                                }    
                                al.url = wrl.url__c;
                                al.id = wrl.id;
                                primaryAtom.atomLinks.add(al);
                            }
                        }
                    }
                    
                    Atom secondaryAtom = new Atom();
                        secondaryAtom.id =  rr.Related_Web_Resource__r.id;
                        secondaryAtom.name = rr.Related_Web_Resource__r.name;
                        secondaryAtom.title = rr.Related_Web_Resource__r.display_title__c;
                        secondaryAtom.summary = rr.Related_Web_Resource__r.summary__c;
                        secondaryAtom.atomType = rr.Related_Web_Resource__r.type__c; 
                    
                    if (webResourceWithLinksMap.get(rr.Related_Web_Resource__r.id) != null) {
                        //for(Related_Resource__c rr : ProductRRMap.get(a.product2id)) {
                        for(Web_Resource_Link__c wrl : webResourceWithLinksMap.get(rr.Primary_Web_Resource__r.id)) {
                            if (wrl.Web_Resource__r.Id == rr.Related_Web_Resource__r.Id) {
                                //This is a link for this Web Resource
                                AtomLink al = new AtomLink();
                                //Determine the name of the link.  Should be the first one of the following that has a value: 1: Web_Resource_Link.DisplayName, 2: Atom.DisplayTitle, 3: Atom.Name
                                if (String.isNotBlank(wrl.DisplayName__c)) {
                                    al.name = wrl.DisplayName__c;
                                } else if (String.isNotBlank(rr.Related_Web_Resource__r.display_title__c)) {
                                    al.name = rr.Related_Web_Resource__r.display_title__c;
                                } else if (String.isNotBlank(rr.Related_Web_Resource__r.name)) {
                                    al.name = rr.Related_Web_Resource__r.name;
                                } else {
                                    al.name = 'Unknown link title';  //This case should never happen
                                }
                                al.url = wrl.url__c;
                                al.id = wrl.id;
                                secondaryAtom.atomLinks.add(al);
                            }
                        }
                    }
                    
                    wr.primaryAtom = primaryAtom;
                    wr.secondaryAtom = secondaryAtom;
                    p.webResources.add(wr);
                }
            }
            
            ta.product = p;
            
            Application app = new Application();
            app.id = a.Participant__r.Id;
            app.name = a.Participant__r.Name;
            if (String.isBlank(a.Participant__r.Public_Display_Name__c)) {
                app.displayName = a.Participant__r.Name;
            } else {
                app.displayName = a.Participant__r.Public_Display_Name__c;
            }
            app.translatedDisplayName = null;
            app.website = a.Participant__r.Website__c;
            app.city = a.Participant__r.City__c;
            app.state = a.Participant__r.State__c;
            ta.application = app;
                
            toolkitAssets.add(ta);
        }  
        
        //Get the dropdown sort order
        List<Toolkit_Search_Dropdown_Order__mdt > dropdownSortOrder = [Select Label, Category__c, Class__c, Offering__c, Primary_Web_Resource__c,
                                          Related_Web_Resource__c, Solution__c
                                          FROM Toolkit_Search_Dropdown_Order__mdt 
                                          WHERE Label = :toolkitName];      
        for (Toolkit_Search_Dropdown_Order__mdt order: dropdownSortOrder ) {
            classSortOrder = order.Class__c.intValue();
            categorySortOrder = order.Category__c.intValue();
            offeringSortOrder = order.Offering__c.intValue();
            primaryWebResourceSortOrder = order.Primary_Web_Resource__c.intValue();
            relatedWebResourceSortOrder = order.Related_Web_Resource__c.intValue();
            solutionSortOrder = order.Solution__c.intValue();
        }   
    
    }
    
    private void getFilterData() {
                
        //Step 2: Determine the filter groupings and filters for the page
        
        //Initialize variables
        filterGroups = new List<FilterGroup>();
        filterGroupMap = new Map<String,FilterGroup>();
        
        for (ToolkitAsset a: toolkitAssets) {
            if (String.isNotBlank(a.product.productClass)) {
                //If filterGroupMap.entrySet doesn't have this name, then add it
                //Product Class
                if (! filterGroupMap.keySet().contains(PRODUCT_CLASS)) {
                    //Create the filterGroup
                    FilterGroup filterGroup = new FilterGroup();
                    filterGroup.filterGroupType = PRODUCT_CLASS;
                    filterGroup.name = PRODUCT_CLASS;
                    filterGroup.sortOrder = classSortOrder;
                    if (String.isNotBlank(a.product.productClass)) { 
                        FilterItem filterItem = new FilterItem();
                        filterItem.id = a.product.id;
                        filterItem.productIds.add(a.product.id);
                        filterItem.name = a.product.productClass;
                        filterGroup.filterItems.add(filterItem);
                    }
                    filterGroupMap.put(PRODUCT_CLASS, filterGroup);
                } else if (String.isNotBlank(a.product.productClass)) { 
                    //The filterGroup already exists.  Grab it and add this value to the FilterItem
                    FilterGroup filterGroup = filterGroupMap.get(PRODUCT_CLASS);
                    FilterItem filterItem = new FilterItem();
                    filterItem.id = a.product.id;
                    filterItem.productIds.add(a.product.id);
                    filterItem.name = a.product.productClass;
                    filterGroup.filterItems.add(filterItem);
                }
            }
            
            if (String.isNotBlank(a.product.productCategory)) {   
                //Product Category
                if (! filterGroupMap.keySet().contains(PRODUCT_CATEGORY)) {
                    //Create the filterGroup
                    FilterGroup filterGroup = new FilterGroup();
                    filterGroup.filterGroupType = PRODUCT_CATEGORY;
                    filterGroup.name = PRODUCT_CATEGORY;
                    filterGroup.sortOrder = categorySortOrder;
                    if (String.isNotBlank(a.product.productCategory)) { 
                        FilterItem filterItem = new FilterItem();  
                        filterItem.id = a.product.id;                      
                        filterItem.productIds.add(a.product.id);
                        filterItem.name = a.product.productCategory;
                        filterGroup.filterItems.add(filterItem);
                    }
                    filterGroupMap.put(PRODUCT_CATEGORY, filterGroup);
                } else if (String.isNotBlank(a.product.productCategory)) { 
                    //The filterGroup already exists.  Grab it and add this value to the FilterItem
                    FilterGroup filterGroup = filterGroupMap.get(PRODUCT_CATEGORY);
                    FilterItem filterItem = new FilterItem(); 
                    filterItem.id = a.product.id;                       
                    filterItem.productIds.add(a.product.id);
                    filterItem.name = a.product.productCategory;
                    filterGroup.filterItems.add(filterItem);
                }
            }
            
            if (String.isNotBlank(a.product.productOffering)) {    
                //Offering
                if (! filterGroupMap.keySet().contains(PRODUCT_OFFERING)) {
                    //Create the filterGroup
                    FilterGroup filterGroup = new FilterGroup();
                    filterGroup.filterGroupType = PRODUCT_OFFERING;
                    filterGroup.name = PRODUCT_OFFERING;
                    filterGroup.sortOrder = offeringSortOrder;
                    if (String.isNotBlank(a.product.productOffering)) { 
                        FilterItem filterItem = new FilterItem(); 
                        filterItem.id = a.product.id;                       
                        filterItem.productIds.add(a.product.id);
                        filterItem.name = a.product.productOffering;
                        filterGroup.filterItems.add(filterItem);  
                    }                      
                    filterGroupMap.put(PRODUCT_OFFERING, filterGroup);
                } else if (String.isNotBlank(a.product.productOffering)) { 
                    //The filterGroup already exists.  Grab it and add this value to the FilterItem
                    FilterGroup filterGroup = filterGroupMap.get(PRODUCT_OFFERING);
                    FilterItem filterItem = new FilterItem();
                    filterItem.id = a.product.id;                        
                    filterItem.productIds.add(a.product.id);
                    filterItem.name = a.product.productOffering;
                    filterGroup.filterItems.add(filterItem);                        
                }
            }
            
            //For each product, get the WebResource and then look at the Atom.Type to see if this should be added
            
            for (WebResource webResource: a.product.webResources) {
                if (webResource.primaryAtom != null && webResource.primaryAtom.atomType != null) {           
                    //Look at the Primary Atom                  
                    if (! filterGroupMap.keySet().contains(webResource.primaryAtom.atomType)) {
                        //Create the filterGroup
                        FilterGroup filterGroup = new FilterGroup();
                        filterGroup.filterGroupType = RESOURCE;
                        filterGroup.name = webResource.primaryAtom.atomType;
                        filterGroup.sortOrder = primaryWebResourceSortOrder;
                        //Create a new Filter Item
                        FilterItem filterItem = new FilterItem();                        
                        filterItem.id = webResource.primaryAtom.id;
                        filterItem.productIds.add(a.product.id);
                        if (String.isNotBlank(webResource.primaryAtom.Title)) {
                            filterItem.name = webResource.primaryAtom.Title;
                        } else if (String.isNotBlank(webResource.primaryAtom.Name)) {
                            filterItem.name = webResource.primaryAtom.Name;
                        } else {
                            filterItem.name = 'Unknown name';  //This should never happen with good data
                        }
                        filterItem.summary = webResource.primaryAtom.Summary;
                        filterItem.links = webResource.primaryAtom.atomLinks;
                        filterGroup.filterItems.add(filterItem); 
                        filterGroupMap.put(webResource.primaryAtom.atomType, filterGroup);
                    } else {
                        //The filterGroup already exists.  Grab it and add this value to the FilterItem
                        FilterGroup filterGroup = filterGroupMap.get(webResource.primaryAtom.atomType);
                        //Check if this filterItem already exists.  If it does, add the Product Id to it.
                        Boolean filterItemFound = false;
                        for (FilterItem filterItem: filterGroup.filterItems) {
                            if (filterItem.id == webResource.primaryAtom.id) {
                                filterItem.productIds.add(a.product.id);
                                filterItemFound = true;
                            }
                        }
                        
                        if (! filterItemFound) {
                            //This is a new FilterItem
                            FilterItem filterItem = new FilterItem();                        
                            filterItem.id = webResource.primaryAtom.id;
                            filterItem.productIds.add(a.product.id);
                            if (String.isNotBlank(webResource.primaryAtom.Title)) {
                                filterItem.name = webResource.primaryAtom.Title;
                            } else if (String.isNotBlank(webResource.primaryAtom.Name)) {
                                filterItem.name = webResource.primaryAtom.Name;
                            } else {
                                filterItem.name = 'Unknown name';  //This should never happen with good data
                            }
                            filterItem.summary = webResource.primaryAtom.Summary;
                            filterItem.links = webResource.primaryAtom.atomLinks;
                            filterGroup.filterItems.add(filterItem); 
                        }
                    }
                }
                
                if (webResource.secondaryAtom != null && webResource.secondaryAtom.atomType != null) {           
                    //Look at the Primary Atom                  
                    if (! filterGroupMap.keySet().contains(webResource.secondaryAtom.atomType)) {
                        //Create the filterGroup
                        FilterGroup filterGroup = new FilterGroup();
                        filterGroup.filterGroupType = RESOURCE;
                        filterGroup.name = webResource.secondaryAtom.atomType;
                        filterGroup.sortOrder = relatedWebResourceSortOrder;
                        //Create a new Filter Item
                        FilterItem filterItem = new FilterItem();                        
                        filterItem.id = webResource.secondaryAtom.id;
                        filterItem.productIds.add(a.product.id);
                        if (String.isNotBlank(webResource.secondaryAtom.Title)) {
                            filterItem.name = webResource.secondaryAtom.Title;
                        } else if (String.isNotBlank(webResource.secondaryAtom.Name)) {
                            filterItem.name = webResource.secondaryAtom.Name;
                        } else {
                            filterItem.name = 'Unknown name';  //This should never happen with good data
                        }
                        filterItem.summary = webResource.secondaryAtom.Summary;
                        filterItem.links = webResource.secondaryAtom.atomLinks;
                        filterGroup.filterItems.add(filterItem); 
                        filterGroupMap.put(webResource.secondaryAtom.atomType, filterGroup);
                    } else {
                        //The filterGroup already exists.  Grab it and add this value to the FilterItem
                        FilterGroup filterGroup = filterGroupMap.get(webResource.secondaryAtom.atomType);
                        //Check if this filterItem already exists.  If it does, add the Product Id to it.
                        Boolean filterItemFound = false;
                        for (FilterItem filterItem: filterGroup.filterItems) {
                            if (filterItem.id == webResource.secondaryAtom.id) {
                                filterItem.productIds.add(a.product.id);
                                filterItemFound = true;
                            }
                        }
                        
                        if (! filterItemFound) {
                            //This is a new FilterItem
                            FilterItem filterItem = new FilterItem();                        
                            filterItem.id = webResource.secondaryAtom.id;
                            filterItem.productIds.add(a.product.id);
                            if (String.isNotBlank(webResource.secondaryAtom.Title)) {
                                filterItem.name = webResource.secondaryAtom.Title;
                            } else if (String.isNotBlank(webResource.secondaryAtom.Name)) {
                                filterItem.name = webResource.secondaryAtom.Name;
                            } else {
                                filterItem.name = 'Unknown name';  //This should never happen with good data
                            }
                            filterItem.summary = webResource.secondaryAtom.Summary;
                            filterItem.links = webResource.secondaryAtom.atomLinks;
                            filterGroup.filterItems.add(filterItem); 
                        }
                    }
                }
            }   
        
            //The last Filter Group is Products (Solutions).  It must be shown last in the UI.
            if (! filterGroupMap.keySet().contains(SOLUTION)) {
                //Create the filterGroup
                FilterGroup filterGroup = new FilterGroup();
                filterGroup.filterGroupType = SOLUTION;
                filterGroup.name = SOLUTION;
                filterGroup.sortOrder = solutionSortOrder;
                if (String.isNotBlank(a.product.name)) {
                    FilterItem filterItem = new FilterItem();  
                    filterItem.id = a.product.id;                      
                    filterItem.productIds.add(a.product.id);
                    filterItem.name = a.product.name;
                    filterGroup.filterItems.add(filterItem);     
                }                   
                filterGroupMap.put(SOLUTION, filterGroup);
            } else if (String.isNotBlank(a.product.name)) {
                FilterGroup filterGroup = filterGroupMap.get(SOLUTION);
                FilterItem filterItem = new FilterItem();  
                filterItem.id = a.product.id;                      
                filterItem.productIds.add(a.product.id);
                filterItem.name = a.product.name;
                filterGroup.filterItems.add(filterItem);                  
            }
        
        }  //End looping through toolkitAssets
        
        filterGroups = filterGroupMap.values();  //Necessary only for the UI because the UI doesn't understand filterGroupMap.values()  

    }
    
    public void refreshFilters() {
        //Step 3: When a filter is selected, determine the filters that are still appropriate to display on the page.
        
        //Reset variables
        filteredProductIds = new Set<String>();
        selectedItems = new Set<SelectedItem>();
        selectedProductId = null;
        
        //Determine the selected items
        for (FilterGroup filterGroup : filterGroupMap.values()) {
            if (! filterGroup.selectedOptions.isEmpty()) {
                //Parse the selectedOption -- there can only be 0 or 1
                String[] optionParse1 = filterGroup.selectedOptions[0].split('\\' + OPTION_DELIMITER_1);
                String[] optionParse2 = optionParse1[1].split('\\' + OPTION_DELIMITER_2);
                SelectedItem selectedItem = new SelectedItem();    
                selectedItem.itemType = optionParse1[0];
                selectedItem.id = optionParse2[0];
                selectedItem.name = optionParse2[1];
                selectedItems.add(selectedItem);
            }
        }
        
        //Loop through the list of selectedOptions and determine if there is a Product ID selected
        //A Product ID is selected if there is a selection made for a non-RESOURCE-type filter group
        for (SelectedItem si: selectedItems) {
            if (si.itemType != RESOURCE) {
                selectedProductId = si.id;
            }
        }
        
        //Loop through the filterGroups and populate which options are available        
        for (FilterGroup filterGroup : filterGroupMap.values()) {
            //Reset the available options
            filterGroup.availableOptions = new List<SelectOption>();
            
            if (selectedItems.isEmpty()) {
                //No options have been chosen for any filter group.  Include all options.
                for (FilterItem filterItem: filterGroup.filterItems) {
                    SelectOption so = new SelectOption(filterGroup.filterGroupType + OPTION_DELIMITER_1 + filterItem.id + OPTION_DELIMITER_2 + filterItem.name, filterItem.name);
                    filterGroup.availableOptions.add(so);
                    filteredProductIds.addAll(filterItem.productIds);
                } 
            } else if (! filterGroup.selectedOptions.isEmpty()) {
                //An option was chosen for this filter.  Use it as the only available option.
                String[] optionParse1 = filterGroup.selectedOptions[0].split('\\' + OPTION_DELIMITER_1);
                String[] optionParse2 = optionParse1[1].split('\\' + OPTION_DELIMITER_2);
                SelectOption so = new SelectOption(filterGroup.selectedOptions[0], optionParse2[1]);
                filterGroup.availableOptions.add(so);
                if (optionParse1[0] != RESOURCE) {
                    //This is a non-RESOURCE filter group.  Include the product id in the filtered product ids.
                    filteredProductIds.add(optionParse2[0]);
                } else {
                    //This is a RESOURCE filter group.  Determine the product id(s) for the filter item.
                    for (FilterItem filterItem: filterGroup.filterItems) {
                        if (filterItem.id == optionParse2[0]) {
                            //This is the filter item that was selected.  Include all product ids in the filtered product ids.
                            filteredProductIds.addAll(filterItem.productIds);
                        }
                    }
                }
            }
        }
             
        //Loop through the filterGroups again.  All selected options already have their product ids included in filtered Product Ids
        for (FilterGroup filterGroup : filterGroupMap.values()) {
            if (filterGroup.availableOptions.isEmpty()) {
                //There is nothing chosen for this filter group.
                //Determine the available options based on the other chosen filter items
                
                if (selectedProductId != null) {
                    //If there is a selectedProductId, include only options that match it.
                    for (FilterItem filterItem: filterGroup.filterItems) {
                        if (filterItem.productids.contains(selectedProductId)) {
                            //Include this option
                            SelectOption so = new SelectOption(filterGroup.filterGroupType + OPTION_DELIMITER_1 + filterItem.id + OPTION_DELIMITER_2 + filterItem.name, filterItem.name);
                            filterGroup.availableOptions.add(so);
                            //Don't add this option to the filteredProductIds, because nothing was chosen for this filter group
                        }
                    } 
                } else {
                    //Include all options that have product ids matching the filtered product ids
                    for (FilterItem filterItem: filterGroup.filterItems) {
                        for (String filteredProductId: filteredProductIds) {
                            if (filterItem.productids.contains(filteredProductId)) {
                                //Include this option, but avoid duplicates
                                isDuplicateOption = false;
                                for (SelectOption so: filterGroup.availableOptions) {
                                    if (so.getLabel() == filterItem.name) {
                                        //This is a duplicate
                                        isDuplicateOption = true;
                                    }
                                }
                                if (! isDuplicateOption) {
                                    SelectOption so = new SelectOption(filterGroup.filterGroupType + OPTION_DELIMITER_1 + filterItem.id + OPTION_DELIMITER_2 + filterItem.name, filterItem.name);
                                    filterGroup.availableOptions.add(so);
                                    //Don't add this option to the filteredProductIds, because nothing was chosen for this filter group
                                }
                            }
                        }
                    }
                }
            }
            //Sort the available options
            filterGroup.availableOptions = ListUtils.sortSelectOptions(filterGroup.availableOptions);
            
        }
        
        filterGroups = filterGroupMap.values();  //Necessary only for the UI because the UI doesn't understand filterGroupMap.values()
        filterGroups.sort();
            
    }
    
    public void getResults() {
        //Step 4: Provide the results based on the filters
        
        //Start off with a list of Product IDs as the result of the filters.  FilteredProductIds was already populated in refreshFilters().
        
        //searchString will only be populated if the user is searching by text rather than selecting a checkbox
        
        //Initialize variables
        hasResourceFilterGroup = false;
        
        //Product (Solution) results
        //Reset the Results
        appProductResultMap = new Map<String, AppProductResult>();  //The key is the Application Id   
        
        //Variables used in the for-loop below
        Set<FilterItem> filterItemResultSet;
        SelectedItem si;
        Integer i;     
        
        for (ToolkitAsset a: toolkitAssets) {
            
            //Check if the user is searching by a text string.  If the string doesn't match, weed out this result
            if (String.isNotBlank(searchString)) {
                searchString = searchString.trim();
                
                if (searchString.length() > 1) {
                    //Search using the entire company name
                    if ((! a.application.displayName.containsIgnoreCase(searchString)) && (! a.application.name.containsIgnoreCase(searchString)) && (! a.application.translatedDisplayName.containsIgnoreCase(searchString))) {
                        //Go to the next application.  This one doesn't match the searchString criterion
                        continue;
                    }
                } else {
                    //Search using the first letter of the company name if only 1 letter was entered.
                    if ((! searchString.equalsIgnoreCase(a.application.displayName.left(1))) && (! searchString.equalsIgnoreCase(a.application.name.left(1))) && (! searchString.equalsIgnoreCase(a.application.translatedDisplayName.left(1)))) {  
                        //Go to the next application.  This one doesn't match the searchString criterion
                        continue;
                    }                                       
                }
            }

            if (selectedItems.isEmpty() && String.isNotBlank(searchString)) {
                //The user is searching only by text.  Get these results.
                
                //Product (Solution) results
                if (! appProductResultMap.containsKey(a.application.id)) {
                    //This application is not yet in the results.  Add it.
                    AppProductResult apr = new AppProductResult();
                    apr.application = a.application;
                    
                    //Get all the products for this application
                    for (ToolkitAsset a2: toolkitAssets) {
                        if (a2.application.id == a.application.id) {
                            //This product is supported by this application.  Add it.
                            apr.products.add(a2.product);
                        }  
                    }
                    appProductResultMap.put(a.application.id, apr);
                }
                   
            } else {
                //The user is searching by a filter item by iteself or by a filter item and a text string.  The text string non-matches were already weeded out in the code above.
                
                //Get the Product (Solution) Results
                for (String prodIdResult: filteredProductIds) {
                    addedProduct = false;
                    if (a.product.id == prodIdResult) {
                        //This product should be part of the results, based on the filter item
                        
                        if (! appProductResultMap.containsKey(a.application.id)) {
                            //This application is not yet in the results.  Add it.
                            AppProductResult apr = new AppProductResult();
                            apr.application = a.application;
                            
                            //Get all the products for this application
                            for (ToolkitAsset a2: toolkitAssets) {
                                if (a2.application.id == a.application.id) {
                                    //This product is supported by this application.  Add it.
                                    apr.products.add(a2.product);
                                }  
                            }
                            appProductResultMap.put(a.application.id, apr);
                        }                    
                    }
                }
            }
            
            //Get the Non-Product Results
            for (FilterGroup filterGroup : filterGroupMap.values()) {
                filterItemResultSet = new Set<FilterItem>();
                for (FilterItem filterItem: filterGroup.filterItems) {
                    if (selectedItems.isEmpty() && String.isNotBlank(searchString)) {
                        //The user is searching only by text, so only add this item to the result if it matches one of the products for one of the applications
                        for (AppProductResult apr: appProductResultMap.values()) {
                            for (Product p: apr.products) {
                                if (filterItem.productIds.contains(p.id )) {
                                    filterItemResultSet.add(filterItem);
                                }
                            }
                        }  
                    } else {
                        //The user is searching by either a selected item or by a selected item and a text string
                        if (String.isNotBlank(searchString)) {
                            //The user is searching by text, so only add this item to the result if it matches one of the products for one of the applications and if it matches one of the filtered product Ids for a selected item
                            for (AppProductResult apr: appProductResultMap.values()) {
                                for (Product p: apr.products) {
                                    if (filterItem.productIds.contains(p.id ) && filteredProductIds.contains(p.id)) {
                                        //This filter item matches one of the products associated with an application and it matches one of the filtered product Ids for a selected item
                                        filterItemResultSet.add(filterItem);
                                    }
                                }
                            }
                        } else {
                            //The user is only searching by selected items
                            //If this filter group has an item selected, only allow that item to be added to the filter item result set
                            if (filterGroup.hasSelectedOption) {
                                //Get the id of the selected option
                                if (getSelectedOptionId(filterGroup.selectedOptions[0]) == filterItem.id) {
                                    //This item matches the selected option, so add it to the result set
                                    filterItemResultSet.add(filterItem);
                                }
                            } else {
                                for (String prodId: filteredProductIds) {
                                    if (filterItem.productIds.contains(prodId) ) {
                                        //This filter item matches one of the products associated with an application and it matches one of the filtered product Ids for a selected item
                                        filterItemResultSet.add(filterItem);
                                    }
                                }
                            } 
                        }
                    }
                }
                
                if (filterGroup.filterGroupType == RESOURCE) {
                    hasResourceFilterGroup = true;
                }
                
                filterGroup.filterItemResults = new List<FilterItem>();
                filterGroup.filterItemResults.addAll(filterItemResultSet);  //A Set of a custom class object can't be used in a apex:repeat, so this List is used instead
                filterGroup.filterItemResults.sort();  //Sort the Non-Product results
            }
            
        }
        
        appProductResults = appProductResultMap.values();  //Necessary only for the UI because the UI doesn't understand appProductResultMap.values()
        appProductResults.sort();  //Sort the Product/Solution Results
        
    } 
    
    public void changeLanguage () {
        
        //Reset the selected items
        filteredProductIds = new Set<String>();
        selectedItems = new Set<SelectedItem>();
        selectedProductId = '';
        searchString = '';
        
        //Set default values for English
        selectedLanguageDirection = 'ltr';  //This will be changed by the code below if the language is not English
        
        //Step 1: Get data from Salesforce.  This will start everything from English
        getDataFromSalesforce();
        
        getUILabels(toolkitName + ' en');  //Get the UI Labels in English 
        
        if (! selectedLanguage.equalsIgnoreCase('en')) {
            //If English is not selected, then replace the English data with translations where available.
            
            Boolean firstTranslationRecord = true;
            
            for (Translation__c t: [SELECT Name, Product__c, Atom__c, Web_Resource_Link__c, Participation__c,
                Translation__c, Language__r.Name, Language__r.Direction__c, Language__r.ISO_639_1__c    
                FROM Translation__c
                WHERE (Product__c IN :productIds OR Atom__c IN :webResourceIds
                OR Web_Resource_Link__c IN :webResourceLinkIds OR Participation__c IN :applicationIds )
                AND Language__r.ISO_639_1__c = :selectedLanguage 
                ORDER BY Name, Language__r.Name
            ]) {
            
                //Replace values in the Filter Groups
                for (FilterGroup fg: filterGroups) {
                    if (fg.filterGroupType != RESOURCE) {
                        for (FilterItem fi: fg.filterItems) {
                            if (fi.id == t.product__c) {
                                //Translate this filter item
                                if (String.isNotBlank(t.name)) {
                                    fi.name = t.name;
                                }
                            }    
                        }
                    }
                }
                
                //Replace values in toolkitAssets
                for (ToolkitAsset a: toolkitAssets) {
                    if (firstTranslationRecord) {
                        //Get the language direction, but only do this for the first record because they will all be the same
                        selectedLanguageDirection = t.Language__r.Direction__c;
                        firstTranslationRecord = false;
                    }
                    //Overwrite the product name and description if there is a translation
                    if (t.product__c == a.product.id) {
                        if (String.isNotBlank(t.name)) {
                            a.product.name = t.name;
                        }
                    }
                    //Overwrite the company name if there is a translation
                    if (t.participation__c == a.application.id) {
                        if (String.isNotBlank(t.name)) {
                            if (a.application.displayName != t.name) {
                                //The company display name (English) and the translated display name must not match.  If they do, don't use the translated display name.
                                a.application.translatedDisplayName = t.name;
                            }
                        }
                    }
                    //Overwrite the Web Resource Atoms
                    for (WebResource wr: a.product.webResources) {
                        if (t.atom__c == wr.primaryAtom.id) {
                            if (String.isNotBlank(t.name)) {
                                wr.primaryAtom.title = t.name;
                            }
                            if (String.isNotBlank(t.translation__c)) {
                                wr.primaryAtom.summary= t.translation__c;
                            }
                        } else if (t.atom__c == wr.secondaryAtom.id) {
                            if (String.isNotBlank(t.name)) {
                                wr.secondaryAtom.title = t.name;
                            }
                            if (String.isNotBlank(t.translation__c)) {
                                wr.secondaryAtom.summary= t.translation__c;
                            }
                        }
                        
                        //Translate the Web Resource Links
                        for (AtomLink al: wr.primaryAtom.atomLinks) {
                            if (t.Web_Resource_Link__c == al.id) {
                                if (String.isNotBlank(t.name)) {
                                    al.name = t.name;
                                }    
                            }
                        }
                        for (AtomLink al: wr.secondaryAtom.atomLinks) {
                            if (t.Web_Resource_Link__c == al.id) {
                                if (String.isNotBlank(t.name)) {
                                    al.name = t.name;
                                }    
                            }
                        }
                    }
                }
            }
        }
        
        //Refresh the filters
        getFilterData();
        
        //Get the English names of the UI Labels
        getUILabels(toolkitName + ' ' + selectedLanguage);
        
        //Get results
        //refreshChoices();
    }
    
    private void getUILabels(String toolkitLabel) {
        //Get the UI Labels for the passed in Program Name and Language
    
        List<Toolkit_Search_Label__mdt> labels = [Select Label, Category__c, Class__c, Environmental_Issue__c,  //Block__c, Shore__c, 
                                          EPA_Regulation__c, Issue__c, NoResultsLabel__c, Offering__c, Performance_Improvement_Areas__c,
                                          Product__c, Project_Phase__c, Sector__c, SelectAnOption__c, Solution__c,
                                          Solution_Provider__c, Use_Case__c, Total_Providers__c 
                                          FROM Toolkit_Search_Label__mdt 
                                          WHERE Label = :toolkitLabel];
                                          
        for (Toolkit_Search_Label__mdt label: labels) {                     
            for (FilterGroup fg: filterGroups) {
                if (fg.filterGroupType == PRODUCT_CLASS && String.isNotBlank(label.Class__c)) {
                    fg.name =  label.Class__c;
                }  
                if (fg.filterGroupType == PRODUCT_CATEGORY && String.isNotBlank(label.Category__c)) {
                    fg.name =  label.Category__c;
                }
                if (fg.filterGroupType == SOLUTION && String.isNotBlank(label.Product__c)) {
                    fg.name =  label.Product__c;
                }
                if (fg.filterGroupType == PRODUCT_OFFERING && String.isNotBlank(label.Offering__c)) {
                    fg.name =  label.Offering__c;
                }
                if (fg.name == 'Environmental Issue' && String.isNotBlank(label.Environmental_Issue__c)) {
                    fg.name =  label.Environmental_Issue__c;
                } 
                if (fg.name == 'EPA Regulation' && String.isNotBlank(label.EPA_Regulation__c)) {
                    fg.name =  label.EPA_Regulation__c;
                }
                if (fg.name == 'Sector' && String.isNotBlank(label.Sector__c)) {
                    fg.name =  label.Sector__c;
                }
                if (fg.name == 'Issue' && String.isNotBlank(label.Issue__c)) {
                    fg.name =  label.Issue__c;
                }  
                if (fg.name == 'Project Phase' && String.isNotBlank(label.Project_Phase__c)) {
                    fg.name =  label.Project_Phase__c;
                }
                if (fg.name == 'Performance Improvement Areas' && String.isNotBlank(label.Performance_Improvement_Areas__c)) {
                    fg.name =  label.Performance_Improvement_Areas__c;
                }
                if (fg.name == 'Use Case' && String.isNotBlank(label.Use_Case__c)) {
                    fg.name =  label.Use_Case__c;
                } 
                
            }
            
            if (String.isNotBlank(label.Solution_Provider__c)) {
                searchLabel = label.Solution_Provider__c;
            }
            if (String.isNotBlank(label.Solution__c)) {
                solutionLabel = label.Solution__c;
            }
            if (String.isNotBlank(label.Solution_Provider__c)) {
                usSolutionProviderLabel = label.Solution_Provider__c;
            }
            if (String.isNotBlank(label.SelectAnOption__c)) {
                selectAnOptionLabel = label.SelectAnOption__c;
            }
            if (String.isNotBlank(label.NoResultsLabel__c)) {
                noResultsForCriteriaLabel = label.NoResultsLabel__c;
            }
            if (String.isNotBlank(label.Total_Providers__c)) {
                totalProvidersLabel = label.Total_Providers__c;
            }
                     
        }
    }
    
    private String getSelectedOptionId (String selectedOptionValue) {
        if (String.isBlank(selectedOptionvalue)) {
            return null;
        }
        String[] optionParse1 = selectedOptionValue.split('\\' + OPTION_DELIMITER_1);
        String[] optionParse2 = optionParse1[1].split('\\' + OPTION_DELIMITER_2);
        return optionParse2[0];
    }
        
}