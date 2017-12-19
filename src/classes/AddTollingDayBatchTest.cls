/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 *    Revised 12/18/2017
 *
 **/
 
@isTest
public class AddTollingDayBatchTest {

    public static string initialState = '';
    public static string queryObject = '';
    public static Date petitionDate = System.today();
    public static Date testNextAnnouncmentDate = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
    public static Date testNextDueToDAS = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
    public static Date testNextOfficeDeadline = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
    public static Date testPublishedDate = System.today();
    public static Date segmentDate = System.today();
    public static Date litigationDate = System.today();
    public static string latestDate = string.valueOf(system.today().addDays(-6));
	public static Date tollingDateStart = System.today().addDays(-10);
	public static Date tollingDateEnd = System.today().addDays(-6);
    public static Boolean testTollingUpdate = false;
    public static AppConfig__c app {
        get{
            if(app == null){ 
                app = new AppConfig__c();
                app.Name = 'default';
                app.Primary_Admin__c = 'csmith@milcorp.com'; 
                app.ADCVD_Admin__c = 'calvin.smith@trade.gov';
                app.TriggersEnabled__c = false;
                app.AppEnabled__c = true;
                app.ChronExp_LitigationSegement__c = ' 0 ' + string.valueOf((system.now().addMinutes(30)).minute()) + ' ' + string.valueOf((system.now().addMinutes(30)).hour()) + ' ' + string.valueOf(system.today().day()) + ' ' + string.valueOf(system.today().Month()) + ' ?';
                system.debug('app.ChronExp_LitigationSegement__c = ' + app.ChronExp_LitigationSegement__c);
                app.ChronExpr_PetitionInvestigation__c = '0 0 1 ' +  string.valueOf((system.today().addDays(1)).day()) + ' ' + string.valueOf(system.today().addDays(1).month()) + ' ?';
                system.debug('ChronExpr_PetitionInvestigation__c = ' + app.ChronExpr_PetitionInvestigation__c); 
                insert app;
            }
            return app;
        }
    }               

