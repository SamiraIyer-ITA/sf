@isTest
public class CP_Flow_Query_Groups_Test {
   
    @testSetup static void testSetup(){
        Group g = new Group(Type='Queue', Name='MyTestQueue');
        insert g;
       
        QueueSObject q = new QueueSObject(SobjectType='Lead', QueueId=g.Id);
        insert q;       
    }
   
  @IsTest
    static void testgetQueueId(){
        List<Group> baseQueueId = new List<Group>();
        Group result;
        CP_Flow_Query_Groups.RequestVariables target = new CP_Flow_Query_Groups.RequestVariables();
        list<CP_Flow_Query_Groups.RequestVariables> findList = new list<CP_Flow_Query_Groups.RequestVariables>();
        target.groupName='MyTestQueue';
        findList.add(target);
        baseQueueId = [Select Id,Name from group WHERE DeveloperName =: 'MyTestQueue'];
        result = CP_Flow_Query_Groups.getId(findList)[0];
        system.assertEquals((String)baseQueueId[0].id, result.id);
        system.assertEquals((String)baseQueueId[0].name, result.name);

    }
}