public without sharing class RecusalCS implements ADCVD_CascadeService {

	public static Map<Id,Set<Id>> idToHierarchyIdSetMap = new Map<Id,Set<Id>>();

	public static Map<Id,Set<Id>> getIdToHierarchyIdSetMap(){
		return idToHierarchyIdSetMap;
	}

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
								Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Litigation__c, Related_Organization__c,
								Investigation__r.AD_Investigation_Aligned_To__c, Investigation__r.Petition__c,
								Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								ADCVD_Order__r.Investigation__c, ADCVD_Order__r.Investigation__r.Petition__c,
								ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c,
								ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								Segment__r.ADCVD_Order__c, Segment__r.ADCVD_Order__r.Investigation__c,
								Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, 
								Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								Segment__r.ADCVD_Order__r.Investigation__r.Petition__c,
								Litigation__r.Segment__c, Litigation__r.Segment__r.ADCVD_Order__c,
								Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c,
								Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c,
								Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c,
								Litigation__r.Investigation__c, Litigation__r.Investigation__r.Petition__c,
								Litigation__r.Investigation__r.AD_Investigation_Aligned_To__c,
								Litigation__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								Related_Organization__r.ADCVD_Order__c, Related_Organization__r.ADCVD_Order__r.Investigation__c,
								Related_Organization__r.ADCVD_Order__r.Investigation__r.Petition__c,
								Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c,
								Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								Related_Organization__r.Investigation__c, Related_Organization__r.Investigation__r.Petition__c,
								Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__c,
								Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
								Related_Organization__r.Legal_Representation__c,
								Related_Organization__r.Litigation__c, Related_Organization__r.Litigation__r.Segment__c,
								Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__c,
								Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c,
								Related_Organization__r.Petition__c, Related_Organization__r.Segment__c,
								Related_Organization__r.Segment__r.ADCVD_Order__c, Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__c,
								Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c,
								Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c
							FROM Recusal__c 
							WHERE User__c IN: parentIdSet AND Primary_Recusal_Aligned_To__c !=: null AND Start_Date__c <=: today AND End_Date__c >=: today
							]) {
			//create sets for each hierarchy to be mapped to the direct parent
			Set<Id> tempInvestigationSet = new Set<Id>{r.Investigation__r.AD_Investigation_Aligned_To__c, 
				r.Investigation__r.Petition__c, r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c};
			Set<Id> tempOrderSet = new Set<Id>{r.ADCVD_Order__r.Investigation__c, r.ADCVD_Order__r.Investigation__r.Petition__c,
				r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c};
			Set<Id> tempSegmentSet = new Set<Id>{r.Segment__r.ADCVD_Order__c, r.Segment__r.ADCVD_Order__r.Investigation__c,
				r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c,
				r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c};
			Set<Id> tempLitigationSet = new Set<Id>{r.Litigation__r.Segment__c, r.Litigation__r.Segment__r.ADCVD_Order__c,
				r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c, r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c,
				r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Litigation__r.Investigation__c, r.Litigation__r.Investigation__r.Petition__c,
				r.Litigation__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Litigation__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c};
			Set<Id> tempRelatedOrgSet = new Set<Id>{r.Related_Organization__r.ADCVD_Order__c, r.Related_Organization__r.ADCVD_Order__r.Investigation__c,
				r.Related_Organization__r.ADCVD_Order__r.Investigation__r.Petition__c, r.Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c,
				r.Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Related_Organization__r.Investigation__c, 
				r.Related_Organization__r.Investigation__r.Petition__c, r.Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__c,
				r.Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Related_Organization__r.Legal_Representation__c,
				r.Related_Organization__r.Litigation__c, r.Related_Organization__r.Litigation__r.Segment__c, r.Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__c,
				r.Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c, r.Related_Organization__r.Petition__c, r.Related_Organization__r.Segment__c,
				r.Related_Organization__r.Segment__r.ADCVD_Order__c, r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__c, r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c,
				r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c};
			//create a temporary set for this Recusal that contains all it's potential parents
			Set<Id> tempSet = new Set<Id>{
				r.Petition__c, r.Investigation__c, r.ADCVD_Order__c, r.Segment__c, r.Litigation__c, r.Related_Organization__c, r.Primary_Recusal_Aligned_To__c, r.Investigation__r.AD_Investigation_Aligned_To__c, 
				r.Investigation__r.Petition__c, r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.ADCVD_Order__r.Investigation__c, r.ADCVD_Order__r.Investigation__r.Petition__c, 
				r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Segment__r.ADCVD_Order__c, 
				r.Segment__r.ADCVD_Order__r.Investigation__c, r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, 
				r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c, r.Litigation__r.Segment__c, 
				r.Litigation__r.Segment__r.ADCVD_Order__c, r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c, r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c, 
				r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Litigation__r.Investigation__c, r.Litigation__r.Investigation__r.Petition__c, 
				r.Litigation__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Litigation__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Related_Organization__r.ADCVD_Order__c, 
				r.Related_Organization__r.ADCVD_Order__r.Investigation__c, r.Related_Organization__r.ADCVD_Order__r.Investigation__r.Petition__c, 
				r.Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c, r.Related_Organization__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, 
				r.Related_Organization__r.Investigation__c, r.Related_Organization__r.Investigation__r.Petition__c, r.Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__c, 
				r.Related_Organization__r.Investigation__r.AD_Investigation_Aligned_To__r.Petition__c, r.Related_Organization__r.Legal_Representation__c, r.Related_Organization__r.Litigation__c, 
				r.Related_Organization__r.Litigation__r.Segment__c, r.Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__c, 
				r.Related_Organization__r.Litigation__r.Segment__r.ADCVD_Order__r.Investigation__c, r.Related_Organization__r.Petition__c, r.Related_Organization__r.Segment__c, 
				r.Related_Organization__r.Segment__r.ADCVD_Order__c, r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__c, 
				r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.Petition__c, r.Related_Organization__r.Segment__r.ADCVD_Order__r.Investigation__r.AD_Investigation_Aligned_To__c};
			for (Id tempId : tempSet) {
				if (tempId != null) {//only map this Recusal to parents that are not null
					List<Recusal__c> tempList = new List<Recusal__c>();
					if (returnMap.get(tempId) != null) {
						tempList.addAll(returnMap.get(tempId));
					}
					tempList.add(r);
					returnMap.put(tempId, tempList);
				}
				Set<Id> tempHierarchySet = new Set<Id>();
				if (tempId == r.Investigation__c) {
					if(idToHierarchyIdSetMap.get(r.Investigation__c) != null) {
						tempHierarchySet = idToHierarchyIdSetMap.get(r.Investigation__c);
					}
					tempHierarchySet.addAll(tempInvestigationSet);
					idToHierarchyIdSetMap.put(r.Investigation__c, tempHierarchySet);
				} else if (tempId == r.ADCVD_Order__c) {
					if(idToHierarchyIdSetMap.get(r.ADCVD_Order__c) != null) {
						tempHierarchySet = idToHierarchyIdSetMap.get(r.ADCVD_Order__c);
					}
					tempHierarchySet.addAll(tempOrderSet);
					idToHierarchyIdSetMap.put(r.ADCVD_Order__c, tempHierarchySet);
				} else if (tempId == r.Segment__c) {
					if(idToHierarchyIdSetMap.get(r.Segment__c) != null) {
						tempHierarchySet = idToHierarchyIdSetMap.get(r.Segment__c);
					}
					tempHierarchySet.addAll(tempSegmentSet);
					idToHierarchyIdSetMap.put(r.Segment__c, tempHierarchySet);
				} else if (tempId == r.Litigation__c) {
					if(idToHierarchyIdSetMap.get(r.Litigation__c) != null) {
						tempHierarchySet = idToHierarchyIdSetMap.get(r.Litigation__c);
					}
					tempHierarchySet.addAll(tempLitigationSet);
					idToHierarchyIdSetMap.put(r.Litigation__c, tempHierarchySet);
				} else if (tempId == r.Related_Organization__c) {
					if(idToHierarchyIdSetMap.get(r.Related_Organization__c) != null) {
						tempHierarchySet = idToHierarchyIdSetMap.get(r.Related_Organization__c);
					}
					tempHierarchySet.addAll(tempRelatedOrgSet);
					idToHierarchyIdSetMap.put(r.Related_Organization__c, tempHierarchySet);
				}
			}
		}
		//remove nulls from idToHierarchyIdSetMap
		for(Id parent : idToHierarchyIdSetMap.keySet()) {
			if(idToHierarchyIdSetMap.get(parent).isEmpty()) {
				idToHierarchyIdSetMap.remove(parent);
			} else {
				for(Id hierarchyId : idToHierarchyIdSetMap.get(parent)) {
					if(hierarchyId == null) {
						idToHierarchyIdSetMap.get(parent).remove(hierarchyId);
					}
				}
			}	
		}
		return (Map<Id,List<SObject>>)returnMap;
	}
}