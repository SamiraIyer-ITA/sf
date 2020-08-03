/**
 * 
 *    Created by Joshua Moody
 *    on Dec 13 2017
 *    MIL Corporation
 * 
 **/

public class ADCVD_OrderDetailController {

  /************************************************
  * This class queries the ADCVD Object for the ADCVD Order
  * in scope, which is received from an external source. It writes
  * the child segments to Segment objects.  This controller is
  * used with the ADCVD_OrderDetail visual force page.
  *************************************************/

  public ADCVD_Case__c caseObj { get; set; }
  public ADCVD_Order__c order { get; set; }
  public String adcvdCase { get; set; }
  private static string defaultName = 'Scope.txt';
  public String attachmentBody { get; set; }
  public Map<Id, String> recordTypeIdToNameMapSegment {
    get {
      if (recordTypeIdToNameMapSegment == null) {
        recordTypeIdToNameMapSegment = utils.getRecordTypeLabelMap('Segment__c');
      }
      return recordTypeIdToNameMapSegment;
    }
    set;
  }
  public Map<Id, String> recordTypeIdToNameMapInvestigation {
    get {
      if (recordTypeIdToNameMapInvestigation == null) {
        recordTypeIdToNameMapInvestigation = utils.getRecordTypeLabelMap('Investigation__c');
      }
      return recordTypeIdToNameMapInvestigation;
    }
    set;
  }

  public List<SegmentInvestigationObj> segInvList { get; set; }
  public class SegmentInvestigationObj {
    public String name { get; set; }
    public String recordType { get; set; }
    public String announcementType { get; set; }
    public String announcementDate { get; set; }
    public String productShortName { get; set; }
    public String country { get; set; }
    public String caseNumber { get; set; }
    public String daysRemaining { get; set; }
    public String PeriodCoveredStartDate{ get; set; }
    public String PeriodCoveredEndDate{ get; set; }
    
    
  }

  public ADCVD_OrderDetailController() {
    this.adcvdCase = ApexPages.currentPage().getParameters().get('adcvdcase');
    System.debug(this.adcvdCase);
    this.segInvList = new List<SegmentInvestigationObj>();
    //TODO:use selectors instead of query
    this.caseObj = [
        SELECT Id, Name, ADCVD_Case_Type__c, Product__c, Product_Short_Name__c, Commodity__c,ADCVD_Case_Number__c,Country__c, (
            SELECT Id, Name,Period_Covered_End_Date__c,Period_Covered_Start_Date__c, ADCVD_Case_Number_Text__c, Product_Short_Name_Text__c, Country_Text__c, RecordTypeId, Actual_Final_Signature__c,
                Initiation_Extension_Remaining__c, Preliminary_Extension_Remaining__c, Final_Extension_Remaining__c, Announcement_Type__c,
                Initiation_Announcement_Date__c, Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Next_Announcement_Date__c, Days_Remaining__c
            FROM Segments__r
            WHERE Next_Announcement_Date__c != null
            ORDER BY Next_Announcement_Date__c ASC
        ), (
            SELECT Id, Name,Period_Covered_End_Date__c,Period_Covered_Start_Date__c,ADCVD_Case_Number_Text__c, Product_Short_Name_Text__c, Country_Text__c, RecordTypeId, Actual_Final_Signature__c,
                Preliminary_Extension_Remaining__c, Final_Extension_Remaining__c, Preliminary_Announcement_Date__c, Final_Announcement_Date__c,
                Next_Announcement_Date__c, Announcement_Type__c, Days_Remaining__c
            FROM Investigations__r
        ), (SELECT Id, HTS_Number_Formatted__c FROM Harmonized_Tariff_Schedules__r ORDER BY HTS_Number_Formatted__c ASC
        ), (SELECT Id, Name, ADCVD_Case_Number_Text__c, Product_Short_Name_Text__c, Country_Text__c, Commodity_Text__c FROM ADCVD_Orders__r)
        FROM ADCVD_Case__c
        WHERE ADCVD_Case_Number__c = :this.adcvdCase
        Limit 1
    ];

    //TODO:use selectors instead of query
    if(!caseObj.ADCVD_Orders__r.isEmpty()) {
      this.order = [
          Select id, (SELECT Id FROM Attachments WHERE Name = :defaultName LIMIT 1)
          FROM ADCVD_Order__c
          WHERE ADCVD_Case_Number_Text__c = :this.adcvdCase
          LIMIT 1
      ];
      if (!order.Attachments.isEmpty()) {
        this.attachmentBody = [SELECT Id, Body, Description FROM Attachment WHERE Id = :this.order.Attachments[0].Id LIMIT 1].Body.toString();
      }
    }
    if (!caseObj.Segments__r.isEmpty() || !caseObj.ADCVD_Orders__r.isEmpty()) {
      for (Segment__c segment : caseObj.Segments__r) {
        SegmentInvestigationObj si = new SegmentInvestigationObj();
        si.name = segment.Name;
        si.recordType = recordTypeIdToNameMapSegment.get(segment.RecordTypeId);
        si.productShortName = segment.Product_Short_Name_Text__c;
        si.country = segment.Country_Text__c;
        si.caseNumber = segment.ADCVD_Case_Number_Text__c;
        si.announcementDate = segment.Next_Announcement_Date__c != null ? segment.Next_Announcement_Date__c.format() :'' ;
        si.announcementType = segment.Announcement_Type__c;
        si.daysRemaining = segment.Days_Remaining__c;
        si.PeriodCoveredStartDate = segment.Period_Covered_Start_Date__c != null ? segment.Period_Covered_Start_Date__c.format() :'' ;
        si.PeriodCoveredEndDate = segment.Period_Covered_End_Date__c != null ? segment.Period_Covered_End_Date__c.format() : '';
        
        if(si.recordType == 'Administrative Review' || si.recordType == 'New Shipper Review' 
                || si.recordType == 'Expedited Review'){
            this.segInvList.add(si);
        }
        
      }
    } else if (!caseObj.Investigations__r.isEmpty()) {
      for (Investigation__c investigation : caseObj.Investigations__r) {
        SegmentInvestigationObj si = new SegmentInvestigationObj();
        si.name = investigation.Name;
        si.recordType = recordTypeIdToNameMapInvestigation.get(investigation.RecordTypeId) +' Investigation';
        si.productShortName = investigation.Product_Short_Name_Text__c;
        si.country = investigation.Country_Text__c;
        si.caseNumber = investigation.ADCVD_Case_Number_Text__c;
        si.announcementDate = investigation.Next_Announcement_Date__c != null ? investigation.Next_Announcement_Date__c.format() : '';
        si.announcementType = investigation.Announcement_Type__c;
        si.daysRemaining = investigation.Days_Remaining__c;
        si.PeriodCoveredStartDate = investigation.Period_Covered_Start_Date__c != null ? investigation.Period_Covered_Start_Date__c.format() : '';
        si.PeriodCoveredEndDate = investigation.Period_Covered_End_Date__c != null ? investigation.Period_Covered_End_Date__c.format() : '';
        
        this.segInvList.add(si);
      }
    }
  }
}