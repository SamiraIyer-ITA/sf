global with sharing class Flow_DetermineNISTCaseReason {

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
			if (myProfile.Name == 'NIST User') {
				caseReason = 'From NIST';
			} else {
				caseReason = 'To NIST';
			}
			ResponseVariables responseVariables = new ResponseVariables();
			responseVariables.caseReason = caseReason;
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
	}

	class DetermineNISTCaseReasonActionException extends Exception {}

}