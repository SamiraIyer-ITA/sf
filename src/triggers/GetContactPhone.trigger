// TODO: This needs to be deleted in favor of creating a master case trigger that delegates to helper classes (CLC - 4/4/2019)
trigger GetContactPhone on Case (before update) {

	List<String> contactNamesList = new List<String>();
	List<Case> filteredCases = new List<Case>();

	for(Case c : Trigger.new){
		if(c.Copy_Contact_Phone__c != null) {
			filteredCases.add(c);
			contactNamesList.add(c.Contact_Name_copy__c);
		}
	}

	List<Contact> relevantContactsList = [
			SELECT Id, Name, Phone
			FROM Contact
			WHERE Name IN :contactNamesList
	];

	for(Case updatedCase : filteredCases){
		for(Contact existingContact : relevantContactsList){
			if(existingContact.Name == updatedCase.Contact_Name_copy__c){
				updatedCase.Copy_Contact_Phone__c = existingContact.Phone;
			}
		}
	}

}