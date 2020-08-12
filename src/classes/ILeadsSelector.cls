/**
 * Lead fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface ILeadsSelector extends fflib_ISObjectSelector {

	List<Lead> selectById(Set<Id> idSet);
}