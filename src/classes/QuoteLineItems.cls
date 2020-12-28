/**
 * Implementation of IQuoteLineItems interface that will be used as an fflib domain object.
 *
 * @author Andrew La Russa
 */
public class QuoteLineItems extends fflib_SObjectDomain implements IQuoteLineItems {

	public static IQuoteLineItems newInstance(List<QuoteLineItem> records)  {
		return (IQuoteLineItems) fflibext_Application.Domain.newInstance(records);
	}

	public static IQuoteLineItems newInstance(Set<Id> recordIds) {
		return (IQuoteLineItems) fflibext_Application.Domain.newInstance(recordIds);
	}

	public QuoteLineItems(List<QuoteLineItem> sObjectList) {
		super(sObjectList);
	}

	public override void onBeforeInsert() {
		QuoteLineItemsService.handleBeforeInsert(Records);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		QuoteLineItemsService.handleBeforeUpdate(Records, existingRecords);
	}

	public override void onBeforeDelete() {
		QuoteLineItemsService.handleBeforeDelete(Records);
	}

	public override void onAfterDelete() {
		QuoteLineItemsService.handleAfterDelete(Records);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new QuoteLineItems(sObjectList);
		}
	}
}