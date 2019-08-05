/**
 * Created by jeffweyhrauch on 2019-07-17.
 */

@IsTest private class AttendeeContactCreatorTest {

    @IsTest static void testRestriction() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'business_conference_participants';
        context.linkTargetName = 'Attendee__c';

        System.assertEquals(true, new AttendeeContactCreator().validFor(context));
    }

    @IsTest static void testRestrictionBadSource() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'events';
        context.linkTargetName = 'Attendee__c';

        System.assertEquals(false, new AttendeeContactCreator().validFor(context));
    }

    @IsTest static void testRestrictionBadTarget() {

        valence.LinkContext context = new valence.LinkContext();
        context.linkSourceName = 'business_conference_participants';
        context.linkTargetName = 'Contact';

        System.assertEquals(false, new AttendeeContactCreator().validFor(context));
    }

    @IsTest static void testFilterBehavior() {

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
                        'company' => 'alpha'
                }),
                new valence.RecordInFlight(new Map<String, Object>{ // existing company, new contact
                        'email' => 'sarahsword@beta.gov',
                        'FirstName__c' => 'Sarah',
                        'LastName__c' => 'Sword',
                        'company' => 'Beta',
                        'Telephone__c' => '555-3333',
                        'company' => 'Beta'
                }),
                new valence.RecordInFlight(new Map<String, Object>{ // new company, new contact
                        'email' => 'jim.thomas@charlie.gov',
                        'FirstName__c' => 'Jim',
                        'LastName__c' => 'Thomas',
                        'company' => 'Charlie Group',
                        'Telephone__c' => '555-2222',
                        'company' => 'Charlie Group'
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
        Test.stopTest();

        List<Contact> contacts = [SELECT Id, AccountId, Account.Name, FirstName, LastName, Email, Phone FROM Contact ORDER BY LastName];
        // Bean, Fiddle, Sword, Thomas

        //2 unique, non-gov contacts should be created: Susie and Tom
        System.assertEquals(2, contacts.size());

        // existing contact
        System.assertEquals('Susan', contacts[0].FirstName); // make sure we didn't change Susan to Susie
        System.assertEquals('Bean', contacts[0].LastName);
        System.assertEquals('susie@alpha.org', contacts[0].Email);
        System.assertEquals('555-1111', contacts[0].Phone);
        System.assertEquals(contacts[0].Id, susie.Id);
        System.assertEquals(contacts[0].Id, records[0].getProperties().get('Contact__c'));
        System.assertEquals(alpha.Id, contacts[0].AccountId);

        // existing company, new contact
        System.assertEquals('Tom', contacts[1].FirstName);
        System.assertEquals('Fiddle', contacts[1].LastName);
        System.assertEquals('sarahsword@beta.gov', contacts[1].Email);
        System.assertEquals('555-3333', contacts[1].Phone);
        System.assertEquals(contacts[1].Id, records[1].getProperties().get('Contact__c'));
        System.assertEquals(beta.Id, contacts[1].AccountId);
    }
}
