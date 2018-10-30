public without sharing class CustomInstructionTriggerHandler{

public static void mainEntry(List<Custom_Instruction__c> newList, List<Custom_Instruction__c> oldList, Map<Id, Custom_Instruction__c> newMap, 
        Map<Id, Custom_Instruction__c> oldMap, Boolean isInsert, Boolean isBefore, Boolean isAfter) {

        // ----- Trigger test enablement -------
        if (Test.isRunningTest() && newList != null && !newList.isEmpty() && '--This is a test--'.equalsIgnoreCase(newList.get(0).ADCVD_Case_Number_Text__c)) return;
        
        if (!AppConfigService.triggerEnabled) {return;}

        if(isBefore && isInsert) {
        	newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, null);
            setCaseValues(newList);
        }
        if(isAfter && isInsert) {
        	newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
        }
    }

    //Mapper declared that will be initialized later based on the parent
    @TestVisible private static ADCVD_IMapper adcvdMapper;
    //Mapper declared that will be initialized after caseMapper is initiatlized
    @TestVisible private static CustomInstructionMapper ciMapper;
    //Mapper declared that will be initialized in the initialize method
    @TestVisible private static ADCVD_CaseMapper caseMapper;

    //method to initialize the caseMapper and if newMap is passed (after insert/update) it will add the new Custom Instructions to the Mappers
    @TestVisible private static void initialize(List<Custom_Instruction__c> newList, Map<Id,Custom_Instruction__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        caseMapper = caseMapper.getInstance(caseIdSet);
        if (newMap != null) {
            addNewCIsToMappers(newMap);
        }
    }
    //method to get the case Ids from the parents.  If a list of Custom Instructions is added that have parents from all 5 potential
    //parents, all 5 queries will run.  This should only be called in the initialize method.
    @TestVisible private static Set<Id> getCaseIdSet (List<Custom_Instruction__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> petitionIdSet = new Set<Id>();
        Set<Id> investigationIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> suspAgrmntIdSet = new Set<Id>();
        Set<Id> segmentIdSet = new Set<Id>();
        for (Custom_Instruction__c ci : newList) {
            if(ci.Petition__c != null) {
                setCiParent(ci, 'Petition__c');
                petitionIdSet.add(ci.Petition__c);
            } else if(ci.Investigation__c != null) {
                setCiParent(ci, 'Investigation__c');
                investigationIdSet.add(ci.Investigation__c);
            } else if(ci.Segment__c != null) {
                setCiParent(ci, 'Segment__c');
                segmentIdSet.add(ci.Segment__c);
            } else if(ci.ADCVD_Order__c != null) {
                setCiParent(ci, 'ADCVD_Order__c');
                orderIdSet.add(ci.ADCVD_Order__c);
            } else if(ci.Suspension_Agreement__c != null) {
                setCiParent(ci, 'Suspension_Agreement__c');
                suspAgrmntIdSet.add(ci.Suspension_Agreement__c);
            }
        }
        for (Petition__c p : PetitionSelector.newInstance().selectById(petitionIdSet)) {
            caseIdSet.add(p.ADCVD_Case__c);
        }
        for (Investigation__c i : InvestigationSelector.newInstance().selectById(investigationIdSet)) {
            caseIdSet.add(i.ADCVD_Case__c);
        }
        for (Segment__c s : SegmentSelector.newInstance().selectById(segmentIdSet)) {
            caseIdSet.add(s.ADCVD_Case__c);
        }
        for (ADCVD_Order__c ao : ADCVD_OrderSelector.newInstance().selectById(orderIdSet)) {
            caseIdSet.add(ao.ADCVD_Case__c);
        }
        for (Suspension_Agreement__c sa : SuspensionAgreementSelector.newInstance().selectById(suspAgrmntIdSet)) {
            caseIdSet.add(sa.ADCVD_Case__c);
        }
        return caseIdSet;
    }
    //used to set the ADCVD_Case__c field on the Custom Instructions based on the value in the parents
    @TestVisible private static void setCaseValues(List<Custom_Instruction__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Custom_Instruction__c ci : newList) {
            Id parentId = (Id) ci.get(ci.CI_Parent__c);
            adcvdMapper = (ADCVD_IMapper) caseMapper.getMapper(ci.CI_Parent__c).getInstance();
            ADCVD_Case__c currentCase = (ADCVD_Case__c) caseMapper.getMap(true).get((Id)adcvdMapper.getMap(true).get(parentId).get('ADCVD_Case__c'));
            ci.ADCVD_Case__c = currentCase.Id;
            ci = (Custom_Instruction__c) pvs.setCaseValuesFromParent(currentCase, ci);
        }
    }
    //Sets CI_Parent__c to the DeveloperName of the field of the parent (allows .get(CI_Parent__c) to retrieve the Id of the parent)
    @TestVisible private static void setCiParent (Custom_Instruction__c ci, String parentName) {
        if (String.isBlank(ci.CI_Parent__c)) {
            ci.CI_Parent__c = parentName;
        }
    }
    //method to add the Custom Instructions from the recent insert/update to the ciMapper, the caseMapper,
    //and update the CustomInstructionMapper instance in the map of selectors with the new Custom Instructions
    @TestVisible private static void addNewCIsToMappers(Map<Id,Custom_Instruction__c> newMap) {
        Map<Id,List<Custom_Instruction__c>> caseToCIsMap = new Map<Id,List<Custom_Instruction__c>>();
        //get the FederalRegisterMapper instance from the caseMapper
        ciMapper = (CustomInstructionMapper) caseMapper.getMapper('Custom_Instruction__c').getInstance();
        for (Custom_Instruction__c ci : newMap.values()) {
            //update FederalRegisterMapper instance
            ciMapper.addCstInstToMap(ci);
            List<Custom_Instruction__c> tempList = caseToCIsMap.get(ci.ADCVD_Case__c) != null ?
                                                   caseToCIsMap.get(ci.ADCVD_Case__c) : new List<Custom_Instruction__c>();
            tempList.add(ci);
            caseToCIsMap.put(ci.ADCVD_Case__c, tempList);
        }
        //add the CI to the case Maps
        for (Id caseId : caseToCIsMap.keySet()) {
            caseMapper.setCaseIdToCstInstMap(caseId, caseToCIsMap.get(caseId));
        }
        //replace the CustomInstructionMapper in the caseMapper map with the new updated one
        caseMapper.putMapper('Custom_Instruction__c', ciMapper);
    }
}