@RestResource(urlMapping='/ADCVD_OrderSearch/*')
global without sharing class ADCVD_OrderSearch {
    
    //JSON output classes.  These are marked as Public so the ADCVD_OrderSearchTest can see them.
       
    public class ADCVD_Order {
        public String id;
        public String caseNumber;
        public String productShortName;
        public String country;
        public List<Segment> segments = new List<Segment>();
        public List<HTS> htsNums = new List<HTS>();
    }
    
    public class Segment {
        public String id;
        public String recordType;
        public String decisionSigned;
        public String daysRemaining;
        public String announcementType;
        public String announcementDate;
    }

    public class Hts {
        public String id;
        public String htsNumber;
        public String htsNumberFormatted;
    }
    
    //The class that is used to create the JSON return value
    public class JsonOutput {
        public List<ADCVD_Order> adcvdOrders = new List<ADCVD_Order>();
    }

    private static Map<Id,String> recordTypeIdToNameMap {
    	get {
    		if (recordTypeIdToNameMap == null) {
    			recordTypeIdToNameMap = utils.getRecordTypeLabelMap('Segment__c');
    		}
    		return recordTypeIdToNameMap;
    	} set;
    }

    //The only callable method
    @HttpPost   
    global static void doPost() {
        
        //Initialize the return value
        JsonOutput output = new JsonOutput();
                
        List<ADCVD_Order__c> orders = [SELECT Id, ADCVD_Case_Number__c, Product_Short_Name__c, Country__c, 
			                               (SELECT Id, RecordTypeId, Actual_Final_Signature__c, Initiation_Extension_Remaining__c, 
			                               			Preliminary_Extension_Remaining__c, Final_Extension_Remaining__c, Initiation_Announcement_Date__c, 
			                               			Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Next_Announcement_Date__c 
			                               			FROM Segments__r WHERE Next_Announcement_Date__c != null ORDER BY Next_Announcement_Date__c ASC),
			                               (SELECT Id, HTS_Number__c, HTS_Number_Formatted__c FROM Harmonized_Tariff_Schedules__r ORDER BY HTS_Number_Formatted__c ASC)
			                               FROM ADCVD_Order__c
			                             ];
        
        for (ADCVD_Order__c o: orders) {
            ADCVD_Order ao = new ADCVD_Order();
            ao.id = o.id;
            ao.caseNumber = o.ADCVD_Case_Number__c;
            ao.productShortName = o.Product_Short_Name__c;
            ao.country = o.Country__c;
            
            for (Segment__c seg: o.Segments__r) {
                Segment s = new Segment();
                s.id = seg.id;
                s.recordType = recordTypeIdToNameMap.get(seg.RecordTypeId);
                s.announcementDate = seg.Next_Announcement_Date__c.format();
                getAnnouncementTypeInfo(seg, s);
                ao.segments.add(s);
            }
            for (Harmonized_Tariff_Schedule__c hts: o.Harmonized_Tariff_Schedules__r) {
                Hts h = new Hts();
                h.id = hts.id;
                h.htsNumber = hts.HTS_Number__c;
                h.htsNumberFormatted = hts.HTS_Number_Formatted__c;
                ao.htsNums.add(h);
            }
            
            output.adcvdOrders.add(ao);
            
        }
        
        //Create the JSON output
        RestContext.response.addHeader('Content-Type', 'application/json');
        String returnValue = JSON.serialize(output, true);
        System.debug(loggingLevel.Error, '*** returnValue: ' + returnValue);
        RestContext.response.responseBody = Blob.valueOf(returnValue);
        return;

    }

    private static void getAnnouncementTypeInfo(Segment__c seg, Segment s) {
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
    		s.decisionSigned = 'true';
    	} else {
    		s.decisionSigned = 'false';
    	}
    }

}