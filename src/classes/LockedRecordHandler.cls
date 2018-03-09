public without sharing class LockedRecordHandler {

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