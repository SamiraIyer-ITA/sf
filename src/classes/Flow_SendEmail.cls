/**
 * Created by Mark Keckeis on 7/6/2020.
 */

global without sharing class Flow_SendEmail {

	@InvocableMethod(label='Create Email Receipt' description='Sends an email receipt from Order or Payment2' category='Email')
	global static List<ResponseVariables> createEMailReceipt(List<RequestVariables> inputs){

		ResponseVariables responseFromEmail = new ResponseVariables();
		List<ResponseVariables> rv = new List<ResponseVariables>();

		if (inputs.isEmpty()) {
			rv.add(responseFromEmail);
			return rv;
		}
		try{
			String csvEmails = inputs[0].emailList;
			String recordId = inputs[0].recordId;

			String jsonReturnedFrom = REST_EmailTransactionReceipt.doPost(csvEmails, recordId);
			REST_EmailTransactionReceipt.EmailResult emailResult = (REST_EmailTransactionReceipt.EmailResult)JSON.deserialize(jsonReturnedFrom, REST_EmailTransactionReceipt.EmailResult.class);
			responseFromEmail.VarEmailReceiptSent = emailResult.receiptSent;
			responseFromEmail.VarEmailErrorMessage = emailResult.errorMessage;
			rv.add(responseFromEmail);
			return rv;
		}
		catch(Exception e){
			responseFromEmail.VarEmailErrorMessage = e.getMessage();
			rv.add(responseFromEmail);
			return rv;
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='FormulaEmailList' required=true)
		global String emailList;
		@InvocableVariable(label='VarRecordID' required=true)
		global String recordID;
		@InvocableVariable(label='FormulaUserID' required=true)
		global String userId;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='VarEmailErrorMessage' required=true)
		global String VarEmailErrorMessage = '';
		@InvocableVariable(label='VarEmailReceiptSent' required=true)
		global Boolean VarEmailReceiptSent = false;
	}

	class SendReceiptEmailException extends Exception {}
}