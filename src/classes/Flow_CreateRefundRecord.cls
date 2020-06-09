global without sharing class Flow_CreateRefundRecord {

	@InvocableMethod(label='Create Refund Record' description='Inserts a Refund record and updates the order(s)' category='Payments')
	global static List<ResponseVariables> createRefundRecord(List<RequestVariables> inputs){

		if (inputs.isEmpty()) {
			return null;
		}

		try {
			String contractId = inputs[0].contractId;
			String accountType = inputs[0].accountType;
			Decimal refundAmount = inputs[0].refundAmount;
			List<Order> ordersWithoutParentOrders = inputs[0].orders;

			//The passed-in orders don't have information about their parent orders, so query them
			Set<Id> orderIds = new Set<Id>();
			for (Order order: ordersWithoutParentOrders) {
				orderIds.add(order.Id);
			}

			List<Order> orders = OrdersSelector.newInstance().selectWithReductionOrderDetails(orderIds, false, true, true, false);

			//Create the refund record
			Payment2__c refund = new Payment2__c();

			String recordTypeName = 'NIST_Issued_Refund';
			refund.Account_Type__c = accountType;
			refund.RecordTypeId = Utils.getRecordTypeNameByDeveloperName(recordTypeName, 'Payment2__c');
			refund.Contract__c = contractId;
			refund.Payment_Processor__c = '';
			refund.Transaction_Status__c = 'Success';
			//refund.Payment2__c = orders.;
			refund.Transaction_Amount__c = refundAmount;  //Calculate this here or use passed-in value?

			List<Order> originalOrders = new List<Order>();
			try {
				fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
				uow.registerNew(refund);
				for (Order eachOrder: orders) {
					eachOrder.Payment2__c = refund.Id;
					eachOrder.Status = 'Paid';
					eachOrder.Order_Paid__c = true;
					uow.registerDirty(eachOrder, Order.Payment2__c, refund);
					//Update the original order to keep track of the refunded amount
					eachOrder.OriginalOrder.Refunded_Amount__c = eachOrder.OriginalOrder.Refunded_Amount__c + Math.abs(eachOrder.TotalAmount);
					originalOrders.add(eachOrder.OriginalOrder);
				}
				uow.registerDirty(originalOrders);
				uow.commitWork();
			} catch (Exception e) {
				String errorMessage = 'Unable to insert refund or update order records.';
				throw new CreateRefundRecordActionException(e.getMessage());
			}

			ResponseVariables responseVariables = new ResponseVariables();
			responseVariables.refundId = refund.Id;
			List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();
			responseVariablesList.add(responseVariables);
			return responseVariablesList;

		} catch(Exception e) {
			throw new CreateRefundRecordActionException(e.getMessage());
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Contract Id' required=true)
		global String contractId;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;

		@InvocableVariable(label='Refund Amount' required=true)
		global Decimal refundAmount;

		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Refund Id' required=true)
		global String refundId;

	}

	class CreateRefundRecordActionException extends Exception {}

}