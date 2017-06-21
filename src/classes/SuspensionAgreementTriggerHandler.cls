public without sharing class SuspensionAgreementTriggerHandler {

	private static Map<String,Constant__mdt> saCalcOffsets = saCalcOffsets();

	//FINAL ADCVD Order Offsets
	private static FINAL Integer SUNSET_INIT_YEARS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Years').Number_Value__c);//Next_Sunset_Initiation_Date__c
	private static FINAL Integer SUNSET_INIT_MONTHS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Months').Number_Value__c);//Next_Sunset_Initiation_Date__c


    public static boolean preventRecursion = false;
    public static void mainEntry(List<Suspension_Agreement__c> newList, List<Suspension_Agreement__c> oldList, Map<Id, Suspension_Agreement__c> newMap, 
        Map<Id, Suspension_Agreement__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        if (isBefore && isInsert) {
            initialize(newList,newMap);
            calculateDates(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList,newMap);
            calculateDates(newList);
        }
        if (isAfter && isUpdate) {

        }
        if(isAfter && isInsert) {

        }
    }

    /*****************************
     * Class Level Variables
    *****************************/

    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();


    /******************************************
    * Methods called directly by mainEntry()
    ******************************************/

    @TestVisible private static void initialize(List<Suspension_Agreement__c> newList, Map<Id,Suspension_Agreement__c> newMap) {
        if(newMap != null) {
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Segments with an Id
            frUtilMap = listInstance.utilMap;
        }
    }

    @TestVisible private static void calculateDates(List<Suspension_Agreement__c> newList) {
		for (Suspension_Agreement__c sa : newList) {
            setAnniversaryMonth(sa);
			setNextSunsetInitiationDate(sa);
		}
	}


    /***********************************
    * Helper Methods
    ***********************************/

    //used to set Offset Variables
	@TestVisible private static Map<String,Constant__mdt> saCalcOffsets() {
		if(saCalcOffsets == null || saCalcOffsets.size() < 1) {
			Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
			List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
													ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
											FROM Constant__mdt 
											WHERE Suspension_Agreement_Calculation_Offset__c =: true];
			for(Constant__mdt sc : tempList) {
				returnMap.put(sc.QualifiedAPIName, sc);
			}
			return returnMap;
		} else {
			return saCalcOffsets;
		}
	}


    /*********************************
    * Date Calculations
    *********************************/

    //Set Anniversary_Month__c
    @TestVisible private static void setAnniversaryMonth(Suspension_Agreement__c sa) {
        Date suspensionAgreementPublishedDate = null;
        if (sa.Id != null && frUtilMap != null) {
            suspensionAgreementPublishedDate = frUtilMap.get(sa.Id) != null ? frUtilMap.get(sa.Id).suspensionAgreementPublishedDate : null;
        }
        if (suspensionAgreementPublishedDate != null) {
            sa.Anniversary_Month__c = utils.getMonthFromDate(suspensionAgreementPublishedDate);
        } else {
            sa.Anniversary_Month__c = null;
        }
    }

    //Next_Sunset_Initiation_Date__c
    @TestVisible private static void setNextSunsetInitiationDate(Suspension_Agreement__c sa) {
    	Date nextSSR = null;
    	if (sa.Id != null && frUtilMap != null) {
    		nextSSR = frUtilMap.get(sa.Id) != null ? frUtilMap.get(sa.Id).suspensionAgreementPublishedDate : null;//set to suspensionAgreementPublishedDate if populated
    		nextSSR = (frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).continuationPublishedDate != null) ? frUtilMap.get(sa.Id).continuationPublishedDate : nextSSR;//overwrite to continuationPublishedDate if populated
    		nextSSR = (frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).terminationPublishedDate != null) ? null : nextSSR;//overwrite to null if revocationPublishedDate is populated
    	}
    	if (nextSSR != null) {
    		sa.Next_Sunset_Initiation_Date__c = nextSSR.toStartOfMonth().addYears(SUNSET_INIT_YEARS).addMonths(SUNSET_INIT_MONTHS);
    	} else {
            sa.Next_Sunset_Initiation_Date__c = null;
        }
    }
}