public with sharing class ProductSelectorComponent {

	private final String PRODUCT2_OBJECT_ID_PREFIX = '01t';

	/* Passed in via ProductSelector.component */
	public String WebResourceType {get; set;}       // Required
	public String PriceBookId {get; set;}           // Required
	public String OrderId {get; set;}               // Required
	public Boolean ShowProductSelector {get; set;}

	/* Referenced on the page */
	public List<String>                         Tier1Selected {get; set;}
	public List<String>                         Tier2Selected {get; set;}
	public Map<String, List<String>>            Tier3Selected {get; set;}
	public Map<String, List<String>>            Tier4Selected {get; set;}
	public List<SelectOption>                   Tier1VisibleSelectOptions {get; set;}
	public List<SelectOption>                   Tier2VisibleSelectOptions {get; set;}
	public Map<String, List<SelectOption>>      Tier3VisibleSelectOptions {get; set;}
	public Map<String, List<SelectOption>>      Tier4VisibleSelectOptions {get; set;}

	@TestVisible private List<PricebookEntry> PriceBookEntries {get; set;}
	@TestVisible private ProductSelector ProductSelector {get; set;}
	@TestVisible private Map<Id, Related_Resource__c> RelatedWebResources {get; set;}
	private Boolean HasWebResources {get; set;}

	public Map<String, String> AvailableProductsMap {get; set;}
	public List<String> SelectedProductIds {get; set;}
	private Map<Id, Product2> SelectedProductsMap {get; set;}

	private Set<String> Tier1DuplicateTracker {get; set;}
	private Set<String> Tier2DuplicateTracker {get; set;}
	private Map<String, Set<String>> Tier3DuplicateTracker {get; set;}
	private Map<String, Set<String>> Tier4DuplicateTracker {get; set;}

	public String getInit(){

		/* This is the only property of the four that are passed in to the component that is required and could be empty */
		if(this.ShowProductSelector == null){
			this.ShowProductSelector = true;
		}

		/* Referenced on the page */
		this.Tier1Selected = new List<String>();
		this.Tier2Selected = new List<String>();
		this.Tier3Selected = new Map<String, List<String>>();
		this.Tier4Selected = new Map<String, List<String>>();
		this.Tier1VisibleSelectOptions = new List<SelectOption>();
		this.Tier2VisibleSelectOptions = new List<SelectOption>();
		this.Tier3VisibleSelectOptions = new Map<String, List<SelectOption>>();
		this.Tier4VisibleSelectOptions = new Map<String, List<SelectOption>>();

		this.PriceBookEntries = new List<PricebookEntry>();
		this.ProductSelector = new ProductSelector();
		this.RelatedWebResources = new Map<Id, Related_Resource__c>();

		this.AvailableProductsMap = new Map<String, String>();
		this.SelectedProductIds = new List<String>();
		this.SelectedProductsMap = new Map<Id, Product2>();

		this.Tier1DuplicateTracker = new Set<String>();
		this.Tier2DuplicateTracker = new Set<String>();
		this.Tier3DuplicateTracker = new Map<String, Set<String>>();
		this.Tier4DuplicateTracker = new Map<String, Set<String>>();

		setPriceBookEntries();

		setRelatedWebResources();

		setAvailableProductsMap();

		setSelectedProducts();

		populateProductSelector();

		return '';
	}

	private void setPriceBookEntries(){
		if(String.isEmpty(this.PriceBookId)){
			throw new ProductSelectorComponentException('Invalid Pricebook Id provided');
		}

		this.PriceBookEntries = [
			SELECT Id, UnitPrice, Product2Id, Product2.Name, Product2.Family, Product2.Class__c, Product2.Category__c
			FROM PricebookEntry
			WHERE Pricebook2Id = :THIS.PriceBookId
			AND IsActive = TRUE
		];
	}

	private void setRelatedWebResources(){
		Set<Id> productIdsFromPriceBookEntries = new Set<Id>();
		for(PricebookEntry priceBookEntry : this.PriceBookEntries){
			productIdsFromPriceBookEntries.add(priceBookEntry.Product2Id);
		}

		this.RelatedWebResources = new Map<Id, Related_Resource__c>([
			SELECT Id, Primary_Web_Resource__c, Product__c, Product__r.Name, Product__r.Class__c,
				Product__r.Category__c, Primary_Web_Resource__r.Name, Primary_Web_Resource__r.Display_Title__c
			FROM Related_Resource__c
			WHERE Primary_Web_Resource__r.RecordType.DeveloperName = 'Web_Resource'
			AND Primary_Web_Resource__r.Type__c = :THIS.WebResourceType
			AND Product__c IN :productIdsFromPriceBookEntries
		]);

		setHasWebResources();

		System.debug('RelatedWebResources.size() = ' + RelatedWebResources.size());
	}

	private void setHasWebResources(){
		if(this.RelatedWebResources.size() > 0){
			this.HasWebResources = true;
		} else {
			this.HasWebResources = false;
		}
	}

	public void setAvailableProductsMap(){
		for(PricebookEntry priceBookEntryItem : this.PriceBookEntries){
			this.AvailableProductsMap.put(priceBookEntryItem.Product2Id, priceBookEntryItem.Product2.Name);
		}
	}

	private void setSelectedProducts(){
		List<Product2> tempProductList = ProductSelector.getAllOrderProducts(this.OrderId);
		this.SelectedProductIds = new List<String>();
		this.SelectedProductsMap = new Map<Id, Product2>();
		for(Product2 product : tempProductList){
			this.SelectedProductIds.add(product.Id);
			this.SelectedProductsMap.put(product.Id, product);
		}
	}

	public PageReference refreshPage(){
		resetVariables();
		addRemoveProducts();
		populateProductSelector();
		return null;
	}

	private void populateProductSelector(){
		populateTier1();
		populateLaterTiers();
	}

	private void populateTier1(){
		if(this.HasWebResources){
			populateTier1_WebResourceVersion();
		} else {
			populateTier1_PriceBookVersion();
		}
	}

	private void populateTier1_WebResourceVersion(){
		Set<Id> tier1VisibleDupeCheckSet = new Set<Id>();
		for(Related_Resource__c rr : this.RelatedWebResources.values()){
			String productId = rr.Product__c;
			String primaryResourceId = rr.Primary_Web_Resource__c;
			String primaryResourceName = rr.Primary_Web_Resource__r.Name;
			String primaryResourceDisplayTitle = rr.Primary_Web_Resource__r.Display_Title__c;
			if(this.SelectedProductsMap.keySet().contains(productId)){
				if(this.Tier1DuplicateTracker.contains(primaryResourceId)){
					continue;
				}
				this.Tier1DuplicateTracker.add(primaryResourceId);
				this.Tier1Selected.add(primaryResourceId);
			}
			// we always add every possible tier 1 value
			if(!tier1VisibleDupeCheckSet.contains(primaryResourceId)){
				if(String.isNotEmpty(primaryResourceDisplayTitle)){
					this.Tier1VisibleSelectOptions.add(new SelectOption(primaryResourceId, primaryResourceDisplayTitle));
				} else {
					this.Tier1VisibleSelectOptions.add(new SelectOption(primaryResourceId, primaryResourceName));
				}
				tier1VisibleDupeCheckSet.add(primaryResourceId);
			}
		}
	}

	private void populateTier1_PriceBookVersion(){
		Set<String> tier1VisibleDupeCheckSet = new Set<String>();
		for(PricebookEntry priceBookEntryItem : this.PriceBookEntries){
			String productId = priceBookEntryItem.Product2Id;
			String productName = priceBookEntryItem.Product2.Name;
			String productClass = priceBookEntryItem.Product2.Class__c;
			String value = (!String.isBlank(productClass)) ? productClass : productName;
			if(this.SelectedProductsMap.keySet().contains(productId)){
				if(this.Tier1DuplicateTracker.contains(productClass)){
					continue;
				}
				this.Tier1DuplicateTracker.add(productClass);
				this.Tier1Selected.add(productClass);
			}
			this.Tier1DuplicateTracker.addAll(this.Tier1Selected);
			if(!tier1VisibleDupeCheckSet.contains(productClass)){
				this.Tier1VisibleSelectOptions.add(new SelectOption(productClass, value));
				tier1VisibleDupeCheckSet.add(productClass);
			}
		}
	}

	public void populateLaterTiers(){
		setSelectedProducts();
		if(this.HasWebResources){
			populateTier234_WebResourceVersion_ForEverySelectedProduct();
			populateTier234_WebResourceVersion_ForEveryWebResource();
		} else {
			populateTier234_PriceBookVersion_ForEverySelectedProduct();
			populateTier234_PriceBookVersion_ForEveryPriceBookEntry();
		}
		sortTiersForPresentation();
	}

	private void resetVariables(){
		this.Tier1VisibleSelectOptions = new List<SelectOption>();
		this.Tier2VisibleSelectOptions = new List<SelectOption>();
		this.Tier3VisibleSelectOptions = new Map<String, List<SelectOption>>();
		this.Tier4VisibleSelectOptions = new Map<String, List<SelectOption>>();

		this.Tier1DuplicateTracker = new Set<String>();
		this.Tier2DuplicateTracker = new Set<String>();
		this.Tier3DuplicateTracker = new Map<String, Set<String>>();
		this.Tier4DuplicateTracker = new Map<String, Set<String>>();
	}

	private void populateTier234_WebResourceVersion_ForEverySelectedProduct(){
		for(Related_Resource__c rr : this.RelatedWebResources.values()){

			// THIS IS WHERE WE CHANGE GEARS AND GO BY EVERY ~SELECTED~ PRODUCT RATHER THAN EVERY RESOURCE
			if(!this.SelectedProductsMap.containsKey(rr.Product__c)){
				continue;
			}

			String productId = rr.Product__c;
			String productName = rr.Product__r.Name;
			String productClass = rr.Product__r.Class__c;
			String productCategory = rr.Product__r.Category__c;
			String productClassCategoryString = rr.Product__r.Class__c + ' - ' + rr.Product__r.Category__c;
			String primaryResourceId = rr.Primary_Web_Resource__c;
			String key = (String.isNotBlank(productCategory))? productClassCategoryString : productId;

			// TIER 2 /////////////////////////////////////////////////////////////
			if(String.isNotEmpty(productClass)){
				if(!this.Tier2DuplicateTracker.contains(productClass)){
					this.Tier2DuplicateTracker.add(productClass);
					this.Tier2Selected.add(productClass);
					this.Tier2VisibleSelectOptions.add(new SelectOption(productClass, productClass));
				}
			} else {
				if(!this.Tier2DuplicateTracker.contains(productId)){
					this.Tier2DuplicateTracker.add(productId);
					this.Tier2VisibleSelectOptions.add(new SelectOption(productId, productName));
					this.Tier2Selected.add(productId);
					continue;
				}
			}

			// TIER 3 ////////////////////////////////////////////////////////////
			if(String.isNotBlank(productClass)){
				if (String.isNotBlank(productCategory) && !this.Tier3DuplicateTracker.keySet().contains(productClass)) {
					this.Tier3DuplicateTracker.put(productClass, new Set<String>());
				}
				if (String.isBlank(productCategory)) {
					if (!this.Tier3Selected.keySet().contains(productClass)) {
						this.Tier3Selected.put(productClass, new List<String>());
					}
					if (!this.Tier3Selected.keySet().contains(productId) && this.Tier2DuplicateTracker.contains(productClass)) {
						this.Tier3Selected.get(productClass).add(productId);
					}
				}
				if (!this.Tier3VisibleSelectOptions.keySet().contains(productClass)) {
					this.Tier3VisibleSelectOptions.put(productClass, new List<SelectOption>());
				}
				if (String.isNotBlank(productCategory) && !this.Tier3Selected.keySet().contains(productClass)) {
					this.Tier3Selected.put(productClass, new List<String>());
				}
				if (String.isNotBlank(productCategory) && !new Set<String>(this.Tier3Selected.get(productClass)).contains(key)) {
					this.Tier3Selected.get(productClass).add(key);
				}
			} else {
				// do nothing for now
			}

			// TIER 4 /////////////////////////////////////////////////////////////
			if(String.isNotBlank(productCategory)) {
				if (!this.Tier4DuplicateTracker.keySet().contains(productClassCategoryString)) {
					this.Tier4DuplicateTracker.put(productClassCategoryString, new Set<String>());
				}
				if (!this.Tier4VisibleSelectOptions.keySet().contains(productClassCategoryString)) {
					this.Tier4VisibleSelectOptions.put(productClassCategoryString, new List<SelectOption>());
				}
				if (!this.Tier4Selected.keySet().contains(productClassCategoryString)) {
					this.Tier4Selected.put(productClassCategoryString, new List<String>());
				}
				if (!new Set<String>(this.Tier4Selected.get(productClassCategoryString)).contains(productId)) {
					this.Tier4Selected.get(productClassCategoryString).add(productId);
				}
			} else {
				// do nothing for now
			}
		}
	}

	private void populateTier234_WebResourceVersion_ForEveryWebResource(){
		for(Related_Resource__c rr : this.RelatedWebResources.values()){
			String productId = rr.Product__c;
			String productName = rr.Product__r.Name;
			String productClass = rr.Product__r.Class__c;
			String productCategory = rr.Product__r.Category__c;
			String productClassCategoryString = rr.Product__r.Class__c + ' - ' + rr.Product__r.Category__c;
			String primaryResourceId = rr.Primary_Web_Resource__c;
			String key = String.isNotBlank(productCategory) ? productClassCategoryString : productId;
			String value = String.isNotBlank(productCategory) ? productCategory : productName;

			for (String tier1SelectedPrimaryResourceId : this.Tier1Selected){
				if(primaryResourceId == tier1SelectedPrimaryResourceId){
					if(String.isNotBlank(productClass)){
						if(!this.Tier2DuplicateTracker.contains(productClass)){
							this.Tier2DuplicateTracker.add(productClass);
							this.Tier2VisibleSelectOptions.add(new SelectOption(productClass, productClass));
						}
					} else if(!this.Tier2DuplicateTracker.contains(productId)){
						this.Tier2DuplicateTracker.add(productId);
						this.Tier2VisibleSelectOptions.add(new SelectOption(productId, productName));
					}

					for (String tier2ProductClass : this.Tier2Selected) {
						if (!isProductId(tier2ProductClass)) {
							// first time; init t3DupeTracker
							if (!this.Tier3DuplicateTracker.keySet().contains(tier2ProductClass)) {
								this.Tier3DuplicateTracker.put(tier2ProductClass, new Set<String>());
							}
							// first time; init t3Selected
							if (!this.Tier3Selected.keySet().contains(tier2ProductClass)) {
								this.Tier3Selected.put(tier2ProductClass, new List<String>());
							}
							// first time; init t3VisibleSelectOptions
							if (!this.Tier3VisibleSelectOptions.keySet().contains(tier2ProductClass)) {
								this.Tier3VisibleSelectOptions.put(tier2ProductClass, new List<SelectOption>());
							}

							if (String.isNotBlank(productClass) &&
								tier2ProductClass == productClass &&
								!this.Tier3DuplicateTracker.get(tier2ProductClass).contains(key)) {
									this.Tier3VisibleSelectOptions.get(tier2ProductClass).add(new SelectOption(key, value));
									this.Tier3DuplicateTracker.get(tier2ProductClass).add(key);
							}
						}
					}

				}

				Set<String> tier1SelectedSet = new Set<String>(this.Tier1Selected);
				Set<String> tier2SelectedSet = new Set<String>(this.Tier2Selected);

				for (String tier3String : this.Tier3Selected.keySet()){

					Set<String> tier3SelectedSpecific = new Set<String>( this.Tier3Selected.get(tier3String) );
					if(tier1SelectedSet.contains(primaryResourceId)
							&& tier2SelectedSet.contains(rr.Product__r.Class__c)
							&& String.isNotBlank(productCategory)
							&& tier3SelectedSpecific.contains(productClassCategoryString)
							&& !this.Tier4DuplicateTracker.keySet().contains(productClassCategoryString))
					{
						if(!this.Tier4DuplicateTracker.keySet().contains(productClassCategoryString)){
							this.Tier4DuplicateTracker.put(productClassCategoryString, new Set<String>());
						}

						if(!this.Tier4Selected.keySet().contains(productClassCategoryString)){
							this.Tier4Selected.put(productClassCategoryString, new List<String>());
						}

						if(!this.Tier4VisibleSelectOptions.keySet().contains(productClassCategoryString)){
							this.Tier4VisibleSelectOptions.put(productClassCategoryString, new List<SelectOption>());
						}
					}

					if(tier1SelectedSet.contains(primaryResourceId)
						&& tier2SelectedSet.contains(productClass)
						&& String.isNotBlank(productCategory)
						&& tier3SelectedSpecific.contains(productClassCategoryString)
						&& !this.Tier4DuplicateTracker.get(productClassCategoryString).contains(productId))
					{
							this.Tier4DuplicateTracker.get(productClassCategoryString).add(productId);
							this.Tier4VisibleSelectOptions.get(productClassCategoryString).add(new SelectOption(productId, productName));
					}
				}
			}
		}
	}

	private void populateTier234_PriceBookVersion_ForEverySelectedProduct(){
		for(Product2 selectedProduct : this.SelectedProductsMap.values()){
			String productId = selectedProduct.Id;
			String productName = selectedProduct.Name;
			String productCategory = selectedProduct.Category__c;
			String key = !String.isBlank(productCategory) ? productCategory : productId;
			String value = !String.isBlank(productCategory) ? productCategory : selectedProduct.Name;

			if(this.Tier2Selected != null){
				Set<String> tier2SelectedSet = new Set<String>(this.Tier2Selected);
				if(tier2SelectedSet != null && !tier2SelectedSet.contains(key)){
					this.Tier2Selected.add(key);
				}
			}
			if(!this.Tier2DuplicateTracker.contains(key)){
				this.Tier2DuplicateTracker.add(key);
				this.Tier2VisibleSelectOptions.add(new SelectOption(key, value));
			}

			if(!String.isBlank(productCategory)){
				if(!this.Tier3Selected.keySet().contains(productCategory)){
					this.Tier3Selected.put(productCategory, new List<String>());
				}

				if(!this.Tier3VisibleSelectOptions.keySet().contains(productCategory)){
					this.Tier3VisibleSelectOptions.put(productCategory, new List<SelectOption>());
				}

				if(!this.Tier3DuplicateTracker.keySet().contains(productCategory)){
					this.Tier3DuplicateTracker.put(productCategory, new Set<String>());
				}

				this.Tier3Selected.get(productCategory).add(productId);

				if(!this.Tier3DuplicateTracker.get(productCategory).contains(productId)){
					this.Tier3DuplicateTracker.get(productCategory).add(productId);
					this.Tier3VisibleSelectOptions.get(productCategory).add(new SelectOption(productId, productName));
				}
			}
		}
	}

	private void populateTier234_PriceBookVersion_ForEveryPriceBookEntry(){
		for(PricebookEntry priceBookEntryItem : this.PriceBookEntries){
			String productId = priceBookEntryItem.Product2Id;
			String productName = priceBookEntryItem.Product2.Name;
			String productClass = priceBookEntryItem.Product2.Class__c;
			String productCategory = priceBookEntryItem.Product2.Category__c;
			for(String tier1SelectedProductClass : this.Tier1Selected){
				String key = (!String.isBlank(productCategory)) ? productCategory : productId;
				String value = (!String.isBlank(productCategory)) ? productCategory : productName;
				if(tier1SelectedProductClass == productClass && !this.Tier2DuplicateTracker.contains(key)){
					this.Tier2DuplicateTracker.add(key);
					this.Tier2VisibleSelectOptions.add(new SelectOption(key, value));
					break;
				}
			}
			for(String tier2String : this.Tier2Selected){
				if(!String.isBlank(productCategory) && this.Tier3DuplicateTracker.get(tier2String) == null){
					this.Tier3DuplicateTracker.put(tier2String, new Set<String>());
				}
				if(this.Tier3VisibleSelectOptions.get(tier2String) == null && !isProductId(tier2String)){
					this.Tier3VisibleSelectOptions.put(tier2String, new List<SelectOption>());
				}
				if(this.Tier3Selected.get(tier2String) == null && !isProductId(tier2String)){
					this.Tier3Selected.put(tier2String, new List<String>());
				}
				if(
					this.Tier3DuplicateTracker.get(tier2String) != null
					&& tier2String == productCategory
					&& this.Tier1DuplicateTracker.contains(productClass)
					&& this.Tier2DuplicateTracker.contains(productCategory)
					&& !this.Tier3DuplicateTracker.get(tier2String).contains(productId))
				{
						this.Tier3DuplicateTracker.get(tier2String).add(productId);
						this.Tier3VisibleSelectOptions.get(tier2String).add(new SelectOption(productId, productName));
						break;
				}
			}
		}
	}

	private void sortTiersForPresentation(){
		this.Tier1VisibleSelectOptions = ListUtils.sortSelectOptions(this.Tier1VisibleSelectOptions);
		this.Tier2VisibleSelectOptions = ListUtils.sortSelectOptions(this.Tier2VisibleSelectOptions);
		for(String key : this.Tier3VisibleSelectOptions.keySet()){
			this.Tier3VisibleSelectOptions.put(key, ListUtils.sortSelectOptions(this.Tier3VisibleSelectOptions.get(key)));
		}
		for(String key : this.Tier4VisibleSelectOptions.keySet()){
			this.Tier4VisibleSelectOptions.put(key, ListUtils.sortSelectOptions(this.Tier4VisibleSelectOptions.get(key)));
		}
	}

	/* These properties are only used in the next few methods. Rather than confuse the reader as to where they are used
		I've put them directly next to the first method in which they are used. They are properties because I didn't want to
		pass them to the methods they are used.
	 */
	private List<Id> productsToAdd = new List<Id>();
	private List<Id> productsToRemove = new List<Id>();
	private Set<String> currentProducts = new Set<String>();
	private Set<String> tier1SelectedSet, tier2SelectedSet;
	public void addRemoveProducts(){
		setSelectedProducts();
		if(this.productsToAdd.size() != 0) this.productsToAdd = new List<Id>();
		if(this.productsToRemove.size() != 0) this.productsToRemove = new List<Id>();
		this.currentProducts = getSelectedProductStrings();
		this.tier1SelectedSet = new Set<String>(this.Tier1Selected);
		this.tier2SelectedSet = new Set<String>(this.Tier2Selected);
		for(String p : this.currentProducts){
			if(!this.SelectedProductsMap.keySet().contains(p)){
				this.productsToAdd.add(p);
			}
		}
		for(Product2 p : this.SelectedProductsMap.values()){
			if(!this.currentProducts.contains(p.Id)){
				this.productsToRemove.add(p.Id);
			}
		}
		if(this.HasWebResources){
			addRemoveProducts_WebVersion();
		} else{
			addRemoveProducts_PriceBookVersion();
		}
		this.Tier2Selected = new List<String>(this.tier2SelectedSet);
		if(productsToAdd.size() != 0){
			ProductSelector.addProductsToOrder(this.OrderId, new List<Id>(productsToAdd));
		}
		if(productsToRemove.size() != 0){
			ProductSelector.removeProductsFromOrder(this.OrderId, new List<Id>(productsToRemove));
		}

		setSelectedProducts();
	}

	private void addRemoveProducts_WebVersion(){
		for(Product2 product : this.SelectedProductsMap.values()){
			String productId = product.Id;
			String productClass = product.Class__c;
			String productCategory = product.Category__c;
			String productClassCategoryString = productClass + ' - ' + productCategory;
			Set<String> tier3SpecificClassSelectedSet = new Set<String>();
			if(this.Tier3Selected.containsKey(productClass)){
				tier3SpecificClassSelectedSet = new Set<String>(this.Tier3Selected.get(productClass));
			}
			// remove products associated with a tier 2 item that has been unselected
			if(String.isNotBlank(productClass) && !this.tier2SelectedSet.contains(productClass)){
				if(this.Tier3Selected.keySet().contains(productClass)){
					this.Tier3Selected.remove(productClass);
				}
				if(this.Tier3VisibleSelectOptions.keySet().contains(productClass)){
					this.Tier3VisibleSelectOptions.remove(productClass);
				}
			}
			// remove products associated with a tier 3 item that has been unselected
			if(
				( String.isNotBlank(productCategory) && !this.Tier3Selected.containsKey(productClass) )
				|| ( this.Tier3Selected.containsKey(productClass) && !tier3SpecificClassSelectedSet.contains(productClassCategoryString) )
			){
					if(this.Tier4Selected.get(productClassCategoryString) != null){
						this.Tier4Selected.remove(productClassCategoryString);
					}
					if(this.Tier4VisibleSelectOptions.get(productClassCategoryString) != null){
						this.Tier4VisibleSelectOptions.remove(productClassCategoryString);
					}
			}
		}
	}

	private void addRemoveProducts_PriceBookVersion(){
		for(Product2 product : this.SelectedProductsMap.values()){
			String productId = product.Id;
			String productClass = product.Class__c;
			String productCategory = product.Category__c;
			/*
				If product class in question has been removed from the selected set in tier 1 then remove all products
				associated with that class.
			*/
			if(String.isNotBlank(productClass) && !tier1SelectedSet.contains(productClass)){
				this.productsToRemove.add(productId);
			}
			/*
				If a product category exists in the selected options but doesn't exist in the tier2selected set anymore then
				remove all products associated with it.
			*/
			if(String.isNotBlank(productCategory) && !tier2SelectedSet.contains(productCategory)){
				this.productsToRemove.add(productId);
				if(this.Tier3Selected.keySet().contains(productCategory)){
					this.Tier3Selected.remove(productCategory);
				}
				if(this.Tier3VisibleSelectOptions.keySet().contains(productCategory)){
					this.Tier3VisibleSelectOptions.remove(productCategory);
				}
			}
		}
	}

	public Boolean getShowSpecificProductsHeader(){
		if(this.Tier3Selected != null){
			return this.Tier3Selected.keySet().size() != 0;
		}
		return false;
	}

	private Boolean isProductId(String idString){
		if(!String.isEmpty(idString)){
			if(idString.startsWith(PRODUCT2_OBJECT_ID_PREFIX)){
				return true;
			}
		}
		return false;
	}

	private Set<String> getSelectedProductStrings(){
		Set<String> currentProductsSet = new Set<String>();
		currentProductsSet.addAll(this.Tier1Selected);

		currentProductsSet.addAll(this.Tier2Selected);

		for(List<String> productId : this.Tier3Selected.values()){
			currentProductsSet.addAll(productId);
		}

		for(List<String> productId : this.Tier4Selected.values()){
			currentProductsSet.addAll(productId);
		}

		for(String productId : currentProductsSet){
			if(!isProductId(productId)) {
				currentProductsSet.remove(productId);
			}
		}
		return currentProductsSet;
	}

	public class ProductSelectorComponentException extends Exception{}
}
