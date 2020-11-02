/**
 * Product2 fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IProductsSelector extends fflib_ISObjectSelector {
	
	List<Product2> selectById(Set<Id> idSet);
	AggregateResultProxy[] selectMaxProductCodesByFamily(Set<String> filters);

}