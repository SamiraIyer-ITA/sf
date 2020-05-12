public without sharing class ADCVD_TollingDayMapper implements ADCVD_IMapper {
    public static ADCVD_TollingDayMapper instance = null;
    public static Map<Id, Tolling_Day__c> idToAllTollingDayMap = new Map<Id, Tolling_Day__c>();
    public static Map<Id,Tolling_Day__c> standardTollingDayMap = new Map<Id,Tolling_Day__c>();
    // parent record Id (petition, investigation, or segment) > Tolling Id > Tolling record
    public static Map<Id,Map<Id,Tolling_Day__c>> specificTollingDayMap = new Map<Id,Map<Id,Tolling_Day__c>>();

    public ADCVD_TollingDayMapper() {}
    @TestVisible
    private ADCVD_TollingDayMapper(Boolean newQuery) {
        if (standardTollingDayMap.isEmpty()) {
            System.debug('Querying Tolling Days in ADCVD_TollingDayMapper');
            for (Tolling_Day__c td : ADCVD_TollingDaySelector.newInstance().selectAllToLimit()) {
                addTollingDayToMap(td);
            }
        }
    }
    public ADCVD_TollingDayMapper getInstance() {
        if (instance == null) {
            return getNewInstance();
        }
        return instance;
    }
    public static ADCVD_TollingDayMapper getNewInstance() {
        instance = new ADCVD_TollingDayMapper(true);
        return instance;
    }
    public Map<Id,Tolling_Day__c> getMap() {
        return standardTollingDayMap;
    }
    public Map<Id, Tolling_Day__c> getMap(Boolean includeLocked) {
        //Locking not currently implemented on Tolling Day, so all is returned either way
        if (includeLocked) {
            return idToAllTollingDayMap;
        } else {
            return idToAllTollingDayMap;
        }
    }
    public Map<Id, Tolling_Day__c> getMap(Id parentId) {
        return specificTollingDayMap.get(parentId);
    }
    public void addTollingDayToMap(Tolling_Day__c td) {
        System.debug('Adding Tolling to Maps');
        if (Utils.getRecordTypeDeveloperNameMap(td).get(td.RecordTypeId) == 'Toll_By_Specific_Record') {
            //add to specificMap with populated lookup as Id
            String populatedParentLookup = '';
            if(td.Petition__c != null) {
                populatedParentLookup = 'Petition__c';
            } else if (td.Investigation__c != null) {
                populatedParentLookup = 'Investigation__c';
            } else if (td.Segment__c != null) {
                populatedParentLookup = 'Segment__c';
            }
            if (populatedParentLookup != '') {
                System.debug('populated parent lookup: ' + populatedParentLookup);
                Id parentId = (Id)td.get(populatedParentLookup);
                Map<Id, Tolling_Day__c> tempMap = new Map<Id, Tolling_Day__c>();
                if (specificTollingDayMap.get(parentId) != null) {
                    tempMap = specificTollingDayMap.get(parentId);
                }
                tempMap.put(td.Id, td);
                specificTollingDayMap.put(parentId, tempMap);
                System.debug('specificTollingDayMap has been updated to: ' + specificTollingDayMap);
            }
        } else if (Utils.getRecordTypeDeveloperNameMap(td).get(td.RecordTypeId) == 'Standard_Tolling'){
            standardTollingDayMap.put(td.Id, td);
        }
        idToAllTollingDayMap.put(td.Id, td);
    }


}