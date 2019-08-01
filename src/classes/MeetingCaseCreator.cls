global with sharing class MeetingCaseCreator implements valence.TransformationFilter {

    public Boolean validFor(valence.LinkContext context) {
        if('business_conference_meetings'.equalsIgnoreCase(context.linkSourceName) && 'Meeting__c'.equalsIgnoreCase(context.linkTargetName)) {
            return true;
        }
        return false;
    }

    public void process(valence.LinkContext context, List<valence.RecordInFlight> records) {
        Set<Id> attendeeIds = new Set<Id>();
        Map<String,String> attendeesToEmails = new Map<String,String>();

        for(valence.RecordInFlight record : records) {
            Map<String, Object> props = record.getProperties();
            if(props.get('Attendee__c') != null) {
                attendeeIds.add((Id)props.get('Attendee__c'));
            }
            if(props.get('Host__c') != null) {
                attendeeIds.add((Id)props.get('Host__c'));
            }
        }

        for(Attendee__c attendee : [SELECT Id,Email__c FROM Attendee__c WHERE Id IN: attendeeIds]) {
            attendeesToEmails.put(attendee.Id, attendee.Email__c);
        }

        Set<Id> acceptedMeetingAttendeeIds = new Set<Id>();
        Set<String> emailsG2B = new Set<String>();
        Set<String> acceptedMeetingEmails = new Set<String>();

        for(valence.RecordInFlight record : records) {
            Map<String, Object> props = record.getProperties();
            String meetingType = 'B2B';

            if(props.get('Attendee__c') != null) {
                String attendeeId = String.valueOf(props.get('Attendee__c'));
                String attendeeEmail = attendeesToEmails.get(attendeeId);
                if(attendeeEmail != null && attendeeEmail.toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                    emailsG2B.add(attendeeEmail);
                }
                String meetingStatus = String.valueOf(props.get('Status__c'));
                if(meetingStatus != null) {
                    if(meetingStatus == '2') {
                        acceptedMeetingAttendeeIds.add(attendeeId);
                        acceptedMeetingEmails.add(attendeeEmail);
                    }
                }

            }
            if(props.get('Host__c') != null) {
                String hostId = String.valueOf(props.get('Host__c'));
                String hostEmail = attendeesToEmails.get(hostId);
                if(hostEmail != null && hostEmail.toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                    emailsG2B.add(hostEmail);
                }
                String meetingStatus = String.valueOf(props.get('Status__c'));
                if(meetingStatus != null) {
                    if(meetingStatus == '2') {
                        acceptedMeetingAttendeeIds.add(hostId);
                        acceptedMeetingEmails.add(hostEmail);
                    }
                }
            }
            record.getProperties().put('Type__c',meetingType);
        }

        Map<String,Id> emailToBusinessConferenceId = new Map<String,Id>();
        Map<String,Id> emailToCampaignId = new Map<String,Id>();
        Map<Id,String> campaignIdToCampaignName = new Map<Id,String>();
        Set<Id> acceptedMeetingContactIds = new Set<Id>();
        Set<Id> contactsWithCases = new Set<Id>();
        Map<Id,String> businessConferenceIdToCampaignName = new Map<Id,String>();
        Map<Id,String> businessConferenceIdToOutgoingCommunicationEmail = new Map<Id,String>();
        Map<String,Id> communicationEmailToUserId = new Map<String,Id>();
        Map<String,Case> emailToCase = new Map<String,Case>();

        //attendees related to this bulk operation
        List<Attendee__c> relatedAttendees = [SELECT Id,Email__c,BusinessConference__c,BusinessConference__r.Campaign__c FROM Attendee__c WHERE Id IN: acceptedMeetingAttendeeIds];
        for(Attendee__c attendee : relatedAttendees) {
            emailToBusinessConferenceId.put(attendee.Email__c,attendee.BusinessConference__c);
            if(attendee.BusinessConference__c != null) {
                emailToCampaignId.put(attendee.Email__c,attendee.BusinessConference__r.Campaign__c);
            }
        }

        for(Campaign myCampaign : [SELECT Id,Name FROM Campaign WHERE Id IN: emailToCampaignId.values()]) {
            campaignIdToCampaignName.put(myCampaign.Id,myCampaign.Name);
        }

        for(Contact myContact : [SELECT Name,Id,Email,AccountId,Account.Name from Contact WHERE Email IN: acceptedMeetingEmails]) {
            if(myContact != null && myContact.Id != null) {
                acceptedMeetingContactIds.add(myContact.Id);
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

        //Create Cases on Contacts associated by email with an attendee associated to an accepted meeting
        for(Contact thisContact : [SELECT Id,Name,Account.Name,Account.OwnerId,Email FROM Contact WHERE Id IN: acceptedMeetingContactIds]) {
            if(!contactsWithCases.contains(thisContact.Id)) {
                Id businessConferenceId = emailToBusinessConferenceId.get(thisContact.Email);
                String campaignName = businessConferenceIdToCampaignName.get(businessConferenceId);
                String orgName = '';

                Id orgOwnerId = null;
                //Case owner is associated org owner
                if(thisContact.Account != null) {
                    orgOwnerId = thisContact.Account.OwnerId;
                    orgName = thisContact.Account.Name;
                }

                String caseSubject = (String.isBlank(campaignName) ? '' : campaignName+' ')+orgName;
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

                emailToCase.put(thisContact.Email,newCase);
            }
        }
        Database.insert(emailToCase.values(),false);

        Set<Id> existingCaseIds = new Set<Id>();
        List<Case> acceptedMeetingCases = new List<Case>();
        for(Case thisCase : [SELECT Id,ContactId,Contact.Email,OwnerId,Contact.MailingCountry FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            existingCaseIds.add(thisCase.Id);
            acceptedMeetingCases.add(thisCase);
        }

        Set<Id> casesWithExistingTasks = new Set<Id>();
        for(Task thisTask : [SELECT Id,WhatId FROM Task WHERE WhatId IN: existingCaseIds]) {
            casesWithExistingTasks.add(thisTask.WhatId);
        }

        List<Task> tasksToInsert = new List<Task>();
        for(Case myCase : acceptedMeetingCases) {
            if(!casesWithExistingTasks.contains(myCase.Id) && myCase.ContactId != null && myCase.Contact.Email != null && emailsG2B.contains(myCase.Contact.Email)) {
                Id campaignId = emailToCampaignId.get(myCase.Contact.Email);
                String campaignName = (campaignId != null ? campaignIdToCampaignName.get(campaignId) : 'Campaign');
                String contactCountry = (myCase.ContactId != null ? ' - '+myCase.Contact.MailingCountry : '');
                Task thisTask = new Task(Subject='G2B '+campaignName+contactCountry,
                                        OwnerId = myCase.OwnerId,
                                        WhoId = myCase.ContactId,
                                        WhatId = myCase.Id,
                                        Type = 'G2B',
                                        Status = 'Completed');
            }
        }
    }
}
