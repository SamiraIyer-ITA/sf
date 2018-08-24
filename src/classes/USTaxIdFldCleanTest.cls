@isTest
public class USTaxIdFldCleanTest {
	public USTaxIdFldCleanTest() {
		
	}
	@isTest static void USTaxIdVal()
	{
		DandBCompany dnb = new DandBCompany();
		dnb.DunsNumber ='12345';
		dnb.Name =' Test DnB Company';
		insert dnb;

		System.assertEquals(dnb.UsTaxId,Null);
	} 
}