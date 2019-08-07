global with sharing class MeetingCaseCreator implements valence.TransformationFilter {

    public Boolean validFor(valence.LinkContext context) {
        if('business_conference_meetings'.equalsIgnoreCase(context.linkSourceName) && 'Meeting__c'.equalsIgnoreCase(context.linkTargetName)) {
            return true;
        }
        return false;
    }

    public void process(valence.LinkContext context, List<valence.RecordInFlight> records) {
        Set<Id> attendeeIds = new Set<Id>();
        Map<Id,String> attendeesToEmails = new Map<Id,String>();

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
        Map<String,Set<Date>> emailToStartDate = new Map<String,Set<Date>>();

        for(valence.RecordInFlight record : records) {
            Map<String, Object> orgprops = record.getOriginalProperties();
            Map<String, Object> props = record.getProperties();
            String meetingType = 'B2B';
            String meetingStatus = String.valueOf(props.get('Status__c'));
            DateTime currentDateTime = null;
            try {
                currentDateTime = (DateTime)JSON.deserialize('\"'+String.valueOf(record.getProperties().get('StartDateTime__c'))+'\"', DateTime.class);
            } catch(Exception e) {
                currentDateTime = null;
            }

            if(props.get('Attendee__c') != null) {
                String attendeeId = String.valueOf(props.get('Attendee__c'));
                String attendeeEmail = attendeesToEmails.get((Id)attendeeId);

                if(attendeeEmail != null && attendeeEmail.toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                    emailsG2B.add(attendeeEmail);

                    if(props.get('Host__c') != null) {
                        String hostId = String.valueOf(props.get('Host__c'));
                        String hostEmail = attendeesToEmails.get((Id) hostId);
                        emailsG2B.add(hostEmail);
                    }
                }

                if(meetingStatus != null) {
                    if(meetingStatus == '2') {
                        acceptedMeetingAttendeeIds.add((Id)attendeeId);
                        if(attendeeEmail != null) {
                            acceptedMeetingEmails.add(attendeeEmail);

                            Set<Date> attendeeDateSet = emailToStartDate.get(attendeeEmail);
                            if (attendeeDateSet == null) {
                                attendeeDateSet = new Set<Date>();
                            }
                            if (currentDateTime != null) {
                                attendeeDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                            }
                            emailToStartDate.put(attendeeEmail, attendeeDateSet);

                            if (props.get('Host__c') != null) {
                                String hostId = String.valueOf(props.get('Host__c'));
                                String hostEmail = attendeesToEmails.get((Id) hostId);

                                Set<Date> hostDateSet = emailToStartDate.get(hostEmail);
                                if (hostDateSet == null) {
                                    hostDateSet = new Set<Date>();
                                }
                                if (currentDateTime != null) {
                                    hostDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                                }
                                emailToStartDate.put(hostEmail, hostDateSet);

                            }
                        }
                    }
                }

            }
            if(props.get('Host__c') != null) {
                String hostId = String.valueOf(props.get('Host__c'));
                String hostEmail = attendeesToEmails.get((Id)hostId);
                if(hostEmail != null && hostEmail.toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                    emailsG2B.add(hostEmail);
                    if(props.get('Attendee__c') != null) {
                        String attendeeId = String.valueOf(props.get('Attendee__c'));
                        String attendeeEmail = attendeesToEmails.get((Id) attendeeId);
                        emailsG2B.add(attendeeEmail);
                    }
                }
                if(meetingStatus != null) {
                    if(meetingStatus == '2') {
                        acceptedMeetingAttendeeIds.add((Id)hostId);
                        if(hostEmail != null) {
                            acceptedMeetingEmails.add(hostEmail);

                            Set<Date> hostDateSet = emailToStartDate.get(hostEmail);
                            if (hostDateSet == null) {
                                hostDateSet = new Set<Date>();
                            }
                            if (currentDateTime != null) {
                                hostDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                            }
                            emailToStartDate.put(hostEmail, hostDateSet);

                            if(props.get('Attendee__c') != null) {
                                String attendeeId = String.valueOf(props.get('Attendee__c'));
                                String attendeeEmail = attendeesToEmails.get((Id) attendeeId);

                                Set<Date> attendeeDateSet = emailToStartDate.get(attendeeEmail);
                                if (attendeeDateSet == null) {
                                    attendeeDateSet = new Set<Date>();
                                }
                                if (currentDateTime != null) {
                                    attendeeDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                                }
                                emailToStartDate.put(attendeeEmail, attendeeDateSet);
                            }
                        }
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
        Map<Id,Id> businessConferenceIdToCampaignId = new Map<Id,Id>();
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

        //not all attendees have emails
        for(Contact myContact : [SELECT Id,Email FROM Contact WHERE Email IN: acceptedMeetingEmails]) {
            acceptedMeetingContactIds.add(myContact.Id);
        }

        //make a list of contacts that already have existing cases
        for(Case thisCase : [SELECT ContactId FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            contactsWithCases.add(thisCase.ContactId);
        }

        //gather information about campaigns and business conferences for later use
        for(Business_Conference__c networkingTrack : [SELECT Id,Campaign__r.Name,Campaign__c,Campaign__r.Outgoing_Communication_Email__c FROM Business_Conference__c WHERE Id IN: emailToBusinessConferenceId.values()]) {
            if(networkingTrack.Campaign__c != null) {
                businessConferenceIdToCampaignId.put(networkingTrack.Id,networkingTrack.Campaign__c);
                businessConferenceIdToCampaignName.put(networkingTrack.Id,networkingTrack.Campaign__r.Name);
                businessConferenceIdToOutgoingCommunicationEmail.put(networkingTrack.Id,networkingTrack.Campaign__r.Outgoing_Communication_Email__c);
            }
        }

        //get users from list of users related to outgoing communications emails for later use
        for(User thisUser : [SELECT Id,Email from User WHERE Email IN: businessConferenceIdToOutgoingCommunicationEmail.values()]) {
            communicationEmailToUserId.put(thisUser.Email,thisUser.Id);
        }

        //Create Cases on Contacts associated by email with an attendee associated to an accepted meeting
        for(Contact thisContact : [SELECT Id,AccountId,Account.Name,Account.OwnerId,Email FROM Contact WHERE Id IN: acceptedMeetingContactIds]) {
            if(!contactsWithCases.contains(thisContact.Id)) {
                Id businessConferenceId = emailToBusinessConferenceId.get(thisContact.Email);
                String campaignName = businessConferenceIdToCampaignName.get(businessConferenceId);
                String orgName = '';
                Id campaignId = businessConferenceIdToCampaignId.get(businessConferenceId);

                Id orgOwnerId = null;
                //Case owner is associated org owner
                if(thisContact.AccountId != null) {
                    orgOwnerId = thisContact.Account.OwnerId;
                    orgName = thisContact.Account.Name;
                }

                String caseSubject = (String.isBlank(campaignName) ? '' : campaignName)+(!String.isBlank(orgName) ? ' '+orgName : '');
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
                            Description = 'U.S. Exhibitor/Client registered for value added programming (G2B, B2B, Demos Int\'l Reception), at an event.',
                            OwnerId = orgOwnerId,
                            ContactId = thisContact.Id,
                            Campaign_Name__c = campaignId
                    );
                    emailToCase.put(thisContact.Email,newCase);
                } else {
                    newCase = new Case(Subject=(String.isBlank(caseSubject) ? 'Case' : caseSubject),
                            Description = 'U.S. Exhibitor/Client registered for value added programming (G2B, B2B, Demos Int\'l Reception), at an event.',
                            ContactId = thisContact.Id,
                            Campaign_Name__c = campaignId
                    );
                    emailToCase.put(thisContact.Email,newCase);
                }
            }
        }
        Database.insert(emailToCase.values(),false);

        Set<Id> existingCaseIds = new Set<Id>();
        List<Case> acceptedMeetingCases = new List<Case>();
        for(Case thisCase : [SELECT Id,ContactId,Contact.Email,OwnerId,Contact.MailingCountry FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            existingCaseIds.add(thisCase.Id);
            acceptedMeetingCases.add(thisCase);
        }

        List<Task> tasksToInsert = new List<Task>();
        for(Case myCase : acceptedMeetingCases) {
            if(myCase.ContactId != null && myCase.Contact.Email != null && emailsG2B.contains(myCase.Contact.Email)) {
                for(Date myDate : emailToStartDate.get(myCase.Contact.Email)) {
                    Id campaignId = emailToCampaignId.get(myCase.Contact.Email);
                    String campaignName = (campaignId != null ? ' '+campaignIdToCampaignName.get(campaignId) : ' Campaign');
                    String contactCountry = (myCase.ContactId != null ? ' - '+myCase.Contact.MailingCountry : '');
                    Task thisTask = new Task(Subject='G2B Meeting at'+campaignName+contactCountry,
                            OwnerId = myCase.OwnerId,
                            WhoId = myCase.ContactId,
                            WhatId = myCase.Id,
                            Type = 'G2B',
                            Status = 'Completed',
                            ActivityDate = myDate
                    );
                    tasksToInsert.add(thisTask);
                }
            }
        }
        Database.insert(tasksToInsert,false);
    }
}