    system.LoggingLevel level = LoggingLevel.ERROR; 
    public static User u{
        get{
            if(u == null){
                u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
                                Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
                            FROM User WHERE LastName =: 'LastName1' LIMIT 1];
            }
            return u;
        }
    }
    public static List<Investigation__c> iList {
        get {
            if(iList == null) {
                iList = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
                            Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
                            Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                            Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
                            Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
                            Calculated_Postponement_of_PrelimDeterFR__c, 
                            Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
                            Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c,
                            Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                            Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c,
                            Schedule_Refresh__c, Tolling_Update__c
                        FROM Investigation__c];
            }
            return iList;
        }
    }
    public static Petition__c adP{
        get{
            if (adP == null) {
                adP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Next_Office_Deadline__c, Schedule_Refresh__c, Tolling_Update__c 
                        FROM Petition__c WHERE ADCVD_Case_Type__c LIKE 'AD%' LIMIT 1];
            }
            return adP;
        }
    }
    public static Petition__c cvdP{
        get{
            if (cvdP == null) {
                cvdP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Next_Office_Deadline__c, Schedule_Refresh__c, Tolling_Update__c 
                        FROM Petition__c WHERE ADCVD_Case_Type__c LIKE 'CVD%' LIMIT 1];
            }
            return cvdP;
        }
    }
    public static Investigation__c iAD {
        get {
            if(iAD == null) {
                Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('AD');
                iAD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
                            Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
                            Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                            Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
                            Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
                            Calculated_Postponement_of_PrelimDeterFR__c, 
                            Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
                            Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                            Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                            Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, 
                            Calculated_ITC_Prelim_Determination__c, Schedule_Refresh__c, Tolling_Update__c 
                        FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
            }
            return iAD;
        }   
    }
    public static Investigation__c iCVD {
        get {
            if(iCVD == null) {
                Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('CVD');
                iCVD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
                            Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
                            Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                            Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
                            Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
                            Petition_Initiation_Signature__c, Calculated_Postponement_of_PrelimDeterFR__c, 
                            Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
                            Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                            Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                            Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, 
                            Calculated_ITC_Prelim_Determination__c, Schedule_Refresh__c, Tolling_Update__c 
                        FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
            }
            return iCVD;
        }   
    }
    public static Federal_Register__c adPrelimFR {
        get {
            if(adPrelimFR == null) {
                adPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'Preliminary' LIMIT 1];
            }
            return adPrelimFR;
        }
    }
    public static Federal_Register__c adPrelimItcFR {
        get {
            if(adPrelimItcFR == null) {
                adPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
            }
            return adPrelimItcFR;
        }
    }
    public static Federal_Register__c adFinalItcFR {
        get {
            if(adFinalItcFR == null) {
                adFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Final' LIMIT 1];
            }
            return adFinalItcFR;
        }
    }
    public static Federal_Register__c adOrderFR {
        get {
            if(adOrderFR == null) {
                adOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: adOrder.Id AND Type__c =: 'Order' LIMIT 1];
            }
            return adOrderFR;
        }
    }
    public static Federal_Register__c cvdPrelimFR {
        get {
            if(cvdPrelimFR == null) {
                cvdPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'Preliminary' LIMIT 1];
            }
            return cvdPrelimFR;
        }
    }
    public static Federal_Register__c cvdPrelimItcFR {
        get {
            if(cvdPrelimItcFR == null) {
                cvdPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
            }
            return cvdPrelimItcFR;
        }
    }
    public static Federal_Register__c cvdFinalItcFR {
        get {
            if(cvdFinalItcFR == null) {
                cvdFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Final' LIMIT 1];
            }
            return cvdFinalItcFR;
        }
    }
    public static Federal_Register__c cvdOrderFR {
        get {
            if(cvdOrderFR == null) {
                cvdOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: cvdOrder.Id AND Type__c =: 'Order' LIMIT 1];
            }
            return cvdOrderFR;
        }
    }
    public static ADCVD_Order__c adOrder{
        get{
            if (adOrder == null) {
                adOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iAD.Id LIMIT 1];
            }
            return adOrder;
        }
    }
    public static ADCVD_Order__c cvdOrder{
        get{
            if (cvdOrder == null) {
                cvdOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iCVD.Id LIMIT 1];
            }
            return cvdOrder;
        }
    }
    public static ADCVD_Order__c o{
        get{
            if (o == null) {
                o = [SELECT Id, Anniversary_Month__c FROM ADCVD_Order__c LIMIT 1];
            }
            return o;
        }
    }   
    public static Segment__c adminSeg{
        get{
            if (adminSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                adminSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, 
                                    Schedule_Refresh__c, Tolling_Update__c 
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return adminSeg;
        }
    }
    public static Segment__c nsSeg{
        get{
            if (nsSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('New_Shipper_Review');
                nsSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Calculated_Initiation_Signature__c, Final_Team_Meeting_Deadline__c, 
                                Actual_Initiation_Signature__c, Calculated_Final_Signature__c, Actual_Preliminary_Signature__c, Actual_Final_Signature__c, 
                                Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                                Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
                                Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, 
                                Schedule_Refresh__c, Tolling_Update__c 
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return nsSeg;
        }
    }
    public static Segment__c siSeg{
        get{
            if (siSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Scope_Inquiry');
                siSeg = [SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c, Initiation_Extension_of_days__c, RecordTypeId, Request_Filed__c, 
                                Prelim_Extension__c, Calculated_Preliminary_Signature__c, Actual_Date_of_Decision_on_HoP__c, Calculated_Final_Signature__c, 
                                Decision_on_HOP_Issues_Due_to_DAS__c, Decision_on_HOP_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, 
                                Prelim_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Prelim_Team_Meeting_Deadline__c, 
                                Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Final_Team_Meeting_Deadline__c, 
                                Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return siSeg;
        }
    }
    public static Segment__c expedSeg{
        get{
            if (expedSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Expedited_Review');
                expedSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, 
                                    Schedule_Refresh__c, Tolling_Update__c 
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return expedSeg;
        }
    }
    public static Segment__c acSeg{
        get{
            if (acSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Anti_Circumvention_Review');
                acSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Initiation_Extension_of_days__c, Calculated_Preliminary_Signature__c, 
                                    Calculated_Final_Signature__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    Application_Accepted__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c 
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return acSeg;
        }
    }
    public static Segment__c ccSeg{
        get{
            if (ccSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Changed_Circumstances_Review');
                ccSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Is_This_Review_Expedited__c,
                                    Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    All_parties_in_agreement_to_the_outcome__c, Request_Filed__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ccSeg;
        }
    }
    public static Segment__c ssSeg{
        get{
            if (ssSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Sunset_Review');
                ssSeg = [SELECT Id, RecordTypeId, Calculated_Preliminary_Signature__c, Calculated_Final_Signature__c, Update_ACE_Customs_Module__c, Adequacy_of_Respondents_Submission__c, 
                            Actual_Final_Signature__c, Actual_Revocation_or_Continuation_FR__c, Calculated_Revocation_or_Continuation_FR__c, 
                            Issue_Liquidation_Revocation_Instruction__c, Rebuttal_Comments_Due__c, Adequacy_Determination_Letter__c, 
                            Comments_on_Adequacy_Determination_Filed__c, Memorandum_on_Adequacy_Determination__c, Prelim_Team_Meeting_Deadline__c, 
                            Notify_ITC_of_No_Domestic_Interest__c, Inadequate_Domestic_Response_note_to_ITC__c, Notice_of_Intent_to_Participate__c, 
                            Notify_Cluster_Coordinator_No_Interest__c, Substantive_Response_Due_For_All_Parties__c, Inform_Cluster_Coordinator_if_No_Respons__c, 
                            Notice_of_intent_to_participate_Ips__c, Domestic_Party_File_Substan_Response__c, Review_to_address_zeroing_in_Segments__c, 
                            Respondent_File_Substantive_Response__c, Prelim_Extension__c, Initiation_Extension_of_days__c, 
                            Final_Extension_of_days__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                            Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Final_Team_Meeting_Deadline__c, 
                            Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                            Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c 
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ssSeg;
        }
    }

    public static Litigation__c intLit{
        get{
            if (intLit == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('International_Litigation');
                intLit = [SELECT Id, RecordTypeId, Request_Filed__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
                                Calculated_Final_Signature__c, Prelim_Extension_of_days__c, Status__c, Final_Extension_of_days__c, 
                                Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
                                Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
                                Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Schedule_Refresh__c,
                                Tolling_Update__c 
                                FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return intLit;
        }
    }
    public static Litigation__c remand{
        get{
            if (remand == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('Remand');
                remand = [SELECT Id, RecordTypeId, Final_Extension_of_days__c, Expected_Final_Signature_Before_Ext__c, Calculated_Amended_Final_Signature__c,
                                Calculated_Draft_Remand_release_to_party__c, Calculated_Final_Signature__c, Court_of_Panel_s_Ruling__c, Status__c, 
                                Draft_Remand_Concurrence_Due_to_DAS__c, Draft_Remand_Issues_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
                                Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
                                Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c 
                            FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return remand;
        }
    }
	//calls db everytime
	private static List<Petition__c> petitionList {
		get {
			petitionList = [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c];
			return petitionList;
		}
	}
	private static Set<Id> petitionSet {
		get {
			if(petitionSet == null) {
				petitionSet = new Set<Id>();
				petitionSet.add(petitionList[0].Id);
			}
			return petitionSet;
		}
	}
	//calls db everytime
	private static List<Tolling_Day__c> tdList {
		get {
			tdList = [SELECT Id, Start_Date__c, End_Date__c FROM Tolling_Day__c];
			return tdList;
		}
	}
    

    public static AppConfig__c insertAppConfig() {
    			AppConfig__c app = new AppConfig__c();
                app.Name = 'default';
                app.Primary_Admin__c = 'csmith@milcorp.com'; 
                app.ADCVD_Admin__c = 'calvin.smith@trade.gov';
                app.TriggersEnabled__c = false;
                app.AppEnabled__c = true;
                app.ChronExp_LitigationSegement__c = ' 0 ' + string.valueOf((system.now().addMinutes(30)).minute()) + ' ' + string.valueOf((system.now().addMinutes(30)).hour()) + ' ' + string.valueOf(system.today().day()) + ' ' + string.valueOf(system.today().Month()) + ' ?';
                system.debug('app.ChronExp_LitigationSegement__c = ' + app.ChronExp_LitigationSegement__c);
                app.ChronExpr_PetitionInvestigation__c = '0 0 1 ' +  string.valueOf((system.today().addDays(1)).day()) + ' ' + string.valueOf(system.today().addDays(1).month()) + ' ?';
                system.debug('ChronExpr_PetitionInvestigation__c = ' + app.ChronExpr_PetitionInvestigation__c); 
                insert app;
        return app;
    }               


    static testMethod void testPetitionDates() {
 		
        system.LoggingLevel level = LoggingLevel.INFO;
		AppConfig__c app = insertAppConfig();
        integer emailMax = limits.getLimitEmailInvocations();
        integer emailActualBefore = limits.getEmailInvocations();
        integer emailAllowedBefore = emailMax - emailActualBefore;
        integer dmlStatementsMax = limits.getLimitDMLStatements();
        integer dmlStatementsUsedBefore = limits.getDMLStatements();
        integer dmlStatementsAllowedBefore = dmlStatementsMax - dmlStatementsUsedBefore;
        integer dmlRowsMax = limits.getLimitDmlRows();
        integer dmlRowsUsedBefore = limits.getDmlRows();
		integer dmlRowsAllowedBefore = dmlRowsMax - dmlRowsUsedBefore;		
        integer dmlStatementsActual1 = 0;
        integer dmlStatementsAllowed1 = 0; 
        integer dmlStatementsUsed1 = 0;
        integer dmlRowsActual1 = 0;
        integer dmlRowsAllowed1 = 0;
        integer dmlRowsUsed1 = 0;
        integer dmlStatementsUsed2 = 0;
        integer dmlStatementsActual2 = 0;
        integer dmlStatementsAllowed2 = 0;
        integer dmlRowsAllowed2 = 0; 
        integer dmlRowsActual2 = 0; 
		integer dmlRowsUsed2 = 0;
        integer dmlStatementsActualAfter = 0;
        integer dmlStatementsAllowedAfter = 0; 
		integer dmlStatementsUsed = 0; 
        integer dmlRowsActualAfter = 0;
        integer dmlRowsAllowedAfter = 0; 
		integer dmlRowsUsed = 0;
        
        //Set value for batch data
        adP.Next_Due_to_DAS_Deadline__c = System.today();
        adP.Next_Office_Deadline__c = System.today();
        adP.Next_Announcement_Date__c = System.today();
        adP.Schedule_Refresh__c = false; 
        adP.Tolling_Update__c = false;
        
        update adP;

        //Assert values updated correctly
        system.assertEquals(System.today(), adP.Next_Due_to_DAS_Deadline__c);
        system.assertEquals(System.today(), adP.Next_Office_Deadline__c);
        system.assertEquals(System.today(), adP.Next_Announcement_Date__c);
        system.assertEquals(false, adP.Schedule_Refresh__c);
		system.assertEquals(false, adP.Tolling_Update__c);       

        Test.startTest();        
        // Insert Tolling Date : Start Batch Class
        level = LoggingLevel.DEBUG;
        Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
		dmlStatementsActual1 = limits.getDMLStatements();
		dmlStatementsAllowed1 = dmlStatementsMax - dmlStatementsActual1;
        dmlStatementsUsed1 = dmlStatementsActual1 - dmlStatementsUsedBefore;
        dmlRowsActual1 = limits.getDmlRows();
		dmlRowsAllowed1 = dmlRowsMax - dmlRowsActual1;
        dmlRowsUsed1 = dmlRowsActual1 - dmlRowsUsedBefore; 

		list<Tolling_Day__c>tdList = new list<Tolling_Day__c>();
		tdList.add(td);
		list<Petition__c>recordsToProcess = new list<Petition__c>([SELECT Id, Tolling_Update__c FROM Petition__c WHERE Petition_Filed__c <= :tollingDateEnd AND Petition_Outcome__c = null AND Locked__c = false]);
		TollingDayTriggerHandler.setDatesInScope(tdList);
        string initialState = '1';
        string queryObject = 'Petition__c';
        string lastDate = string.valueOf(tollingDateEnd);
        system.debug('lastDate = ' + lastDate);

        //ID batchprocessid        
        Id bid;

		// declare a new tolling day batch & set batch context 
		// this will also cause the checkLimits() and getNumToObject() methods to run
		AddTollingDayBatch atdb = new AddTollingDayBatch(initialState, queryObject, lastDate);
		
		// Call the start method in the batch class during the unit test
		Database.QueryLocator ql = atdb.start(null);
		
		// start the batch class during unit test
		atdb.execute(null, recordsToProcess);
		
		Savepoint sp = Database.setSavepoint();

		// call finish method without starting next job (bc = null)
		level = LoggingLevel.FINE;
		atdb.finish(null);
		
		// Before Rollback...
				
		system.debug('atdb.finish(null).bid = ' + atdb.bid );

		system.assertEquals(atdb.bid,'707000000000000AAA');

		//The next job will have been given a job Id which will have been queried for as 'bid1' in the batch

		system.debug('atdb.finish(null).bid1 = ' + atdb.bid1 );
		
		system.assertNotEquals(atdb.bid1,null);
				 
        dmlStatementsActual2 = limits.getDMLStatements();
        dmlStatementsAllowed2 = dmlStatementsMax - dmlStatementsActual2; 
        dmlRowsActual2 = limits.getDMLRows();
        dmlStatementsUsed2 = dmlStatementsActual2 - dmlStatementsUsedBefore;
        dmlRowsUsed2 = dmlRowsActual2 - dmlRowsUsedBefore; 

		// rollback transaction
		Database.rollback(sp);

        Test.stopTest();

        dmlStatementsActualAfter = limits.getDMLStatements();
        dmlStatementsAllowedAfter = dmlStatementsMax - dmlStatementsActualAfter; 
        dmlRowsActualAfter = limits.getDMLRows();
        dmlRowsAllowedAfter = dmlRowsMax - dmlRowsActualAfter; 
		dmlRowsUsed = dmlRowsActualAfter - dmlRowsUsedBefore;
		dmlStatementsUsed = dmlStatementsActualAfter - dmlStatementsUsedBefore; 

		system.debug('dmlStatementsMax = '+ dmlStatementsMax);
		system.debug('dmlStatementsUsedBefore = '+ dmlStatementsUsedBefore);
		system.debug('dmlRowsMax = '+ dmlRowsMax);
		system.debug('dmlRowsUsedBefore = '+ dmlRowsUsedBefore);
		system.debug('dmlStatementsAllowedBefore = '+ dmlStatementsAllowedBefore);
		system.debug('dmlRowsAllowedBefore = '+ dmlRowsAllowedBefore);
		system.debug('dmlStatementsAllowed1 = ' + dmlStatementsAllowed1);
		system.debug('dmlRowsAllowed1 = ' + dmlRowsAllowed1);
		system.debug('dmlRowsActual1 = ' + dmlRowsActual1);
		system.debug('dmlStatementsUsed1 = ' + dmlStatementsUsed1);
		system.debug('dmlRowsUsed1 = ' + dmlRowsUsed1);
		system.debug('dmlStatementsActual2 = ' + dmlStatementsActual2);
		system.debug('dmlStatementsAllowed2 = ' + dmlStatementsAllowed2);
		system.debug('dmlRowsAllowed2 = ' + dmlRowsAllowed2);
		system.debug('dmlRowsActual2 = ' + dmlRowsActual2);
		system.debug('dmlStatementsUsed2 = ' + dmlStatementsUsed2);
		system.debug('dmlRowsUsed2 = ' + dmlRowsUsed2);
		system.debug('dmlStatementsActualAfter = '+ dmlStatementsActualAfter);		
		system.debug('dmlRowsActualAfter = '+ dmlRowsActualAfter);
		system.debug('dmlRowsAllowedAfter = '+ dmlRowsAllowedAfter);
		system.debug('dmlStatementsAllowedAfter = '+ dmlStatementsAllowedAfter);
		system.debug('dmlRowsUsed = '+ dmlRowsUsed);
		system.debug('dmlStatementsUsed = '+ dmlStatementsUsed); 

		system.assertEquals(dmlRowsActual1,2);
		system.assertEquals(dmlStatementsUsed1,1);
		system.assertEquals(dmlRowsActual2,3);
		system.assertEquals(dmlStatementsUsed2,2);
		system.assertEquals(dmlRowsUsed,1);
		system.assertEquals(dmlStatementsUsed,1);
		// because of rollback...
		system.assertEquals(false, adP.Tolling_Update__c);
		
		//*** FINISHED CREATING FINAL ASSERTIONS ***//

    }

    static testMethod void testInvestigationDates() {
        
        system.LoggingLevel level = LoggingLevel.INFO;    
        AppConfig__c app = insertAppConfig();
        integer emailMax = limits.getLimitEmailInvocations();
        integer emailActualBefore = limits.getEmailInvocations();
        integer emailAllowedBefore = emailMax - emailActualBefore;
        integer dmlStatementsMax = limits.getLimitDMLStatements();
        integer dmlStatementsUsedBefore = limits.getDMLStatements();
        integer dmlStatementsAllowedBefore = dmlStatementsMax - dmlStatementsUsedBefore;
        integer dmlRowsMax = limits.getLimitDmlRows();
        integer dmlRowsUsedBefore = limits.getDmlRows();
		integer dmlRowsAllowedBefore = dmlRowsMax - dmlRowsUsedBefore;		
        integer dmlStatementsActual1 = 0;
        integer dmlStatementsAllowed1 = 0; 
        integer dmlStatementsUsed1 = 0;
        integer dmlRowsActual1 = 0;
        integer dmlRowsAllowed1 = 0;
        integer dmlRowsUsed1 = 0;
        integer dmlStatementsUsed2 = 0;
        integer dmlStatementsActual2 = 0;
        integer dmlStatementsAllowed2 = 0;
        integer dmlRowsAllowed2 = 0; 
        integer dmlRowsActual2 = 0; 
		integer dmlRowsUsed2 = 0;
        integer dmlStatementsActualAfter = 0;
        integer dmlStatementsAllowedAfter = 0; 
		integer dmlStatementsUsed = 0; 
        integer dmlRowsActualAfter = 0;
        integer dmlRowsAllowedAfter = 0; 
		integer dmlRowsUsed = 0;
                
        //Set value for batch data
        iAD.Next_Due_to_DAS_Deadline__c = System.today();
        iAD.Next_Office_Deadline__c = System.today();
        iAD.Next_Announcement_Date__c = System.today();
        iAD.Schedule_Refresh__c = false; 
        iAD.Tolling_Update__c = false;
        

        update iAD;
		level = LoggingLevel.DEBUG;
        //Assert values updated correctly, and have not had the triggers run on them
        system.assertEquals(System.today(), iAD.Next_Due_to_DAS_Deadline__c);
        system.assertEquals(System.today(), iAD.Next_Office_Deadline__c);
        system.assertEquals(System.today(), iAD.Next_Announcement_Date__c);
		system.assertEquals(false, iAD.Tolling_Update__c);
        
        
        // Insert Tolling Date 
        Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
		
		dmlStatementsActual1 = limits.getDMLStatements();
		dmlStatementsAllowed1 = dmlStatementsMax - dmlStatementsActual1;
        dmlStatementsUsed1 = dmlStatementsActual1 - dmlStatementsUsedBefore;
        dmlRowsActual1 = limits.getDmlRows();
		dmlRowsAllowed1 = dmlRowsMax - dmlRowsActual1;
        dmlRowsUsed1 = dmlRowsActual1 - dmlRowsUsedBefore; 

		// We do not need to invoke the tolling day trigger
				
		list<Investigation__c>recordsToProcess = new list<Investigation__c>([SELECT Id, Petition__r.Petition_Filed__c, Tolling_Update__c FROM Investigation__c WHERE Petition__r.Petition_Filed__c <= :tollingDateEnd  AND Investigation_Outcome__c = null AND Locked__c = false]);

        string initialState = '2';
        string queryObject = 'Investigation__c';
        string lastDate = string.valueOf(tollingDateEnd);
        system.debug('lastDate = ' + latestDate);

        //ID batchprocessid        
        Id bid;

        Test.startTest();

        // Start Batch Class

		// declare a new tolling day batch & set batch context 
		// this will also cause the checkLimits() and getNumToObject() methods to run
		AddTollingDayBatch atdb = new AddTollingDayBatch(initialState, queryObject, lastDate);
		
		// Call the start method in the batch class during the unit test
		Database.QueryLocator ql = atdb.start(null);
		
		// start the batch class during unit test
		atdb.execute(null, recordsToProcess);
		
		Savepoint sp = Database.setSavepoint();

		// call finish method without starting next job (bc = null)
		level = LoggingLevel.FINE;
		atdb.finish(null);
		
		// Before Rollback...
		
		system.debug('atdb.finish(null).bid = ' + atdb.bid );

		system.assertEquals(atdb.bid,'707000000000000AAA');

		//The next job will have been given a job Id which will have been queried for as 'bid1' in the batch

		system.debug('atdb.finish(null).bid1 = ' + atdb.bid1 );
		
		system.assertNotEquals(atdb.bid1,null);
				 
        dmlStatementsActual2 = limits.getDMLStatements();
        dmlStatementsAllowed2 = dmlStatementsMax - dmlStatementsActual2; 
        dmlRowsActual2 = limits.getDMLRows();
        dmlStatementsUsed2 = dmlStatementsActual2 - dmlStatementsUsedBefore;
        dmlRowsUsed2 = dmlRowsActual2 - dmlRowsUsedBefore; 

		// rollback transaction
		Database.rollback(sp);

        Test.stopTest();
		
		level = LoggingLevel.DEBUG;
        dmlStatementsActualAfter = limits.getDMLStatements();
        dmlStatementsAllowedAfter = dmlStatementsMax - dmlStatementsActualAfter; 
        dmlRowsActualAfter = limits.getDMLRows();
        dmlRowsAllowedAfter = dmlRowsMax - dmlRowsActualAfter; 
		dmlRowsUsed = dmlRowsActualAfter - dmlRowsUsedBefore;
		dmlStatementsUsed = dmlStatementsActualAfter - dmlStatementsUsedBefore; 
		// rollback counts as a statement
		        
		system.debug('dmlStatementsMax = '+ dmlStatementsMax);
		system.debug('dmlStatementsUsedBefore = '+ dmlStatementsUsedBefore);
		system.debug('dmlRowsMax = '+ dmlRowsMax);
		system.debug('dmlRowsUsedBefore = '+ dmlRowsUsedBefore);
		system.debug('dmlStatementsAllowedBefore = '+ dmlStatementsAllowedBefore);
		system.debug('dmlRowsAllowedBefore = '+ dmlRowsAllowedBefore);
		system.debug('dmlStatementsAllowed1 = ' + dmlStatementsAllowed1);
		system.debug('dmlRowsAllowed1 = ' + dmlRowsAllowed1);
		system.debug('dmlRowsActual1 = ' + dmlRowsActual1);
		system.debug('dmlStatementsUsed1 = ' + dmlStatementsUsed1);
		system.debug('dmlRowsUsed1 = ' + dmlRowsUsed1);
		system.debug('dmlStatementsActual2 = ' + dmlStatementsActual2);
		system.debug('dmlStatementsAllowed2 = ' + dmlStatementsAllowed2);
		system.debug('dmlRowsAllowed2 = ' + dmlRowsAllowed2);
		system.debug('dmlRowsActual2 = ' + dmlRowsActual2);
		system.debug('dmlStatementsUsed2 = ' + dmlStatementsUsed2);
		system.debug('dmlRowsUsed2 = ' + dmlRowsUsed2);
		system.debug('dmlStatementsActualAfter = '+ dmlStatementsActualAfter);		
		system.debug('dmlRowsActualAfter = '+ dmlRowsActualAfter);
		system.debug('dmlRowsAllowedAfter = '+ dmlRowsAllowedAfter);
		system.debug('dmlStatementsAllowedAfter = '+ dmlStatementsAllowedAfter);
		system.debug('dmlRowsUsed = '+ dmlRowsUsed);
		system.debug('dmlStatementsUsed = '+ dmlStatementsUsed); 

		// assert rows & statements used are what's expected
		system.assertEquals(dmlRowsActual1,4);
		system.assertEquals(dmlStatementsUsed1,3);
		system.assertEquals(dmlRowsActual2,1);
		system.assertEquals(dmlStatementsUsed2,0);
		system.assertEquals(dmlRowsUsed,3);
		system.assertEquals(dmlStatementsUsed,3);
		
		// because of rollback...
		system.assertEquals(false, iAD.Tolling_Update__c);
		
		//*** FINISHED CREATING FINAL ASSERTIONS ***//

    }

   static testMethod void testLitigationDates() {
        
        system.LoggingLevel level = LoggingLevel.INFO;    
        AppConfig__c app = insertAppConfig();
        integer emailMax = limits.getLimitEmailInvocations();
        integer emailActualBefore = limits.getEmailInvocations();
        integer emailAllowedBefore = emailMax - emailActualBefore;
        integer dmlStatementsMax = limits.getLimitDMLStatements();
        integer dmlStatementsUsedBefore = limits.getDMLStatements();
        integer dmlStatementsAllowedBefore = dmlStatementsMax - dmlStatementsUsedBefore;
        integer dmlRowsMax = limits.getLimitDmlRows();
        integer dmlRowsUsedBefore = limits.getDmlRows();
		integer dmlRowsAllowedBefore = dmlRowsMax - dmlRowsUsedBefore;		
        integer dmlStatementsActual1 = 0;
        integer dmlStatementsAllowed1 = 0; 
        integer dmlStatementsUsed1 = 0;
        integer dmlRowsActual1 = 0;
        integer dmlRowsAllowed1 = 0;
        integer dmlRowsUsed1 = 0;
        integer dmlStatementsUsed2 = 0;
        integer dmlStatementsActual2 = 0;
        integer dmlStatementsAllowed2 = 0;
        integer dmlRowsAllowed2 = 0; 
        integer dmlRowsActual2 = 0; 
		integer dmlRowsUsed2 = 0;
        integer dmlStatementsActualAfter = 0;
        integer dmlStatementsAllowedAfter = 0; 
		integer dmlStatementsUsed = 0; 
        integer dmlRowsActualAfter = 0;
        integer dmlRowsAllowedAfter = 0; 
		integer dmlRowsUsed = 0;
                
        //Set value for batch data
        intLit.Next_Due_to_DAS_Deadline__c = System.today();
        intLit.Next_Office_Deadline__c = System.today();
        intLit.Next_Announcement_Date__c = System.today();
        intLit.Schedule_Refresh__c = false; 
        intLit.Tolling_Update__c = false;

        update intLit;

		level = LoggingLevel.DEBUG;
        //Assert values updated correctly, and have not had the triggers run on them
        system.assertEquals(System.today(), intLit.Next_Due_to_DAS_Deadline__c);
        system.assertEquals(System.today(), intLit.Next_Office_Deadline__c);
        system.assertEquals(System.today(), intLit.Next_Announcement_Date__c);
		system.assertEquals(false, intLit.Tolling_Update__c);
        
        // Insert Tolling Date 
        Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
		dmlStatementsActual1 = limits.getDMLStatements();
		dmlStatementsAllowed1 = dmlStatementsMax - dmlStatementsActual1;
        dmlStatementsUsed1 = dmlStatementsActual1 - dmlStatementsUsedBefore;
        dmlRowsActual1 = limits.getDmlRows();
		dmlRowsAllowed1 = dmlRowsMax - dmlRowsActual1;
        dmlRowsUsed1 = dmlRowsActual1 - dmlRowsUsedBefore; 

		// We do not need to invoke the tolling day trigger
        
        list<Litigation__c>recordsToProcess = new list<Litigation__c>([SELECT Id, Tolling_Update__c, Locked__c FROM Litigation__c WHERE Actual_Final_Signature__c = null AND (Draft_Remand_Issues_Due_to_DAS__c <= :tollingDateEnd OR Request_Filed__c <= :tollingDateEnd ) AND Locked__c = false]);
		
        string initialState = '3';
        string queryObject = 'Litigation__c';
        string lastDate = string.valueOf(tollingDateEnd);
        system.debug('lastDate = ' + latestDate);
        //ID batchprocessid        
        Id bid;

        Test.startTest();

        // Start Batch Class

		// declare a new tolling day batch & set batch context 
		// this will also cause the checkLimits() and getNumToObject() methods to run
		AddTollingDayBatch atdb = new AddTollingDayBatch(initialState, queryObject, lastDate);
		
		// Call the start method in the batch class during the unit test
		Database.QueryLocator ql = atdb.start(null);
		
		// start the batch class during unit test
		atdb.execute(null, recordsToProcess);
		
		Savepoint sp = Database.setSavepoint();

		// call finish method without starting next job (bc = null)

		level = LoggingLevel.FINE;
		atdb.finish(null);
		
		// Before Rollback...
				
		system.debug('atdb.finish(null).bid = ' + atdb.bid );

		system.assertEquals(atdb.bid,'707000000000000AAA');

		//The next job will have been given a job Id which will have been queried for as 'bid1' in the batch

		system.debug('atdb.finish(null).bid1 = ' + atdb.bid1 );
		
		system.assertNotEquals(atdb.bid1,null);
				 
        dmlStatementsActual2 = limits.getDMLStatements();
        dmlStatementsAllowed2 = dmlStatementsMax - dmlStatementsActual2; 
        dmlRowsActual2 = limits.getDMLRows();
        dmlStatementsUsed2 = dmlStatementsActual2 - dmlStatementsUsedBefore;
        dmlRowsUsed2 = dmlRowsActual2 - dmlRowsUsedBefore; 

		// rollback transaction
       

        Test.stopTest();
		level = LoggingLevel.DEBUG;
        dmlStatementsActualAfter = limits.getDMLStatements();
        dmlStatementsAllowedAfter = dmlStatementsMax - dmlStatementsActualAfter; 
        dmlRowsActualAfter = limits.getDMLRows();
        dmlRowsAllowedAfter = dmlRowsMax - dmlRowsActualAfter; 
		dmlRowsUsed = dmlRowsActualAfter - dmlRowsUsedBefore;
		dmlStatementsUsed = dmlStatementsActualAfter - dmlStatementsUsedBefore; 
		        
		system.debug('dmlStatementsMax = '+ dmlStatementsMax);
		system.debug('dmlStatementsUsedBefore = '+ dmlStatementsUsedBefore);
		system.debug('dmlRowsMax = '+ dmlRowsMax);
		system.debug('dmlRowsUsedBefore = '+ dmlRowsUsedBefore);
		system.debug('dmlStatementsAllowedBefore = '+ dmlStatementsAllowedBefore);
		system.debug('dmlRowsAllowedBefore = '+ dmlRowsAllowedBefore);
		system.debug('dmlStatementsAllowed1 = ' + dmlStatementsAllowed1);
		system.debug('dmlRowsAllowed1 = ' + dmlRowsAllowed1);
		system.debug('dmlRowsActual1 = ' + dmlRowsActual1);
		system.debug('dmlStatementsUsed1 = ' + dmlStatementsUsed1);
		system.debug('dmlRowsUsed1 = ' + dmlRowsUsed1);
		system.debug('dmlStatementsActual2 = ' + dmlStatementsActual2);
		system.debug('dmlStatementsAllowed2 = ' + dmlStatementsAllowed2);
		system.debug('dmlRowsAllowed2 = ' + dmlRowsAllowed2);
		system.debug('dmlRowsActual2 = ' + dmlRowsActual2);
		system.debug('dmlStatementsUsed2 = ' + dmlStatementsUsed2);
		system.debug('dmlRowsUsed2 = ' + dmlRowsUsed2);
		system.debug('dmlStatementsActualAfter = '+ dmlStatementsActualAfter);		
		system.debug('dmlRowsActualAfter = '+ dmlRowsActualAfter);
		system.debug('dmlRowsAllowedAfter = '+ dmlRowsAllowedAfter);
		system.debug('dmlStatementsAllowedAfter = '+ dmlStatementsAllowedAfter);
		system.debug('dmlRowsUsed = '+ dmlRowsUsed);
		system.debug('dmlStatementsUsed = '+ dmlStatementsUsed); 

		// assert rows & statements used are what's expected		
		system.assertEquals(dmlRowsActual1,4);
		system.assertEquals(dmlStatementsUsed1,3);
		system.assertEquals(dmlRowsActual2,1);
		system.assertEquals(dmlStatementsUsed2,0);
		system.assertEquals(dmlRowsUsed,3);
		system.assertEquals(dmlStatementsUsed,3);
		
		// because of rollback...
		system.assertEquals(false, intLit.Tolling_Update__c);

		//*** FINISHED CREATING FINAL ASSERTIONS ***//

    }

    static testMethod void testSegmentDates() {
        
        system.LoggingLevel level = LoggingLevel.INFO;    
        AppConfig__c app = insertAppConfig();
        integer emailMax = limits.getLimitEmailInvocations();
        integer emailActualBefore = limits.getEmailInvocations();
        integer emailAllowedBefore = emailMax - emailActualBefore;
        integer dmlStatementsMax = limits.getLimitDMLStatements();
        integer dmlStatementsUsedBefore = limits.getDMLStatements();
        integer dmlStatementsAllowedBefore = dmlStatementsMax - dmlStatementsUsedBefore;
        integer dmlRowsMax = limits.getLimitDmlRows();
        integer dmlRowsUsedBefore = limits.getDmlRows();
		integer dmlRowsAllowedBefore = dmlRowsMax - dmlRowsUsedBefore;		
        integer dmlStatementsActual1 = 0;
        integer dmlStatementsAllowed1 = 0; 
        integer dmlStatementsUsed1 = 0;
        integer dmlRowsActual1 = 0;
        integer dmlRowsAllowed1 = 0;
        integer dmlRowsUsed1 = 0;
        integer dmlStatementsUsed2 = 0;
        integer dmlStatementsActual2 = 0;
        integer dmlStatementsAllowed2 = 0;
        integer dmlRowsAllowed2 = 0; 
        integer dmlRowsActual2 = 0; 
		integer dmlRowsUsed2 = 0;
        integer dmlStatementsActualAfter = 0;
        integer dmlStatementsAllowedAfter = 0; 
		integer dmlStatementsUsed = 0; 
        integer dmlRowsActualAfter = 0;
        integer dmlRowsAllowedAfter = 0; 
		integer dmlRowsUsed = 0;
                
        //Set value for batch data
        adminSeg.Next_Due_to_DAS_Deadline__c = System.today();
        adminSeg.Next_Office_Deadline__c = System.today();
        adminSeg.Next_Announcement_Date__c = System.today();
        adminSeg.Schedule_Refresh__c = false; 
        adminSeg.Tolling_Update__c = false;

        update adminSeg;

		level = LoggingLevel.DEBUG;
        //Assert values updated correctly, and have not had the triggers run on them
        system.assertEquals(System.today(), adminSeg.Next_Due_to_DAS_Deadline__c);
        system.assertEquals(System.today(), adminSeg.Next_Office_Deadline__c);
        system.assertEquals(System.today(), adminSeg.Next_Announcement_Date__c);
		system.assertEquals(false, adminSeg.Tolling_Update__c);
        
        // Insert Tolling Date 
        Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
		dmlStatementsActual1 = limits.getDMLStatements();
		dmlStatementsAllowed1 = dmlStatementsMax - dmlStatementsActual1;
        dmlStatementsUsed1 = dmlStatementsActual1 - dmlStatementsUsedBefore;
        dmlRowsActual1 = limits.getDmlRows();
		dmlRowsAllowed1 = dmlRowsMax - dmlRowsActual1;
        dmlRowsUsed1 = dmlRowsActual1 - dmlRowsUsedBefore; 

		// We do not need to invoke the tolling day trigger
		
		list<Segment__c>recordsToProcess = new list<Segment__c>([SELECT Id, Tolling_Update__c, Locked__c FROM Segment__c WHERE Segment_Outcome__c = null AND (Application_Accepted__c <= :tollingDateEnd OR Final_Date_of_Anniversary_Month__c <= :tollingDateEnd OR Final_Date_of_Anniversary_Month__c <= :tollingDateEnd OR Request_Filed__c <= :tollingDateEnd OR Calculated_Initiation_Signature__c <= :tollingDateEnd OR Initiation_Issues_Due_to_DAS__c <= :tollingDateEnd OR Prelim_Team_Meeting_Deadline__c <= :tollingDateEnd OR Final_Team_Meeting_Deadline__c <= :tollingDateEnd ) AND Locked__c = false]);

        string initialState = '4';
        string queryObject = 'Segment__c';
        string lastDate = string.valueOf(tollingDateEnd);
        system.debug('lastDate = ' + latestDate);

        //ID batchprocessid        
        Id bid;
		
        Test.startTest();

        // Start Batch Class

		// declare a new tolling day batch & set batch context 
		// this will also cause the checkLimits() and getNumToObject() methods to run
		AddTollingDayBatch atdb = new AddTollingDayBatch(initialState, queryObject, lastDate);
		
		// Call the start method in the batch class during the unit test
		Database.QueryLocator ql = atdb.start(null);
		
		// start the batch class during unit test
		atdb.execute(null, recordsToProcess);
		
		Savepoint sp = Database.setSavepoint();

		// call finish method without starting next job (bc = null)
		level = LoggingLevel.FINE;
		atdb.finish(null);
		
		// Before Rollback...
		
		system.debug('atdb.finish(null).bid = ' + atdb.bid );

		system.assertEquals(atdb.bid,'707000000000000AAA');

		//This is final batch, there will not be a next job. Job Id for 'bid1' will be null
		
		system.assertEquals(atdb.bid1,null);
				 
        dmlStatementsActual2 = limits.getDMLStatements();
        dmlStatementsAllowed2 = dmlStatementsMax - dmlStatementsActual2; 
        dmlRowsActual2 = limits.getDMLRows();
        dmlStatementsUsed2 = dmlStatementsActual2 - dmlStatementsUsedBefore;
        dmlRowsUsed2 = dmlRowsActual2 - dmlRowsUsedBefore; 

		// rollback transaction
		Database.rollback(sp);

        Test.stopTest();
		level = LoggingLevel.FINE;
		
        dmlStatementsActualAfter = limits.getDMLStatements();
        dmlStatementsAllowedAfter = dmlStatementsMax - dmlStatementsActualAfter; 
        dmlRowsActualAfter = limits.getDMLRows();
        dmlRowsAllowedAfter = dmlRowsMax - dmlRowsActualAfter; 
		dmlRowsUsed = dmlRowsActualAfter - dmlRowsUsedBefore;
		dmlStatementsUsed = dmlStatementsActualAfter - dmlStatementsUsedBefore; 
		        
		system.debug('dmlStatementsMax = '+ dmlStatementsMax);
		system.debug('dmlStatementsUsedBefore = '+ dmlStatementsUsedBefore);
		system.debug('dmlRowsMax = '+ dmlRowsMax);
		system.debug('dmlRowsUsedBefore = '+ dmlRowsUsedBefore);
		system.debug('dmlStatementsAllowedBefore = '+ dmlStatementsAllowedBefore);
		system.debug('dmlRowsAllowedBefore = '+ dmlRowsAllowedBefore);
		system.debug('dmlStatementsAllowed1 = ' + dmlStatementsAllowed1);
		system.debug('dmlRowsAllowed1 = ' + dmlRowsAllowed1);
		system.debug('dmlRowsActual1 = ' + dmlRowsActual1);
		system.debug('dmlStatementsUsed1 = ' + dmlStatementsUsed1);
		system.debug('dmlRowsUsed1 = ' + dmlRowsUsed1);
		system.debug('dmlStatementsActual2 = ' + dmlStatementsActual2);
		system.debug('dmlStatementsAllowed2 = ' + dmlStatementsAllowed2);
		system.debug('dmlRowsAllowed2 = ' + dmlRowsAllowed2);
		system.debug('dmlRowsActual2 = ' + dmlRowsActual2);
		system.debug('dmlStatementsUsed2 = ' + dmlStatementsUsed2);
		system.debug('dmlRowsUsed2 = ' + dmlRowsUsed2);
		system.debug('dmlStatementsActualAfter = '+ dmlStatementsActualAfter);		
		system.debug('dmlRowsActualAfter = '+ dmlRowsActualAfter);
		system.debug('dmlRowsAllowedAfter = '+ dmlRowsAllowedAfter);
		system.debug('dmlStatementsAllowedAfter = '+ dmlStatementsAllowedAfter);
		system.debug('dmlRowsUsed = '+ dmlRowsUsed);
		system.debug('dmlStatementsUsed = '+ dmlStatementsUsed); 

		// assert rows & statements used are what's expected
		system.assertEquals(dmlRowsActual1,4);
		system.assertEquals(dmlStatementsUsed1,3);
		system.assertEquals(dmlRowsActual2,2);
		system.assertEquals(dmlStatementsUsed2,1);
		system.assertEquals(dmlRowsUsed,3);
		system.assertEquals(dmlStatementsUsed,3);
		
		// because of rollback...
		system.assertEquals(false, adminSeg.Tolling_Update__c);
				
		//*** FINISHED CREATING FINAL ASSERTIONS ***//

    }

     
    @testSetup static void dataSetup() {
        Test.startTest();

        Map<String,Segment__c> segsToInsert = new Map<string,Segment__c>();
        integer emailMax = limits.getLimitEmailInvocations();
        integer emailActualBefore = limits.getEmailInvocations();
        integer emailAllowedBefore = emailMax - emailActualBefore;
        integer dmlStatementsMax = limits.getLimitDMLStatements();
        integer dmlStatementsUsedBefore = limits.getDMLStatements();
        integer dmlStatementsAllowedBefore = dmlStatementsMax - dmlStatementsUsedBefore;
        integer dmlRowsMax = limits.getLimitDmlRows();
        integer dmlRowsUsedBefore = limits.getDmlRows();
		integer dmlRowsAllowedBefore = dmlRowsMax - dmlRowsUsedBefore;		
        integer dmlStatementsActual1 = 0;
        integer dmlStatementsAllowed1 = 0; 
        integer dmlStatementsUsed1 = 0;
        integer dmlRowsActual1 = 0;
        integer dmlRowsAllowed1 = 0;
        integer dmlRowsUsed1 = 0;
        integer dmlStatementsUsed2 = 0;
        integer dmlStatementsActual2 = 0;
        integer dmlStatementsAllowed2 = 0;
        integer dmlRowsAllowed2 = 0; 
        integer dmlRowsActual2 = 0; 
		integer dmlRowsUsed2 = 0;
        integer dmlStatementsActualAfter = 0;
        integer dmlStatementsAllowedAfter = 0; 
		integer dmlStatementsUsed = 0; 
        integer dmlRowsActualAfter = 0;
        integer dmlRowsAllowedAfter = 0; 
		integer dmlRowsUsed = 0;        
        
        List<Litigation__c> litToInsert = new List<Litigation__c>();

        User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        Petition__c testADPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
        Petition__c testCVDPetition = TestUtils.createPetition(petitionDate, 'CVD', true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testADPetition, true);
        Federal_Register__c testAdPrelimFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(210), 'Preliminary', true);
        Investigation__c testCVDinvestigation = TestUtils.createInvestigation('CVD', testCVDPetition, true);
        Federal_Register__c testCvdPrelimFR = TestUtils.createFR(testCVDinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(140), 'Preliminary', true);
        ADCVD_Order__c testAdOrder = TestUtils.createOrder(testADinvestigation, true);
        ADCVD_Order__c testCvdOrder = TestUtils.createOrder(testCVDinvestigation, true);
        System.runAs(testUser) {
            for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
                Segment__c testSeg = TestUtils.createSegment(testAdOrder, segRecordTypeName, false);
                segsToInsert.put(segRecordTypeName, testSeg);
            }
            insert segsToInsert.values();
            for(String litRecordTypeName : utils.getRecordTypeDeveloperNameMap('Litigation__c').values()) {
                Litigation__c testLit = TestUtils.createLitigation(segsToInsert.get('Administrative_Review').Id, 'Segment__c', litigationDate, litRecordTypeName, false);
                litToInsert.add(testLit);
            }
            insert litToInsert;
        }
        setStartDates();
        Federal_Register__c testSsrInitiationFR = TestUtils.createFR(ssSeg.Id, 'Segment__c', testPublishedDate, 'Initiation', true);
        AppConfig__c a = new AppConfig__c(Name = 'default');
        insert a;
    }

    /*******************
    * Helper Methods
    *******************/

    private static void setStartDates() {
        List<Segment__c> segsToUpdate = new List<Segment__c>();
        //ACR
        acSeg.Application_Accepted__c = segmentDate;
        segsToUpdate.add(acSeg);
        //Administrative Review
        adminSeg.Final_Date_of_Anniversary_Month__c = segmentDate;
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(adminSeg);
        //CCR
        ccSeg.Request_Filed__c = segmentDate;
        segsToUpdate.add(ccSeg);
        //Expedited Review
        expedSeg.Calculated_Initiation_Signature__c = segmentDate;
        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(expedSeg);
        //New Shipper Review
        nsSeg.Calculated_Initiation_Signature__c = segmentDate;
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(nsSeg);
        //SI
        siSeg.Request_Filed__c = segmentDate;
        siSeg.Actual_Date_of_Decision_on_HoP__c = segmentDate.addDays(21);
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Type_of_Scope_Ruling__c = 'K (1)';
        segsToUpdate.add(siSeg);

        update segsToUpdate;
    }

    
}