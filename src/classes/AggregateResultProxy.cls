/**
 * AggregateResult wrapper class, so we can mock in test methods. (credit to cropredy)
 *
 * @author Andrew La Russa
 */
public class AggregateResultProxy {

	Map<String, Object> valuesByAlias = new Map<String, Object>();

	public AggregateResultProxy withAggregateResult(AggregateResult groupedResult) {
		String groupedResultJson = JSON.serialize(groupedResult);
		this.valuesByAlias = (Map<String, Object>) JSON.deserializeUntyped(groupedResultJson);
		return this;
	}

	public AggregateResultProxy withAliasAndValue(String alias, Object val) {
		this.valuesByAlias.put(alias, val);
		return this;
	}

	public Map<String, Object> getValuesByAlias() {
		return this.valuesByAlias;
	}
}