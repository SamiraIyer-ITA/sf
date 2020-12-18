@IsTest
private class MasterCongressionalDistrictsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<Master_CongressionalDistrict__c> result
			= MasterCongressionalDistrictsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByMin4Max4AndZipPlus4() {
		Master_CongressionalDistrict__c testDistrict = new Master_CongressionalDistrict__c(
			State_Code__c = 'MD',
			County_Name__c = 'Franklin',
			zip_Plus4__c = '22020',
			Min4__c = '1600',
			Max4__c = '1700',
			Congressional_Dist__c ='01'
		);
		insert testDistrict;
		List<Master_CongressionalDistrict__c> districts
			= MasterCongressionalDistrictsSelector.newInstance()
				.selectByMin4Max4AndZipPlus4(new Set<String>{  '1599', '1601' }, new Set<String>{ '22020' });
		System.assertEquals(1, districts.size(), 'Verify we found a match by criteria');
	}
    
    @IsTest
	static void testSelectByzip_Plus4() {
		Master_CongressionalDistrict__c testDistrict = new Master_CongressionalDistrict__c(
			State_Code__c = 'MD',
			County_Name__c = 'Franklin',
			zip_Plus4__c = '22020',
			Min4__c = '1600',
			Max4__c = '1700',
			Congressional_Dist__c ='01'
		);
		insert testDistrict;
		List<Master_CongressionalDistrict__c> districts
			= MasterCongressionalDistrictsSelector.newInstance()
				.selectByzip_Plus4(new Set<String>{ '22020' });
		System.assertEquals(1, districts.size(), 'Verify we found a match by criteria');
	}
}