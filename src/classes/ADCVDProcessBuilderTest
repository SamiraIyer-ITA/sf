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
		Date petitionDate = Date.Today();
        Petition__c aPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
		
	}
	
    @isTest static void petitionStaffingAssignmentFeedTest() {
    	//Create a petition, staffing assignemnts get auto created for it, 
    	//need to reassign those staffing assignments to different users
    	//check the staffing assignment show up in their feed
        Profile aProfile = [Select Id From Profile Where Name ='Standard User'];
        
        Petition__c queriedPetition = [Select Id, Name From Petition__c Limit 1];
        //Assert petition is created
        System.assert(queriedPetition != null);
        
                
        List<Staffing_Assignment__c> queriedSA = [Select Id, Name, User__c From Staffing_Assignment__c];
        System.assert(queriedSA.size() > 0, 'No Staffing Assignments were created');
        List<User> usersToInsert = new List<User>();
        for(Integer i=0; i<queriedSA.size(); i++){
        	usersToInsert.add(TestUtils.createGenericUser(i+'username@trade.gov',i+'username@trade.gov', aProfile.Id));
        } 
        insert usersToInsert;
        
        for(Integer i=0; i<queriedSA.size(); i++){
        	queriedSA[i].User__c = usersToInsert[i].Id;
        }
        Test.startTest();
        update queriedSA;
        Test.stopTest();
        
        //Set of assigned user Ids at the begining
        Set<String> userIds = new Set<String>();
        for(User aUser: usersToInsert){
        	userIds.add(aUser.Id);
        }
        
        
        List<FeedItem> feedItems = [Select ParentId, Id, Body From FeedItem Where ParentId in: userIds];
        System.assert(feedItems.size() == queriedSA.size());
        
        
        //Reassigning to new users
        List<Staffing_Assignment__c> queriedSA2 = [Select Id, Name, User__c From Staffing_Assignment__c];
        List<User> reassignedUsers = new List<User>();
        for(Integer i=queriedSA.size(); i<queriedSA2.size()*2; i++){//starting point of i is different to avoid duplicate users
        	reassignedUsers.add(TestUtils.createGenericUser(i+'username@trade.gov',i+'username@trade.gov', aProfile.Id));
        } 
        insert reassignedUsers;
        for(Integer i=0; i<queriedSA2.size(); i++){
        	//Reassign to different user
        	queriedSA2[i].User__c = reassignedUsers[i].Id;
        }
        update queriedSA2;
        Set<String> reassignedUserIds = new Set<String>();
        for(User aUser: reassignedUsers){
        	reassignedUserIds.add(aUser.Id);
        }
        List<FeedItem> feedItems2 = [Select ParentId, Id, Body From FeedItem Where ParentId in: reassignedUserIds];
        
		System.assert(feedItems2.size() == reassignedUsers.size());        
        
    }
    
}
