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

        //Collect Organization Names and filter out trade.gov email
        for(valence.RecordInFlight record : records) {
            //Do not create Organization or Contact if Attendee has a .gov email
            if(record.getOriginalProperties().containsKey('email') && String.valueOf(record.getOriginalProperties().get('email')).toLowerCase().endsWith('.gov') == false) {
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
        for(Contact contact : [SELECT Id, Email FROM Contact where Email IN :contactEmails]) {
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
            if(record.getOriginalProperties().containsKey('email') && String.valueOf(record.getOriginalProperties().get('email')).toLowerCase().endsWith('.gov') == false) {
                record.getProperties().put('Contact__c', contactEmailToExistingContact.get(String.valueOf(record.getOriginalProperties().get('email'))).Id);
            }
        }

        //Create a case on Contacts associated by email with an attendee associated to an accepted meeting
        List<Id> attendeeIdList = new List<Id>();
        Set<Id> acceptedMeetingAttendeeIds = new Set<Id>();

        Set<String> acceptedMeetingEmails = new Set<String>();
        Set<Id> acceptedMeetingContactIds = new Set<Id>();
        Set<Id> contactsWithCases = new Set<Id>();
        Map<String,Id> emailToBusinessConferenceId = new Map<String,Id>();
        Map<Id,String> businessConferenceIdToCampaignName = new Map<Id,String>();
        Map<Id,String> businessConferenceIdToOutgoingCommunicationEmail = new Map<Id,String>();
        Map<String,Id> communicationEmailToUserId = new Map<String,Id>();

        //attendees related to this bulk operation
        List<Attendee__c> relatedAttendees = [SELECT Id,Email__c,BusinessConference__c FROM Attendee__c WHERE Email__c IN: contactEmailToExistingContact.keySet()];
        for(Attendee__c attendee : relatedAttendees) {
            attendeeIdList.add(attendee.Id);
            emailToBusinessConferenceId.put(attendee.Email__c,attendee.BusinessConference__c);
        }
        //gather a list of emails from related attendees that have at least one accepted meeting as a host or attendee
        for(Meeting__c meeting : [SELECT Id,Host__c,Attendee__c,Type__c FROM Meeting__c WHERE Status__c = '2' AND (Host__c IN: attendeeIdList OR Attendee__c IN: attendeeIdList)]) {
            if(meeting.Host__c != null) {
                acceptedMeetingAttendeeIds.add(meeting.Host__c);
            }
            if(meeting.Attendee__c != null) {
                acceptedMeetingAttendeeIds.add(meeting.Attendee__c);
            }
        }
        for(Attendee__c attendee : relatedAttendees) {
            if(acceptedMeetingAttendeeIds.contains(attendee.Id)) {
                acceptedMeetingEmails.add(attendee.Email__c);
            }
        }
        //use the list of emails to gather a list of contact ids of related attendees that have at least one accepted meeting
        for(String email : acceptedMeetingEmails) {
            if(contactEmailToExistingContact.containsKey(email)) {
                acceptedMeetingContactIds.add(contactEmailToExistingContact.get(email).Id);
            }
        }
        //make a list of contacts that already have existing cases
        for(Case thisCase : [SELECT Id,ContactId FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            contactsWithCases.add(thisCase.ContactId);
        }

        //gather information about campaigns and business conferences for later use
        for(Business_Conference__c networkingTrack : [SELECT Id,Campaign__r.Name,Campaign__c,Campaign__r.Outgoing_Communication_Email__c FROM Business_Conference__c WHERE Id IN: emailToBusinessConferenceId.values()]) {
            if(networkingTrack.Campaign__c != null) {
                businessConferenceIdToCampaignName.put(networkingTrack.Id,networkingTrack.Campaign__r.Name);
                businessConferenceIdToOutgoingCommunicationEmail.put(networkingTrack.Id,networkingTrack.Campaign__r.Outgoing_Communication_Email__c);
            }
        }

        //get users from list of users related to outgoing communications emails for later use
        for(User thisUser : [SELECT Id,Email from User WHERE Email IN: businessConferenceIdToOutgoingCommunicationEmail.values()]) {
            communicationEmailToUserId.put(thisUser.Email,thisUser.Id);
        }

        //create the cases
        List<Case> casesToCreate = new List<Case>();
        for(Contact thisContact : [SELECT Id,Name,Account.Name,Account.OwnerId,Email FROM Contact WHERE Id IN: acceptedMeetingContactIds]) {
            if(!contactsWithCases.contains(thisContact.Id)) {
                Id businessConferenceId = emailToBusinessConferenceId.get(thisContact.Email);
                String campaignName = businessConferenceIdToCampaignName.get(businessConferenceId);
                String orgName = '';
                String caseSubject = (String.isBlank(campaignName) ? '' : campaignName+' ')+orgName;
                Id orgOwnerId = null;

                //Case owner is associated org owner
                if(thisContact.Account != null) {
                    orgOwnerId = thisContact.Account.OwnerId;
                    orgName = thisContact.Account.Name;
                }
                //If there is no org owner then use the user associated with the campaign outgoing communication email field
                if(orgOwnerId == null && businessConferenceId != null) {
                    String communicationEmail = businessConferenceIdToOutgoingCommunicationEmail.get(businessConferenceId);
                    if(communicationEmail != null) {
                        orgOwnerId = communicationEmailToUserId.get(communicationEmail);
                    }
                }
                //If there is still no match just let the system automatically assign it
                Case newCase = null;
                if(orgOwnerId != null) {
                    newCase = new Case(Subject=(String.isBlank(caseSubject) ? 'Case' : caseSubject),
                            Description = 'U.S. Exhibitor/Client registered to value added programming (G2B, B2B, Demos Int\'l Reception), at an event.',
                            OwnerId = orgOwnerId
                    );
                } else {
                    newCase = new Case(Subject=(String.isBlank(caseSubject) ? 'Case' : caseSubject),
                            Description = 'U.S. Exhibitor/Client registered to value added programming (G2B, B2B, Demos Int\'l Reception), at an event.'
                    );
                }

                casesToCreate.add(newCase);
            }
        }
        Database.insert(casesToCreate,false);
    }
}