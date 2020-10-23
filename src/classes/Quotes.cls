/**
 * Implementation of IQuotes interface that will be used as an fflib domain object.
 *
 * @author Andrew La Russa
 */
public class Quotes extends fflib_SObjectDomain implements IQuotes {

	public static IQuotes newInstance(List<Quote> records)  {
		return (IQuotes) fflibext_Application.Domain.newInstance(records);
	}

	public static IQuotes newInstance(Set<Id> recordIds) {
		return (IQuotes) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Quotes(List<Quote> sObjectList) {
		super(sObjectList);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
	   QuotesService.handleBeforeUpdate(Records, existingRecords);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Quotes(sObjectList);
		}
	}
}