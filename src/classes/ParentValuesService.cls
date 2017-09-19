public without sharing class ParentValuesService {

	public SObject setCaseValuesFromParent (SObject parent, SObject child) {
		child.put('ADCVD_Case_Number__c',(String)parent.get('ADCVD_Case_Number__c'));
		child.put('ADCVD_Case_Type__c',(String)parent.get('ADCVD_Case_Type__c'));
		child.put('Country__c',(String)parent.get('Country__c'));
		child.put('Product__c',(String)parent.get('Product__c'));
		return child;
	}
}