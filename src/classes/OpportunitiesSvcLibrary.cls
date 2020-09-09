/**
 * Opportunities Service class that can be called by implementations when they share the same exact methodology.
 */
public with sharing class OpportunitiesSvcLibrary {

	public static OpportunityNeedsAnalysisNewContract oppNeedsAnalysisNewContract {
		get {
			if (oppNeedsAnalysisNewContract == null) {
				oppNeedsAnalysisNewContract = new OpportunityNeedsAnalysisNewContract();
			}
			return oppNeedsAnalysisNewContract;
		}
		private set;
	}

	public static OpportunityNeedsAnalysisNewOrder oppNeedsAnalysisNewOrder {
		get {
			if (oppNeedsAnalysisNewOrder == null) {
				oppNeedsAnalysisNewOrder = new OpportunityNeedsAnalysisNewOrder();
			}
			return oppNeedsAnalysisNewOrder;
		}
		private set;
	}

	public static void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		for (Opportunity opp : (List<Opportunity>) records.deepClone(true, true, true)) {
			if (opp.StageName == 'Needs Analysis') {
				Contract oppContract = (Contract) oppNeedsAnalysisNewContract.getTargetRecord(opp);
				Order oppOrder = (Order) oppNeedsAnalysisNewOrder.getTargetRecord(opp);
				// Using a list so we verify in our mock test
				uow.registerNew(new List<SObject>{ oppContract, oppOrder });
				uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
				uow.registerDirty(opp, Opportunity.ContractId, oppContract);
			}
		}
		uow.commitWork();
	}

	public static void createContractsAndOrdersWhensNeedsAnalysis(
		List<SObject> records,
		Map<Id, SObject> existingRecords
	) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		List<Order> ordersByOpportunities
			= OrdersSelector.newInstance().selectOrdersByOpportunities(new Map<Id, SObject>(records).keySet());
		Set<Id> opportunityIdsWithOrders
			= Utils.getRecordsIdsByRelatedObjectRecords((List<SObject>) ordersByOpportunities, Order.OpportunityId);
		for (Opportunity opp: (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			// Create a order/contract if opportunity meets criteria and one does not already exist for this opportunity
			if (opp.StageName != existingOpp.StageName && opp.StageName == 'Needs Analysis'
					&& !opportunityIdsWithOrders.contains(opp.Id) && opp.ContractId == null) {
				Contract oppContract = (Contract) oppNeedsAnalysisNewContract.getTargetRecord(opp);
				Order oppOrder = (Order) oppNeedsAnalysisNewOrder.getTargetRecord(opp);
				// Using a list so we verify in our mock test
				uow.registerNew(new List<SObject>{ oppContract, oppOrder });
				uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
				uow.registerRelationship(opp, Opportunity.ContractId, oppContract);
			}
		}
		uow.commitWork();
	}

	public class OpportunityNeedsAnalysisNewContract extends SObjectsFieldMapper {

		public override Schema.SObjectType targetSObjectType() {
			return Contract.SObjectType;
		}

		public override Map<String, String> targetFieldsBySourceFields() {
			return new Map<String, String>{
				'AccountId' => 'AccountId'
			};
		}

		public override void setAdditionalTargetRecordFields(SObject targetRecord) {
			targetRecord.put('RecordTypeId', recordTypeIdsByNames.get('Participation_Agreement'));
			targetRecord.put('ContractTerm', 12);
		}

        public override void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {
            // If the requested service start date is null use the close date
            targetRecord.put(
                'StartDate',
                sourceRecord.get('Requested_Service_Start_Date__c') == null
                	? sourceRecord.get('CloseDate')
                	: sourceRecord.get('Requested_Service_Start_Date__c')
            );
        }
	}

	public class OpportunityNeedsAnalysisNewOrder extends SObjectsFieldMapper {

		public override Schema.SObjectType targetSObjectType() {
			return Order.SObjectType;
		}

		public override Map<String, String> targetFieldsBySourceFields() {
			return new Map<String, String>{
				'Id'								=> 'OpportunityId',
				'AccountId'							=> 'AccountId',
				'Requested_Service_End_Date__c'		=> 'EndDate'
			};
		}

		public override void setAdditionalTargetRecordFields(SObject targetRecord) {
			targetRecord.put('Status', 'Draft');
		}

		public override void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {
			if (sourceRecord.get('Record_Type_Developer_Name__c') == 'Events') {
				targetRecord.put('Type', 'Events');
				targetRecord.put('RecordTypeId', recordTypeIdsByNames.get('Events'));
			} else if (sourceRecord.get('Record_Type_Developer_Name__c') == 'Services') {
				targetRecord.put('Type', 'Services');
				targetRecord.put('RecordTypeId', recordTypeIdsByNames.get('Services'));
			}
            // If the requested service start date is null use the close date
            targetRecord.put(
                'EffectiveDate',
                sourceRecord.get('Requested_Service_Start_Date__c') == null
                	? sourceRecord.get('CloseDate')
                	: sourceRecord.get('Requested_Service_Start_Date__c')
            );
		}
	}
}