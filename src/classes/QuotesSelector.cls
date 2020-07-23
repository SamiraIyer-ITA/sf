/**
 * Quote fflib Selector
 *
 * @author Andrew La Russa
 */
public class QuotesSelector extends fflib_SObjectSelector implements IQuotesSelector {

	public static IQuotesSelector newInstance()  {
		return (IQuotesSelector) fflibext_Application.Selector.newInstance(Quote.SObjectType);
	}

	public List<Quote> selectById(Set<Id> idSet) {
		return (List<Quote>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Quote.Id
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Quote.SObjectType;
	}
}