global without sharing class Flow_CreatePaymentRecord {

	@InvocableMethod(label='Create Payment Record' description='Inserts a Payment record and updates the order(s)' category='Payments')
	global static List<String> createPaymentRecord(List<RequestVariables> inputs){

		if (inputs.isEmpty()) {
			return null;
		}

		try {
			String contractId = inputs[0].contractId;
			String paymentType = inputs[0].paymentType;
			Decimal amount = inputs[0].amount;
			List<Order> orders = inputs[0].orders;
			String bankName = inputs[0].bankName;
			String checkNumber = inputs[0].checkNumber;
			Date checkDate = inputs[0].checkDate;
			Datetime bankTransferDatetime = inputs[0].bankTransferDatetime;
			String accountType = inputs[0].accountType;

			//Create the payment record
			Payment2__c payment = new Payment2__c();

			//Determine the record type id
			String recordTypeName;
			switch on paymentType {
				when 'Check' {
					recordTypeName = 'Check_Payment';
					payment.Bank_Name__c = bankName;
					payment.Check_Number__c = checkNumber;
					payment.Check_Date__c = checkDate;
				}
				when 'Cash' {
					recordTypeName = 'Cash_Payment';
				}
				when 'Bank Transfer' {
					recordTypeName = 'Bank_Transfer_Payment';
					payment.Transaction_Date__c = bankTransferDatetime;
				}
			}

			payment.Account_Type__c = accountType;
			payment.RecordTypeId = Utils.getRecordTypeNameByDeveloperName(recordTypeName, 'Payment2__c');
			payment.Contract__c = contractId;
			payment.Payment_Processor__c = '';
			payment.Transaction_Status__c = 'Success';
			payment.Transaction_Amount__c = amount;
			try {
				fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
				uow.registerNew(payment);
				for (Order eachOrder: orders) {
					eachOrder.Payment2__c = payment.Id;
					eachOrder.Order_Paid__c = true;
					uow.registerDirty(eachOrder, Order.Payment2__c, payment);
				}
				uow.commitWork();
			} catch (Exception e) {
				String errorMessage = 'Unable to insert payment or update order records.';
				throw new CreatePaymentRecordActionException(errorMessage + '  ' + e.getMessage());
			}

			return new List<String>{(String) payment.Id};

		} catch(Exception e) {
			throw new CreatePaymentRecordActionException(e.getMessage());
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Contract Id' required=true)
		global String contractId;

		@InvocableVariable(label='Payment Type' required=true)
		global String paymentType;  //Bank Transfer, Cash, Check

		@InvocableVariable(label='Payment Amount' required=true)
		global Decimal amount;

		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;

		@InvocableVariable(label='Bank Name' required=false)
		global String bankName;

		@InvocableVariable(label='Check Number' required=false)
		global String checkNumber;

		@InvocableVariable(label='Check Date' required=false)
		global Date checkDate;

		@InvocableVariable(label='Bank Transfer Datetime' required=false)
		global Datetime bankTransferDatetime;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;
	}

	class CreatePaymentRecordActionException extends Exception {}


}