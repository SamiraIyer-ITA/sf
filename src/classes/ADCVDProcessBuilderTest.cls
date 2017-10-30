/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ADCVDProcessBuilderTest {
	
	@testSetup static void setupRecords(){
		//Petition is created and users are assgined to its realted staffing assignments
		Date petitionDate = Date.Today();
        Petition__c aPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
        Profile aProfile = [Select Id From Profile Where Name ='Standard User'];
        
        List<Staffing_Assignment__c> staffingAssignments = [Select Id, Name, User__c From Staffing_Assignment__c];
        List<User> usersToInsert = new List<User>();
        for(Integer i=0; i<staffingAssignments.size(); i++){
        	usersToInsert.add(TestUtils.createGenericUser(i+'initialAssignment@trade.gov',i+'username@trade.gov', aProfile.Id));
        } 
        insert usersToInsert;
        
        for(Integer i=0; i<staffingAssignments.size(); i++){
        	staffingAssignments[i].User__c = usersToInsert[i].Id;
        }
        update staffingAssignments;
	}
	
    @isTest static void petitionStaffingAssignmentFeedTest() {
    	//Create a petition, staffing assignemnts get auto created for it, 
    	//need to reassign those staffing assignments to different users
    	//check the staffing assignment show up in their feed
        Profile aProfile = [Select Id From Profile Where Name ='Standard User'];
        
        Petition__c queriedPetition = [Select Id, Name From Petition__c Limit 1];
        //Assert petition is created
        System.assert(queriedPetition != null);
        
        List<Staffing_Assignment__c> staffingAssignments = [Select Id, Name,User__c, User__r.Username From Staffing_Assignment__c];
        //Assert staffing assignemnts were created
        System.assert(staffingAssignments.size() > 0);
        
        //Set of assigned user Ids at the begining
        Set<String> userIds = new Set<String>();
        for(Staffing_Assignment__c anAssignment: staffingAssignments){
        	userIds.add(anAssignment.User__c);
        	String username = anAssignment.User__r.Username;
        	System.assert(username.contains('initialassignment')); 
        }
        
        
        List<FeedItem> feedItems = [Select ParentId, Id, Body From FeedItem Where ParentId in: userIds];
        System.assert(feedItems.size() == staffingAssignments.size());
        
        
        //Reassigning to new users
        List<User> reassignedUsers = new List<User>();
        for(Integer i=0; i<staffingAssignments.size(); i++){
        	reassignedUsers.add(TestUtils.createGenericUser(i+'reassignment@trade.gov',i+'username@trade.gov', aProfile.Id));
        } 
        insert reassignedUsers;
        for(Integer i=0; i<staffingAssignments.size(); i++){
        	//Reassign to different user
        	staffingAssignments[i].User__c = reassignedUsers[i].Id;
        }
        Test.startTest();
        update staffingAssignments;
        Test.stopTest(); 
        
        List<Staffing_Assignment__c> staffingAssignments2 = [Select Id, Name,User__c, User__r.Username From Staffing_Assignment__c];
        
        
        Set<String> reassignedUserIds = new Set<String>();
        for(Staffing_Assignment__c anAssignment: staffingAssignments2){
        	reassignedUserIds.add(anAssignment.User__c);
        	String username = anAssignment.User__r.Username;
        	System.assert(username.contains('reassignment'));
        }
        List<FeedItem> feedItems2 = [Select ParentId, Id, Body From FeedItem Where ParentId in: reassignedUserIds];
        
		System.assert(feedItems2.size() == reassignedUsers.size());        
        
    }
    
}
