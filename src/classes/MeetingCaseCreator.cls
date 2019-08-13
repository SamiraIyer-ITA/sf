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

        List<User> automatedProcessUser = [SELECT Id FROM User WHERE Name = 'Automated Process' ORDER BY CreatedDate ASC LIMIT 1];
        Id automatedProcessId = null;
        if(!automatedProcessUser.isEmpty()) {
            automatedProcessId = automatedProcessUser[0].Id;
        }


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
        Map<Id,List<Date>> attendeeIdToStartDate = new Map<Id,List<Date>>();

        for(valence.RecordInFlight record : records) {
            Map<String, Object> orgprops = record.getOriginalProperties();
            Map<String, Object> props = record.getProperties();
            String meetingType = 'B2B';
            String meetingStatus = String.valueOf(props.get('Status__c'));

            DateTime currentDateTime = null;
            try {
                currentDateTime = (DateTime) JSON.deserialize('\"' + String.valueOf(record.getProperties().get('StartDateTime__c')) + '\"', DateTime.class);
            } catch (Exception e) {
                currentDateTime = null;
            }

            String attendeeId = (props.get('Attendee__c') == null ? null : String.valueOf(props.get('Attendee__c')));
            String hostId = (props.get('Host__c') == null ? null : String.valueOf(props.get('Host__c')));
            String attendeeEmail = attendeesToEmails.get((Id) attendeeId);
            String hostEmail = attendeesToEmails.get((Id) hostId);

            if ((attendeeEmail != null && attendeeEmail.toLowerCase().endsWith('.gov')) || (hostEmail != null && hostEmail.toLowerCase().endsWith('.gov'))) {
                record.getProperties().put('Type__c', 'B2G');
                if (attendeeEmail != null) {
                    emailsG2B.add(attendeeEmail);
                }
                if (hostEmail != null) {
                    emailsG2B.add(hostEmail);
                }
            } else {
                record.getProperties().put('Type__c', 'B2B');
            }

            if (meetingStatus == '1') {
                record.getProperties().put('Status__c', 'Requested');
            } else if (meetingStatus == '2') {
                if (attendeeEmail != null) {
                    acceptedMeetingEmails.add(attendeeEmail);
                    List<Date> attendeeDateSet = attendeeIdToStartDate.get(attendeeId);
                    if(attendeeId != null) {
                        acceptedMeetingAttendeeIds.add(attendeeId);
                    }
                    if (attendeeDateSet == null) {
                        attendeeDateSet = new List<Date>();
                    }
                    if (currentDateTime != null) {
                        attendeeDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                    }
                    attendeeIdToStartDate.put(attendeeId, attendeeDateSet);
                }
                if (hostEmail != null) {
                    acceptedMeetingEmails.add(hostEmail);
                    List<Date> hostDateSet = attendeeIdToStartDate.get(hostId);
                    if(hostId != null) {
                        acceptedMeetingAttendeeIds.add(hostId);
                    }
                    if (hostDateSet == null) {
                        hostDateSet = new List<Date>();
                    }
                    if (currentDateTime != null) {
                        hostDateSet.add(date.newinstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.day()));
                    }
                    attendeeIdToStartDate.put(hostId, hostDateSet);
                }
                record.getProperties().put('Status__c', 'Accepted');
            } else if (meetingStatus == '3') {
                record.getProperties().put('Status__c', 'Rejected');
            }
        }

        //Map<String,Set<Id>> emailToBusinessConferenceIds = new Map<String,Set<Id>>();
        Map<String,Set<Attendee__c>> emailToAttendees = new Map<String,Set<Attendee__c>>();
        Map<Id,Id> attendeeToBusinessConferenceId = new Map<Id,Id>();
        Set<Id> acceptedMeetingContactIds = new Set<Id>();
        Set<Id> contactsWithCases = new Set<Id>();
        Map<Id,String> businessConferenceIdToCampaignName = new Map<Id,String>();
        Map<Id,Id> businessConferenceIdToCampaignId = new Map<Id,Id>();
        Map<Id,String> businessConferenceIdToOutgoingCommunicationEmail = new Map<Id,String>();
        Map<String,Id> communicationEmailToUserId = new Map<String,Id>();
        Map<String,Case> emailToCase = new Map<String,Case>();
        Map<Id,Set<String>> contactIdToCampaignName = new Map<Id,Set<String>>();

        //attendees related to this bulk operation
        List<Attendee__c> relatedAttendees = [SELECT Id,Email__c,BusinessConference__c,BusinessConference__r.Campaign__c FROM Attendee__c WHERE Id IN: acceptedMeetingAttendeeIds];
        for(Attendee__c attendee : relatedAttendees) {
            attendeeToBusinessConferenceId.put(attendee.Id,attendee.BusinessConference__c);

            if(attendee.Email__c != null && attendee.BusinessConference__c != null) {
                Set<Attendee__c> attendeesByEmail = emailToAttendees.get(attendee.Email__c);
                if (attendeesByEmail == null) {
                    attendeesByEmail = new Set<Attendee__c>();
                }
                attendeesByEmail.add(attendee);
                emailToAttendees.put(attendee.Email__c, attendeesByEmail);
            }
        }

        //not all attendees have emails
        for(Contact myContact : [SELECT Id,Email FROM Contact WHERE Email IN: acceptedMeetingEmails]) {
            acceptedMeetingContactIds.add(myContact.Id);
        }

        //make a list of contacts that already have existing cases
        for(Case thisCase : [SELECT ContactId,Campaign_Name__c,Campaign_Name__r.Name FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            contactsWithCases.add(thisCase.ContactId);

            Set<String> campaignNames = contactIdToCampaignName.get(thisCase.ContactId);
            if(campaignNames == null) {
                campaignNames = new Set<String>();
            }
            if(thisCase.Campaign_Name__c != null) {
                campaignNames.add(thisCase.Campaign_Name__r.Name);
                contactIdToCampaignName.put(thisCase.ContactId,campaignNames);
            }
        }

        //gather information about campaigns and business conferences for later use
        for(Business_Conference__c networkingTrack : [SELECT Id,Campaign__r.Name,Campaign__c,Campaign__r.Outgoing_Communication_Email__c FROM Business_Conference__c WHERE Id IN: attendeeToBusinessConferenceId.values()]) {
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
            for(Attendee__c attendeeFromEmail : emailToAttendees.get(thisContact.Email)) {
                System.debug('attendee From Email');
                //Id businessConferenceId = emailToBusinessConferenceIds.get(thisContact.Email);
                Id businessConferenceId = attendeeFromEmail.BusinessConference__c;
                String campaignName = businessConferenceIdToCampaignName.get(businessConferenceId);
                String orgName = '';
                String caseSubject = (String.isBlank(campaignName) ? '' : campaignName) + (!String.isBlank(orgName) ? ' ' + orgName : '');

                Set<String> caseCampaignNames = contactIdToCampaignName.get(thisContact.Id);
                if (caseCampaignNames == null || !caseCampaignNames.contains(caseSubject)) {
                    System.debug('case Name does not exist');
                    Id campaignId = businessConferenceIdToCampaignId.get(businessConferenceId);

                    Id orgOwnerId = null;
                    //Case owner is associated org owner
                    if (thisContact.AccountId != null) {
                        orgOwnerId = thisContact.Account.OwnerId;
                        orgName = thisContact.Account.Name;
                    }

                    //If there is no org owner then use the user associated with the campaign outgoing communication email field
                    if ((orgOwnerId == null || orgOwnerId == automatedProcessId) && businessConferenceId != null) {
                        String communicationEmail = businessConferenceIdToOutgoingCommunicationEmail.get(businessConferenceId);
                        if (communicationEmail != null) {
                            orgOwnerId = communicationEmailToUserId.get(communicationEmail);
                        }
                        if(orgOwnerId == null) {
                            orgOwnerId = automatedProcessId;
                        }
                    }
                    //If there is still no match just let the system automatically assign it
                    Case newCase = null;
                    if (orgOwnerId != null) {
                        newCase = new Case(Subject = (String.isBlank(caseSubject) ? 'Case' : caseSubject),
                                Description = 'U.S. Exhibitor/Client registered for value added programming (G2B, B2B, Demos Int\'l Reception), at an event.',
                                OwnerId = orgOwnerId,
                                ContactId = thisContact.Id,
                                Campaign_Name__c = campaignId
                        );
                        emailToCase.put(thisContact.Email, newCase);
                    } else {
                        newCase = new Case(Subject = (String.isBlank(caseSubject) ? 'Case' : caseSubject),
                                Description = 'U.S. Exhibitor/Client registered for value added programming (G2B, B2B, Demos Int\'l Reception), at an event.',
                                ContactId = thisContact.Id,
                                Campaign_Name__c = campaignId
                        );
                        emailToCase.put(thisContact.Email, newCase);
                    }
                }
            }
        }
        Database.insert(emailToCase.values(),false);

        Set<Id> existingCaseIds = new Set<Id>();
        List<Case> acceptedMeetingCases = new List<Case>();
        Set<Id> existingContactIds = new Set<Id>();

        for(Case thisCase : [SELECT Id,ContactId,Contact.Email,OwnerId,Contact.MailingCountry,Campaign_Name__c,Campaign_Name__r.Name FROM Case WHERE ContactId IN: acceptedMeetingContactIds]) {
            existingCaseIds.add(thisCase.Id);
            acceptedMeetingCases.add(thisCase);
            existingContactIds.add(thisCase.ContactId);
        }

        //list existing tasks to prevent duplicates
        List<Task> existingTasks = [SELECT Subject,OwnerId,WhoId,WhatId,Type,Status,ActivityDate FROM Task WHERE WhatId IN: existingCaseIds AND WhoId IN: existingContactIds];

        List<Task> tasksToInsert = new List<Task>();
        for(Case myCase : acceptedMeetingCases) {
            if(myCase.ContactId != null && myCase.Contact.Email != null && emailsG2B.contains(myCase.Contact.Email)) {
                for(Attendee__c relatedAttendee : emailToAttendees.get(myCase.Contact.Email)) {
                    //case id to start date?
                    for (Date myDate : attendeeIdToStartDate.get(relatedAttendee.Id)) {
                        String campaignName = '';
                        if (myCase.Campaign_Name__c != null) {
                            campaignName = myCase.Campaign_Name__r.Name;
                        } else {
                            campaignName = 'Campaign';
                        }
                        String contactCountry = (myCase.ContactId != null ? ' - ' + myCase.Contact.MailingCountry : '');
                        Task thisTask = new Task(Subject = 'B2G Meeting at ' + campaignName + ' ' + myDate.year() + contactCountry,
                                OwnerId = myCase.OwnerId,
                                WhoId = myCase.ContactId,
                                WhatId = myCase.Id,
                                Type = 'B2G',
                                Status = 'Completed',
                                ActivityDate = myDate
                        );
                        Boolean bFound = false;
                        for(Task existingTask : existingTasks) {
                            //prevent endless hordes of tasks from being created
                            if(existingTask.Subject == thisTask.Subject &&
                                    existingTask.OwnerId == thisTask.OwnerId &&
                                    existingTask.WhoId == thisTask.WhoId &&
                                    existingTask.WhatId == thisTask.WhatId &&
                                    existingTask.Type == thisTask.Type &&
                                    existingTask.Status == thisTask.Status &&
                                    existingTask.ActivityDate == thisTask.ActivityDate) {
                                bFound = true;
                                break;
                            }
                        }
                        for(Task existingTask : tasksToInsert) {
                            //prevent endless hordes of tasks from being created
                            if(existingTask.Subject == thisTask.Subject &&
                                    existingTask.OwnerId == thisTask.OwnerId &&
                                    existingTask.WhoId == thisTask.WhoId &&
                                    existingTask.WhatId == thisTask.WhatId &&
                                    existingTask.Type == thisTask.Type &&
                                    existingTask.Status == thisTask.Status &&
                                    existingTask.ActivityDate == thisTask.ActivityDate) {
                                bFound = true;
                                break;
                            }
                        }
                        if(bFound == false) {
                            tasksToInsert.add(thisTask);
                        }
                    }
                }
            }
        }
        Database.insert(tasksToInsert,false);
    }
}