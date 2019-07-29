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

        //Organization variables
        Set<String> organizationNames = new Set<String>();
        Map<String,Account> organizationNameToExistingOrganization = new Map<String,Account>();
        Map<String,Account> organizationNameToNewOrganization = new Map<String,Account>();
        Id orgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ITA_User_Account_RT').getRecordTypeId();

        //Contact variables
        Set<String> contactEmails = new Set<String>();
        Map<String,Contact> contactEmailToExistingContact = new Map<String,Contact>();
        Map<String,Contact> contactEmailToNewContact = new Map<String,Contact>();
        Map<String,valence.RecordInFlight> emailToAttendee = new Map<String,valence.RecordInFlight>();
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ITA_Contacts').getRecordTypeId();


        Map<String,String> emailToOrganizationName = new Map<String,String>();

        //Collect Organization Names and filter out trade.gov email
        for(valence.RecordInFlight record : records) {
            //Do not create Organization or Contact if Attendee has a .gov email
            if(String.valueOf(record.getOriginalProperties().get('email')) != null && String.valueOf(record.getOriginalProperties().get('email')).toLowerCase().endsWith('.gov') == false) {
                if(!String.isBlank(String.valueOf(record.getOriginalProperties().get('company')))) {
                    organizationNames.add(String.valueOf(record.getOriginalProperties().get('company')));
                }
                if(!String.isBlank(String.valueOf(record.getOriginalProperties().get('email')))) {
                    contactEmails.add(String.valueOf(record.getOriginalProperties().get('email')));
                    emailToAttendee.put(String.valueOf(record.getOriginalProperties().get('email')),record);
                }
                if(!String.isBlank(String.valueOf(record.getOriginalProperties().get('company'))) && !String.isBlank(String.valueOf(record.getOriginalProperties().get('email')))) {
                    emailToOrganizationName.put(String.valueOf(record.getOriginalProperties().get('email')),String.valueOf(record.getOriginalProperties().get('company')));
                }
            }
        }

        //Use Organization Names to find existing Organizations with those names, map them
        for(Account organization : [SELECT Name FROM Account WHERE Name IN :organizationNames]) {
            if(!organizationNameToExistingOrganization.containsKey(organization.Name)) {
                organizationNameToExistingOrganization.put(organization.Name, organization);
            }
        }

        //Iterate through Attendee company names and collect the ones that don't have any matching Organizations,
        //  then create new Organizations for those names that still don't have an Org, then map the new orgs by name
        for(String orgName : organizationNames) {
            if(organizationNameToExistingOrganization.containsKey(orgName) || organizationNameToNewOrganization.containsKey(orgName)) {
                //Organization already exists with that name, do nothing
            } else {
                //Organization doesn't already exist, create it and map it
                Account newOrganization = new Account(Name = orgName, recordTypeId = orgRecordTypeId);
                organizationNameToNewOrganization.put(orgName,newOrganization);
            }
        }

        //Insert the new organizations
        Database.insert(organizationNameToNewOrganization.values(),false);

        //Update the map of Names to Existing Organizations to include the newly inserted ones
        for(String key : organizationNameToNewOrganization.keySet()) {
            if(!organizationNameToExistingOrganization.containsKey(key)) {
                organizationNameToExistingOrganization.put(key,organizationNameToNewOrganization.get(key));
            }
        }

        //Use contact emails to find existing contacts, map them
        for(Contact contact : [SELECT Id, Email from Contact where Email IN :contactEmails]) {
            contactEmailToExistingContact.put(contact.Email, contact);
        }

        //Find unmatched contacts and create new contacts
        for(String contactEmail : contactEmails) {
            if(contactEmailToExistingContact.containsKey(contactEmail) || contactEmailToNewContact.containsKey(contactEmail)) {
                //Contact already exists with that email, do nothing
            } else {
                //Contact doesn't already exist, create it and map it
                valence.RecordInFlight record = emailToAttendee.get(contactEmail);
                Map<String, Object> props = record.getProperties();
                Contact newContact = new Contact(
                        FirstName = String.valueOf(props.get('FirstName__c')),
                        LastName = String.valueOf(props.get('LastName__c')),
                        Email = contactEmail,
                        Phone = String.valueOf(props.get('Telephone__c')),
                        Title = String.valueOf(props.get('Title__c')),
                        MailingStreet = String.valueOf(props.get('MailingStreet__c')),
                        MailingCity = String.valueOf(props.get('MailingCity__c')),
                        MailingState = String.valueOf(props.get('MailingState__c')),
                        MailingPostalCode = String.valueOf(props.get('MailingPostalCode__c')),
                        MailingCountry = String.valueOf(props.get('MailingCountry__c')),
                        RecordTypeId = contactRecordTypeId
                );
                if(organizationNameToExistingOrganization.get(emailToOrganizationName.get(contactEmail)) != null) {
                    //this conditional is to prevent a very rare edge case with a null pointer exception
                    newContact.AccountId = organizationNameToExistingOrganization.get(emailToOrganizationName.get(contactEmail)).Id;
                }
                contactEmailToNewContact.put(newContact.Email,newContact);
            }
        }

        //Insert the new contacts
        Database.insert(contactEmailToNewContact.values(),false);

        //Add newly inserted contacts with newly generated Ids into the map of existing contacts
        contactEmailToExistingContact.putAll(contactEmailToNewContact);

        //Update Attendee record with newly created or existing Contact Id (as long as they are not trade.gov)
        for(valence.RecordInFlight record : records) {
            if(String.valueOf(record.getOriginalProperties().get('email')).toLowerCase().endsWith('.gov') == false) {
                record.getProperties().put('Contact__c', contactEmailToExistingContact.get(String.valueOf(record.getOriginalProperties().get('email'))).Id);
            }
        }
    }
}