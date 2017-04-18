public without sharing class IssueTriggerHandler {

	private static Map<String,Constant__mdt> issueCalcOffsets = issueCalcOffsets();
	//FINAL Issue Parent Object Types
	private static FINAL String PETITION = 'Petition__c';
	private static FINAL String INVESTIGATION = 'Investigation__c';
	private static FINAL String SEGMENT = 'Segment__c';
	private static FINAL String LITIGATION = 'Litigation__c';

	//FINAL Issue Parent Object Record Types
	private static FINAL String ADMIN_REVIEW						= issueCalcOffsets.get('Admin_Review_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String ANTI_CIRCUMVENTION_REVIEW			= issueCalcOffsets.get('Anti_Circ_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String CHANGED_CIRCUMSTANCES_REVIEW		= issueCalcOffsets.get('Changed_Circ_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String EXPEDITED_REVIEW					= issueCalcOffsets.get('Exped_Review_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String NEW_SHIPPER_REVIEW					= issueCalcOffsets.get('New_Shipper_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String SCOPE_INQUIRY						= issueCalcOffsets.get('Scope_Inq_Calc_Prelim_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String SUNSET_REVIEW						= issueCalcOffsets.get('SS_Rev_Notice_Intent_Participate').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String INT_LITIGATION 						= issueCalcOffsets.get('Int_Lit_Calc_Initiation_Sig').ADCVD_Objects__r.Record_Type_Name__c;
    private static FINAL String REMAND 								= issueCalcOffsets.get('Remand_Calc_Draft_Remand_Release').ADCVD_Objects__r.Record_Type_Name__c;

    //FINAL Issue Types
    private static FINAL String TYPE_INITIATION 					= issueCalcOffsets.get('Issues_to_DAS_Initiation').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_PRELIMINARY 					= issueCalcOffsets.get('Issues_to_DAS_Preliminary').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_AMENDED_PRELIMINARY 			= issueCalcOffsets.get('Issues_to_DAS_Amended_Prelim').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_FINAL 							= issueCalcOffsets.get('Issues_to_DAS_Final').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_AMENDED_FINAL 					= issueCalcOffsets.get('Issues_to_DAS_Amended_Final').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_DEADLINE_FOR_HOP 				= issueCalcOffsets.get('Issues_to_DAS_Deadline_for_Dec_on_HOP').ADCVD_Objects__r.Type__c;
    private static FINAL String TYPE_CONT_OR_REVO 					= issueCalcOffsets.get('Concur_to_DAS_Cont_or_Revo').ADCVD_Objects__r.Type__c;

	//FINAL Issues To DAS Offsets
	private static FINAL Integer ISSUES_PETITION_INITIATION 		= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Petition_Initiation').Number_Value__c);//Calculated_Initiation_Signature__c
	private static FINAL Integer ISSUES_INITIATION 					= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Initiation').Number_Value__c);//Calculated_Initiation_Signature__c
	private static FINAL Integer ISSUES_PRELIMINARY 				= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Preliminary').Number_Value__c);//Calculated_Preliminary_Signature__c or Calculated_Draft_Remand_release_to_party__c
	private static FINAL Integer ISSUES_AMENDED_PRELIMINARY 		= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Amended_Prelim').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
	private static FINAL Integer ISSUES_FINAL 						= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Final').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer ISSUES_AMENDED_FINAL				= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Amended_Final').Number_Value__c);//Calculated_Amended_Final_Signature__c
	private static FINAL Integer ISSUES_DEADLINE_FOR_HOP 			= ((Integer)issueCalcOffsets.get('Issues_to_DAS_Deadline_for_Dec_on_HOP').Number_Value__c);//Deadline_for_Decision_on_how_to_proceed__c
	//FINAL Concurrence to DAS Offsets
	private static FINAL Integer CONCURRENCE_PETITION_INITIATION 	= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Petition_Initiation').Number_Value__c);//Calculated_Initiation_Signature__c
	private static FINAL Integer CONCURRENCE_INITIATION 			= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Initiation').Number_Value__c);//Calculated_Initiation_Signature__c
	private static FINAL Integer CONCURRENCE_PRELIMINARY 			= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Preliminary').Number_Value__c);//Calculated_Preliminary_Signature__c or Calculated_Draft_Remand_release_to_party__c
	private static FINAL Integer CONCURRENCE_AMENDED_PRELIMINARY 	= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Amended_Prelim').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
	private static FINAL Integer CONCURRENCE_FINAL 					= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Final').Number_Value__c);//Calculated_Final_Signature__c
	private static FINAL Integer CONCURRENCE_AMENDED_FINAL			= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Amended_Final').Number_Value__c);//Calculated_Amended_Final_Signature__c
	private static FINAL Integer CONCURRENCE_DEADLINE_FOR_HOP 		= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Deadline_for_Dec_on_HOP').Number_Value__c);//Deadline_for_Decision_on_how_to_proceed__c
	private static FINAL Integer CONCURRENCE_CONT_OR_REVO			= ((Integer)issueCalcOffsets.get('Concur_to_DAS_Cont_or_Revo').Number_Value__c);//Continuation_or_Revocation_FR_Notice_Pub__c


	public static boolean preventRecursion = false;
    public static void mainEntry(List<Issue__c> newList, List<Issue__c> oldList, Map<Id, Issue__c> newMap, 
        Map<Id, Issue__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isBefore && isInsert) {
            calculateIssueDates(newList);
        }
        if(isBefore && isUpdate) {
            calculateIssueDates(newList);
        }
        if(isAfter && isInsert) {

        }
        if(isAfter && isUpdate) {
            
        }
    }

    //Parent maps
    @TestVisible private static Map<Id,Petition__c> petitionParents = new Map<Id,Petition__c>();
    @TestVisible private static Map<Id,Investigation__c> investigationParents = new Map<Id,Investigation__c>();
    @TestVisible private static Map<Id,Segment__c> segmentParents = new Map<Id,Segment__c>();
    @TestVisible private static Map<Id,Litigation__c> litigationParents = new Map<Id,Litigation__c>();
    @TestVisible private static Map<Id,List<Issue__c>> parentIdToIssueMap = new Map<Id,List<Issue__c>>();
    @TestVisible private static Map<Id,String> parentIdToObjectTypeMap = new Map<Id,String>();
    @TestVisible private static Map<Id,String> parentIdToRecordTypeNameMap = new Map<Id,String>();

    @TestVisible private static void calculateIssueDates(List<Issue__c> newList) {
    	setParentMaps(newList);
    	if (parentIdToIssueMap == null) {return;}// if no parents, set nothing
		for (Id parentId : parentIdToIssueMap.keySet()) {//for each parent
			for (Issue__c i : parentIdToIssueMap.get(parentId)) {//iterate through the related issues
				if (i.Type__c != null) {//if type == null, skip issue
					//Only run each Issue through the method that matches it's type
					if (i.Type__c == TYPE_INITIATION) {
						setInitiationIssuesToDAS(parentId, i);
						setInitiationConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_PRELIMINARY) {
						setPreliminaryIssuesToDAS(parentId, i);
						setPreliminaryConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_AMENDED_PRELIMINARY) {
						setAmendedPreliminaryIssuesToDAS(parentId, i);
						setAmendedPreliminaryConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_FINAL) {
						setFinalIssuesToDAS(parentId, i);
						setFinalConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_AMENDED_FINAL) {
						setAmendedFinalIssuesToDAS(parentId, i);
						setAmendedFinalConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_DEADLINE_FOR_HOP) {
						setDeadlineForDecisionHOPIssuesToDAS(parentId, i);
						setDeadlineForDecisionHOPConcurrenceToDAS(parentId, i);
					} else if (i.Type__c == TYPE_CONT_OR_REVO) {
						setContinuationOrRevocationConcurrenceToDAS(parentId, i);
					}
				}   
			}
		}
	}

    //TODO: Load mdt into class as finals
    //TODO: Identify parent object type
    //TODO: Identify segment and litigation record types
    //TODO: Query parent for starting dates
    //TODO: Method for each type of Date, branching based on parent record
    //TODO: Set parent Next Deadline Date
  	//TODO: Set prevent recursion and update parents in after context
    

    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> issueCalcOffsets() {
        if(issueCalcOffsets == null || issueCalcOffsets.size() < 1) {
            Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
            List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, ADCVD_Objects__r.Type__c,
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c,
                                                    Petition_Calculation_Offset__c, Segment_Calculation_Offset__c, 
                                                    Litigation_Calculation_Offset__c, Investigation_Calculation_Offset__c,
                                                    Issue_Calculation_Offset__c
                                            FROM Constant__mdt];
            for(Constant__mdt sc : tempList) {
                returnMap.put(sc.QualifiedAPIName, sc);
            }
            return returnMap;
        } else {
            return issueCalcOffsets;
        }
    }

    @TestVisible private static void setParentMaps(List<Issue__c> newList) {
    	Map<Id,String> tempSegmentRecordTypeMap = utils.getRecordTypeDeveloperNameMap(SEGMENT);
    	Map<Id,String> tempLitigationRecordTypeMap = utils.getRecordTypeDeveloperNameMap(LITIGATION);
    	for (Issue__c i : newList) {
    		List<Issue__c> tempList = new List<Issue__c>();
	    	if (i.Petition__c != null) {
	    		tempList = parentIdToIssueMap.get(i.Petition__c) != null ? parentIdToIssueMap.get(i.Petition__c) : tempList;
	    		tempList.add(i);
				parentIdToIssueMap.put(i.Petition__c, tempList);
				parentIdToObjectTypeMap.put(i.Petition__c, PETITION);
			} else if (i.Investigation__c != null) {
				tempList = parentIdToIssueMap.get(i.Investigation__c) != null ? parentIdToIssueMap.get(i.Investigation__c) : tempList;
	    		tempList.add(i);
				parentIdToIssueMap.put(i.Investigation__c, tempList);
				parentIdToObjectTypeMap.put(i.Investigation__c, INVESTIGATION);
			} else if (i.Segment__c != null) {
				tempList = parentIdToIssueMap.get(i.Segment__c) != null ? parentIdToIssueMap.get(i.Segment__c) : tempList;
	    		tempList.add(i);
				parentIdToIssueMap.put(i.Segment__c, tempList);
				parentIdToObjectTypeMap.put(i.Segment__c, SEGMENT);
			} else if (i.Litigation__c != null) {
				tempList = parentIdToIssueMap.get(i.Litigation__c) != null ? parentIdToIssueMap.get(i.Litigation__c) : tempList;
	    		tempList.add(i);
				parentIdToIssueMap.put(i.Litigation__c, tempList);
				parentIdToObjectTypeMap.put(i.Litigation__c, LITIGATION);
			}
    	}
    	for (Petition__c p : [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id IN: parentIdToIssueMap.keySet()]) {
    		petitionParents.put(p.Id, p);
    	}
    	for (Investigation__c i : [SELECT Id, Calculated_Preliminary_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Calculated_Final_Signature__c,
    										Calculated_Amended_Final_Signature__c 
    								FROM Investigation__c WHERE Id IN: parentIdToIssueMap.keySet()]) {
    		investigationParents.put(i.Id, i);
    	}
    	for (Segment__c s : [SELECT Id, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
    								Calculated_Final_Signature__c, Calculated_Amended_Final_Signature__c, Deadline_for_Decision_on_how_to_proceed__c,
    								Continuation_or_Revocation__c, RecordTypeId 
    							FROM Segment__c WHERE Id IN: parentIdToIssueMap.keySet()]) {
    		segmentParents.put(s.Id, s);
    		parentIdToRecordTypeNameMap.put(s.Id, tempSegmentRecordTypeMap.get(s.RecordTypeId));
    	}
    	for (Litigation__c l : [SELECT Id, Calculated_Initiation_Signature__c, Calculated_Draft_Remand_release_to_party__c, 
    									Calculated_Final_Signature__c, RecordTypeId 
    								FROM Litigation__c WHERE Id IN: parentIdToIssueMap.keySet()]) {
    		litigationParents.put(l.Id, l);
    		parentIdToRecordTypeNameMap.put(l.Id, tempLitigationRecordTypeMap.get(l.RecordTypeId));
    	}
    }

    /**************************************
    * All Issues To DAS Calculations
    **************************************/

    @TestVisible private static void setInitiationIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == PETITION) {
    		Petition__c p = petitionParents.get(parentId);
    		if (p.Calculated_Initiation_Signature__c != null) {
    			i.Start_Date__c = p.Calculated_Initiation_Signature__c;
    			i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_PETITION_INITIATION);
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == ANTI_CIRCUMVENTION_REVIEW
				|| parentIdToRecordTypeNameMap.get(s.Id) == CHANGED_CIRCUMSTANCES_REVIEW
				|| parentIdToRecordTypeNameMap.get(s.Id) == NEW_SHIPPER_REVIEW
				) {
    			if (s.Calculated_Initiation_Signature__c != null) {
    				i.Start_Date__c = s.Calculated_Initiation_Signature__c;
	    			i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_INITIATION);
	    		}
    		}
    	}
    }

    @TestVisible private static void setPreliminaryIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Preliminary_Signature__c != null) {
    			i.Start_Date__c = inv.Calculated_Preliminary_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (s.Calculated_Preliminary_Signature__c != null) {
    			i.Start_Date__c = s.Calculated_Preliminary_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == LITIGATION) {
    		Litigation__c l = litigationParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(l.Id) == INT_LITIGATION) {
    			if (l.Calculated_Preliminary_Signature__c != null) {
    				i.Start_Date__c = l.Calculated_Preliminary_Signature__c;
	    		}
    		} else if (parentIdToRecordTypeNameMap.get(l.Id) == REMAND) {
    			if (l.Calculated_Draft_Remand_release_to_party__c != null) {
    				i.Start_Date__c = l.Calculated_Draft_Remand_release_to_party__c;
	    		}
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_PRELIMINARY);
        }
    }

    @TestVisible private static void setAmendedPreliminaryIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calc_Amended_Prelim_Determination_Sig__c != null) {
    			i.Start_Date__c = inv.Calc_Amended_Prelim_Determination_Sig__c;
    			i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_AMENDED_PRELIMINARY);
    		}
    	}
    }

    @TestVisible private static void setFinalIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Final_Signature__c != null) {
    			i.Start_Date__c = inv.Calculated_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (s.Calculated_Final_Signature__c != null) {
    			i.Start_Date__c = s.Calculated_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == LITIGATION) {
    		Litigation__c l = litigationParents.get(parentId);
    		if (l.Calculated_Final_Signature__c != null) {
    			i.Start_Date__c = l.Calculated_Final_Signature__c;
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_FINAL);
        }
    }

    @TestVisible private static void setAmendedFinalIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Amended_Final_Signature__c != null) {
    			i.Start_Date__c = inv.Calculated_Amended_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == ADMIN_REVIEW
    			|| parentIdToRecordTypeNameMap.get(s.Id) == EXPEDITED_REVIEW
    			|| parentIdToRecordTypeNameMap.get(s.Id) == NEW_SHIPPER_REVIEW
    			) {
    			if (s.Calculated_Amended_Final_Signature__c != null) {
    				i.Start_Date__c = s.Calculated_Amended_Final_Signature__c;
	    		}
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_AMENDED_FINAL);
        }
    }

    @TestVisible private static void setDeadlineForDecisionHOPIssuesToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == SCOPE_INQUIRY) {
    			if (s.Deadline_for_Decision_on_How_to_Proceed__c != null) {
    				i.Start_Date__c = s.Deadline_for_Decision_on_How_to_Proceed__c;
	    			i.Issues_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, ISSUES_DEADLINE_FOR_HOP);
	    		}
    		}
    	}
    }

    /**************************************
    * All Concurrence To DAS Calculations
    **************************************/

    @TestVisible private static void setInitiationConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == PETITION) {
    		Petition__c p = petitionParents.get(parentId);
    		if (p.Calculated_Initiation_Signature__c != null) {
                i.Start_Date__c = p.Calculated_Initiation_Signature__c;
    			i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_PETITION_INITIATION);
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == ANTI_CIRCUMVENTION_REVIEW
				|| parentIdToRecordTypeNameMap.get(s.Id) == CHANGED_CIRCUMSTANCES_REVIEW
				) {
    			if (s.Calculated_Initiation_Signature__c != null) {
                    i.Start_Date__c = s.Calculated_Initiation_Signature__c;
	    		}
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == LITIGATION) {
    		Litigation__c l = litigationParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(l.Id) == INT_LITIGATION) {
    			if (l.Calculated_Initiation_Signature__c != null) {
                    i.Start_Date__c = l.Calculated_Initiation_Signature__c;
	    		}
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_INITIATION);
        }
    }

    @TestVisible private static void setPreliminaryConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Preliminary_Signature__c != null) {
                i.Start_Date__c = inv.Calculated_Preliminary_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (s.Calculated_Preliminary_Signature__c != null) {
                i.Start_Date__c = s.Calculated_Preliminary_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == LITIGATION) {
    		Litigation__c l = litigationParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(l.Id) == INT_LITIGATION) {
    			if (l.Calculated_Preliminary_Signature__c != null) {
                    i.Start_Date__c = l.Calculated_Preliminary_Signature__c;
	    		}
    		} else if (parentIdToRecordTypeNameMap.get(l.Id) == REMAND) {
    			if (l.Calculated_Draft_Remand_release_to_party__c != null) {
                    i.Start_Date__c = l.Calculated_Draft_Remand_release_to_party__c;
	    		}
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_PRELIMINARY);
        }
    }

    @TestVisible private static void setAmendedPreliminaryConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calc_Amended_Prelim_Determination_Sig__c != null) {
    			i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_AMENDED_PRELIMINARY);
    		}
    	}
    }

    @TestVisible private static void setFinalConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Final_Signature__c != null) {
                i.Start_Date__c = inv.Calculated_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (s.Calculated_Final_Signature__c != null) {
                i.Start_Date__c = s.Calculated_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == LITIGATION) {
    		Litigation__c l = litigationParents.get(parentId);
    		if (l.Calculated_Final_Signature__c != null) {
                i.Start_Date__c = l.Calculated_Final_Signature__c;
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_FINAL);
        }
    }

    @TestVisible private static void setAmendedFinalConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == INVESTIGATION) {
    		Investigation__c inv = investigationParents.get(parentId);
    		if (inv.Calculated_Amended_Final_Signature__c != null) {
                i.Start_Date__c = inv.Calculated_Amended_Final_Signature__c;
    		}
    	} else if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == ADMIN_REVIEW
    			|| parentIdToRecordTypeNameMap.get(s.Id) == EXPEDITED_REVIEW
    			|| parentIdToRecordTypeNameMap.get(s.Id) == NEW_SHIPPER_REVIEW
    			) {
    			if (s.Calculated_Amended_Final_Signature__c != null) {
                    i.Start_Date__c = s.Calculated_Amended_Final_Signature__c;
	    		}
    		}
    	}
        if (i.Start_Date__c != null) {
            i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_AMENDED_FINAL);
        }
    }

    @TestVisible private static void setDeadlineForDecisionHOPConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == SCOPE_INQUIRY) {
    			if (s.Deadline_for_Decision_on_How_to_Proceed__c != null) {
                    i.Start_Date__c = s.Deadline_for_Decision_on_How_to_Proceed__c;
	    			i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_DEADLINE_FOR_HOP);
	    		}
    		}
    	}
    }

    @TestVisible private static void setContinuationOrRevocationConcurrenceToDAS(Id parentId, Issue__c i) {
    	if (parentIdToObjectTypeMap.get(parentId) == SEGMENT) {
    		Segment__c s = segmentParents.get(parentId);
    		if (parentIdToRecordTypeNameMap.get(s.Id) == SUNSET_REVIEW) {
    			if (s.Continuation_or_Revocation_FR_Notice_Pub__c != null) {
    				i.Start_Date__c = s.Continuation_or_Revocation_FR_Notice_Pub__c;
	    			i.Concurrence_to_DAS__c = ADCVD_TollingDayUtility.countBackBusinessDays(i.Start_Date__c, CONCURRENCE_CONT_OR_REVO);
	    		}
    		}
    	}
    }
}