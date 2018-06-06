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
   * FederalRegistersInScope is an abstract inner class.
   */
  public Map<Id, FederalRegistersInScope> masterMap = new Map<Id, FederalRegistersInScope>();

  /**
   * FederalRegistersInScope is an abstract inner class which is implemented by an inner class for each of the types of Federal Registers.
   */
  public abstract class FederalRegistersInScope {
    @testVisible Id myId { get; private set; }  //Id will vary, based on the inner case
    public Map<String, Date> typeToPublishedDateMap = new Map<String, Date>();

    /**
     * Retrieve the Federal Registers for a given sObject Id.
     * The sObject Id is the Id of a Petition, Investigation, ADCVD Order, Suspension Agreement, or Segment.
     *
     * @param soId
     */
    public virtual void getFRsFromId(Id soId) {
      Set<Id> relatedIdSet = ADCVD_CaseSelector.fr_ParentIdToRelatedParentIds.get(soId);
      List<Federal_Register__c> frsInScope = new List<Federal_Register__c>();
      for (Id relatedId : relatedIdSet) {
        if (FederalRegisterSelector.parentIdToFRMap.containsKey(relatedId)) {
          frsInScope.addAll(FederalRegisterSelector.parentIdToFRMap.get(relatedId).values());
        }
      }
      for (Federal_Register__c fr : frsInScope) {
        mapFR(fr);
      }
    }
    public abstract void mapFR(Federal_Register__c fr);
  }

  //Inner Classes
  public class PetitionFRs extends FederalRegistersInScope {
    Federal_Register__c initiationFR { get; private set; }

    public override void mapFR(Federal_Register__c fr) {

      if (fr.Type__c == 'Initiation') {
        if (initiationFR == null || (initiationFR != null && fr.CreatedDate < initiationFR.CreatedDate)) {
          initiationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      }
    }
  }

  public class InvestigationFRs extends FederalRegistersInScope {
    Federal_Register__c initiationFR { get; private set; }  //From Petition
    Federal_Register__c prelimFR { get; private set; }
    Federal_Register__c amendedPreliminaryFR { get; private set; }
    Federal_Register__c finalFR { get; private set; }
    Federal_Register__c amendedFinalFR { get; private set; }
    Federal_Register__c itcPreliminaryFR { get; private set; }
    Federal_Register__c itcFinalFR { get; private set; }
    Federal_Register__c orderFR { get; private set; }  //From ADCVD Order
    Federal_Register__c postponementFR { get; private set; }

    public override void mapFR(Federal_Register__c fr) {
      if (fr.Type__c == 'Initiation') {
        if (initiationFR == null || (initiationFR != null && fr.CreatedDate < initiationFR.CreatedDate)) {
          initiationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Preliminary') {
        if (prelimFR == null || (prelimFR != null && fr.CreatedDate < prelimFR.CreatedDate)) {
          prelimFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Amended Preliminary') {
        if (amendedPreliminaryFR == null || (amendedPreliminaryFR != null && fr.CreatedDate < amendedPreliminaryFR.CreatedDate)) {
          amendedPreliminaryFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Final') {
        if (finalFR == null || (finalFR != null && fr.CreatedDate < finalFR.CreatedDate)) {
          finalFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Amended Final') {
        if (amendedFinalFR == null || (amendedFinalFR != null && fr.CreatedDate < amendedFinalFR.CreatedDate)) {
          amendedFinalFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'ITC Preliminary') {
        if (itcPreliminaryFR == null || (itcPreliminaryFR != null && fr.CreatedDate < itcPreliminaryFR.CreatedDate)) {
          itcPreliminaryFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'ITC Final') {
        if (itcFinalFR == null || (itcFinalFR != null && fr.CreatedDate < itcFinalFR.CreatedDate)) {
          itcFinalFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Postponement') {
        if (postponementFR == null || (postponementFR != null && fr.CreatedDate < postponementFR.CreatedDate)) {
          postponementFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      }
    }
  }

  public class ADCVD_OrderFRs extends FederalRegistersInScope {
    Federal_Register__c orderFR { get; private set; }
    Federal_Register__c continuationFR { get; private set; }
    Federal_Register__c revocationFR { get; private set; }

    public override void mapFR(Federal_Register__c fr) {
      if (fr.Type__c == 'Order') {
        if (orderFR == null || (orderFR != null && fr.CreatedDate < orderFR.CreatedDate)) {
          orderFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Continuation') {//Use the newest one for Continuation
        if (continuationFR == null || (continuationFR != null && fr.CreatedDate > continuationFR.CreatedDate)) {
          continuationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Revocation') {
        if (revocationFR == null || (revocationFR != null && fr.CreatedDate < revocationFR.CreatedDate)) {
          revocationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      }
    }
  }

  public class Suspension_AgreementFRs extends FederalRegistersInScope {
    Federal_Register__c suspAgreementFR { get; private set; }
    Federal_Register__c continuationFR { get; private set; }
    Federal_Register__c terminationFR { get; private set; }

    public override void mapFR(Federal_Register__c fr) {
      if (fr.Type__c == 'Suspension Agreement') {
        if (suspAgreementFR == null || (suspAgreementFR != null && fr.CreatedDate < suspAgreementFR.CreatedDate)) {
          suspAgreementFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Continuation') {//Use the newest one for Continuation
        if (continuationFR == null || (continuationFR != null && fr.CreatedDate > continuationFR.CreatedDate)) {
          continuationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Termination') {
        if (terminationFR == null || (terminationFR != null && fr.CreatedDate < terminationFR.CreatedDate)) {
          terminationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      }
    }
  }

  public class SegmentFRs extends FederalRegistersInScope {
    Federal_Register__c initiationFR { get; private set; }
    Federal_Register__c prelimFR { get; private set; }
    Federal_Register__c finalFR { get; private set; }
    Federal_Register__c amendedFinalFR { get; private set; }
    Federal_Register__c rescissionFR { get; private set; }
    Federal_Register__c continuationFR { get; private set; }  //From ADCVD Order or Suspension Agreement
    Federal_Register__c revocationFR { get; private set; } //From ADCVD Order
    Federal_Register__c terminationFR { get; private set; }  //From Suspension Agreement

    public override void mapFR(Federal_Register__c fr) {
      if (fr.Type__c == 'Initiation') {
        if (initiationFR == null || (initiationFR != null && fr.CreatedDate < initiationFR.CreatedDate)) {
          initiationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Preliminary') {
        if (prelimFR == null || (prelimFR != null && fr.CreatedDate < prelimFR.CreatedDate)) {
          prelimFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Final') {
        if (finalFR == null || (finalFR != null && fr.CreatedDate < finalFR.CreatedDate)) {
          finalFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Amended Final') {
        if (amendedFinalFR == null || (amendedFinalFR != null && fr.CreatedDate < amendedFinalFR.CreatedDate)) {
          amendedFinalFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Rescission') {
        if (rescissionFR == null || (rescissionFR != null && fr.CreatedDate < rescissionFR.CreatedDate)) {
          rescissionFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Continuation') {//Use the newest one for Continuation
        if (continuationFR == null || (continuationFR != null && fr.CreatedDate > continuationFR.CreatedDate)) {
          continuationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Revocation') {
        if (revocationFR == null || (revocationFR != null && fr.CreatedDate < revocationFR.CreatedDate)) {
          revocationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
        }
      } else if (fr.Type__c == 'Termination') {
        if (terminationFR == null || (terminationFR != null && fr.CreatedDate < terminationFR.CreatedDate)) {
          terminationFR = fr;
          typeToPublishedDateMap.put(fr.type__c, fr.published_date__c);
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
  public FederalRegisterMapper(Set<Id> soIdSet, String objectName) {  //objectName is the sObject name of the Ids
    for (Id soId : soIdSet) {
      //Create the appropriate inner class based on objectName
      //try {
        FederalRegistersInScope tempClass;
        if (String.isNotBlank(objectName) && objectName.equals('Petition__c')) {
          tempClass = (FederalRegistersInScope) new PetitionFRs();
        } else if (objectName.equals('Investigation__c')) {
          tempClass = (FederalRegistersInScope) new InvestigationFRs();
        } else if (objectName.equals('ADCVD_Order__c')) {
          tempClass = (FederalRegistersInScope) new ADCVD_OrderFRs();
        } else if (objectName.equals('Suspension_Agreement__c')) {
          tempClass = (FederalRegistersInScope) new Suspension_AgreementFRs();
        } else if (objectName.equals('Segment__c')) {
          tempClass = (FederalRegistersInScope) new SegmentFRs();
        }
        if (tempClass != null) {
          //set the myId on that inner class
          tempClass.myId = soId;
          //Call a virtual class method that is implemented differently on each method.  This way the same method call can get us the correct logic dynamically.
          tempClass.getFRsFromId(soId);
          masterMap.put(soId, tempClass);
        }
      /*} catch (Exception e) {
        System.debug('Unable to map Federal Registers.  ' + 'Error: ' + e.getMessage());
      }*/
    }
  }
}