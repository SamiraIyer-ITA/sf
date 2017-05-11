public without sharing class ADCVDOrderTriggerHandler {

	private static Map<String,Constant__mdt> orderCalcOffsets = orderCalcOffsets();

	//FINAL ADCVD Order Offsets
	private static FINAL Integer SUNSET_INIT_YEARS				    = ((Integer)orderCalcOffsets.get('Order_Sunset_Initiation_Years').Number_Value__c);//Next_Sunset_Initiation_Date__c
	private static FINAL Integer SUNSET_INIT_MONTHS				    = ((Integer)orderCalcOffsets.get('Order_Sunset_Initiation_Months').Number_Value__c);//Next_Sunset_Initiation_Date__c


    public static boolean preventRecursion = false;
    public static void mainEntry(List<ADCVD_Order__c> newList, List<ADCVD_Order__c> oldList, Map<Id, ADCVD_Order__c> newMap, 
        Map<Id, ADCVD_Order__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        if (preventRecursion) {return;}

        if (isBefore && isInsert) {
            initialize(newList,newMap);
            calculateOrderDates(newList);
            calculateOrderStatuses(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList,newMap);
            calculateOrderDates(newList);
            calculateOrderStatuses(newList);
        }
        if (isAfter && isUpdate) {

        }
        if(isAfter && isInsert) {
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(newList);
        }
    }

    /*****************************
    * Class Level Variables
    *****************************/
    @TestVisible private static Map<Id,List<Segment__c>> orderIdToSegmentMap = new Map<Id,List<Segment__c>>();
    @TestVisible private static Map<Id,String> orderIdToSegmentStatusMap = new Map<Id,String>();
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    /**
     * Sets class level variables
     * @param  newList new Orders in scope, available before insert
     * @param  newMap  new Orders in scope, null before insert
     * @return         [description]
     */
    @TestVisible private static void initialize(List<ADCVD_Order__c> newList, Map<Id,ADCVD_Order__c> newMap) {
        if(newMap != null) {
        	setOrderIdToSegmentMap(newMap.keySet());
            setOrderIdToSegmentStatusMap();
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Segments with an Id
            frUtilMap = listInstance.utilMap;
        }
    }

    /**
     * Primary method to order and call all date calculations.  Restricted to only logical order, not specific field calculations
     * @param  newList [description]
     * @return         [description]
     */
    @TestVisible private static void calculateOrderDates(List<ADCVD_Order__c> newList) {
		for (ADCVD_Order__c o : newList) {
			setNextSunsetInitiationDate(o);
		}
	}

    /**
     * Primary method to order and call all status calculations. Restricted to only logical order, not specific field calculations
     * @param  newList [description]
     * @return         [description]
     */
	@TestVisible private static void calculateOrderStatuses(List<ADCVD_Order__c> newList) {
		setSegmentStatus(newList);
		setStatus(newList);
	}



    /***********************************
    * Helper Methods
    ***********************************/

    //used to set Offset Variables
	@TestVisible private static Map<String,Constant__mdt> orderCalcOffsets() {
		if(orderCalcOffsets == null || orderCalcOffsets.size() < 1) {
			Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
			List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
													ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
											FROM Constant__mdt 
											WHERE ADCVD_Order_Calculation_Offset__c =: true];
			for(Constant__mdt sc : tempList) {
				returnMap.put(sc.QualifiedAPIName, sc);
			}
			return returnMap;
		} else {
			return orderCalcOffsets;
		}
	}

    /**
     * Sets map of order Ids in scope to all of their Segments.
     * Segment Status
     * @param  orderIdSet [description]
     * @return            [description]
     */
	@TestVisible private static void setOrderIdToSegmentMap(Set<Id> orderIdSet) {
        for (Segment__c s : [SELECT Id, ADCVD_Order__c, Status__c FROM Segment__c WHERE ADCVD_Order__c IN: orderIdSet]) {
        	List<Segment__c> tempList = new List<Segment__c>();
        	if (orderIdToSegmentMap.get(s.ADCVD_Order__c) != null) {
        		tempList = orderIdToSegmentMap.get(s.ADCVD_Order__c);
        	}
        	tempList.add(s);
        	orderIdToSegmentMap.put(s.ADCVD_Order__c, tempList);
        }
    }

    @TestVisible private static void setOrderIdToSegmentStatusMap() {
        if (orderIdToSegmentMap != null && !orderIdToSegmentMap.isEmpty()) {
            for (Id orderId : orderIdToSegmentMap.keySet()) {
                for (Segment__c s : orderIdToSegmentMap.get(orderId)) {
                    if (orderIdToSegmentStatusMap.get(orderId) == null || orderIdToSegmentStatusMap.get(orderId) != 'Active') {
                        orderIdToSegmentStatusMap.put(orderId, s.Status__c);
                    }
                }
            }
        }
    }


    /*********************************
    * Date Calculations
    *********************************/

    //Next_Sunset_Initiation_Date__c
    @TestVisible private static void setNextSunsetInitiationDate(ADCVD_Order__c o) {
    	Date nextSSR = null;
    	if (o.Id != null && frUtilMap != null) {
    		nextSSR = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).orderPublishedDate : null;//set to orderPublishedDate if populated
    		nextSSR = frUtilMap.get(o.Id) != null && frUtilMap.get(o.Id).continuationPublishedDate != null ? frUtilMap.get(o.Id).continuationPublishedDate : nextSSR;//overwrite to continuationPublishedDate if populated
    		nextSSR = frUtilMap.get(o.Id) != null && frUtilMap.get(o.Id).revocationPublishedDate != null ? null : nextSSR;//overwrite to null if revocationPublishedDate is populated
    	}
    	if (nextSSR != null) {
    		o.Next_Sunset_Initiation_Date__c = nextSSR.toStartOfMonth().addYears(SUNSET_INIT_YEARS).addMonths(SUNSET_INIT_MONTHS);
    	} else {
            o.Next_Sunset_Initiation_Date__c = null;
        }
    }

    /******************************
    * Status Calculations
    ******************************/

    @TestVisible private static void setSegmentStatus(List<ADCVD_Order__c> newList) {
		for (ADCVD_Order__c o : newList) {
			if (o.Id != null && orderIdToSegmentStatusMap.get(o.Id) != null && orderIdToSegmentStatusMap.get(o.Id) == 'Active') {
				o.Segment_Status__c = 'Active';
			} else {
				o.Segment_Status__c = 'Inactive';
			}
		}
	}

    @TestVisible private static void setStatus(List<ADCVD_Order__c> newList){        
        for (ADCVD_Order__c o : newList){
        	if (o.Status__c != 'Revoked-Complete') {//skip if already Revoked-Complete
        		o.Status__c = 'Order FR Needed';//set for before insert context
	            Date orderPublishedDate = null;
	            Date revocationPublishedDate = null;
	            if (o.Id != null) {
		            if (frUtilMap != null) {
		            	revocationPublishedDate = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).revocationPublishedDate : null;
		                orderPublishedDate = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).orderPublishedDate : null;
		            }
		            if (orderPublishedDate == null) {//set if updated and still does not have an Order FR
		                o.Status__c = 'Order FR Needed';
		            } else if (o.Segment_Status__c == 'Active') {//set based on Segment Status
		                o.Status__c = 'Current-Active';
		            } else if (o.Segment_Status__c != 'Active') {
		            	o.Status__c = 'Current-Inactive';
		            }
		            if (revocationPublishedDate != null) {
		            	o.Status__c = 'Revoked-Incomplete';
		            }
		        }
        	}
        }
    }
}