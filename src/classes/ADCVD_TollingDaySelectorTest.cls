@isTest
public class ADCVD_TollingDaySelectorTest {
	@IsTest
	static void testBehavior() {
		ADCVD_TollingDaySelector.newInstance().selectById(new Set<Id>());
		ADCVD_TollingDaySelector.newInstance().selectByWhereClause('Id != null');
		ADCVD_TollingDaySelector.newInstance().selectAllToLimit();
	}
}