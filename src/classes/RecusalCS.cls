/**
 * 
 *    Created by Joshua Moody
 *    on Apr 3 2017
 *    MIL Corporation
 * 
 **/

public without sharing class RecusalCS implements ADCVD_CascadeService {

	/******************************************************************
	* This class queries Recusals and stores them in class
	* for faster reference by classes.
	* This class provides methods to:
	* 1. Query Recusals in scope of the parents/grandparents
	* 2. Map those records for the easiest consumption by classes
	******************************************************************/

	/**
	 * Implements the ADCVD_CascadeService for Recusal__c objects
	 * @param  parentObjectName Not needed currently, but is in place in case special logic applies to different parent SObject types
	 * @param  parentIdSet      List of parentIds. Can be Recusal__c Ids if a Recusal__c is inserted or updated
	 * @return                  Map of parentId to Recusal__c that has been type cast to an SObject
	 */
	public Map<Id,SObject> getParentIdToObjectMap(String parentObjectName, Set<Id> parentIdSet){
		return new Map<Id,SObject>();
	}

	/**
	 * Implements the ADCVD_CascadeService for Recusal__c objects
	 * @param  parentObjectName Not needed currently, but is in place in case special logic applies to different parent SObject types
	 * @param  parentIdSet      List of parentIds. Can be Recusal__c Ids if a Recusal__c is inserted or updated
	 * @return                  Map of parentId to List of Recusal__c objects that has been type cast to SObjects
	 */
	public static Map<Id,List<SObject>> getParentIdToObjectsMap(String parentObjectName, Set<Id> parentIdSet) {
		Map<Id,List<Recusal__c>> returnMap = new Map<Id,List<Recusal__c>>();
		Date today = System.today();
		//query all potential parents for the Recusals whose parent is in the parentIdSet
		for(Recusal__c r : [SELECT Id, Actor__c, Actor_Start_Date__c, Actor_End_Date__c, Start_Date__c, End_Date__c, User__c, Primary_Recusal_Aligned_To__c, 
								Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Litigation__c, Related_Organization__c, Related_Organization__r.Account__c 
							FROM Recusal__c 
							WHERE User__c IN: parentIdSet AND Start_Date__c <=: today AND End_Date__c >=: today
							]) {
			//create a temporary set for this Recusal that contains all it's potential parents
			Set<Id> tempSet = new Set<Id>{
				r.Id, r.Petition__c, r.Investigation__c, r.ADCVD_Order__c, r.Segment__c, r.Litigation__c, 
				r.Related_Organization__c, r.Related_Organization__r.Account__c, r.Primary_Recusal_Aligned_To__c};
			for (Id tempId : tempSet) {
				if (tempId != null) {//only map this Recusal to parents that are not null
					List<Recusal__c> tempList = new List<Recusal__c>();
					if (returnMap.get(tempId) != null) {
						tempList.addAll(returnMap.get(tempId));
					}
					tempList.add(r);
					returnMap.put(tempId, tempList);
				}
			}
		}
		return (Map<Id,List<SObject>>)returnMap;
	}
}