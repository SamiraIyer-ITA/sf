/**
 * Product2 fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IProductsSelector {
	
	List<Product2> selectById(Set<Id> idSet);
	AggregateResultProxy[] selectMaxProductCodesByFamily(Set<String> filters);

}