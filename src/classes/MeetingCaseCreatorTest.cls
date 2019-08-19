/**
 * Created by jeffweyhrauch on 2019-07-17.
 */

@IsTest private class MeetingCaseCreatorTest {

    @IsTest static void testRestriction() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'business_conference_meetings';
        context.linkTargetName = 'Meeting__c';

        System.assertEquals(true, new MeetingCaseCreator().validFor(context));
    }

    @IsTest static void testRestrictionBadSource() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'meetings';
        context.linkTargetName = 'Meeting__c';

        System.assertEquals(false, new AttendeeContactCreator().validFor(context));
    }

    @IsTest static void testRestrictionBadTarget() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'business_conference_meetings';
        context.linkTargetName = 'Meeting';

        System.assertEquals(false, new MeetingCaseCreator().validFor(context));
    }

    @IsTest static void testMeetingFilterBehavior() {
        Campaign myCampaign = new Campaign(Name='Campaign');
        insert myCampaign;

        Business_Conference__c busConf = new Business_Conference__c(Name='ABC Conference',EventtiaID__c='6666',Campaign__c=myCampaign.Id);
        insert busconf;

        Account alpha = new Account(Name = 'Alpha');
        Account beta = new Account(Name = 'Beta');
        insert new List<Account>{alpha, beta};

        Contact susie = new Contact(FirstName = 'Susan', LastName = 'Bean', Email = 'susie@alpha.org', Phone = '555-1111', AccountId = alpha.Id);
        Contact tom = new Contact(FirstName = 'Tom', LastName = 'Fiddle', AccountId = beta.Id);
        insert new List<Contact>{susie, tom};

        List<valence.RecordInFlight> records = new List<valence.RecordInFlight>{
                new valence.RecordInFlight(new Map<String, Object>{ // existing contact
                        'email' => 'susie@alpha.org',
                        'FirstName__c' => 'Susie',
                        'LastName__c' => 'Bean',
                        'company' => 'alpha',
                        'Telephone__c' => '555-1111',
                        'Contact__c' => susie.Id,
                        'AttendeeID__c' => '811111'
                }),
                new valence.RecordInFlight(new Map<String, Object>{ // existing company, new contact
                        'email' => 'sarahsword@beta.gov',
                        'FirstName__c' => 'Sarah',
                        'LastName__c' => 'Sword',
                        'company' => 'Beta',
                        'Telephone__c' => '555-3333',
                        'company' => 'Beta',
                        'AttendeeID__c' => '822222'
                }),
                new valence.RecordInFlight(new Map<String, Object>{ // new company, new contact
                        'email' => 'jim.thomas@charlie.org',
                        'FirstName__c' => 'Jim',
                        'LastName__c' => 'Thomas',
                        'company' => 'Charlie Group',
                        'Telephone__c' => '555-2222',
                        'company' => 'Charlie Group',
                        'AttendeeID__c' => '833333'
                })
        };

        // a little hacky, but we need to move the original properties into properties to mimic Valence mapping behavior
        for(valence.RecordInFlight record : records) {
            Map<String, Object> propRef = record.getProperties();
            for(String key : record.getOriginalProperties().keySet())
                propRef.put(key, record.getOriginalProperties().get(key));
        }

        Test.startTest();
        new AttendeeContactCreator().process(null, records);

        Attendee__c susan = new Attendee__c(Email__c='susie@alpha.org',FirstName__c='Susan',LastName__c='Bean',Company__c='Alpha',AttendeeID__c='811111',BusinessConference__c=busconf.Id,Contact__c=susie.Id);
        insert susan;
        Attendee__c sarah = new Attendee__c(Email__c='sarahsword@beta.gov',FirstName__c='Sarah',LastName__c='Sword',Company__c='Beta',AttendeeID__c='822222',BusinessConference__c=busconf.Id);
        insert sarah;

        List<valence.RecordInFlight> records2 = new List<valence.RecordInFlight>{

                new valence.RecordInFlight(new Map<String, Object>{
                        'Host__c' => sarah.Id,
                        'Attendee__c' => susan.Id,
                        //'Host__c' => hostId,
                        'participant_id' => '822222',
                        'location' => 'Fancy Restaurant',
                        'status' => '2',
                        'Status__c' => '2',
                        'id' => '333333',
                        'business_conference_id' => '6666'
                })

        };

        // a little hacky, but we need to move the original properties into properties to mimic Valence mapping behavior
        for(valence.RecordInFlight record : records2) {
            Map<String, Object> propRef = record.getProperties();
            for(String key : record.getOriginalProperties().keySet())
                propRef.put(key, record.getOriginalProperties().get(key));
        }


        new MeetingCaseCreator().process(null, records2);
        Test.stopTest();

        List<Account> accounts = [SELECT Id,Name FROM Account];
        System.debug(accounts.size());

        List<Contact> contacts = [SELECT Id, AccountId, Account.Name, FirstName, LastName, Email, Phone FROM Contact ORDER BY LastName];
        System.assertEquals(4, contacts.size());

        System.assertEquals('B2G',records2[0].getProperties().get('Type__c'));
        System.assertEquals('Accepted',records2[0].getProperties().get('Status__c'));

        List<Case> cases = [SELECT Id FROM Case];
        System.assertEquals(2,cases.size());

        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0,tasks.size());
    }
}
