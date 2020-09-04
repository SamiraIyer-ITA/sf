/**
 * 
 *    Created by Joshua Moody
 *    on Apr 17 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class ADCVDOrderTriggerHandler {
     /***********************************************************
    * This class handles all trigger contexts for the ADCVD_Order__c
    * object.  It provides methods that:
    * 1. Organize the flow of logic for each trigger context
    * 2. Initialize class variables
    * 3. Help in the mapping of related objects
    * 4. Call services classes to do date calculations
    * 5. Retrieve constant values saved in custom metadata
    * 6. Performs status calculations
    * 7. Performs custom validations not possible with validation rules
    ***********************************************************/

    @TestVisible private static Set<String> activeSegmentStatuses = new Set<String>();
    private static Map<String,Constant__mdt> orderCalcOffsets = orderCalcOffsets();

    //FINAL ADCVD Order Offsets
    private static FINAL Integer SUNSET_INIT_YEARS                  = ((Integer)orderCalcOffsets.get('Order_Sunset_Initiation_Years').Number_Value__c);//Next_Sunset_Initiation_Date__c
    private static FINAL Integer SUNSET_INIT_MONTHS                 = ((Integer)orderCalcOffsets.get('Order_Sunset_Initiation_Months').Number_Value__c);//Next_Sunset_Initiation_Date__c
    private static FINAL Integer EFFECTIVE_DATE_REVO_MONTHS         = ((Integer)orderCalcOffsets.get('Order_Effective_Revocation_Months').Number_Value__c);//Effective_Date_of_Revocation__c
    private static FINAL Integer EFFECTIVE_DATE_REVO_YEARS          = ((Integer)orderCalcOffsets.get('Order_Effective_Revocation_Years').Number_Value__c);//Effective_Date_of_Revocation__c


    public static boolean preventRecursion = false;
    public static void mainEntry(List<ADCVD_Order__c> newList, List<ADCVD_Order__c> oldList, Map<Id, ADCVD_Order__c> newMap, 
        Map<Id, ADCVD_Order__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {
            return;
        }

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList,newMap);
            setCaseValues(newList);
            calculateOrderDates(newList);
            calculateOrderStatuses(newList);
            runCustomValidations(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList,newMap);
            calculateOrderDates(newList);
            calculateOrderStatuses(newList);
            runCustomValidations(newList);
        }
        if (isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            new StaffingAssignmentService().createStaffFromSObjectParent(newList, 'ADCVD_Order__c');
        }
        if (isAfter && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
        }
    }

    /*****************************
    * Class Level Variables
    *****************************/
    @TestVisible private static Map<Id,Investigation__c> investigationsInScopeMap = new Map<Id,Investigation__c>();
    @TestVisible private static Map<Id,List<Segment__c>> orderIdToSegmentMap = new Map<Id,List<Segment__c>>();
    @TestVisible private static Map<Id,String> orderIdToSegmentStatusMap = new Map<Id,String>();
    @TestVisible private static Map<Id, FederalRegisterMapper.MappedFRs> frUtilMap = new Map<Id, FederalRegisterMapper.MappedFRs>();
    @TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
    @TestVisible private static ADCVD_OrderMapper orderMapper;
    @TestVisible private static FederalRegisterMapper frMapper;

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
        Set<Id> caseIdSet = getCaseIdSet(newList);
        for (ADCVD_Order__c ao : newList) {
            caseIdSet.add(ao.ADCVD_Case__c);
        }
        caseMapper = caseMapper.getInstance(caseIdSet);
        InvestigationMapper is = (InvestigationMapper) caseMapper.getMapper('Investigation__c').getInstance();
        investigationsInScopeMap = (Map<Id,Investigation__c>) caseMapper.getMapper('Investigation__c').getInstance().getMap(true);
        if(newMap != null) {
            addNewOrderToMappers(newMap);
            frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
            frUtilMap = frMapper.getMappedFRs(newMap.keySet(), caseMapper);
            
            if(!system.isFuture() && !system.isBatch() && !system.isQueueable() && Limits.getLimitFutureCalls() > Limits.getFutureCalls()){
                
                setOrderIdToSegmentMap(newMap.keySet());
            }
            
            setOrderIdToSegmentStatusMap(newMap.keySet());
        }
    }
    @TestVisible private static Set<Id> getCaseIdSet (List<ADCVD_Order__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> invIdSet = new Set<Id>();
        for (ADCVD_Order__c ao : newList) {
            invIdSet.add(ao.Investigation__c);
        }
        for (Investigation__c i : [SELECT ADCVD_Case__c FROM Investigation__c WHERE Id IN: invIdSet]) {
            caseIdSet.add(i.ADCVD_Case__c);
        }
        return caseIdSet;
    }

    @TestVisible private static void setCaseValues(List<ADCVD_Order__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (ADCVD_Order__c ao : newList) {
            ao = (ADCVD_Order__c) pvs.setCaseValuesFromParent(investigationsInScopeMap.get(ao.Investigation__c), ao);
        }
    }

    @TestVisible private static void addNewOrderToMappers(Map<Id,ADCVD_Order__c> newMap) {
        Map<Id,List<ADCVD_Order__c>> caseToOrderMap = new Map<Id,List<ADCVD_Order__c>>();
        orderMapper = (ADCVD_OrderMapper) caseMapper.getMapper('ADCVD_Order__c').getInstance();
        for (ADCVD_Order__c ao : newMap.values()) {
            orderMapper.addOrderToMap(ao);
            List<ADCVD_Order__c> tempList = caseToOrderMap.get(ao.ADCVD_Case__c) != null ?
                                                   caseToOrderMap.get(ao.ADCVD_Case__c) : new List<ADCVD_Order__c>();
            tempList.add(ao);
            caseToOrderMap.put(ao.ADCVD_Case__c, tempList);
        }
        for (Id caseId : caseToOrderMap.keySet()) {
            caseMapper.setCaseIdToOrderMap(caseId, caseToOrderMap.get(caseId));
        }
    }

    /**
     * Primary method to order and call all date calculations.  Restricted to only logical order, not specific field calculations
     * @param  newList [description]
     * @return         [description]
     */
    @TestVisible private static void calculateOrderDates(List<ADCVD_Order__c> newList) {
        for (ADCVD_Order__c o : newList) {
            setAnniversaryMonth(o);
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

    @TestVisible private static void runCustomValidations(List<ADCVD_Order__c> newList) {
        for (ADCVD_Order__c o : newList) {
            validateEffectiveDateOfRevocation(o);
        }
    }


    /***********************************
    * Helper Methods
    ***********************************/

    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> orderCalcOffsets() {
        if(orderCalcOffsets == null || orderCalcOffsets.size() < 1) {
            Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
            for (Constant__mdt sc : [
                    SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, String_Value__c,
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c,
                                                    Segment_Calculation_Offset__c 
                                            FROM Constant__mdt 
                    WHERE ADCVD_Order_Calculation_Offset__c = :true
            ]) {
                if (sc.Used_with_Field_Named__c == 'Status__c' && sc.Segment_Calculation_Offset__c && sc.String_Value__c != null) {
                    activeSegmentStatuses.add(sc.String_Value__c);
                }
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

    @Future
    @TestVisible private static void setOrderIdToSegmentMap(Set<Id> orderIdSet) {
        for (Segment__c s : [SELECT Id, ADCVD_Order__c, Status__c, Do_Delete__c FROM Segment__c WHERE ADCVD_Order__c IN: orderIdSet]) {
            List<Segment__c> tempList = new List<Segment__c>();
            if (orderIdToSegmentMap.get(s.ADCVD_Order__c) != null) {
                tempList = orderIdToSegmentMap.get(s.ADCVD_Order__c);
            }
            tempList.add(s);
            orderIdToSegmentMap.put(s.ADCVD_Order__c, tempList);
        }
    }

    @TestVisible private static void setOrderIdToSegmentStatusMap(Set<Id> orderIdSet) {
        if (orderIdToSegmentMap != null && !orderIdToSegmentMap.isEmpty()) {
            for (Id orderId : orderIdToSegmentMap.keySet()) {
                for (Segment__c s : orderIdToSegmentMap.get(orderId)) {
                    if ((orderIdToSegmentStatusMap.get(orderId) == null || !activeSegmentStatuses.contains(orderIdToSegmentStatusMap.get(orderId))) && !s.Do_Delete__c) {
                        orderIdToSegmentStatusMap.put(orderId, s.Status__c);
                    }
                }
            }
        }
        for (Id orderId : orderIdSet) {
            if (!orderIdToSegmentMap.keySet().contains(orderId)) {
                orderIdToSegmentStatusMap.put(orderId, '');
            }
        }
    }


    /*********************************
    * Date Calculations
    *********************************/

    //Set Anniversary_Month__c
    @TestVisible private static void setAnniversaryMonth(ADCVD_Order__c o) {
        Date orderPublishedDate = null;
        if (o.Id != null && frUtilMap != null) {
            orderPublishedDate = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).typeToPublishedDateMap.get('Order') : null;
        }
        if (orderPublishedDate != null) {
            o.Anniversary_Month__c = utils.getMonthFromDate(orderPublishedDate);
        } else {
            o.Anniversary_Month__c = null;
        }
    }

    //Next_Sunset_Initiation_Date__c
    @TestVisible private static void setNextSunsetInitiationDate(ADCVD_Order__c o) {
        Date nextSSR = null;
        if (o.Id != null && frUtilMap != null) {
            nextSSR = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).typeToPublishedDateMap.get('Order') : null;//set to orderPublishedDate if populated
            nextSSR = frUtilMap.get(o.Id) != null && frUtilMap.get(o.Id).typeToPublishedDateMap.get('Continuation') != null ? frUtilMap.get(o.Id).typeToPublishedDateMap.get('Continuation') : nextSSR;//overwrite to continuationPublishedDate if populated
            nextSSR = frUtilMap.get(o.Id) != null && frUtilMap.get(o.Id).typeToPublishedDateMap.get('Revocation') != null ? null : nextSSR;//overwrite to null if revocationPublishedDate is populated
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
            if (o.Id != null && orderIdToSegmentStatusMap.get(o.Id) != null && activeSegmentStatuses.contains(orderIdToSegmentStatusMap.get(o.Id))){
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
                Date orderPublished = null;
                Date revocationPublished = null;
                if (o.Id != null && frUtilMap != null) {
                    revocationPublished = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).typeToPublishedDateMap.get('Revocation') : null;
                    orderPublished = frUtilMap.get(o.Id) != null ? frUtilMap.get(o.Id).typeToPublishedDateMap.get('Order') : null;
                }
                if (orderPublished == null) {//set if updated and still does not have an Order FR
                    o.Status__c = 'Order FR Needed';
                } else if (o.Segment_Status__c == 'Active') {//set based on Segment Status
                    o.Status__c = 'Current-Active';
                } else if (o.Segment_Status__c != 'Active') {
                    o.Status__c = 'Current-Inactive';
                }
                if (revocationPublished != null) {
                    o.Status__c = 'Revoked-Incomplete';
                }
            }
        }
    }


    /**************************
    * Custom Validations
    **************************/

    //Effective_Date_of_Revocation__c
    @TestVisible private static void validateEffectiveDateOfRevocation(ADCVD_Order__c o) {
        String maxDateName = '';
        Date maxDate = null;
        if (o.Id != null && frUtilMap != null && frUtilMap.get(o.Id) != null && frUtilMap.get(o.Id).typeToPublishedDateMap.get('Revocation') != null) {
            if (frUtilMap.get(o.Id).typeToPublishedDateMap.get('Order') != null) {
                maxDate = frUtilMap.get(o.Id).typeToPublishedDateMap.get('Order');
                maxDateName = 'Order Federal Register Published Date: ' + maxDate.format();
            }
            if (frUtilMap.get(o.Id).typeToPublishedDateMap.get('Continuation') != null) {
                maxDate = frUtilMap.get(o.Id).typeToPublishedDateMap.get('Continuation');
                maxDateName = 'most recent Continuation Federal Register Published Date: ' + maxDate.format();
            }
            maxDate = maxDate != null ? maxDate.addYears(EFFECTIVE_DATE_REVO_YEARS).addMonths(EFFECTIVE_DATE_REVO_MONTHS) : null;
        }
        if (maxDate != null && o != null && o.Effective_Date_of_Revocation__c != null && maxDate < o.Effective_Date_of_Revocation__c) {
            o.Effective_Date_of_Revocation__c.addError('The Effective Date of Revocation cannot be more than 5 years from the ' + maxDateName);
        }
    }
}