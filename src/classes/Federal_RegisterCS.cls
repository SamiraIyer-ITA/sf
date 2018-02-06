/**
 * 
 *    Created by Joshua Moody
 *    on Mar 8 2017
 *    MIL Corporation
 * 
 **/

public without sharing class Federal_RegisterCS implements ADCVD_CascadeService {

	/************************************************
    * This class queries and maps Federal Registers to their parents and grandparents.  This 
    * query is more expensive because of the ORs in the WHERE clause, but saves
    * on the number of queries due to cascading updates.  This class provides
    * methods to:
    * 1. Get a map of Federal Registers to all possible parent/grandparents that it could affect calculations
    *************************************************/

	/**
	 * Implements the ADCVD_CascadeService for Federal_Register__c objects
	 * @param  parentObjectName Not needed currently, but is in place in case special logic applies to different parent SObject types
	 * @param  parentIdSet      List of parentIds. Can be Federal_Register__c Ids if a Federal_Register__c is inserted or updated
	 * @return                  Map of parentId to Federal_Register__c that has been type cast to an SObject
	 */

	public Map<Id,SObject> getParentIdToObjectMap(String parentObjectName, Set<Id> parentIdSet){
		return new Map<Id,SObject>();
	}

	/**
	 * Implements the ADCVD_CascadeService for Federal_Register__c objects
	 * @param  parentObjectName Not needed currently, but is in place in case special logic applies to different parent SObject types
	 * @param  parentIdSet      List of parentIds. Can be Federal_Register__c Ids if a Federal_Register__c is inserted or updated
	 * @return                  Map of parentId to List of Federal_Register__c objects that has been type cast to SObjects
	 */
	public Map<Id,List<SObject>> getParentIdToObjectsMap(String parentObjectName, Set<Id> parentIdSet) {
		Map<Id,List<Federal_Register__c>> returnMap = new Map<Id,List<Federal_Register__c>>();
		if (parentObjectName == 'Segment__c') {
			for (Segment__c s : [SELECT ADCVD_Order__c, Suspension_Agreement__c FROM Segment__c WHERE Id IN: parentIdSet]) {
				parentIdSet.add(s.ADCVD_Order__c);
				parentIdSet.add(s.Suspension_Agreement__c);
			}
		}
		if (parentObjectName == 'Investigation__c') {
			for (ADCVD_Order__c ao : [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c IN: parentIdSet]) {
				parentIdSet.add(ao.Id);
			}
		}
		//query all potential parents for the FRs whose parent is in the parentIdSet
		for(Federal_Register__c fr : [SELECT Id, Type__c, Published_Date__c, Do_Delete__c, Segment__c, Segment__r.ADCVD_Order__c, Investigation__c, CreatedDate, 
										ADCVD_Order__c, ADCVD_Order__r.Investigation__c, Suspension_Agreement__c, Suspension_Agreement__r.Investigation__c 
										FROM Federal_Register__c 
										WHERE Id IN: parentIdSet
										OR Segment__c IN: parentIdSet
										OR Investigation__c IN: parentIdSet
										OR ADCVD_Order__c IN: parentIdSet
										OR Suspension_Agreement__c IN: parentIdSet]) {
			//create a temporary set for this FR that contains all it's potential parents
			Set<Id> tempSet = new Set<Id>{fr.Id, fr.Segment__c, fr.Segment__r.ADCVD_Order__c, fr.Investigation__c, fr.ADCVD_Order__c, 
											fr.ADCVD_Order__r.Investigation__c, fr.Suspension_Agreement__c, fr.Suspension_Agreement__r.Investigation__c};
			for(Id tempId : tempSet) {
				if(tempId != null) {//only map this FR to parents that are not null
					List<Federal_Register__c> tempList = new List<Federal_Register__c>();
					if(returnMap.get(tempId) != null) {
						tempList.addAll(returnMap.get(tempId));
					}
					tempList.add(fr);
					returnMap.put(tempId, tempList);
				}
			}
		}
		return (Map<Id,List<SObject>>)returnMap;
	}
}