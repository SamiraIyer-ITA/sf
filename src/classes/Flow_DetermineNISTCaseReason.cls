global without sharing class Flow_DetermineNISTCaseReason {

	/**
	* Return the value of the Case Reason field for a new Transaction Management Support Case.
	*
	* @return The Case Reason value in a List of Response Variables.
	*/
	@InvocableMethod(label='Determine Case Reason' description='Based on the user Profile, determine the Case Reason' category='Payments')
	global static List<ResponseVariables> determineNISTCaseReason() {

		try {
			String caseReason = null;  //Will be 'To NIST' or 'From NIST'
			Id profileId = userinfo.getProfileId();
			Profile myProfile = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1];
			if (myProfile.Name == 'Transaction Management') {
				caseReason = 'From NIST';
			} else {
				caseReason = 'To NIST';
			}
			QueueSobject queue = [SELECT Id, QueueId FROM QueueSobject WHERE Queue.DeveloperName = 'Transaction_Management_Support' LIMIT 1];
			ResponseVariables responseVariables = new ResponseVariables();
			responseVariables.queueId = queue.QueueId;
			responseVariables.caseReason = caseReason;
			responseVariables.recordTypeId = Utils.getRecordTypeIdMap('Case').get('Transaction_Management_Support');
			List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();
			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		} catch(Exception e) {
			throw new DetermineNISTCaseReasonActionException(e.getMessage());
		}
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Case Reason' required=true)
		global String caseReason;

		@InvocableVariable(label='Transaction Management Record Type Id' required=true)
		global String recordTypeId;

		@InvocableVariable(label='Transaction Management Support Queue Id' required=true)
		global String queueId;
	}

	class DetermineNISTCaseReasonActionException extends Exception {}

}
