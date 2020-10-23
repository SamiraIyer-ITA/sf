public class OpportunitySObjectMapper {

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

		private final Set<String> NOT_REQUIRED_PRODUCT_NAMES = new Set<String>{
			 'Official Letters Specific To A Market',
			 'Featured US Exporters: Annual Renewal',
			 'Featured US Exporters: Lanugage Translation',
			 'Featured US Exporters: Per Market',
			 'Services: Contact List',
			 'Services: Other',
			 'Services: Other (SelectUSA)',
			 'Business Service Provider'
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

		public void setReportStatus(Order order, String productFamily, String productName) {
			order.Mid_Term_Report_Status__c = REQUIRED_PRODUCT_FAMILIES.contains(productFamily)
				? 'Required'
				: 'Not Required';
			order.Final_Report_Status__c = NOT_REQUIRED_PRODUCT_NAMES.contains(productName)
				? 'Not Required'
				: 'Required';
			order.Official_Letter_Status__c = productName == 'Official Letters Specific To A Market'
				? 'Required'
				: 'Not Required';
		}
	}
}