@isTest
public class USTaxIdFldCleanTest {
	public USTaxIdFldCleanTest() {
		
	}
	@isTest static void USTaxIdVal()
	{
		DNBoptimizer__DnBCompanyRecord__c dnb = new DNBoptimizer__DnBCompanyRecord__c();
		dnb.DNBoptimizer__DUNSNumber__c ='12345';
		dnb.Name =' Test DnB Company';
		insert dnb;

		System.assertEquals(dnb.DNBoptimizer__USTaxID__c,Null);
	} 
}