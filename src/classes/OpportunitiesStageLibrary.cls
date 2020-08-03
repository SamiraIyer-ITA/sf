/**
 * Opportunities Stage Library class
 *
 * Sets the stage based on implementation and field criteria
 *
 * @author Andrew La Russa
 */
public with sharing class OpportunitiesStageLibrary {

	private static IStageCriteria stageServices = (IStageCriteria) new StageCriteriaServices();

	/**
	 * Sets Opportunity Services stages based on field criteria
	 *
	 * @param records Opportunity Trigger.new records
	 */
	public static void setServicesStages(List<SObject> records) {
		for (Opportunity opp: (List<Opportunity>) records) {
			stageServices.setStage(opp);
		}
	}

	/**
	 * Sets Opportunity Services stages based on field criteria when a criteria field has changed
	 *
	 * @param records Opportunity Trigger.new
	 * @param existingRecords Opportunity Trigger.oldMap
	 */
	public static void setServicesStages(List<SObject> records, Map<Id, SObject> existingRecords) {
		for (Opportunity opp: (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			stageServices.setStage(opp, existingOpp);
		}
	}

	/**
	 * Determines if an Opportunity's field has changed from its old and new value
	 *
	 * @param stageCriteriaFields List of fields to check
	 * @param record New Opportunity
	 * @param existingRecord Existing Opportunity
	 *
	 * @return If any field has changed (breaks on first occurrence)
	 */
	private static Boolean stageCriteriaFieldChanged(
		List<Schema.SObjectField> stageCriteriaFields,
		SObject record,
		SObject	existingRecord
	) {
		Boolean fieldChanged = false;
		for (Schema.SObjectField field: stageCriteriaFields) {
			if ((fieldChanged = record.get(field) != existingRecord.get(field))) {
				break;
			}
		}
		return fieldChanged;
	}

	/**
	 * Implement this interface for Opportunity implementations (eg. Services and Events)
	 */
	public interface IStageCriteria {

		Boolean baseCriteriaMet(Opportunity opp);
		List<Schema.SObjectField> stageCriteriaFields();
		List<IStage> stages();
		void setStage(Opportunity opp);
		void setStage(Opportunity opp, Opportunity existingOpp);
	}

	/**
	 * Services Stage Criteria implementation
	 */
	public class StageCriteriaServices implements IStageCriteria {

		public Boolean baseCriteriaMet(Opportunity opp) {
			return !opp.IsClosed;
		}

		public List<Schema.SObjectField> stageCriteriaFields() {
			return new List<Schema.SObjectField>{
				Opportunity.Company_Questionnaire__c,
				Opportunity.Export_Ready__c,
				Opportunity.Conference_Call_Scheduled__c,
				Opportunity.Conference_Call_Completed__c,
				Opportunity.PA_Sent__c
			};
		}

		public List<IStage> stages() {
			return new List<IStage>{
				new StageQualificationServices(),
				new StageNeedsAnalysisServices(),
				new StageValuePropositionServices(),
				new StageProposalPriceQuoteServices(),
				new StageNegotiationReviewServices()
			};
		}

		public void setStage(Opportunity opp) {
			if (baseCriteriaMet(opp)) {
				for (IStage stage: stages()) {
					if (stage.criteria(opp)) {
						opp.StageName = stage.name();
						break;
					}
				}
			}
		}

		public void setStage(Opportunity opp, Opportunity existingOpp) {
			if (baseCriteriaMet(opp)
				&& stageCriteriaFieldChanged(stageCriteriaFields(), (SObject)opp, (SObject)existingOpp)) {
				for (IStage stage : stages()) {
					if (stage.criteria(opp)) {
						opp.StageName = stage.name();
						break;
					}
				}
			}
		}
	}

	/**
	 * Implement this interface for each stage that requires automation based on criteria
	 */
	public interface IStage {

		String name();
		Boolean criteria(Opportunity opp);
	}

	public class StageQualificationServices implements IStage {

		public String name() {
			return 'Qualification';
		}

		public Boolean criteria(Opportunity opp) {
			return (
				(opp.Export_Ready__c != 'Yes' || opp.Company_Questionnaire__c == null)
					& !opp.Conference_Call_Scheduled__c && !opp.Conference_Call_Completed__c && !opp.PA_Sent__c
			);
		}
	}

	public class StageNeedsAnalysisServices implements IStage {

		public String name() {
			return 'Needs Analysis';
		}

		public Boolean criteria(Opportunity opp) {
			return (
				opp.Export_Ready__c == 'Yes' && opp.Company_Questionnaire__c != null
					& !opp.Conference_Call_Scheduled__c && !opp.Conference_Call_Completed__c && !opp.PA_Sent__c
			);
		}
	}

	public class StageValuePropositionServices implements IStage {

		public String name() {
			return 'Value Proposition';
		}

		public Boolean criteria(Opportunity opp) {
			return (
				opp.Export_Ready__c == 'Yes' && opp.Company_Questionnaire__c != null
					& opp.Conference_Call_Scheduled__c && !opp.Conference_Call_Completed__c && !opp.PA_Sent__c
			);
		}
	}

	public class StageProposalPriceQuoteServices implements IStage {

		public String name() {
			return 'Proposal/Price Quote';
		}

		public Boolean criteria(Opportunity opp) {
			return (
				opp.Export_Ready__c == 'Yes' && opp.Company_Questionnaire__c != null
					& opp.Conference_Call_Scheduled__c && opp.Conference_Call_Completed__c && !opp.PA_Sent__c
			);
		}
	}

	public class StageNegotiationReviewServices implements IStage {

		public String name() {
			return 'Negotiation/Review';
		}

		public Boolean criteria(Opportunity opp) {
			return (
				opp.Export_Ready__c == 'Yes' && opp.Company_Questionnaire__c != null
					& opp.Conference_Call_Scheduled__c && opp.Conference_Call_Completed__c && opp.PA_Sent__c
			);
		}
	}
}