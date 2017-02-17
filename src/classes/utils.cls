public class utils {
	//Gets a map of Record Type Ids to Developer Names for the object name
	public static Map<Id,String> getRecordTypeDeveloperNameMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType =: sObjectName]){
			returnMap.put(rt.Id, rt.DeveloperName);
		}
		return returnMap;
	}
	public static Map<Id,String> getRecordTypeDeveloperNameMap(SObject o){
		Schema.DescribeSObjectResult dsr = o.getSObjectType().getDescribe();
		String sObjectName = dsr.getName();
		Map<Id,String> returnMap = getRecordTypeDeveloperNameMap(sObjectName);
		return returnMap;
	}
}