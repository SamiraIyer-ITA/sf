/**
 * 
 *    Created by Joshua Moody
 *    on Feb 23 2017
 *    MIL Corporation
 * 
 **/
public without sharing class SegmentTriggerHandler {
 	/***********************************************************
   * This class handles all trigger contexts for the Segment__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Call services classes to do date calculations
   * 5. Retrieve constant values saved in custom metadata
   * 6. Performs status calculations
   * 7. Performs custom validations not possible with validation rules
   * 8. Calls service classes to create Staffing Assignments and Chatter Posts
   ***********************************************************/

	@TestVisible private static Set<String> activeSegmentStatuses = new Set<String>();
	private static Map<String,Constant__mdt> segmentCalcOffsets = segmentCalcOffsets();
	//FINAL Segment Record Types
	private static FINAL String ADMIN_REVIEW							= segmentCalcOffsets.get('Admin_Review_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String ANTI_CIRCUMVENTION_REVIEW				= segmentCalcOffsets.get('Anti_Circ_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String CHANGED_CIRCUMSTANCES_REVIEW			= segmentCalcOffsets.get('Changed_Circ_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String EXPEDITED_REVIEW						= segmentCalcOffsets.get('Exped_Review_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String NEW_SHIPPER_REVIEW						= segmentCalcOffsets.get('New_Shipper_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String SCOPE_INQUIRY							= segmentCalcOffsets.get('Scope_Inq_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String SUNSET_REVIEW							= segmentCalcOffsets.get('SS_Rev_Notice_Intent_Participate').ADCVD_Objects__r.Record_Type_Name__c;

	public static void mainEntry(List<Segment__c> newList, List<Segment__c> oldList, Map<Id, Segment__c> newMap, 
		Map<Id, Segment__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
		Boolean isBefore, Boolean isAfter) {
		
		if (!AppConfigService.triggerEnabled) {return;}

		if (isBefore && isInsert) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			initialize(newList, newMap);
			setCaseValues(newList);
			syncToAdcvdOrder(newList, isInsert);
			syncToAdministrativeReview(newList);
			calculateSegmentDates(newList);
			calculateSegmentStatuses(newList);
			runValidations(newList);
		}
		if (isBefore && isUpdate) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			initialize(newList, newMap);
			syncToAdministrativeReview(newList);
			calculateSegmentDates(newList);
			calculateSegmentStatuses(newList);
			runValidations(newList);
		}
		if (isBefore && isDelete) {
			recalculateOrdersOnSegmentDelete(oldMap);
		}
		if(isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
			Map<Id, Segment__c> noLockedRecordsMap = new Map<Id, Segment__c>(newList);
			recalculateOrders(noLockedRecordsMap, oldMap);
            initialize(newList, newMap);
            createStaffing(newList);
			recalculateOrders(newMap, oldMap);
		}
		if (isAfter && isUpdate) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			Map<Id, Segment__c> noLockedRecordsMap = new Map<Id, Segment__c>(newList);
			recalculateNewShipperReviews(newMap);
			recalculateOrders(noLockedRecordsMap, oldMap);
			new ChatterPostWriter('Segment__c', newMap, oldMap);
		}
	}

	/****************************************
	* Class Level Variables
	****************************************/

	@TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
	@TestVisible private static Map<Id,ADCVD_Order__c> ordersInScopeMap = new Map<Id,ADCVD_Order__c>();
	@TestVisible private static Map<Id,Suspension_Agreement__c> suspAgrmntsInScopeMap = new Map<Id,Suspension_Agreement__c>();
    @TestVisible private static FederalRegisterMapper frMapper;
    @TestVisible private static Map<Id, FederalRegisterMapper.MappedFRs> frUtilMap = new Map<Id, FederalRegisterMapper.MappedFRs>();
    @TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
    @TestVisible private static SegmentMapper segMapper;
    @TestVisible private static String ssrType = '';
	@TestVisible private static Map<Id,List<Litigation__c>> segmentIdToLitigationMap = new Map<Id,List<Litigation__c>>();
	@TestVisible private static Map<Id,String> segmentIdToLitigationStatusMap = new Map<Id,String>();


	/*****************************************
	* Methods called directly by mainEntry()
	*****************************************/

	//Setup Methods used to set class level variables
	@TestVisible private static void initialize(List<Segment__c> newList, Map<Id,Segment__c> newMap) {
		Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = caseMapper.getInstance(caseIdSet);
        recordTypeNameMap = Utils.getRecordTypeDeveloperNameMap('Segment__c');
        ADCVD_OrderMapper aos = (ADCVD_OrderMapper) caseMapper.getMapper('ADCVD_Order__c').getInstance();
        ordersInScopeMap = (Map<Id,ADCVD_Order__c>) caseMapper.getMapper('ADCVD_Order__c').getInstance().getMap(true);
        Suspension_AgreementMapper sas = (Suspension_AgreementMapper) caseMapper.getMapper('Suspension_Agreement__c').getInstance();
        suspAgrmntsInScopeMap = (Map<Id,Suspension_Agreement__c>) caseMapper.getMapper('Suspension_Agreement__c').getInstance().getMap(true);

		if(newMap != null) {
			addNewSegmentToMappers(newMap);
            frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
            frUtilMap = frMapper.getMappedFRs(newMap.keySet(), caseMapper);
		}
	}

	@TestVisible private static Set<Id> getCaseIdSet (List<Segment__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> suspAgrmtIdSet = new Set<Id>();
        for (Segment__c s : newList) {
            orderIdSet.add(s.ADCVD_Order__c);
            suspAgrmtIdSet.add(s.Suspension_Agreement__c);
        }
        for (ADCVD_Order__c ao : [SELECT ADCVD_Case__c FROM ADCVD_Order__c WHERE Id IN: orderIdSet]) {
            caseIdSet.add(ao.ADCVD_Case__c);
        }
        for (Suspension_Agreement__c sa : [SELECT ADCVD_Case__c FROM Suspension_Agreement__c WHERE Id IN: suspAgrmtIdSet]) {
            caseIdSet.add(sa.ADCVD_Case__c);
        }
        return caseIdSet;
    }

	@TestVisible private static void setCaseValues(List<Segment__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Segment__c s : newList) {
        	if (ordersInScopeMap.containsKey(s.ADCVD_Order__c)) {
        		s = (Segment__c) pvs.setCaseValuesFromParent(ordersInScopeMap.get(s.ADCVD_Order__c), s);
        	} else if (suspAgrmntsInScopeMap.containsKey(s.Suspension_Agreement__c)) {
        		s = (Segment__c) pvs.setCaseValuesFromParent(suspAgrmntsInScopeMap.get(s.Suspension_Agreement__c), s);
        	}
        }
    }
    @TestVisible private static void addNewSegmentToMappers(Map<Id,Segment__c> newMap) {
        Map<Id,List<Segment__c>> caseToSegmentMap = new Map<Id,List<Segment__c>>();
        segMapper = (SegmentMapper) caseMapper.getMapper('Segment__c').getInstance();
        for (Segment__c s : newMap.values()) {
            segMapper.addSegmentToMap(s);
            List<Segment__c> tempList = caseToSegmentMap.get(s.ADCVD_Case__c) != null ?
                                                   caseToSegmentMap.get(s.ADCVD_Case__c) : new List<Segment__c>();
            tempList.add(s);
            caseToSegmentMap.put(s.ADCVD_Case__c, tempList);
        }
        for (Id caseId : caseToSegmentMap.keySet()) {
            caseMapper.setCaseIdToSegmentMap(caseId, caseToSegmentMap.get(caseId));
        }
    }

	//Syncs Order Fields to Segment only on insert
	@TestVisible private static void syncToAdcvdOrder(List<Segment__c> newList, Boolean isInsert) {
		if (isInsert && !newList.isEmpty()) SyncUtility.syncObject(newList, 'ADCVD_Order__c');
	}

	//Syncs New Shipper Reviews in scope to Administrative Reviews
    @TestVisible private static void syncToAdministrativeReview(List<Segment__c> newList) {
    	List<Segment__c> newShipperReviewsToSyncList = new List<Segment__c>();
    	for (Segment__c s : newList) {
    		if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW && s.Administrative_Review_Aligned_To__c != null) {
    			setNewShipperSyncLevel(s);
    			newShipperReviewsToSyncList.add(s);
    		}
		}
    		if (!newShipperReviewsToSyncList.isEmpty()) {
    			SyncUtility.syncObject(newShipperReviewsToSyncList, null, true);
            }
    	}

	@TestVisible private static void calculateSegmentDates(List<Segment__c> newList) {
		Map<String,List<Segment__c>> segmentListMap = new Map<String,List<Segment__c>>();
    	for (Segment__c s : newList) {
    		if (segmentListMap.get(recordTypeNameMap.get(s.RecordTypeId)) != null) {
    			segmentListMap.get(recordTypeNameMap.get(s.RecordTypeId)).add(s);
			} else {
				segmentListMap.put(recordTypeNameMap.get(s.RecordTypeId), new List<Segment__c>{s});
			}
    	}
        for (String recordTypeName : segmentListMap.keySet()) {
        	if (recordTypeName == 'Sunset_Review') { 
        		setSsrType(segmentListMap.get(recordTypeName));
        	}
        	DateCalculationService dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance(recordTypeName);
        	dcs.getCalculatedDates(segmentListMap.get(recordTypeName), 'Segment__c', recordTypeName);
        }
    }

	/**
	 * Primary method to call all status calculations.
	 * @param  newList List of Segments in scope
	 * @return		 void
	 */
	@TestVisible private static void calculateSegmentStatuses(List<Segment__c> newList) {
		setLitigationStatus(newList);
		setStatus(newList);
	}

	@TestVisible private static void runValidations(List<Segment__c> newList) {
    	for (Segment__c s : newList) {
    		validateRescissionOutcome(s);
    		//validateCompletedOutcome(s);
    	}
    }

	@TestVisible private static void recalculateOrders(Map<Id,Segment__c> newMap, Map<Id,Segment__c> oldMap) {
		Set<Id> orderIdSet = getOrderParentIds(newMap, oldMap);
		List<ADCVD_Order__c> ordersToUpdate = new List<ADCVD_Order__c>();
		System.debug('ordersToUpdate : ' + ordersToUpdate);
		for (ADCVD_Order__c o : [SELECT Id FROM ADCVD_Order__c WHERE Id IN: orderIdSet AND Locked__c =: false]) {
			ordersToUpdate.add(o);
		}
		if (!ordersToUpdate.isEmpty())  update ordersToUpdate;
	}

	@TestVisible private static void recalculateOrdersOnSegmentDelete(Map<Id,Segment__c> oldMap) {
		List<Segment__c> segmentsToDelete = new List<Segment__c>();
		for (Segment__c s : [SELECT Id, Segment_Outcome__c, Do_Delete__c FROM Segment__c WHERE Id IN: oldMap.keySet() AND Locked__c =: false]) {
			s.Do_Delete__c = true;
			segmentsToDelete.add(s);
		}
		if (!segmentsToDelete.isEmpty())  update segmentsToDelete;
	}

	//updates a list of New Shipper Reviews if they are aligned to a Administrative Review in scope that was updated
    @TestVisible private static void recalculateNewShipperReviews(Map<Id,Segment__c> newMap) {
        List<Segment__c> newShipperReviewsToSyncList = [SELECT Id FROM Segment__c WHERE Administrative_Review_Aligned_To__c IN: newMap.keySet() AND Locked__c =: false];
        update newShipperReviewsToSyncList;
    }


	/***********************************
	* Helper Methods
	***********************************/

	//Called from mainEntry->calculateSegmentDates for lists
	@TestVisible private static void setSsrType(List<Segment__c> newList) {
		for (Segment__c s : newList) {
			setSsrType(s);
		}
	}

	//called from bulk and for status updates
	@TestVisible private static void setSsrType(Segment__c s) {
		if ((s.Notice_of_intent_to_participate_Ips__c == 'No' || s.Domestic_Party_File_Substan_Response__c == 'No')  
				&& s.Review_to_address_zeroing_in_Segments__c != 'Yes') {
			ssrType = '90';
		} else if (s.Notice_of_intent_to_participate_Ips__c == 'Yes' && s.Domestic_Party_File_Substan_Response__c == 'Yes' 
				&& s.Respondent_File_Substantive_Response__c != 'Yes' && s.Review_to_address_zeroing_in_Segments__c != 'Yes') {
			ssrType = '120';
		} else if ((s.Notice_of_intent_to_participate_Ips__c == 'Yes' && s.Domestic_Party_File_Substan_Response__c == 'Yes'
				&& s.Respondent_File_Substantive_Response__c == 'Yes') || s.Review_to_address_zeroing_in_Segments__c == 'Yes') {
			ssrType = '240';
		}
		if(ssrType == '120' || ssrType == '240') {
			if (s.Adequacy_of_Respondents_Submission__c =='Adequate or Substantive') {
				ssrType = '240';
			} else if(s.Adequacy_of_Respondents_Submission__c =='Inadequate or Non-Substantive' && s.Review_to_address_zeroing_in_Segments__c != 'Yes') {
				ssrType = '120';
			}
		}
		s.Sunset_Review_Type__c = ssrType;
	}

	//used to set Offset Variables
	@TestVisible private static Map<String,Constant__mdt> segmentCalcOffsets() {
		if(segmentCalcOffsets == null || segmentCalcOffsets.size() < 1) {
			Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
			for (Constant__mdt sc : [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, String_Value__c, 
													ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
											FROM Constant__mdt 
											WHERE Segment_Calculation_Offset__c =: true]) {
				if (sc.Used_with_Field_Named__c == 'Status__c' && sc.String_Value__c != null) {
                    activeSegmentStatuses.add(sc.String_Value__c);
                }
				returnMap.put(sc.QualifiedAPIName, sc);
			}
			return returnMap;
		} else {
			return segmentCalcOffsets;
		}
	}

	@TestVisible private static Set<Id> getOrderParentIds(Map<Id,Segment__c> newMap, Map<Id,Segment__c> oldMap) {
		Set<Id> returnIdSet = new Set<Id>();
		if (newMap != null) {
			for (Segment__c s : newMap.values()) {
				returnIdSet.add(s.ADCVD_Order__c);
			} 
		} else if (oldMap != null) {
			for (Segment__c s : oldMap.values()) {
				returnIdSet.add(s.ADCVD_Order__c);
			}
		}
		return returnIdSet;
	}

	/**
	 * Sets map of Segment Ids in scope to all of their Litigations.
	 * @param  petitionIdSet [description]
	 * @return			[description]
	 */
	@TestVisible private static void setSegmentIdToLitigationMap(Set<Id> segmentIdSet) {
		for (Litigation__c l : [SELECT Id, Segment__c, Status__c FROM Litigation__c WHERE Segment__c IN: segmentIdSet]) {
			List<Litigation__c> tempList = new List<Litigation__c>();
			if (segmentIdToLitigationMap.get(l.Segment__c) != null) {
				tempList = segmentIdToLitigationMap.get(l.Segment__c);
			}
			tempList.add(l);
			segmentIdToLitigationMap.put(l.Segment__c, tempList);
		}
	}

	@TestVisible private static void setSegmentIdToLitigationStatusMap() {
		if (segmentIdToLitigationMap != null && !segmentIdToLitigationMap.isEmpty()) {
			for (Id segmentId : segmentIdToLitigationMap.keySet()) {
				for (Litigation__c l : segmentIdToLitigationMap.get(segmentId)) {
					if (segmentIdToLitigationStatusMap.get(segmentId) == null || segmentIdToLitigationStatusMap.get(segmentId) != 'Active') {
						segmentIdToLitigationStatusMap.put(segmentId, l.Status__c);
					}
				}
			}
		}
	}

	@TestVisible private static void setNewShipperSyncLevel(Segment__c s) {
		if (s.Administrative_Review_Aligned_To__c != null) {
			if (s.New_Shipper_Sync_Level__c == null) {
				s.New_Shipper_Sync_Level__c = (s.Actual_Preliminary_Signature__c == null) ? 'Preliminary' : 'Final';
			}
		} else {
			s.New_Shipper_Sync_Level__c = '';
		}
	}


	/*****************************
	* Validations
	*****************************/

	@TestVisible private static void validateRescissionOutcome(Segment__c s) {
		if (s.Segment_Outcome__c != 'Full Rescission') {return;}
		Date rescissionPublished = null;
		if(s.Id != null && frUtilMap != null) {
			rescissionPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Rescission') : null;
		}
		if (rescissionPublished == null) {
			s.addError('You must enter a Rescission Federal Register to set Segment Outcome to "Full Rescission".');
		}
	}

	@TestVisible private static void validateCompletedOutcome(Segment__c s) {
		if (s.Segment_Outcome__c != 'Completed' || recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {return;}
		Date finalPublished = null;
		if(s.Id != null && frUtilMap != null) {
			finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Final') : null;
		}
		if (finalPublished == null || s.Actual_Final_Signature__c == null) {
			s.addError('You must enter a Final Federal Register and an Actual Final Signature to set Segment Outcome to "Completed".');
		}
	}


	/*****************************
	* Status Calculations
	*****************************/

	@TestVisible private static void setLitigationStatus(List<Segment__c> newList) {
		for (Segment__c s : newList) {
			if (s.Id != null && segmentIdToLitigationStatusMap.get(s.Id) != null && activeSegmentStatuses.contains(segmentIdToLitigationStatusMap.get(s.Id))) {
				s.Litigation_Status__c = 'Active';
			} else {
				s.Litigation_Status__c = 'Inactive';
			}
		}
	}

	@TestVisible private static void setStatus(List<Segment__c> newList) {
		for (Segment__c s : newList) {
			setSsrType(s);
			setHowToProceedStatus(s);
			setInitiationStatus(s);
			setPreliminaryStatus(s);
			setFinalStatus(s);
			setAmendedFinalStatus(s);
			setHoldStatus(s);
			setLitigationStatus(s);
			setCustomsInstructionsStatus(s);
			setClosedStatus(s);

		}
	}

	@TestVisible private static void setInitiationStatus(Segment__c s) {
		Date initPublished = null;
		if(s.Id != null && frUtilMap != null) {
			initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Initiation') : null;
		}
		if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW) {
			if (initPublished == null || s.Actual_Initiation_Signature__c == null) {
				s.Status__c = 'Initiation';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW) {
			if (initPublished == null || s.Actual_Initiation_Signature__c == null || s.All_parties_in_agreement_to_the_outcome__c == null) {
				s.Status__c = 'Initiation';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
			if (initPublished == null || ssrType == '') {
				s.Status__c = 'Initiation';
			}
		}
	}

	@TestVisible private static void setHowToProceedStatus(Segment__c s) {
		if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
			if (s.Decision_on_How_to_Proceed__c == null) {
				s.Status__c = 'How To Proceed';
			}
		}
	}

	@TestVisible private static void setPreliminaryStatus(Segment__c s) {
		Date prelimPublished = null;
		Date initPublished = null;
		if(s.Id != null && frUtilMap != null) {
			prelimPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Preliminary') : null;
			initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Initiation') : null;
		}
		if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {		   
			if ((prelimPublished == null || s.Actual_Preliminary_Signature__c == null) && s.Segment_Outcome__c == null) {
				s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW) {
			if ((prelimPublished == null || s.Actual_Preliminary_Signature__c == null) && s.Segment_Outcome__c == null) {
				s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
			if ((prelimPublished == null || s.Actual_Preliminary_Signature__c == null) && s.Segment_Outcome__c == null) {
				s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW) {
			if (s.Preliminary_Determination__c == 'Yes' 
				&& initPublished != null
				&& s.Actual_Initiation_Signature__c != null
				&& (prelimPublished == null || s.Actual_Preliminary_Signature__c == null)  
				&& s.Segment_Outcome__c == null) {
					s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW) {
			if (s.Type_of_Circumvention_Inquiry__c != null 
				&& s.Type_of_Circumvention_Inquiry__c != 'Later-Developed Merchandise' 
				&& s.Preliminary_Determination__c == 'Yes' 
				&& (s.Actual_Initiation_Signature__c != null && initPublished != null)
				&& (s.Actual_Preliminary_Signature__c == null || prelimPublished == null)
				&& s.Segment_Outcome__c == null) {
					s.Status__c = 'Prelim';
			} else if (s.Type_of_Circumvention_Inquiry__c == 'Later-Developed Merchandise' 
				&& (s.Actual_Initiation_Signature__c != null && initPublished != null)
				&& (s.Actual_Preliminary_Signature__c == null || prelimPublished == null)
			   	&& s.Segment_Outcome__c == null) {
					s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
			if (s.Decision_on_How_to_Proceed__c == 'Formal' && s.Preliminary_Determination__c != 'No' && s.Actual_Preliminary_Signature__c == null) {
				 s.Status__c = 'Prelim';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
			if (ssrType == '240') {
				if(s.Actual_Preliminary_Signature__c == null || prelimPublished == null) {
					s.Status__c = 'Prelim';
				}
			}
		}
	}

	@TestVisible private static void setFinalStatus(Segment__c s) {
		Date initPublished = null;
		Date prelimPublished = null;
		Date finalPublished = null;
		if (s.Id != null && frUtilMap != null) {
			initPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Initiation') : null;
			prelimPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Preliminary') : null;
			finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Final') : null;
		}
		if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW) {
			if (prelimPublished != null 
				&& s.Actual_Preliminary_Signature__c != null 
				&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW) {
			if (prelimPublished != null 
				&& s.Actual_Preliminary_Signature__c != null 
				&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW) {
			if (prelimPublished != null 
				&& s.Actual_Preliminary_Signature__c != null 
				&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == CHANGED_CIRCUMSTANCES_REVIEW) {
			if ((s.Preliminary_Determination__c != 'Yes')
				&& initPublished != null
				&& s.Actual_Initiation_Signature__c != null
				&& (finalPublished == null || s.Actual_Final_Signature__c == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			} else if ((s.Preliminary_Determination__c == 'Yes')
				&& initPublished != null
				&& s.Actual_Initiation_Signature__c != null
				&& prelimPublished != null
				&& s.Actual_Preliminary_Signature__c != null 
				&& (finalPublished == null || s.Actual_Final_Signature__c == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == ANTI_CIRCUMVENTION_REVIEW) {
			// if doing a prelim, require sig and fr to go to final
			if (s.Type_of_Circumvention_Inquiry__c != null
				&& s.Type_of_Circumvention_Inquiry__c != 'Later-Developed Merchandise' 
				&& (s.Preliminary_Determination__c == 'No' || (s.Preliminary_Determination__c == 'Yes' && s.Actual_Preliminary_Signature__c != null && prelimPublished != null))
				&& (s.Actual_Initiation_Signature__c != null && initPublished != null)
				&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			} else if (s.Type_of_Circumvention_Inquiry__c == 'Later-Developed Merchandise' 
				&& (s.Actual_Initiation_Signature__c != null && initPublished != null)
				&& (s.Actual_Preliminary_Signature__c != null && prelimPublished != null) 
				&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SCOPE_INQUIRY) {
			if (s.Decision_on_How_to_Proceed__c == 'Formal' 
				&& (s.Preliminary_Determination__c == 'No' || (s.Preliminary_Determination__c != 'No' && s.Actual_Preliminary_Signature__c != null))
				&& s.Actual_Final_Signature__c == null) {
					s.Status__c = 'Final';
			}
			if (s.Decision_on_How_to_Proceed__c == 'InFormal' 
				&& s.Actual_Final_Signature__c == null) {
					s.Status__c = 'Final';
			}
		} else if (recordTypeNameMap.get(s.RecordTypeId) == SUNSET_REVIEW) {
			if (ssrType == '90' || ssrType == '120') {
				if (initPublished != null 
					&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
				}
			} else if (ssrType == '240') {
				if (initPublished != null
					&& s.Actual_Preliminary_Signature__c != null 
					&& prelimPublished != null
					&& (s.Actual_Final_Signature__c == null || finalPublished == null || s.Segment_Outcome__c == null)) {
					s.Status__c = 'Final';
				}
			}
		}
	}

	@TestVisible private static void setAmendedFinalStatus(Segment__c s) {
		Date prelimPublished = null;
		Date finalPublished = null;
		if(s.Id != null && frUtilMap != null) {
			prelimPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Preliminary') : null;
			finalPublished = frUtilMap.get(s.Id) != null ? frUtilMap.get(s.Id).typeToPublishedDateMap.get('Final') : null;
		}
		if (recordTypeNameMap.get(s.RecordTypeId) == ADMIN_REVIEW
			|| recordTypeNameMap.get(s.RecordTypeId) == EXPEDITED_REVIEW
			|| (recordTypeNameMap.get(s.RecordTypeId) == NEW_SHIPPER_REVIEW)) {
			if (prelimPublished != null 
				&& finalPublished != null 
				&& s.Actual_Preliminary_Signature__c != null 
				&& s.Actual_Final_Signature__c != null 
				&& s.Will_you_Amend_the_Final__c == 'Yes'
				&& s.Actual_Amended_Final_Signature__c == null 
				&& (s.Segment_Outcome__c == null || s.Segment_Outcome__c == 'Completed')) {
					s.Status__c = 'Amend Final';
			}
		}
	}

	@TestVisible private static void setHoldStatus(Segment__c s) {
		if ((s.Will_you_Amend_the_Final__c != 'Yes' || s.Actual_Amended_Final_Signature__c != null)) {
			if (s.Litigation_Hold_Expiration_Date__c != null 
				&& s.Litigation_YesNo__c == null 
				&& s.Segment_Outcome__c != null) {
	            	s.Status__c = 'Hold';
	        }
	    }
	}

	@TestVisible private static void setLitigationStatus(Segment__c s) {
        if (s.Litigation_YesNo__c == 'Yes' && s.Litigation_Resolved__c == 'No' && s.Segment_Outcome__c != null) {
            s.Status__c = 'Litigation';
        }
    }

	 @TestVisible private static void setCustomsInstructionsStatus(Segment__c s) {
         if ((s.Litigation_YesNo__c == 'No' || (s.Litigation_YesNo__c == 'Yes' && s.Litigation_Resolved__c == 'Yes'))
           && s.Have_Custom_Instruction_been_sent__c != 'Yes' && s.Segment_Outcome__c != null) {
             s.Status__c = 'Customs';
         }
     }

	@TestVisible private static void setClosedStatus(Segment__c s) {
        if ((s.Litigation_YesNo__c == 'No' || (s.Litigation_YesNo__c == 'Yes' && s.Litigation_Resolved__c == 'Yes'))
            && s.Have_Custom_Instruction_been_sent__c == 'Yes' && s.Segment_Outcome__c != null) {
                s.Status__c = 'Closed';
        }
	}


    /*********************************************
    * Staffing Creation
    *********************************************/

    @TestVisible private static void createStaffing(List<Segment__c> newList) {
        List<Segment__c> segmentsFromOrders = new List<Segment__c>();
        List<Segment__c> segmentsFromSuspAgrmts = new List<Segment__c>();
        List<Staffing_Assignment__c> staffToInsert = new List<Staffing_Assignment__c>();
        for (Segment__c s : newList) {
            if (s.ADCVD_Order__c != null) {
                segmentsFromOrders.add(s);
            } else if (s.Suspension_Agreement__c != null) {
                segmentsFromSuspAgrmts.add(s);
            }
        }
        if (!segmentsFromOrders.isEmpty()) {
            staffToInsert.addAll(
                new StaffingAssignmentService().createStaffFromSObjectParent(segmentsFromOrders, 'Segment__c', false)
            );
        }
        if (!segmentsFromSuspAgrmts.isEmpty()) {
            staffToInsert.addAll(
                new StaffingAssignmentService().createStaffFromSObjectParent(segmentsFromSuspAgrmts, 'Segment__c', false)
            );
        }
        if (!staffToInsert.isEmpty()) {insert staffToInsert;}
    }

}