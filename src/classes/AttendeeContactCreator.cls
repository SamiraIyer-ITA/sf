/**
 * Helps us to make sure no Attendee__c record ever goes into the database without a matching Contact.
 * If we couldn't find a Contact, create one (and possibly a related Account as well).
 */
global with sharing class AttendeeContactCreator implements valence.TransformationFilter {

  public Boolean validFor(valence.LinkContext context) {

    if('business_conference_participants'.equalsIgnoreCase(context.linkSourceName) && 'Attendee__c'.equalsIgnoreCase(context.linkTargetName)) {
      return true;
    }
    return false;
  }

  public void process(valence.LinkContext context, List<valence.RecordInFlight> records) {

    /*
     * 1. Find records that are missing a Contact
     * 2. Look for existing Accounts
     * 3. Create Accounts that need to be created
     * 4. Create Contacts that need to be created (attaching Accounts)
     * 5. Attach Contact Ids to appropriate RecordInFlight instances
     */

    List<valence.RecordInFlight> recordsMissingContact = new List<valence.RecordInFlight>();
    Set<String> namesOfCompanies = new Set<String>();
    for(valence.RecordInFlight record : records) {
      if(!record.getProperties().containsKey('Contact__c')) {
        recordsMissingContact.add(record);
        namesOfCompanies.add(String.valueOf(record.getOriginalProperties().get('company')));

        // TODO - remove
        record.addWarning('Creating a new Contact (and maybe a new Account)');
      }
    }

    // if all our records are good, bail out
    if(recordsMissingContact.isEmpty()) {
      return;
    }

    // fetch all existing Accounts we can find that would be associated with Contacts we're about to create
    Map<String, Id> companyIdByName = new Map<String, Id>();
    for(Account company : [SELECT Id, Name FROM Account WHERE Name IN :namesOfCompanies]) {
      companyIdByName.put(company.Name, company.Id);
    }

    // create new contact records in memory
    List<Contact> newContacts = new List<Contact>();
    Map<String, List<Contact>> accountsAndRelatedContacts = new Map<String, List<Contact>>();
    for(valence.RecordInFlight record : recordsMissingContact) {
      Contact newContact = contactFromRecord(record);
      String companyName = (String)record.getOriginalProperties().get('company');
      if(companyIdByName.containsKey(companyName)) {
        newContact.AccountId = companyIdByName.get(companyName);
      }
      else {
        if(!accountsAndRelatedContacts.containsKey(companyName)) {
          accountsAndRelatedContacts.put(companyName, new List<Contact>());
        }
        accountsAndRelatedContacts.get(companyName).add(newContact);
      }
      newContacts.add(newContact);
    }

    // if we have to create some accounts, create them now and backfill the related contacts
    if(!accountsAndRelatedContacts.isEmpty()) {
      List<Account> accountsToInsert = new List<Account>();
      for(String companyName : accountsAndRelatedContacts.keySet()) {
        accountsToInsert.add(new Account(Name = companyName));
      }
      insert accountsToInsert;

      for(Account company : accountsToInsert) {
        for(Contact relatedContact : accountsAndRelatedContacts.get(company.Name)) {
          relatedContact.AccountId = company.Id;
        }
      }
    }

    // write these new contacts to the database
    insert newContacts;

    // match inserted contacts back to records
    for(Integer i = 0, j = newContacts.size(); i < j; i++) {
      recordsMissingContact[i].getProperties().put('Contact__c', newContacts[i].Id);
    }
  }

  /**
   * Convert a RecordInFlight to a Contact.
   *
   * @param record
   *
   * @return A Contact with fields from the RecordInFlight
   */
  private Contact contactFromRecord(valence.RecordInFlight record) {

    Map<String, Object> props = record.getProperties();
    return new Contact(
      FirstName = String.valueOf(props.get('FirstName__c')),
      LastName = String.valueOf(props.get('LastName__c')),
      Email = String.valueOf(props.get('Email__c')),
      Phone = String.valueOf(props.get('Telephone__c')),
      Title = String.valueOf(props.get('Title__c')),
      MailingStreet = String.valueOf(props.get('MailingStreet__c')),
      MailingCity = String.valueOf(props.get('MailingCity__c')),
      MailingState = String.valueOf(props.get('MailingState__c')),
      MailingPostalCode = String.valueOf(props.get('MailingPostalCode__c')),
      MailingCountry = String.valueOf(props.get('MailingCountry__c'))
    );
  }
}