/**
 * 
 *    Created by Joshua Moody & Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/
//interface for the inner classes
	public interface IChatterPostWriter {
        
		//iterates through incoming map
		void getChatterPosts(Map<Id,SObject> newMap, Map<Id,SObject> oldMap);
        /*
		//must be implemented in each extended class, orders the logic for the potential posts per record
		void checkConditions(SObject newRecord, SObject oldRecord);
        
		//add a finished post to one of the maps for posting
		void addPostToPostMap(String finishedPost, SObject newRecord, Boolean tempMap);
        
		//check Test.isRunningTest() and call the correct posting method
		void separatePostCall();
        
		//overloaded to handle either map and posts accordingly
		void postToChatter(Map<Id, List<String>> postMap, Boolean tempMap);
        
		//check if condition was met
		Map<String,String> fieldChanged(String fieldName, SObject newRecord, SObject oldRecord);
        
		//get template from mdt and add case info
		String addTemplateWithCaseInfo(SObject newRecord, Automated_Chatter_Post__mdt postTemplate);
		String setCaseInformation(SObject newRecord);
        
		//get details from record for this specific change
		String addExtensionChangeToPost(String extType, Map<String, String> newToOldValueMap);
		String addExtensionResultToPost(Map<String, String> fieldNameToLabelMap, SObject newRecord);
		String getLitigationStateChange(SObject newRecord, SObject oldRecord);
        
		//add a link to the record
		String addLinkToPost(SObject newRecord);
        
		//mention users whose titles are in the template
		String mentionChatterRecipients(SObject newRecord, String post); */
	}