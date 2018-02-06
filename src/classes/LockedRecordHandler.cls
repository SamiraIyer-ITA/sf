/**
 * 
 *    Created by Joshua Moody
 *    on Oct 20 2017
 *    MIL Corporation
 * 
 **/

public without sharing class LockedRecordHandler {

	/************************************************
    * This class checks the values of the Locked__c field
    * on records of all objects in the ADCVD App and removes
    * them from the list so they are not triggered for updates.
    * There are validation rules in place to keep almost all users
    * from being able to edit a locked record.  For those users
    * that can edit a locked record, this effectively disables
    * triggers so they can set any value without interference.
    * This class provides methods that:
    * 1. Build a set of Ids of locked records
    * 2. Return a list with only unlocked (Locked__c == false) records
    *************************************************/

	public Set<Id> getLockedRecordSet(List<SObject> soList) {
		Set<Id> returnSet = new Set<Id>();
		for (SObject s : soList) {
			Boolean locked = (Boolean) s.get('Locked__c');
			if (locked) {
				returnSet.add((Id)s.get('Id'));
			} else {
				continue;
			}
		}
		return returnSet;
	}
	public List<SObject> removeLockedRecords(List<SObject> initialList) {
		List<SObject> returnList = new List<SObject>();
		for (SObject s : initialList) {
			Boolean locked = (Boolean) s.get('Locked__c');
			if (!locked) {
				returnList.add(s);
			} else {
				continue;
			}
		}
		return returnList;
	}
}