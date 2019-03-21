/**
 * Created by Skip Kleckner on 3/21/2019.
 */

@IsTest
private class LockedRecordHandlerTest {
    @IsTest
    static void testRemoveLockedRecordMap() {
        Map<Id, SObject> objMap = new Map<Id, SObject>();
        Segment__c s1 = new Segment__c(Locked__c = true);
        Segment__c s2 = new Segment__c(Locked__c = false);
        s1.Id = fflib_IDGenerator.generate(Segment__c.SObjectType);
        s2.Id = fflib_IDGenerator.generate(Segment__c.SObjectType);

        objMap.put(s1.Id, s1);
        objMap.put(s2.Id, s2);

        Test.startTest();
        Map<Id, SObject> testMap = new LockedRecordHandler().removeLockedRecords(objMap);
        System.assertEquals(testMap.size(), 1);
        Test.stopTest();

    }
    @IsTest
    static void testRemoveLockedRecordList() {
        List<SObject> objList = new List<SObject>();
        Segment__c s1 = new Segment__c(Locked__c = true);
        Segment__c s2 = new Segment__c(Locked__c = false);

        objList.add(s1);
        objList.add(s2);

        Test.startTest();
        List<SObject> testList = new LockedRecordHandler().removeLockedRecords(objList);
        System.assertEquals(testList.size(), 1);
        Test.stopTest();
    }
}