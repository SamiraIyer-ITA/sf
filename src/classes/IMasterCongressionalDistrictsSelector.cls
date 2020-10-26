/**
 * Opportunity fflib Selector Interface
 *
 * @author Mark Keckeis
 */
public interface IMasterCongressionalDistrictsSelector extends fflib_ISObjectSelector {

	List<Master_CongressionalDistrict__c> selectById(Set<Id> idSet);
	List<Master_CongressionalDistrict__c> selectByMin4Max4AndZipPlus4(Set<String> zip4, Set<String>  zip5);
	List<Master_CongressionalDistrict__c> selectByzip_Plus4(Set<String>  zip5);
}