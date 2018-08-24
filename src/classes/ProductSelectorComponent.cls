public with sharing class ProductSelectorComponent {

public void refreshPBE(){
    this.PBE = [select id, unitprice, product2id, product2.name, product2.family, product2.class__c, product2.category__c from pricebookentry where pricebook2id = :this.pricebookid and isActive = true];
}

public string getInit(){
    //initialize the page variables
    this.cat1 = new String[]{};
    this.cat2a = new string[]{};
    this.cat3a1 = new map<string, list<string>>();
    this.cat4a1 = new map<string, list<string>>();
    
    this.options1 =  new SelectOption[]{};
    this.options2A = new SelectOption[]{};
    this.options3a1 = new map<string, selectOption[]>();
    this.options4a1 = new map<string, selectOption[]>();

    this.IssueNameMap = new map<id, string>();
    this.SelectedProducts = new String[]{};
    
    refreshPBE();
    Set<id> ProductIds = new Set<id>();
    for(PricebookEntry pbe : this.PBE){
        ProductIds.add(pbe.product2Id);
    }

    //get the list of Web Resources associated to this Product Selector
    this.WebResources = [select id, primary_web_resource__c, product__c, product__r.name, product__r.class__c, product__r.category__c, primary_web_resource__r.name, primary_web_resource__r.display_title__c from Related_Resource__c where Primary_Web_Resource__r.recordtype.developername = 'Web_Resource' AND primary_web_resource__r.type__c = :this.webresourcetype and Product__c in :ProductIds];        
    set<string> c1 = new set<string>();  //The WebResource that the Selector will utilize
    set<string> c2 = new set<string>(); //the set of Class or Products
    map<string, set<string>> c3 = new map<string, set<string>>(); //map of Product Category or Product
    map<string, set<string>> c4 = new map<string, set<string>>(); //map of Products to Class-Category

    if(this.WebResources.size() != 0){
        system.debug('Web Resources:  '+WebResources.size());
        for(Related_Resource__c rr : this.webResources){
            if(!c1.contains(rr.primary_web_resource__c)){
                this.options1.add(new SelectOption(rr.primary_web_resource__c, rr.primary_web_resource__r.display_title__c != null ? rr.primary_web_resource__r.display_title__c : rr.primary_web_resource__r.name));
                c1.add(rr.primary_web_resource__c);
            }
        }
    }else{
        system.debug('PBE');
        for(PricebookEntry pbentry : this.PBE){
            //begin logic check for Class__c
            if(!c1.contains(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id)){
                c1.add(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id);            
                this.Options1.add(new SelectOption(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id, !String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2.name));
                //this.cat1.add(pbentry.product2.class__c != null ? pbentry.product2.class__c : pbentry.product2id);
            }
        }
    }

    Product2[] products = ProductSelector.getAllOrderProducts(this.OrderId);
    set<string> OrderProductIds = new set<string>();
    for(product2 product : products){
        OrderProductIds.add(product.id);
    }
    this.SelectedProducts = new List<String>(OrderProductIds);

    for(Related_Resource__c rr : this.webResources){
        if(OrderProductIds.contains(rr.product__c)){
            cat1.add(rr.primary_web_resource__c);
        }
    }
    if(this.WebResources.size() == 0){
        for(Product2 p : products){
            cat1.add(!String.isBlank(p.class__c) ? p.class__c : p.id);
        }
    }
    AddRemoveCategories();
    return '';
}

public PageReference doNothing() {
    AddRemoveProducts();
    AddRemoveCategories();
    RefreshPBE();
    return null;
}

public ProductSelector ProductSelector {get{return new ProductSelector();} set;}

public list<string> products{get; set;}

public list<string> selectedProducts{get; set;}

public void AddRemoveProducts(){
    Product2[] products = ProductSelector.getAllOrderProducts(this.OrderId);
    set<string> productIds = new set<string>();
    for(product2 product : products){
        productIds.add(product.id);
    }
    Id[] ProductsToAdd = new Id[]{};
    Id[] ProductsToRemove = new Id[]{};     

    set<string> CurrentProducts = new set<string>();

    for(String c1 : this.cat1){
        if(c1.startsWith('01t')){
            CurrentProducts.add(c1);
        }
    }
    for(String c2 : this.cat2a){
        if(c2.startsWith('01t')){
            CurrentProducts.add(c2);
        }
    }

    for(String key : this.cat3a1.keySet()){
        for(string c3 : this.cat3a1.get(key)){
            if(c3.startsWith('01t')){
                CurrentProducts.add(c3);
            }
        }
    }
    for(String key : this.cat4a1.keySet()){
        for(string c4 : this.cat4a1.get(key)){
            if(c4.startsWith('01t')){
                CurrentProducts.add(c4);
            }
        }
    }   

    for(string p : CurrentProducts){
        if(!productIds.contains(p)){
            ProductsToAdd.add(p);
        }
    }
    
    for(product2 p : products){ //remove products
        if(!CurrentProducts.contains(p.id)){
            ProductsToRemove.add(p.id);
        }
    }

    set<string> ca1 = new set<string>(this.cat1);
    set<string> ca2 = new set<string>(this.cat2a);

    if(this.WebResources.size() != 0){
        for(Related_Resource__c rr : this.WebResources){
            //if the primary web resource is deselected, remove the product, and remove the class from ca2
            if(!ca1.contains(rr.primary_web_resource__c)){
            //    ProductsToRemove.add(rr.product__c);
//@@ASK SARAH AND ANDREW:  with the fact that a class or product can be associated to more than 1 WebResource, how should we handle the removal of a single WebResource selection?
//                ca2.remove();
//                CurrentProducts.remove(rr.primary_web_resource__c);
//                ca2.remove(rr.product__r.class__c != null ? rr.product__r.class__c : rr.product__c);
            }
        }
        for(product2 product : products){
            //if the class is not null, but cat2a does not contain the selected class, remove it from cat3a1
            if(!String.isBlank(product.class__c) && !ca2.contains(product.class__c)){
                ProductsToRemove.add(product.id);
                CurrentProducts.remove(product.id);
                if(this.cat3a1.keySet().contains(product.class__c)){
                    this.cat3a1.remove(product.class__c);
                }
                if(this.options3a1.keySet().contains(product.class__c)){
                    this.options3a1.remove(product.class__c);
                }
            }
        
            //if the product category is not null, but cat3a1.get(class) does not contain the selected class, remove it from 4a1
            if(!String.isBlank(product.category__c) && (cat3a1.get(product.class__c) == null || (cat3a1.get(product.class__c) != null && !new set<string>(cat3a1.get(product.class__c)).contains(product.class__c + ' - '+product.category__c)))){
                system.debug('remove product:  '+product.name);            
                ProductsToRemove.add(product.id);
                system.debug('Remove:  '+product.id);
                CurrentProducts.remove(product.id);
                if(this.cat4a1.get(product.class__c+' - '+product.category__c) != null){
                    this.cat4a1.remove(product.class__c+' - '+product.category__c);
                }
                if(this.options4a1.get(product.class__c+' - '+product.category__c) != null){
                    this.options4a1.remove(product.class__c+' - '+product.category__c);
                }
            }
        }
    }else{
        for(Product2 product : Products){
            if(!String.isBlank(product.class__c) && !ca1.contains(product.class__c)){
                ProductsToRemove.add(product.id);
                if(!String.isBlank(product.category__c) && ca2.contains(product.category__c)){
                    ca2.remove(product.category__c);
                }
            }
            if(!String.isBlank(product.category__c) && !ca2.contains(product.category__c)){
                ProductsToRemove.add(product.id);
                if(this.cat3a1.keySet().contains(product.category__c)){
                    this.cat3a1.remove(product.category__c);
                }
                if(this.options3a1.keySet().contains(product.category__c)){
                    this.options3a1.remove(product.category__c);
                }
            }
        }
    }
    this.cat2a = new List<String>(ca2);
    if(ProductsToAdd.size() != 0){
        ProductSelector.addProductsToOrder(this.OrderId, new list<id>(ProductsToAdd));
    }

    if(ProductsToRemove.size() != 0){
        ProductSelector.removeProductsFromOrder(this.OrderId, new list<id>(ProductsToRemove));
    } 

    //update the list of selected products
    products = ProductSelector.getAllOrderProducts(this.OrderId);
    set<string> OrderProductIds = new set<string>();
    for(product2 product : products){
        OrderProductIds.add(product.id);
    }
    this.SelectedProducts = new List<String>(OrderProductIds);
}

public string pricebookid {get; set;}
public string webresourcetype {get; set;}
public string OrderId {get; set;}
public boolean ShowProductSelector {get {if(this.showProductSelector == null){this.showProductSelector = true;} return this.ShowProductSelector;} set;}
public Related_Resource__c[] WebResources {get; set;}
public PriceBookEntry[] PBE {get; set;}

public map<id, string> IssueNameMap{ get; set; }

public String[] cat1 {get; set;}
public SelectOption[] options1{ get; set; }

public String[] cat2A {get; set;}
public SelectOption[] options2A { get; set; }

public map<string, list<string>> cat3a1 { get; set; }  //category name:  products
public map<string, selectOption[]> options3A1 {get; set;}

public map<string, list<string>> Cat4a1{ get; set; }  //
public map<string, selectOption[]> options4A1{ get; set; }

public boolean getShowSpecifically(){
    if(this.cat3a1 != null)
        return this.cat3a1.keyset().size() != 0;
    return false;
}

public map<string, string> getSelectedProductMap(){
    map<string, string> output = new map<string, string>();
    for(PricebookEntry pbentry : this.PBE){
        output.put(pbentry.product2id, pbentry.product2.name);
    }
    return output;    
}

public void AddRemoveCategories(){
    system.debug('Add Remove Categories');
    //Start With WebResource addition/removal
    boolean hasWebResources =  this.webResources.size() != 0;

    set<string> e1 = new set<string>();
    set<string> e2 = new set<string>();
    map<string, set<string>> e3 = new map<string, set<string>>();
    map<string, set<string>> e4 = new map<string, set<string>>();

    for(string c1 : this.cat1){
        e1.add(c1);
    }
    for(string c2 : this.cat2a){
//        e2.add(c2);
    }    
    
    for(string c3 : this.cat3a1.keySet()){
//        e3.put(c3, new set<string>(this.cat3a1.get(c3)));
    }

    for(string c4 : this.cat4a1.keySet()){
//        e4.put(c4, new set<string>(this.cat4a1.get(c4)));
    }    
    
    this.Options2A = new SelectOption[]{};
    this.Options3A1 = new map<string, SelectOption[]>();
    this.Options4A1 = new map<string, SelectOption[]>();

/*    Set<id> ProductIds = new Set<id>();
    for(PricebookEntry pbe : this.PBE){
        ProductIds.add(pbe.product2Id);
    }


    //get the list of Web Resources associated to this Product Selector
    this.WebResources = [select id, primary_web_resource__c, product__c, product__r.name, product__r.class__c, product__r.category__c, primary_web_resource__r.name, primary_web_resource__r.display_title__c from Related_Resource__c where Primary_Web_Resource__r.recordtype.developername = 'Web_Resource' AND primary_web_resource__r.type__c = :this.webresourcetype and Product__c in :ProductIds];
*/        
    set<string> c1 = new set<string>();  //The WebResource that the Selector will utilize
    set<string> c2 = new set<string>(); //the set of Class or Products
    map<string, set<string>> c3 = new map<string, set<string>>(); //map of Product Category or Product
    map<string, set<string>> c4 = new map<string, set<string>>(); //map of Products to Class-Category


    Product2[] products = ProductSelector.getAllOrderProducts(this.OrderId);
    set<string> OrderProductIds = new set<string>();
    for(product2 product : products){
        OrderProductIds.add(product.id);
    }
    this.SelectedProducts = new List<String>(OrderProductIds);

    //iterate over the secondary sections if there are product set
    for(Product2 product : products){
        //check 1:  webResources has records
        if(hasWebResources){
        //@@DAN:  this is the currently selected products code
        system.debug('272');
            for(Related_Resource__c rr : this.WebResources ) {
                if(rr.product__c == product.id){
                    if(!c1.contains(rr.primary_web_resource__c)){
                        c1.add(rr.primary_web_resource__c);
                    //    this.Options2a.add(new SelectOption(rr.product__r.class__c != null ? rr.product__r.class__c : rr.product__c, rr.product__r.class__c != null ? rr.product__r.class__c : rr.product__r.name));
                    }
                    if(!c2.contains(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c)){
                        c2.add(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c);
                        this.cat2a.add(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c);
                        this.Options2a.add(new SelectOption(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c, !String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__r.name));
                    }
                    if(!String.isBlank(rr.product__r.category__c) && !c3.keySet().contains(rr.product__r.class__c)){
                        c3.put(rr.product__r.class__c, new set<string>());                    
                    }
                    if(!String.isBlank(rr.product__r.category__c) && !c3.get(rr.product__r.class__c).contains(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c+' - '+rr.product__r.category__c : rr.product__c)){
//                        c3.get(rr.product__r.class__c).add(rr.product__r.category__c != null ? rr.product__r.class__c+' - '+rr.product__r.category__c : rr.product__c);//(new selectOption(rr.product__r.category__c != null ? rr.product__r.category__c : rr.product__c, rr.product__r.category__c != null ? rr.product__r.category__c : rr.product__r.name));
                    }

                    if(!String.isBlank(rr.product__r.class__c) && String.isBlank(rr.product__r.category__c)){
                        if(!this.options3a1.keySet().contains(rr.product__r.class__c)){
                            this.options3a1.put(rr.product__r.class__c, new SelectOption[]{});
                        }
                        if(!this.cat3a1.keySet().contains(rr.product__r.class__c)){
                            this.cat3a1.put(rr.product__r.class__c, new String[]{});
                        }
                        if(!new set<string>(this.cat3a1.get(rr.product__r.class__c)).contains(rr.product__c) && c2.contains(rr.product__r.class__c)){
                            this.cat3a1.get(rr.product__r.class__c).add(rr.product__c);                        
                        }
                    }
                    
                    if(!String.isBlank(rr.product__r.category__c) && !this.options3a1.keySet().contains(rr.product__r.class__c)){
                        this.options3a1.put(rr.product__r.class__c, new SelectOption[]{});
                    }                    
                    if(!String.isBlank(rr.product__r.category__c) && !this.cat3a1.keySet().contains(rr.product__r.class__c)){
                        this.cat3a1.put(rr.product__r.class__c, new String[]{});
                    }
                    if(!String.isBlank(rr.product__r.category__c) && !new set<string>(this.cat3a1.get(rr.product__r.class__c)).contains(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c+' - '+rr.product__r.category__c : rr.product__c)){
                        this.cat3a1.get(rr.product__r.class__c).add(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c+' - '+rr.product__r.category__c : rr.product__c);
//                        this.options3a1.get(rr.product__r.class__c).add(new selectOption(rr.product__r.category__c != null ? rr.product__r.class__c +' - '+rr.product__r.category__c : rr.product__c, rr.product__r.category__c != null ? rr.product__r.category__c : rr.product__r.name));
                    }

                    if(!String.isBlank(rr.product__r.category__c) && !c4.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                        c4.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new set<string>());                    
                    }
                    if(!String.isBlank(rr.product__r.category__c) && !c4.get(rr.product__r.class__c+' - '+rr.product__r.category__c).contains(rr.product__c)){
//                        c4.get(rr.product__r.class__c+' - '+rr.product__r.category__c).add(rr.product__c);
                    }
                    
                    if(!String.isBlank(rr.product__r.category__c) && !this.options4a1.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                        this.options4a1.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new SelectOption[]{});
                    }                    
                    if(!String.isBlank(rr.product__r.category__c) && !this.cat4a1.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                        this.cat4a1.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new String[]{});
                    }
                    if(!String.isBlank(rr.product__r.category__c) && !new set<string>(this.cat4a1.get(rr.product__r.class__c+' - '+rr.product__r.category__c)).contains(rr.product__c)){
                        this.cat4a1.get(rr.product__r.class__c+' - '+rr.product__r.category__c).add(rr.product__c);
//                        this.options4a1.get(rr.product__r.class__c+' - '+rr.product__r.category__c).add(new selectOption(rr.product__c, rr.product__r.name+' 317'));
                    }
                }
            }
        }else{
            //operate from the category level here
            for(PricebookEntry pbentry : this.PBE){
                //begin logic check for Class__c
                if(!c1.contains(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id)){
                    c1.add(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id);            
                    this.Options1.add(new SelectOption(!String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2id, !String.isBlank(pbentry.product2.class__c) ? pbentry.product2.class__c : pbentry.product2.name));
                }
            }
            if(!new set<string>(this.cat2a).contains(!String.isBlank(product.category__c) ? product.category__c : product.id))
                this.cat2a.add(!String.isBlank(product.category__c) ? product.category__c : product.id);
            if(!c1.contains(!String.isBlank(product.category__c) ? product.category__c : product.id)){
                c1.add(!String.isBlank(product.category__c) ? product.category__c : product.id);
                this.options2a.add(new SelectOption(!String.isBlank(product.category__c) ? product.category__c : product.id, !String.isBlank(product.category__c) ? product.category__c : product.name));
                e2.add(!String.isBlank(product.category__c) ? product.category__c : product.id);
            }
            
            if(!String.isBlank(product.category__c)){
                if(!this.cat3a1.keySet().contains(product.category__c)){
                    this.cat3a1.put(product.category__c, new list<String>());
                }
                this.cat3a1.get(product.category__c).add(product.id);

               if(!this.options3a1.keySet().contains(product.category__c)){
                    this.options3a1.put(product.category__c, new SelectOption[]{});
                }
                if(!c3.keySet().contains(product.category__c)){
                    c3.put(product.category__c, new set<string>());
                }
                if(!c3.get(product.category__c).contains(product.id)){
                    c3.get(product.category__c).add(product.id);
                //    this.options3a1.get(product.category__c).add(new SelectOption(product.id, product.name));
                } 
                           
            }
        }
    }
    if(hasWebResources){
        for(Related_Resource__c rr : this.WebResources){
        system.debug(rr.product__r);
        system.debug(rr);
            for(string ca1 : this.cat1){
                if(rr.primary_web_resource__c == ca1 && !c2.contains(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c)){
                    c2.add(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c);
                    this.options2a.add(new SelectOption(!String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__c, !String.isBlank(rr.product__r.class__c) ? rr.product__r.class__c : rr.product__r.name));
                }
                for(string ca2 : this.cat2a){
                    if(rr.primary_web_resource__c == ca1 && !ca2.startsWith('01t')){
                        if(!c3.keySet().contains(ca2)){
                            c3.put(ca2, new set<string>());
                        }
                        if(!this.cat3a1.keySet().contains(ca2)){
                            this.cat3a1.put(ca2, new String[]{});
                        }
                        if(!this.Options3a1.keySet().contains(ca2)){
                            this.Options3a1.put(ca2, new SelectOption[]{});
                        }
//@@DAN:  handle scenarios where category is not set.
                        if(!String.isBlank(rr.product__r.class__c) && 
                        ca2 == rr.product__r.class__c && 
                        !c3.get(ca2).contains(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c + ' - ' + rr.product__r.category__c: rr.product__c)){
                            this.Options3a1.get(ca2).add(new SelectOption(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c + ' - ' + rr.product__r.category__c: rr.product__r.id, !String.isBlank(rr.product__r.category__c) ? rr.product__r.category__c : rr.product__r.name));                        
                            c3.get(ca2).add(!String.isBlank(rr.product__r.category__c) ? rr.product__r.class__c + ' - ' + rr.product__r.category__c: rr.product__r.id);
                        }
                    }
                }
                for(string ca3 : this.cat3a1.keySet()){
                    if(new set<string>(this.cat1).contains(rr.primary_web_resource__c) && 
                    new set<string>(this.cat2a).contains(rr.product__r.class__c) && 
                    !String.isBlank(rr.product__r.category__c) && 
                    new set<string>(this.cat3a1.get(ca3)).contains(rr.product__r.class__c + ' - ' + rr.product__r.category__c)
                    && !c4.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                        if(!c4.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                            c4.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new set<string>());
                        }
                        if(!cat4a1.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                            cat4a1.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new List<string>());
                        }
                        if(!options4a1.keySet().contains(rr.product__r.class__c+' - '+rr.product__r.category__c)){
                            options4a1.put(rr.product__r.class__c+' - '+rr.product__r.category__c, new SelectOption[]{});
                        }
                    }
                    if(new set<string>(this.cat1).contains(rr.primary_web_resource__c) && 
                    new set<string>(this.cat2a).contains(rr.product__r.class__c) && 
                    !String.isBlank(rr.product__r.category__c) && 
                    new set<string>(this.cat3a1.get(ca3)).contains(rr.product__r.class__c + ' - ' + rr.product__r.category__c)
                    && !c4.get(rr.product__r.class__c+' - '+rr.product__r.category__c).contains(rr.product__c)){
                        if(!String.isBlank(rr.product__r.category__c) ){
                            c4.get(rr.product__r.class__c+' - '+rr.product__r.category__c).add(rr.product__c);
                            options4a1.get(rr.product__r.class__c+' - '+rr.product__r.category__c).add(new SelectOption(rr.product__c, rr.product__r.name));
                        }
                    }
                }
            }
        }
    }else{
        for(pricebookentry pe : pbe){
            for(string ca1 : this.cat1){
                if(ca1 == pe.product2.class__c && !e2.contains(!String.isBlank(pe.product2.category__c) ? pe.product2.category__c : pe.product2id)){
                    e2.add(!String.isBlank(pe.product2.category__c) ? pe.product2.category__c : pe.product2Id);
                    this.Options2a.add(new SelectOption(!String.isBlank(pe.product2.category__c) ? pe.product2.category__c : pe.product2Id, !String.isBlank(pe.product2.category__c) ? pe.product2.category__c : pe.product2.name));
                    break;
                }                
            }    
            for(string ca2 : this.cat2a){
                if(!String.isBlank(pe.product2.category__c) && e3.get(ca2) == null){
                      e3.put(ca2, new set<string>());
                }
                if(this.options3a1.get(ca2) == null && !ca2.startsWith('01t')){
                    this.options3a1.put(ca2, new SelectOption[]{});
                }
                if(this.cat3a1.get(ca2) == null && !ca2.startsWith('01t')){
                    this.cat3a1.put(ca2, new String[]{});
                }
                
                if(e3.get(ca2) != null && ca2 == pe.product2.category__c && e1.contains(pe.product2.class__c) && e2.contains(pe.product2.category__c) && !e3.get(ca2).contains(pe.product2Id)){
                    e3.get(ca2).add(pe.product2id);
                    this.options3a1.get(ca2).add(new SelectOption(pe.product2id, pe.product2.name));
                    break;
                }
            }
        }
    }
    this.options1 = ListUtils.sortSelectOptions(this.options1);
    this.options2a = ListUtils.sortSelectOptions(this.options2a);
    for(string key : this.options3a1.keySet()){
        this.options3a1.put(key, ListUtils.sortSelectOptions(this.options3a1.get(key)));
    }
    for(string key : this.options4a1.keySet()){
        this.options4a1.put(key, ListUtils.sortSelectOptions(this.options4a1.get(key)));
    }
    
}


}