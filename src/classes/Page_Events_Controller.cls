public class Page_Events_Controller{
	public Page__c[] newPages {get; set;}

	public Page_Events_Controller(Page__c[] newPages){
		this.newPages = newPages;
	}

	public void createCleanURL(){
		for(Page__c page : this.newPages){
			if(page.Clean_URL__c != null){
				page.Clean_URL__c = page.Clean_URL__c.replaceAll(' ', '-');  //replace all spaces with an underscore
				page.Clean_URL__c = page.Clean_URL__c.replaceAll('[^A-Za-z0-9_/-]', '');  //replace all non-numeric, non-forward-slash, and non-underscore with an empty space.
			}
			if(page.Clean_URL__c == null){
				page.Clean_URL__c = page.Name.replaceAll(' ', '-');  //replace all spaces with an underscore
				page.Clean_URL__c = page.Clean_URL__c.replaceAll('[^A-Za-z0-9_/-]', '');  //replace all non-numeric, non-forward-slash, and non-underscore with an empty space.
			}
			if(!page.Clean_URL__c.startsWith('/')){
				page.Clean_URL__c = '/'+page.Clean_URL__c;
			}
		}
	}

	public void checkExisting(){
		String[] existingPagesStrings = new String[]{};
		for(Page__c page : this.newPages){
			existingPagesStrings.add(page.Clean_URL__c);
		}

		List<URL__c> existingURLs = [
			SELECT Id, Friendly__c, Page__c, (SELECT Id, Site__c, Page__c FROM Clean_URLs__r)
			FROM URL__c
			WHERE Friendly__c = :existingPagesStrings
		];

		URL__c[] urlsToInsert = new URL__c[]{};
		Clean_URL__c[] cleanURLsToInsert = new Clean_URL__c[]{};
		for(Page__c page : this.newPages){
			Boolean exists = false;
			for(URL__c url : existingURLs){
				if(url.Friendly__c == page.Clean_URL__c){
					exists = true;
					Boolean existsClean = false;
					for(Clean_URL__c clean : url.Clean_URLs__r){
						if(clean.Site__c == page.Site__c && page.Site__c != null){
							existsClean = true;
							if(page.Id != clean.Page__c){
								page.Clean_URL__c.addError('A Clean URL already exists for another page on this site with this Nickname.');
							}
							break;
						}
					}
					if(!existsClean && page.Site__c != null){
						cleanURLsToInsert.add(new Clean_URL__c(Site__c = page.Site__c, URL__c = url.Id, Page__c = page.Id));
					}else{
						if (page.Id != url.Page__c && page.Site__c == null) {
							page.Clean_URL__c.addError('A Clean URL already exists for another page on this site with this Nickname.');
						}
					}
					break;
				}
			}
			if(!exists){
				if(page.Site__c != null){
					urlsToInsert.add(new URL__c(Friendly__c = page.Clean_URL__c));
				}else{
					urlsToInsert.add(new URL__c(Friendly__c = page.Clean_URL__c, Page__c = page.Id));
				}
			}
		}
		insert urlsToInsert;
		for(Page__c page: this.newPages){
			for(URL__c url : urlsToInsert){
				if(page.Site__c != null){
					cleanURLsToInsert.add(new Clean_URL__c(Site__c = page.Site__c, URL__c = url.Id, Page__c = page.Id));
				}
			}
		}
		insert cleanURLsToInsert;
	}
}