trigger USTaxIdFldClean on DNBoptimizer__DnBCompanyRecord__c(before insert,before update) {

    try
    {
        for(DNBoptimizer__DnBCompanyRecord__c dnbFor : Trigger.new)
        {
            dnbFor.DNBoptimizer__USTaxID__c = Null;
        }
    }
    catch(Exception err)
    {
        System.debug('The error is :'+err);
    }
}

