/**
*
*    Created by Joshua Moody
*    on Jan 4 2019
*    MIL Corporation
*
**/
public without sharing class StaffingAssignmentService {
    /***********************************************************
    * This class  provides 2 overridden methods to create Staffing.
    * It is intended to be called by parent trigger handlers in
    * an after insert context to create their staffing and handles
    * the work needed that must precede inserting the staffing records.
    * All methods are non-static so call from an instance of this class
    * i.e StaffingAssignmentService().method()
    ***********************************************************/
    @TestVisible private static ADCVD_CaseMapper caseMapper;
    
    /**
     * Override of method that assumes insert. Use other method to specify insert
     *
     * @param soList - List of SObjects for which these Staffing Assignments will be created
     * @param sObjectName - SObject name for the SObjects in soList
     *
     * @return List<Staffing_Assignment__c>
     */
    public  List<Staffing_Assignment__c> createStaffFromDefaults(List<SObject> soList, String sObjectName) {
        return createStaffFromDefaults(soList, sObjectName, true);
    }

    /**
     * Method to create Staffing based on the values held in the Constant__mdt custom metadata object for the
     * SObject named in sObjectName.
     *
     * @param soList - List of SObjects for which these Staffing Assignments will be created
     * @param sObjectName - SObject name for the SObjects in soList
     * @param doInsert - Determines if this list is inserted. Set to false when you want to compile multiple lists
     * of Staffing_Assignment__c records for a single insert
     *
     * @return List<Staffing_Assignment__c>
     */
    public List<Staffing_Assignment__c> createStaffFromDefaults(List<SObject> soList, String sObjectName, Boolean doInsert) {
        List<Staffing_Assignment__c> returnList = new List<Staffing_Assignment__c>();
        
        caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
          
        Map<String,Integer> defaultUserRolesMap = new CustomMetadataSelector().getDefaultUserRolesMap(sObjectName);//Title__c field and how many to create from metadata records
        for (SObject so : soList) {//iterate through sObjects creating staffing for each
            for(String s: defaultUserRolesMap.keySet()) {//iterate through each staffing title for this sObjectType
                for (Integer i = 0; i < defaultUserRolesMap.get(s); i++) {//create as many of that title as specified, usually only one
                    Staffing_Assignment__c sa = new Staffing_Assignment__c();
                    sa.ADCVD_Case__c = (Id)so.get('ADCVD_Case__c');
                    sa.put(sObjectName, (Id)so.get('Id'));
                    sa.Title__c = s;
                    if (sa.Title__c == 'Program Manager') {
                        sa.User__c = ((ADCVD_Case__c)caseMapper.getMap(false).get(sa.ADCVD_Case__c)).Program_Manager__c;
                    }
                    returnList.add(sa);
                }
            }
        }
        if (doInsert && !returnList.isEmpty()) {insert returnList;}
        return returnList;
    }

    /**
     * Override of method that assumes insert. Use other method to specify insert
     *
     * @param soList - List of SObjects for which these Staffing Assignments will be created
     * @param sObjectName - SObject name for the SObjects in soList
     *
     * @return List<Staffing_Assignment__c>
     */
    public  List<Staffing_Assignment__c> createStaffFromSObjectParent(List<SObject> soList, String sObjectName) {
        return createStaffFromSObjectParent(soList, sObjectName, true);
    }

    /**
     * Method to create Staffing based on the Staffing of the incoming SObjects' parents.  (i.e. passing in a list of
     * Segments will create staffing records that match each segment's parent's staffing records
     *
     * @param soList - List of SObjects for which these Staffing Assignments will be created
     * @param sObjectName - SObject name for the SObjects in soList
     * @param doInsert - Determines if this list is inserted. Set to false when you want to compile multiple lists
     * of Staffing_Assignment__c records for a single insert
     *
     * @return List<Staffing_Assignment__c>
     */
    public List<Staffing_Assignment__c> createStaffFromSObjectParent(List<SObject> soList, String sObjectName, Boolean doInsert) {
        List<Staffing_Assignment__c> returnList = new List<Staffing_Assignment__c>();
        Set<String> parentSObjectNames = new CustomMetadataSelector().getParentsForChildSObject(sObjectName);//get a Set<String> of the potential parents of this SObject
        ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper)ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c').getInstance();//local ADCVD_CaseMapper instance to maintain non-static
        StaffingAssignmentMapper sam = (StaffingAssignmentMapper)caseMapper.getMapper('Staffing_Assignment__c').getInstance();//local StaffingAssignmentMapper instance
        for (SObject so : soList) {//iterate through sObjects creating staffing for each
            Id parentId;
            for (String parentName : parentSObjectNames) {//iterate through potential parents for this SObject, usually 1 iteration but 5 at most
                if (so.get(parentName) != null) {parentId = (Id) so.get(parentName);}
            }
            Map<Id, Staffing_Assignment__c> tempMap = sam.getParentIdToStaffMap().get(parentId);//sets tempMap to the SAs belonging to this so's parent
            for(Id staffId: tempMap.keySet()) {//iterate through each staffing title for this sObjectType
                Staffing_Assignment__c tempSA = tempMap.get(staffId);//get a copy of the SA instead of calling map every time
                Staffing_Assignment__c sa = new Staffing_Assignment__c();
                sa.ADCVD_Case__c = tempSA.ADCVD_Case__c;
                sa.put(sObjectName, (Id)so.get('Id'));
                sa.Title__c = tempSA.Title__c;
                sa.User__c = tempSA.User__c;
                returnList.add(sa);
            }
        }
        if (doInsert && !returnList.isEmpty()) {insert returnList;}
        return returnList;
    }
}