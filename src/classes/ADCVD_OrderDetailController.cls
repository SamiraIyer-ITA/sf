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

    public ADCVD_Order__c order {get; set;}
    public String adcvdCase {get; set;}
    private static string defaultName = 'Scope.txt';
    public String attachmentBody {get; set;}
    public Map<Id,String> recordTypeIdToNameMap {
      get {
        if (recordTypeIdToNameMap == null) {
          recordTypeIdToNameMap = utils.getRecordTypeLabelMap('Segment__c');
        }
        return recordTypeIdToNameMap;
      } set;
    }
    public List<Segment> Segments {get; set;}

    public class Segment {
      public String name {get; set;}
      public String recordType {get; set;}
      public String announcementType {get; set;}
      public String announcementDate {get; set;}
      public String productShortName {get; set;}
      public String country {get; set;}
      public String caseNumber {get; set;}
      public String daysRemaining {get; set;}
    }
    
    public ADCVD_OrderDetailController() {
        this.adcvdCase = ApexPages.currentPage().getParameters().get('adcvdcase');
        this.Segments = new List<Segment>(); 
        this.order = [SELECT
                               Id, Name, ADCVD_Case_Number__c, Product_Short_Name__c, Country__c, 
                               (SELECT Id, Name, ADCVD_Case_Number__c, Product_Short_Name__c, Country__c, RecordTypeId, Actual_Final_Signature__c, 
                                     Initiation_Extension_Remaining__c, Preliminary_Extension_Remaining__c, Final_Extension_Remaining__c, 
                                     Initiation_Announcement_Date__c, Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Next_Announcement_Date__c 
                                     FROM Segments__r WHERE Next_Announcement_Date__c != null ORDER BY Next_Announcement_Date__c ASC),
                               (SELECT Id, HTS_Number_Formatted__c FROM Harmonized_Tariff_Schedules__r ORDER BY HTS_Number_Formatted__c ASC),
                               (SELECT Id FROM Attachments WHERE Name =: defaultName LIMIT 1)
                               FROM ADCVD_Order__c WHERE ADCVD_Case_Number__c = :this.adcvdCase LIMIT 1
                             ];
        if(!order.Attachments.isEmpty()) {
            this.attachmentBody = [SELECT Id, Body, Description FROM Attachment WHERE Id =: this.order.Attachments[0].Id LIMIT 1].Body.toString();
        }
        for (Segment__c seg : order.Segments__r) {
          Segment s = new Segment();
          s.name = seg.Name;
          s.recordType = recordTypeIdToNameMap.get(seg.RecordTypeId);
          s.productShortName = seg.Product_Short_Name__c;
          s.country = seg.Country__c;
          s.caseNumber = seg.ADCVD_Case_Number__c;
          s.announcementDate = seg.Next_Announcement_Date__c.format();
          getAnnouncementTypeInfo(seg, s);
          this.Segments.add(s);
        }
    }
    public void getAnnouncementTypeInfo(Segment__c seg, Segment s) {
      if (seg.Next_Announcement_Date__c == seg.Initiation_Announcement_Date__c) {
        s.announcementType = 'Initiation';
        s.daysRemaining = seg.Initiation_Extension_Remaining__c.toPlainString();
      } else if (seg.Next_Announcement_Date__c == seg.Preliminary_Announcement_Date__c) {
        s.announcementType = 'Preliminary';
        s.daysRemaining = seg.Preliminary_Extension_Remaining__c.toPlainString();
      } else if (seg.Next_Announcement_Date__c == seg.Final_Announcement_Date__c) {
        s.announcementType = 'Final';
        s.daysRemaining = seg.Final_Extension_Remaining__c.toPlainString();
      }
      if (seg.Actual_Final_Signature__c != null) {
        s.daysRemaining = 'Decision Signed';
      }
    }
}