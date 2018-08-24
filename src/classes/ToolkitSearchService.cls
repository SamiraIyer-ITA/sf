/*
    Toolkit Search REST Service
    Documentation:  https://itaisinternationaltrade.sharepoint.com/sites/salesforceplatformteam/Shared%20Documents/Toolkit%20Search%20REST%20Service?csf=1
*/


@RestResource(urlMapping='/ToolkitSearch/*')
global without sharing class ToolkitSearchService {
    
    //JSON output classes.  These are marked as Public so the TEST_ToolkitSearchService can see them.
    
    //Label values in the UI.  These can be translated.
    public class PageLabels {
        public String searchLabel;
        public String usSolutionProviderLabel;
        public String searchByProviderNameLabel;
        public String providesTheseSolutionsLabel;
        public String solutionLabel;
        public String selectAnOptionLabel;
        public String filterUsProvidersLabel;
        public String noResultsForCriteriaLabel;
        public String totalProvidersLabel;
    }
    
    public class AvailableLanguage {
        public String name;
        public String direction;
        public String iso;
    }
    
    public class Program {
        public String id;
        public String name;  //Program__c.name.  Displayed in the UI.
        public Boolean hasTranslations;  //Program__c.Has_Translations__c.  Whether or not translations into languages other than English are allow for this program.
        public String description;  //Program__c.Toolkit_Search_Description__c.  Displayed in the UI.
        public String disclaimerText;  //Program__c.Disclaimer_Text__c.  Displayed in the UI.
    }
    
    public class CurrentLanguage {
        public String name;
        public String direction;
        public String iso;
    }
    
    //The class that is used to create the JSON return value
    public class JsonOutput {
        public PageLabels pageLabels = new PageLabels();
        public CurrentLanguage currentLanguage = new CurrentLanguage();
        public Program program = new Program(); 
        public List<FilterGroup> filterGroups;  //Populated by filterGroupMap.values()
        public List<AvailableLanguage> availableLanguages = new List<AvailableLanguage>();
    }

    //Classes used by this Web Service
    private class ToolkitAsset {
        Product product;
        Application application;
    }
    
    private class Application {
        private String id;
        private String name;
        private String displayName;
        private String translatedDisplayName;
        private String website;
        private String city;
        private String state;
    }
    
    private class Product {
        private String id;
        private String name;
        private String productClass;
        private String productCategory;
        private String productOffering;
        private List<WebResource> webResources = new List<WebResource>();
    }
    
    private class WebResource {
        private Atom primaryAtom;
        private Atom secondaryAtom;
    }
    
    private class Atom {
        private String id;
        private String name;
        private String title;
        private String summary;
        private String atomType;   //Issue, Regulation, Use, Phase
        private List<AtomLink> atomLinks = new List<AtomLink>();
    }
    
    public class AtomLink {
        public String id;  //Used for translations
        public String name;  //display Name
        public String url;
    }
    
    public class FilterItem {
        public String id; //If the Filter Group is type RESOURCE, then this is Content__c.id.  Otherwise, it's the Product Id.
        public Set<String> productIds = new Set<String>();  //If the Filter Group is type RESOURCE, then this is one or more Product2.id.  Otherwise, it's a single Product2.id.
        public String name;
        public String summary;
        public List<AtomLink> links = new List<AtomLink>();
        public Integer linksSize {get{ return links.size();} set;}
        
        //Add the equals and hashCode methods to weed out duplicates when this is used in a Set
        private Boolean equals(Object obj) {
            if (obj instanceof FilterItem) {
                FilterItem fi = (FilterItem)obj;
                return (this.name == fi.name);
            }
            return false;
        }
        
        private Integer hashCode() {
            return System.hashCode(this.name);
        }
    }
    
    public class FilterGroup {
        public String name;  //This value can be in English or translated
        public String filterGroupType;
        public Integer sortOrder;  //The order in which this grouping should appear on the page
        public Set<FilterItem> filterItems = new Set<FilterItem>();
    }

    //The only callable method
    @HttpPost   
    global static void doPost(String programId, String languageIso) {
        
        //Initialize the return value
        JsonOutput output = new JsonOutput();
        
        if (String.isBlank(programId)) {
            RestContext.response.addHeader('Content-Type', 'application/json');
            String returnValue = '{"error":{"name": "Invalid Program ID"}}';
            RestContext.response.responseBody = Blob.valueOf(returnValue);
            return;
        } else {
            output.program.id = programId;
        }
        
        //Default the language to English
        if (String.isBlank(languageIso)) {
            output.currentLanguage.iso = 'en';
        } else {
            output.currentLanguage.iso = languageIso;
        }
        
        //Initialize Language values
        if (output.currentLanguage.iso == 'en') {
            output.currentLanguage.name = 'English';
            output.currentLanguage.direction = 'ltr';
        }
        
        AvailableLanguage availableLanguage = new AvailableLanguage();
        availableLanguage.name = 'English';
        availableLanguage.direction = 'ltr';
        availableLanguage.iso = 'en';
        output.availableLanguages.add(availableLanguage);
    
        //Variables used with SOQL queries
        Set<Id> productIds;
        Set<Id> applicationIds;
        Set<Id> webResourceIds;
        Set<Id> webResourceLinkIds;
        Map<Id, Related_Resource__c[]> productRRMap;
        Map<Id, Web_Resource_Link__c[]> webResourceWithLinksMap;
        
        //Sort order of dropdowns
        Integer classSortOrder;
        Integer categorySortOrder;
        Integer offeringSortOrder;
        Integer primaryWebResourceSortOrder;
        Integer relatedWebResourceSortOrder;
        Integer solutionSortOrder;
        
        List<ToolkitAsset> toolkitAssets;
        
        final String PRODUCT_CLASS = 'Product Class';
        final String PRODUCT_CATEGORY = 'Product Category';
        final String PRODUCT_OFFERING = 'Offering';
        final String SOLUTION = 'Solution';
        final String RESOURCE = 'Resource';
        
        Map<String,FilterGroup> filterGroupMap = new Map<String,FilterGroup>();
    
        //Initiatize variables
        toolkitAssets = new List<ToolkitAsset>();
        productIds = new Set<Id>();
        applicationIds = new Set<Id>();
        webResourceIds = new Set<Id>();
        webResourceLinkIds = new Set<Id>();
        productRRMap = new Map<Id, Related_Resource__c[]>();
        webResourceWithLinksMap = new Map<Id, Web_Resource_Link__c[]>();
        
        //Get the data
        List<Asset> assetData = [SELECT Product2.Id, Product2.Name, Product2.Class__c,
                Product2.Category__c, Product2.ProductOffering__c, Participant__r.Id, Participant__r.Name,
                Participant__r.Public_Display_Name__c, Participant__r.Website__c, Participant__r.City__c, Participant__r.State__c, Program__r.Id, Program__r.Name,
                Program__r.Has_Translations__c, Program__r.Toolkit_Search_Description__c, Program__r.Disclaimer_Text__r.Content__c
                FROM Asset
                WHERE Program__c = :programId AND Status='Active' AND Product2.IsActive = True
                ORDER BY Product2.Name
                //limit 2 //Used for testing
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
        
        //Determine the available languages, based off whether there is a product, web resource, or web resource link that has a translation
        List<AggregateResult> translations = [SELECT Language__r.Name, Language__r.ISO_639_1__c, Language__r.Direction__c
                                              FROM Translation__c
                                              WHERE Product__c IN :productIds OR Atom__c IN :webResourceIds
                                              OR Web_Resource_Link__c IN :webResourceLinkIds OR Participation__c in :applicationIds
                                              GROUP BY Language__r.Name, Language__r.ISO_639_1__c, Language__r.Direction__c
                                              ORDER BY Language__r.Name
                                             ];
        
        for (AggregateResult ar: translations) {
            availableLanguage = new AvailableLanguage();
            availableLanguage.name = (String)ar.get('Name');
            availableLanguage.direction = (String)ar.get('Direction__c');
            availableLanguage.iso = (String)ar.get('ISO_639_1__c');
            output.availableLanguages.add(availableLanguage);
        }
                        
        //Populate all the data objects.  English is used as the default, so no translations at this point.
        Boolean firstRecordInLoop = true;
        for (Asset a: assetData) {
            if (firstRecordInLoop) {
                //These values are the same in every record so only get them from the first record in the loop
                output.program.hasTranslations = a.Program__r.Has_Translations__c;
                output.program.name = a.Program__r.Name;
                output.program.description = a.Program__r.Toolkit_Search_Description__c;
                output.program.disclaimerText = a.Program__r.Disclaimer_Text__r.Content__c;
                firstRecordInLoop = false;
            }
            //Populate the Asset Object
            ToolkitAsset ta = new ToolkitAsset();
            
            //Product
            Product p = new Product();
            p.id = a.product2.id;
            p.name = a.product2.name;
            p.productClass = a.product2.Class__c;
            p.productCategory = a.product2.Category__c;
            p.productOffering = a.product2.productOffering__c;
            
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
                        for(Web_Resource_Link__c wrl : webResourceWithLinksMap.get(rr.Primary_Web_Resource__r.id)) {
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
                                          WHERE Label = :output.program.name];      
        for (Toolkit_Search_Dropdown_Order__mdt order: dropdownSortOrder ) {
            classSortOrder = order.Class__c.intValue();
            categorySortOrder = order.Category__c.intValue();
            offeringSortOrder = order.Offering__c.intValue();
            primaryWebResourceSortOrder = order.Primary_Web_Resource__c.intValue();
            relatedWebResourceSortOrder = order.Related_Web_Resource__c.intValue();
            solutionSortOrder = order.Solution__c.intValue();
        }  
        
        //Code from the original method called getFilterData()
        filterGroupMap = new Map<String,FilterGroup>();
        
        for (ToolkitAsset a: toolkitAssets) {
            if (String.isNotBlank(a.product.productClass)) {
                //If filterGroupMap.entrySet doesn't have this name, then add it
                //Product Class
                if (! filterGroupMap.keySet().contains(PRODUCT_CLASS)) {
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
        
        output.filterGroups = filterGroupMap.values(); 
        
        //Handle Languages
        if (! output.currentLanguage.iso.equalsIgnoreCase('en')) {
            //If English is not selected, then replace the English data with translations where available.
            
            Boolean firstTranslationRecord = true;
            
            for (Translation__c t: [SELECT Name, Product__c, Atom__c, Web_Resource_Link__c, Participation__c,
                Translation__c, Language__r.Name, Language__r.Direction__c, Language__r.ISO_639_1__c    
                FROM Translation__c
                WHERE (Product__c IN :productIds OR Atom__c IN :webResourceIds
                OR Web_Resource_Link__c IN :webResourceLinkIds OR Participation__c IN :applicationIds )
                AND Language__r.ISO_639_1__c = :languageIso 
                ORDER BY Name, Language__r.Name
            ]) {
            
                //Replace values in the Filter Groups
                for (FilterGroup fg: output.filterGroups) {
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
                        output.currentLanguage.direction = t.Language__r.Direction__c;
                        output.currentLanguage.name = t.Language__r.Name;
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
        
        //Get UI Labels - these can be in various languages
        String toolkitLabel = output.program.name + ' ' + output.currentLanguage.iso;
        List<Toolkit_Search_Label__mdt> labels = [Select Label, Category__c, Class__c, Environmental_Issue__c,
                                          EPA_Regulation__c, Issue__c, NoResultsLabel__c, Offering__c, Performance_Improvement_Areas__c,
                                          Product__c, Project_Phase__c, Sector__c, SelectAnOption__c, Solution__c,
                                          Solution_Provider__c, Use_Case__c, Total_Providers__c 
                                          FROM Toolkit_Search_Label__mdt 
                                          WHERE Label = :toolkitLabel];
                                          
        for (Toolkit_Search_Label__mdt label: labels) {                     
            for (FilterGroup fg: output.filterGroups) {
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
                output.pageLabels.searchLabel = label.Solution_Provider__c;
            }
            if (String.isNotBlank(label.Solution__c)) {
                output.pageLabels.solutionLabel = label.Solution__c;
            }
            if (String.isNotBlank(label.Solution_Provider__c)) {
                output.pageLabels.usSolutionProviderLabel = label.Solution_Provider__c;
            }
            if (String.isNotBlank(label.SelectAnOption__c)) {
                output.pageLabels.selectAnOptionLabel = label.SelectAnOption__c;
            }
            if (String.isNotBlank(label.NoResultsLabel__c)) {
                output.pageLabels.noResultsForCriteriaLabel = label.NoResultsLabel__c;
            }
            if (String.isNotBlank(label.Total_Providers__c)) {
                output.pageLabels.totalProvidersLabel = label.Total_Providers__c;
            }
                     
        }
        
        //Create the JSON output
        RestContext.response.addHeader('Content-Type', 'application/json');
        String returnValue = JSON.serialize(output, true);
        RestContext.response.responseBody = Blob.valueOf(returnValue);
        return;

    }

}