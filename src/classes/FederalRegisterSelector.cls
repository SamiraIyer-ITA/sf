public without sharing class FederalRegisterSelector {

  /**
   * This is a selector class to hold Federal Register information for the execution cycle.
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
   * The first Id in the caseIdToFRMap is the Id of the ADCVD Case.
   * The inner map is the Id of the Federal Register and then the Federal Register itself.
   */
  @TestVisible private static Map<Id, Map<Id, Federal_Register__c>> caseIdToFRMap = new Map<Id, Map<Id, Federal_Register__c>>();  //Id is the Case Id

  /**
   * The first Id in the parentIdToFRMap is the Id of the Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment
   * The inner map is the Id of the Federal Register and then the Federal Register itself.
   */
  public static Map<Id, Map<Id, Federal_Register__c>> parentIdToFRMap = new Map<Id, Map<Id, Federal_Register__c>>();

  /**
   * Populate the maps caseIdToFRMap and parentIdToFRMap based on case Ids in scope.
   */
  static {
    //Only populate the maps if they haven't already been populated.
    if (caseIdToFRMap.isEmpty() || parentIdToFRMap.isEmpty()) {
      //Get the Case Ids in Scope
      Set<Id> caseIdsInScope = ADCVD_CaseSelector.idToCaseMap.keySet();  //idToCaseMap is Map<Id, ADCVD_Case__c> where Id is the Case Id

      //Create a temporary map
      Map<Id, Federal_Register__c> tempFRMap;

      //Retrieve Federal Registers based on the Case Ids in Scope
      for (Federal_Register__c fr : [
          SELECT Id, Type__c, Published_Date__c, Segment__c, Segment__r.ADCVD_Order__c,
              Investigation__c, Petition__c, CreatedDate, ADCVD_Order__c, ADCVD_Order__r.Investigation__c,
              Suspension_Agreement__c, Suspension_Agreement__r.Investigation__c, Do_Delete__c, ADCVD_Case__c
          FROM Federal_Register__c
          WHERE ADCVD_Case__c IN :caseIdsInScope
      ]) {
        //Populate the maps with each Federal Register returned
        if (fr.Petition__c != null) {
          //This Federal Register is for a Petition
          //Get the map in the parentIdToFRMap if this Petition is already in the map.  Otherwise, create a new map.
          Map<Id, Federal_Register__c> tempMap = parentIdToFRMap.containsKey(fr.Petition__c)
              ? parentIdToFRMap.get(fr.Petition__c) : new Map<Id, Federal_Register__c>();
          tempMap.put(fr.Id, fr);
          parentIdToFRMap.put(fr.Petition__c, tempMap);
        } else if (fr.Investigation__c != null) {
          //This Federal Register is for an Investigation
          //Get the map in the parentIdToFRMap if this Investigation is already in the map.  Otherwise, create a new map.
          Map<Id, Federal_Register__c> tempMap = parentIdToFRMap.containsKey(fr.Investigation__c)
              ? parentIdToFRMap.get(fr.Investigation__c) : new Map<Id, Federal_Register__c>();
          tempMap.put(fr.Id, fr);
          parentIdToFRMap.put(fr.Investigation__c, tempMap);
        } else if (fr.ADCVD_Order__c != null) {
          //This Federal Register is for an ADCVD Order
          //Get the map in the parentIdToFRMap if this ADCVD Order is already in the map.  Otherwise, create a new map.
          Map<Id, Federal_Register__c> tempMap = parentIdToFRMap.containsKey(fr.ADCVD_Order__c)
              ? parentIdToFRMap.get(fr.ADCVD_Order__c) : new Map<Id, Federal_Register__c>();
          tempMap.put(fr.Id, fr);
          parentIdToFRMap.put(fr.ADCVD_Order__c, tempMap);
        } else if (fr.Suspension_Agreement__c != null) {
          //This Federal Register is for a Suspension Agreement
          //Get the map in the parentIdToFRMap if this Suspension Agreement is already in the map.  Otherwise, create a new map.
          Map<Id, Federal_Register__c> tempMap = parentIdToFRMap.containsKey(fr.Suspension_Agreement__c)
              ? parentIdToFRMap.get(fr.Suspension_Agreement__c) : new Map<Id, Federal_Register__c>();
          tempMap.put(fr.Id, fr);
          parentIdToFRMap.put(fr.Suspension_Agreement__c, tempMap);
        } else if (fr.Segment__c != null) {
          //This Federal Register is for a Segment
          //Get the map in the parentIdToFRMap if this Segment is already in the map.  Otherwise, create a new map.
          Map<Id, Federal_Register__c> tempMap = parentIdToFRMap.containsKey(fr.Segment__c)
              ? parentIdToFRMap.get(fr.Segment__c) : new Map<Id, Federal_Register__c>();
          tempMap.put(fr.Id, fr);
          parentIdToFRMap.put(fr.Segment__c, tempMap);
        }
        tempFRMap = new Map<Id, Federal_Register__c>();
        tempFRMap.put(fr.Id, fr);
        caseIdToFRMap.put(fr.ADCVD_Case__c, tempFRMap);
      }
    }
  }
}