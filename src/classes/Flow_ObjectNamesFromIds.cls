global without sharing class Flow_ObjectNamesFromIds {

	@InvocableMethod(label='Get Object Names From Ids' description='Gets a unique list of object names for a list of Ids.' category='SObjects')
	global static List<String> findObjectNamesFromRecordIdPrefixes(List<RequestVariables> inputs){
		if (inputs.isEmpty()) {
			return null;
		}
		List<String> ids = inputs[0].ids;
		Set<String> returnSet = new Set<String>();
		for (String id: ids) {
			returnSet.add(Utils.findObjectNameFromRecordIdPrefix(id));
		}
		return new List<String>(returnSet);
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Id' required=true)
		global List<String> ids;
	}

}