public with sharing class OpportunitySObjectMapper {

	/**
	 * Maps Opportunity Services details to a new Contract.
	 */
	public class ServicesNewContract extends SObjectsFieldMapper {

		public ServicesNewContract() {
			// Sets the contract record type
			super('Participation_Agreement');
		}

		public override Schema.SObjectType targetSObjectType() {
			return Contract.SObjectType;
		}

		public override Map<String, String> targetFieldsBySourceFields() {
			return new Map<String, String>{
				'AccountId'     => 'AccountId',
				'Pricebook2Id'  => 'Pricebook2Id'
			};
		}

		public override void setAdditionalTargetRecordFields(SObject targetRecord) {
			targetRecord.put('ContractTerm', 12);
			targetRecord.put('Status', 'Draft');
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

	/**
	 * Maps Opportunity Services details to a new Order.
	 */
	public class ServicesNewOrder extends SObjectsFieldMapper {

		private final Set<String> REQUIRED_PRODUCT_FAMILIES = new Set<String>{
			'Gold Key Services',
			'International Partner Search'
		};

		public ServicesNewOrder() {
			super('Services');
		}

		public override Schema.SObjectType targetSObjectType() {
			return Order.SObjectType;
		}

		public override Map<String, String> targetFieldsBySourceFields() {
			return new Map<String, String>{
				'Id'                                => 'OpportunityId',
				'AccountId'                         => 'AccountId',
				'Pricebook2Id'                      => 'Pricebook2Id',
				'Requested_Service_End_Date__c'     => 'EndDate',
				'SyncedQuoteId'                     => 'QuoteId'
			};
		}

		public override void setAdditionalTargetRecordFields(SObject targetRecord) {
			targetRecord.put('Status', 'Draft');
			targetRecord.put('Type', 'Services');
		}

		public override void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {
			targetRecord.put(
				'EffectiveDate',
				sourceRecord.get('Requested_Service_Start_Date__c') == null
					? sourceRecord.get('CloseDate')
					: sourceRecord.get('Requested_Service_Start_Date__c')
			);
			targetRecord.put('Name', 'Order-' + sourceRecord.get('Name'));
		}

		public void setMidtermStatus(Order order, String productFamily) {
			order.Mid_Term_Report_Status__c = REQUIRED_PRODUCT_FAMILIES.contains(productFamily)
				? 'Required'
				: 'Not Required';
		}
	}
}