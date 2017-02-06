public with sharing class PetitionTriggerHandler {
    public static boolean preventRecursion = false;
    public static void mainEntry(List<Petition__c> newList, List<Petition__c> oldList, Map<Id, Petition__c> newMap, 
        Map<Id, Petition__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isAfter && isInsert) {
            //recalculatePetitionTollingDay(newList);
        }
        if(isAfter && isUpdate) {
            
        }
        if(isBefore && isInsert) {
            calculatePetitionDates(newList);
        }
        if(isBefore && isUpdate) {
        	calculatePetitionDates(newList);
        }
    }
    private static void calculatePetitionDates(List<Petition__c> newList) {
       	for (Petition__c p : newList){
       		if(p.Petition_Outcome__c == 'Initiated' || p.Petition_Outcome__c == 'In Progress') {
        		p.Calculated_Initiation_Signature__c = p.Petition_Filed__c.addDays(20);
	        	if(p.Initiation_Extension_of_days__c != null) {
	        		p.Calculated_Initiation_Signature__c = p.Calculated_Initiation_Signature__c.addDays((integer)p.Initiation_Extension_of_days__c);
	        	}
	        	p.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, p.Calculated_Initiation_Signature__c, true);
	        }
       	}
    }
}