public without sharing class FederalRegisterMapper {

  /**
   * This is a mapper class to hold Federal Register information for the execution cycle.
   *
   * Example of normal execution cycle:
   * A trigger, such as InvestigationTriggerHandler will reference the FederalRegisterMapper.
   * The FederalRegisterMapper will call the FederalRegisterSelector.
   * The FederalRegisterSelector will retrieve data from the ADCVD_CaseSelector class and via SOQL, storing the data for reference during a transaction.
   * The FederalRegisterMapper then uses the retrieved data and maps it in inner classes and a map called masterMap.
   * The FederalRegisterMapper masterMap is then utilized by the InvestigationTriggerHandler.
   *
   */

  /**
   * The first Id of the masterMap is the Id of a Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment.
   * MappedFRs is an inner class.
   */
  public Map<Id, MappedFRs> masterMap = new Map<Id, MappedFRs>();
  @TestVisible private static ADCVD_CaseSelector caseSelector = (ADCVD_CaseSelector) ADCVD_CaseSelector.selectorMap.get('ADCVD_Case__c');
  @TestVisible private static FederalRegisterSelector frSelector = (FederalRegisterSelector) ADCVD_CaseSelector.selectorMap.get('Federal_Register__c').getInstance();

  /**
   * MappedFRs is an inner class which is implemented by an inner class for each of the types of Federal Registers.
   */
  public class MappedFRs {
    @testVisible Id myId { get; private set; }  //Id will vary, based on the inner case
    public Map<String, Date> typeToPublishedDateMap = new Map<String, Date>();
    public Map<String, Federal_Register__c> frsByType = new Map<String, Federal_Register__c>();

    /**
     * Retrieve the Federal Registers for a given sObject Id.
     * The sObject Id is the Id of a Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment.
     *
     * @param soId
     */
    public void getFRsFromId(Id soId) {
      Set<Id> relatedIdSet = caseSelector.getFrRelatedParents(soId);
      System.debug(LoggingLevel.DEBUG, '*** relatedIdSet: ' + relatedIdSet);
      if (relatedIdSet == null || relatedIdSet.isEmpty()) {return;}
      List<Federal_Register__c> frsInScope = new List<Federal_Register__c>();
      for (Id relatedId : relatedIdSet) {
        System.debug(LoggingLevel.DEBUG, '*** frSelector from mapper: ' + frSelector);
        if (frSelector.getParentToFrMap().containsKey(relatedId)) {
          frsInScope.addAll(frSelector.getParentToFrMap().get(relatedId).values());
        }
      }
      for (Federal_Register__c fr : frsInScope) {
        mapFR(fr);
      }
    }
    public void mapFR(Federal_Register__c fr) {
      Federal_Register__c mappedFR = frsByType.get(fr.Type__c) != null ? frsByType.get(fr.Type__c) : null;
      switch on fr.Type__c {
        when 'Continuation' {
          if (mappedFR == null || (mappedFR != null && fr.CreatedDate > mappedFR.CreatedDate)) {
            frsByType.put(fr.Type__c, fr);
            typeToPublishedDateMap.put(fr.Type__c, fr.Published_Date__c);
          }
        }
        when else {
          if (mappedFR == null || (mappedFR != null && fr.CreatedDate < mappedFR.CreatedDate)) {
            frsByType.put(fr.Type__c, fr);
            typeToPublishedDateMap.put(fr.Type__c, fr.Published_Date__c);
          }
        }
      }
      
    }
  }
  /**
  * Populate the above inner classes with the correct Federal Registers.
  * These will be the oldest one, except for the Continuation Federal Register, which is the newest one.
  *
  * @param soIdSet
  * @param objectName
  */
  public FederalRegisterMapper(Set<Id> soIdSet) {  //objectName is the sObject name of the Ids
    for (Id soId : soIdSet) {
      //Create the appropriate inner class based on objectName
      //try {
      MappedFRs tempClass = new MappedFRs();
      //set the myId on that inner class
      tempClass.myId = soId;
      //Call a virtual class method that is implemented differently on each method.  This way the same method call can get us the correct logic dynamically.
      tempClass.getFRsFromId(soId);
      masterMap.put(soId, tempClass);
    }
  }
}