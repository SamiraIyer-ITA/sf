public interface ADCVD_CascadeService {
/**
 * This interface is for classes to implement logic needed for cascading updates.
 * Every method here must have a corresponding method in each of the 
 * implementation classes.  
 */

 	/**
 	 * Method for returning a map of Ids to single SObjects.  Only use when each parentId will only have one SObject returned
 	 * @param  currentObjectName The name of the current object in the trigger.
 	 * @param  parentIdSet       The current set of parentIds.  For additive queries, this should be kept in a utility class as a class level static Set<Id>.
 	 *                           This means any secondary queries (which should be rare) are added to the parentIdSet in the utility class and passed here.
 	 * @return                   Map of parentId to child SObject
 	 */
	Map<Id,SObject> getParentIdToObjectMap(String currentObjectName, Set<Id> parentIdSet);

	/**
 	 * Method for returning a map of Ids to a List of SObjects.  Use when a parentId could have more one SObject returned
 	 * @param  currentObjectName The name of the current object in the trigger.
 	 * @param  parentIdSet       The current set of parentIds.  For additive queries, this should be kept in a utility class as a class level static Set<Id>.
 	 *                           This means any secondary queries (which should be rare) are added to the parentIdSet in the utility class and passed here.
 	 * @return                   Map of parentId to List of child SObjects
 	 */
	Map<Id,List<SObject>> getParentIdToObjectsMap(String currentObjectName, Set<Id> parentIdSet);


	Map<Id,Set<Id>> getIdToHierarchyIdSetMap();
}