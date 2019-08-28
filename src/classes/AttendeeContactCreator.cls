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
        Map<String,Id> organizationNameToOrganizationOwnerId = new Map<String,Id>();
        Id orgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ITA_User_Account_RT').getRecordTypeId();

        //Contact variables
        Set<String> contactEmails = new Set<String>();
        Map<String,Contact> contactEmailToExistingContact = new Map<String,Contact>();
        Map<String,Contact> contactEmailToNewContact = new Map<String,Contact>();
        Map<String,valence.RecordInFlight> emailToAttendee = new Map<String,valence.RecordInFlight>();
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ITA_Contacts').getRecordTypeId();
        Map<String,String> emailToOrganizationName = new Map<String,String>();

        List<User> automatedProcessUser = [SELECT Id FROM User WHERE Name = 'Automated Process' ORDER BY CreatedDate ASC LIMIT 1];
        Id automatedProcessId = null;
        if(!automatedProcessUser.isEmpty()) {
            automatedProcessId = automatedProcessUser[0].Id;
        }
        Set<Id> businessConferenceIds = new Set<Id>();
        Map<String,String> orgNameToBusinessConferenceId = new Map<String,String>();

        //Collect Organization Names and filter out trade.gov email
        for(valence.RecordInFlight record : records) {
            //Do not create Organization or Contact if Attendee has a .gov email
            String company = String.valueOf(record.getProperties().get('Company__c'));
            String email = String.valueOf(record.getProperties().get('Email__c'));
            String oldtitle = String.valueOf(record.getProperties().get('Title__c'));
            String oldtelephone = String.valueOf(record.getProperties().get('Telephone__c'));
            String newtelephone = (oldtelephone != null && oldtelephone.length() > 39 ? oldtelephone.subString(0, 39) : oldtelephone);
            record.getProperties().put('Telephone__c',newtelephone);
            String newtitle = (oldtitle != null && oldtitle.length() > 100? oldtitle.abbreviate(100) : oldtitle);
            record.getProperties().put('Title__c',newtitle);
            if(email == null) {
                email = String.valueOf(record.getOriginalProperties().get('email'));
            }
            if(email != null && !email.toLowerCase().endsWith('trade.gov')) {
                if(!String.isBlank(company)) {
                    organizationNames.add(company.trim());
                }
                if(!String.isBlank(email)) {
                    contactEmails.add(email);
                    emailToAttendee.put(email,record);
                }
                if(!String.isBlank(company) && !String.isBlank(email)) {
                    emailToOrganizationName.put(email,company);
                }
            }
            String busConfId = String.valueOf(record.getProperties().get('BusinessConference__c'));
            if(!String.isBlank(busConfId)) {
                businessConferenceIds.add(busConfId);
                if(!String.isBlank(company)) {
                    orgNameToBusinessConferenceId.put(company,busConfId);
                }
            }
        }

        Map<Id,String> busConfIdToCommunicationEmail = new Map<Id,String>();
        for(Business_Conference__c busConf : [SELECT Id,Campaign__c,Campaign__r.Outgoing_Communication_Email__c FROM Business_Conference__c WHERE Id IN: orgNameToBusinessConferenceId.values()]) {
            if(busConf.Campaign__c != null) {
                busConfIdToCommunicationEmail.put(busConf.Id,busConf.Campaign__r.Outgoing_Communication_Email__c);
            }
        }

        Map<String,String> communicationEmailToUserId = new Map<String,String>();
        //get users from list of users related to outgoing communications emails for later use
        for(User thisUser : [SELECT Id,Email from User WHERE Email IN: busConfIdToCommunicationEmail.values() ORDER BY CreatedDate asc]) {
            communicationEmailToUserId.put(thisUser.Email,thisUser.Id);
        }

        //Use Organization Names to find existing Organizations with those names, map them
        for(Account organization : [SELECT Name,Id,OwnerId FROM Account WHERE Name IN :organizationNames ORDER BY CreatedDate asc]) {
            organizationNameToExistingOrganization.put(organization.Name, organization);
        }

        //Iterate through Attendee company names and collect the ones that don't have any matching Organizations,
        //  then create new Organizations for those names that still don't have an Org, then map the new orgs by name
        for(String orgName : organizationNames) {
            if((!organizationNameToExistingOrganization.containsKey(orgName) && !organizationNameToNewOrganization.containsKey(orgName))) {
                //Organization doesn't already exist, create it and map it
                Account newOrganization = new Account(Name = orgName, recordTypeId = orgRecordTypeId);

                String businessConferenceId = orgNameToBusinessConferenceId.get(orgName);
                if(businessConferenceId != null) {
                    String communicationEmail = busConfIdToCommunicationEmail.get(businessConferenceId);
                    if(communicationEmail != null) {
                        //newOrganization.OwnerId = communicationEmail;
                        String userId = communicationEmailToUserId.get(communicationEmail);
                        if(userId != null) {
                            newOrganization.OwnerId = userId;
                        }
                    }
                }
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
        for(Contact contact : [SELECT Id, Email FROM Contact where Email IN :contactEmails]) {
            contactEmailToExistingContact.put(contact.Email, contact);
        }

        //Find unmatched contacts and create new contacts
        for(String contactEmail : contactEmails) {
            //contact email must not already be connected to a contact, whether it existed before or was created earlier in this operation
            if((!contactEmailToExistingContact.containsKey(contactEmail) && !contactEmailToNewContact.containsKey(contactEmail))) {
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
                    newContact.OwnerId = organizationNameToExistingOrganization.get(emailToOrganizationName.get(contactEmail)).OwnerId;
                }
                contactEmailToNewContact.put(newContact.Email,newContact);
            }
        }

        //Insert the new contacts
        Database.insert(contactEmailToNewContact.values(),false);

        //Add newly inserted contacts with newly generated Ids into the map of existing contacts
        contactEmailToExistingContact.putAll(contactEmailToNewContact);

        //Update Attendee record with newly created or existing Contact Id (as long as they are not .gov)
        for(valence.RecordInFlight record : records) {
            String email = String.valueOf(record.getOriginalProperties().get('email'));
            if(email != null && email.toLowerCase().endsWith('trade.gov') == false) {
                record.getProperties().put('Contact__c', contactEmailToExistingContact.get(email).Id);
            }
        }
    }
}