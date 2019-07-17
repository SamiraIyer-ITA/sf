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

        System.assertEquals(4, contacts.size());

        // existing contact
        System.assertEquals('Susan', contacts[0].FirstName); // make sure we didn't change Susan to Susie
        System.assertEquals('Bean', contacts[0].LastName);
        System.assertEquals('susie@alpha.org', contacts[0].Email);
        System.assertEquals('555-1111', contacts[0].Phone);
        System.assertEquals(contacts[0].Id, susie.Id);
        System.assertEquals(contacts[0].Id, records[0].getProperties().get('Contact__c'));
        System.assertEquals(alpha.Id, contacts[0].AccountId);

        // existing company, new contact
        System.assertEquals('Sarah', contacts[2].FirstName);
        System.assertEquals('Sword', contacts[2].LastName);
        System.assertEquals('sarahsword@beta.gov', contacts[2].Email);
        System.assertEquals('555-3333', contacts[2].Phone);
        System.assertEquals(contacts[2].Id, records[1].getProperties().get('Contact__c'));
        System.assertEquals(beta.Id, contacts[2].AccountId);

        // new company, new contact
        System.assertEquals('Jim', contacts[3].FirstName);
        System.assertEquals('Thomas', contacts[3].LastName);
        System.assertEquals('jim.thomas@charlie.gov', contacts[3].Email);
        System.assertEquals('555-2222', contacts[3].Phone);
        System.assertEquals(contacts[3].Id, records[2].getProperties().get('Contact__c'));
        System.assertEquals('Charlie Group', contacts[3].Account.Name);
        System.assertNotEquals(alpha.Id, contacts[3].AccountId);
        System.assertNotEquals(beta.Id, contacts[3].AccountId);
    }
}
