trigger USTaxIdFldClean on DandBCompany (before insert,before update) {

	try
	{
		for(DandBCompany dnbFor : Trigger.new)
		{
			dnbFor.UsTaxId = Null;
		}
	}
	catch(Exception err)
	{
		System.debug('The error is :'+err);
	}
}