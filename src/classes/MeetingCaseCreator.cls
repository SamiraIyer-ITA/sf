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

        List<Attendee__c> attendeeList = [SELECT Id,Email__c from Attendee__c];
        for(Attendee__c attendee : attendeeList) {
            attendeesToEmails.put(attendee.Id, attendee.Email__c);
        }

        for(valence.RecordInFlight record : records) {
            Map<String, Object> props = record.getProperties();
            String meetingType = 'B2B';

            if(props.get('Attendee__c') != null) {
                if(attendeesToEmails.get(String.valueOf(props.get('Attendee__c'))).toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                }

            }
            if(props.get('Host__c') != null) {
                if(attendeesToEmails.get(String.valueOf(props.get('Host__c'))).toLowerCase().endsWith('.gov') == true) {
                    meetingType = 'G2B';
                }
            }
            record.getProperties().put('Type__c',meetingType);
        }
    }
}