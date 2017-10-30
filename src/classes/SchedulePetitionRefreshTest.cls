/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 **/
 
@isTest
private class SchedulePetitionRefreshTest {

	private static Date petitionDate = System.today();
	private static Date testNextAnnouncmentDate = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testNextDueToDAS = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testNextOfficeDeadline = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testPublishedDate = System.today();
	private static Date segmentDate = System.today();
	private static Date litigationDate = System.today();

	private static AppConfig__c app {
		get{
			if(app == null){ 
				app = new AppConfig__c();
	 			app.Name = 'default';
				app.Primary_Admin__c = 'csmith@milcorp.com'; 
				app.ADCVD_Admin__c = 'calvin.smith@trade.gov';
				app.ADCVD_Developer__c = 'crmprogdev@gmail.com';
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
	
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			return u;
		}
	}
	private static List<Investigation__c> iList {
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
							Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Schedule_Refresh__c, Tolling_Update__c
						FROM Investigation__c];
			}
			return iList;
		}
	}
	private static Petition__c adP{
		get{
			if (adP == null) {
				adP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Next_Office_Deadline__c, Schedule_Refresh__c, Tolling_Update__c 
						FROM Petition__c WHERE ADCVD_Case_Type__c LIKE 'AD%' LIMIT 1];
			}
			return adP;
		}
	}
	private static Petition__c cvdP{
		get{
			if (cvdP == null) {
				cvdP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Next_Office_Deadline__c, Schedule_Refresh__c, Tolling_Update__c 
						FROM Petition__c WHERE ADCVD_Case_Type__c LIKE 'CVD%' LIMIT 1];
			}
			return cvdP;
		}
	}
	private static Investigation__c iAD {
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
	private static Investigation__c iCVD {
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
	private static Federal_Register__c adPrelimFR {
		get {
			if(adPrelimFR == null) {
				adPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'Preliminary' LIMIT 1];
			}
			return adPrelimFR;
		}
	}
	private static Federal_Register__c adPrelimItcFR {
		get {
			if(adPrelimItcFR == null) {
				adPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
			}
			return adPrelimItcFR;
		}
	}
	private static Federal_Register__c adFinalItcFR {
		get {
			if(adFinalItcFR == null) {
				adFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Final' LIMIT 1];
			}
			return adFinalItcFR;
		}
	}
	private static Federal_Register__c adOrderFR {
		get {
			if(adOrderFR == null) {
				adOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: adOrder.Id AND Type__c =: 'Order' LIMIT 1];
			}
			return adOrderFR;
		}
	}
	private static Federal_Register__c cvdPrelimFR {
		get {
			if(cvdPrelimFR == null) {
				cvdPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'Preliminary' LIMIT 1];
			}
			return cvdPrelimFR;
		}
	}
	private static Federal_Register__c cvdPrelimItcFR {
		get {
			if(cvdPrelimItcFR == null) {
				cvdPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
			}
			return cvdPrelimItcFR;
		}
	}
	private static Federal_Register__c cvdFinalItcFR {
		get {
			if(cvdFinalItcFR == null) {
				cvdFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Final' LIMIT 1];
			}
			return cvdFinalItcFR;
		}
	}
	private static Federal_Register__c cvdOrderFR {
		get {
			if(cvdOrderFR == null) {
				cvdOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: cvdOrder.Id AND Type__c =: 'Order' LIMIT 1];
			}
			return cvdOrderFR;
		}
	}
	private static ADCVD_Order__c adOrder{
		get{
			if (adOrder == null) {
				adOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iAD.Id LIMIT 1];
			}
			return adOrder;
		}
	}
	private static ADCVD_Order__c cvdOrder{
		get{
			if (cvdOrder == null) {
				cvdOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iCVD.Id LIMIT 1];
			}
			return cvdOrder;
		}
	}
	private static ADCVD_Order__c o{
		get{
			if (o == null) {
				o = [SELECT Id, Anniversary_Month__c FROM ADCVD_Order__c LIMIT 1];
			}
			return o;
		}
	}	
	private static Segment__c adminSeg{
		get{
			if (adminSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
				adminSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
									Calculated_Final_Signature__c, Actual_Final_Signature__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
									Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
									Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
									Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, Schedule_Refresh__c 
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return adminSeg;
		}
	}
	private static Segment__c nsSeg{
		get{
			if (nsSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('New_Shipper_Review');
				nsSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Calculated_Initiation_Signature__c, Final_Team_Meeting_Deadline__c, 
								Actual_Initiation_Signature__c, Calculated_Final_Signature__c, Actual_Preliminary_Signature__c, Actual_Final_Signature__c, 
								Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
								Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
								Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
								Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, Schedule_Refresh__c 
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return nsSeg;
		}
	}
	private static Segment__c siSeg{
		get{
			if (siSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Scope_Inquiry');
				siSeg = [SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c, Initiation_Extension_of_days__c, RecordTypeId, Request_Filed__c, 
								Prelim_Extension__c, Calculated_Preliminary_Signature__c, Actual_Date_of_Decision_on_HoP__c, Calculated_Final_Signature__c, 
								Decision_on_HOP_Issues_Due_to_DAS__c, Decision_on_HOP_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, 
								Prelim_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Prelim_Team_Meeting_Deadline__c, 
								Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Final_Team_Meeting_Deadline__c, 
								Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
								Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return siSeg;
		}
	}
	private static Segment__c expedSeg{
		get{
			if (expedSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Expedited_Review');
				expedSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
									Calculated_Final_Signature__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
									Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
									Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
									Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
									Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c, Schedule_Refresh__c 
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return expedSeg;
		}
	}
	private static Segment__c acSeg{
		get{
			if (acSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Anti_Circumvention_Review');
				acSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Initiation_Extension_of_days__c, Calculated_Preliminary_Signature__c, 
									Calculated_Final_Signature__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
									Application_Accepted__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
									Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
									Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
									Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
									Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c 
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return acSeg;
		}
	}
	private static Segment__c ccSeg{
		get{
			if (ccSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Changed_Circumstances_Review');
				ccSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Is_This_Review_Expedited__c,
									Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
									All_parties_in_agreement_to_the_outcome__c, Request_Filed__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
									Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
									Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
									Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
									Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return ccSeg;
		}
	}
	private static Segment__c ssSeg{
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
							Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Schedule_Refresh__c 
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return ssSeg;
		}
	}

	private static Litigation__c intLit{
		get{
			if (intLit == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('International_Litigation');
				intLit = [SELECT Id, RecordTypeId, Request_Filed__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
								Calculated_Final_Signature__c, Prelim_Extension_of_days__c, Status__c, Final_Extension_of_days__c, 
								Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
								Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
								Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Schedule_Refresh__c 
								FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return intLit;
		}
	}
	private static Litigation__c remand{
		get{
			if (remand == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('Remand');
				remand = [SELECT Id, RecordTypeId, Final_Extension_of_days__c, Expected_Final_Signature_Before_Ext__c, Calculated_Amended_Final_Signature__c,
								Calculated_Draft_Remand_release_to_party__c, Calculated_Final_Signature__c, Court_of_Panel_s_Ruling__c, Status__c, 
								Draft_Remand_Concurrence_Due_to_DAS__c, Draft_Remand_Issues_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
								Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
								Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Schedule_Refresh__c 
							FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return remand;
		}
	}



    static testMethod void testPetitionDates() {
 
 
     	String CRON_EXP = app.ChronExpr_PetitionInvestigation__c;
		ScheduledDispatcher spr = new ScheduledDispatcher();
    	
    	system.debug('CRON_EXP = ' + CRON_EXP);	
 
        Test.startTest();

   		String CronTriggerID = system.schedule('Dispatch', CRON_EXP, spr);
		
   		CronTrigger ctx = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
            	FROM CronTrigger WHERE Id =: CronTriggerID ];

        // Verify the job has not run
   	    System.assertEquals(0, ctx.TimesTriggered);
   	    //System.debug('ctx.TimesTriggered = ' + ctx.TimesTriggered);
    		
		// verifiy the job is scheduled
   		Integer c1 = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
   		system.assertEquals(c1, 1);
		//system.debug('c1 = ' + c1);

        //Capture current values from trigger for comparison in final assert
        testNextDueToDAS = adP.Next_Due_to_DAS_Deadline__c;
        testNextOfficeDeadline = adP.Next_Office_Deadline__c;
        testNextAnnouncmentDate = adP.Next_Announcement_Date__c;

        //Set value for scheduleable query
        adP.Next_Due_to_DAS_Deadline__c = System.today().addDays(-1);
        adP.Next_Office_Deadline__c = System.today().addDays(-1);
        adP.Next_Announcement_Date__c = System.today().addDays(-1);
		adP.Schedule_Refresh__c = false;
		adP.Tolling_Update__c = false;
		
        update adP;

        //Assert values updated correctly, and have not had the triggers run on them
        System.assertEquals(System.today().addDays(-1), adP.Next_Due_to_DAS_Deadline__c);
		System.assertEquals(System.today().addDays(-1), adP.Next_Office_Deadline__c);
		System.assertEquals(System.today().addDays(-1), adP.Next_Announcement_Date__c);
		System.assertEquals(false, adP.Schedule_Refresh__c);
		System.assertEquals(false, adP.Tolling_Update__c);
		
		//Turn on triggers
		app.TriggersEnabled__c = true;
		update app;
        
		Test.stopTest();
		// Call scheduable class - executes on test.stopTest()

		// Query chron trigger to confirm that job has run 
		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, State, StartTime, EndTime, PreviousFireTime
            	FROM CronTrigger WHERE Id =: CronTriggerID ];
		        
		//system.assertEquals(ct.TimesTriggered, 1);
		system.debug('ct.TimesTriggered = '+ ct.TimesTriggered);

		//System.assertEquals(true, adP.Schedule_Refresh__c);
		System.debug('adP.Schedule_Refresh__c = ' + adP.Schedule_Refresh__c);
        
		// assert follow up class is scheduled to run in 30 minutes
		
   		CronTrigger ct1 = [SELECT Id, CronJobDetail.Name, State, NextFireTime
            	FROM CronTrigger WHERE CronJobDetail.Name= 'DispatchFollower'  ];
		
		system.assert((ct1.NextFireTime.minute() - system.now().minute()) <= 30 );
		

    }

    static testMethod void testInvestigationDates() {
        String CRON_EXP = app.ChronExpr_PetitionInvestigation__c;
		ScheduledDispatcher spr = new ScheduledDispatcher();
    	
    	system.debug('CRON_EXP = ' + CRON_EXP);
    		
        Test.startTest();
		// schedule the job to run
   		String CronTriggerID = system.schedule('Dispatch', CRON_EXP, spr);
		
		// query chron trigger
   		CronTrigger ctx = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
            	FROM CronTrigger WHERE Id =: CronTriggerID ];

        // Verify the job has not run
   	    //System.debug('ctx.TimesTriggered = ' + ctx.TimesTriggered);
   	    System.assertEquals(0, ctx.TimesTriggered);
    		
		// verifiy the job is scheduled
   		Integer c1 = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];

		//system.debug('c1 = ' + c1);
   		system.assertEquals(c1, 1);
        
        //Capture current values from trigger for comparison in final assert
        testNextDueToDAS = iAD.Next_Due_to_DAS_Deadline__c;
        testNextOfficeDeadline = iAD.Next_Office_Deadline__c;
        testNextAnnouncmentDate = iAD.Next_Announcement_Date__c;

        //Set value for scheduleable query
        iAD.Next_Due_to_DAS_Deadline__c = System.today().addDays(-1);
        iAD.Next_Office_Deadline__c = System.today().addDays(-1);
        iAD.Next_Announcement_Date__c = System.today().addDays(-1);
		iAD.Schedule_Refresh__c = false;
		iAD.Tolling_Update__c = false;

        update iAD;

        //Assert values updated correctly, and have not had the triggers run on them
        System.assertEquals(System.today().addDays(-1), iAD.Next_Due_to_DAS_Deadline__c);
		System.assertEquals(System.today().addDays(-1), iAD.Next_Office_Deadline__c);
		System.assertEquals(System.today().addDays(-1), iAD.Next_Announcement_Date__c);
		System.assertEquals(false, iAD.Schedule_Refresh__c);
		System.assertEquals(false, iAD.Tolling_Update__c);

		//Turn on triggers
		app.TriggersEnabled__c = true;
		update app;
        
		Test.stopTest();
		// Call scheduable class - executes on test.stopTest()

		// Query chron trigger to confirm that job has run 		
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, State, StartTime, EndTime, PreviousFireTime
            	FROM CronTrigger WHERE Id =: CronTriggerID ];
        
		//system.assertEquals(ct.TimesTriggered, 1);
		system.debug('ct.TimesTriggered = '+ ct.TimesTriggered);

		//System.assertEquals(true, iAD.Schedule_Refresh__c);
        System.debug('iAD.Schedule_Refresh__c = ' + iAD.Schedule_Refresh__c);
		
		// assert follow up class is scheduled to run in 30 minutes
     	String cronExpr = app.ChronExp_LitigationSegement__c;
		DispatchScheduledFollower dsf = new DispatchScheduledFollower();
		
   		CronTrigger ct1 = [SELECT Id, CronJobDetail.Name, State, NextFireTime
            	FROM CronTrigger WHERE CronJobDetail.Name= 'DispatchFollower'  ];
		
		system.assert((ct1.NextFireTime.minute() - system.now().minute()) <= 30 );
		
		
    }

    
	@testSetup static void dataSetup() {
		Test.startTest();

		Map<String,Segment__c> segsToInsert = new Map<string,Segment__c>();
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