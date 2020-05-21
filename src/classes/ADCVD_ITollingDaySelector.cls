public interface ADCVD_ITollingDaySelector extends fflib_ISObjectSelector {
	List<Tolling_Day__c> selectById(Set<Id> idSet);
	List<Tolling_Day__c> selectByWhereClause(String wc);
	List<Tolling_Day__c> selectAllToLimit();
}