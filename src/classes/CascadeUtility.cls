/**
 * 
 *    Created by Joshua Moody
 *    on Mar 8 2017
 *    MIL Corporation
 * 
 **/

public without sharing class CascadeUtility {

	/********** In the Process of deprecating for the Mapper Classes**********
	* This is the utility that is called to use any of the Cascade Services
	* Each Cascade Service will need a class named as it's object without the
	* ending "__c" and with "CS" in its place.  Then add that service to the
	* Service__mdt as a record with the Service_Type__c "Cascade Services" and
	* Service_Object_Name__c as the name of the object without the ending "__c".
	************************************************************************/
	
	//used for exceptions with the service name is not found from the Service_mdt
	public class NameException extends Exception{}

	public static FINAL Map<String,ADCVD_CascadeService> CASCADESERVICES;

	//Initiation code
	static{
		List<String> cascadeServiceNames = new List<String>();
		//get the names of the Cascade Services
		for(Service__mdt sv : [SELECT Service_Object_Name__c, Service_Type__c FROM Service__mdt WHERE Service_Type__c = 'Cascade Services']) {
			if(sv != null && sv.Service_Object_Name__c != null) {
				cascadeServiceNames.add(sv.Service_Object_Name__c);
			}
		}
		CASCADESERVICES = new Map<String,ADCVD_CascadeService>();
		//map the Cascade Service Name (Service_Object_Name__c value) to a class type of that name + CS
		for(String name : cascadeServiceNames) {
			try {
				CASCADESERVICES.put(name, (ADCVD_CascadeService)Type.forName(name + 'CS').newInstance());
			} catch (Exception e) {
				continue;
			}
		}
	}
	//instantiate the parent interface
	private ADCVD_CascadeService cs;
	/**
	 * Constructor called in classes
	 * @param  objectName The name of the object that corresponds to the Cascade Service implementation neeeded
	 * @return            [description]
	 */
	public CascadeUtility(String objectName) {
		//set string to match the Service_Object_Name from the Service__mdt query
		objectName = objectName.removeEnd('__c');
		if(!CASCADESERVICES.containsKey(objectName)) throw new NameException(objectName);
		cs = CASCADESERVICES.get(objectName);
	}

	//methods that can be called in class for a CascadeUtility instance.  Check the implementation for the object to see logic
	public Map<Id,SObject> getParentObjectMap(String parentObjectName, Set<Id> parentIdSet) {
		return cs.getParentIdToObjectMap(parentObjectName, parentIdSet);
	}
	public Map<Id,List<SObject>> getParentIdToObjectsMap(String parentObjectName, Set<Id> parentIdSet) {
		return cs.getParentIdToObjectsMap(parentObjectName, parentIdSet);
	}
}