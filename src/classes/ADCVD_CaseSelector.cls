/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class ADCVD_CaseSelector implements ADCVD_Selector {

	public static FINAL List<String> FR_RELATED_PARENT_NAMES = new List<String>{
		'Petition', 'Investigation','ADCVD_Order', 'Suspension_Agreement', 'Segment'};
	public static FINAL Map<String,RelatedObjects> RELATED_OBJECTS;
	public static Map<String,ADCVD_Selector> selectorMap;
	@TestVisible private static ADCVD_CaseSelector instance = null;
	static {
		RELATED_OBJECTS = new Map<String,RelatedObjects>();
		selectorMap = new Map<String,ADCVD_Selector>();
		RELATED_OBJECTS.put('Petition', (RelatedObjects) new PetitionRelatedParents());
		RELATED_OBJECTS.put('Investigation', (RelatedObjects) new InvestigationRelatedParents());
		RELATED_OBJECTS.put('ADCVD_Order', (RelatedObjects) new ADCVD_OrderRelatedParents());
		RELATED_OBJECTS.put('Suspension_Agreement', (RelatedObjects) new Suspension_AgreementRelatedParents());
		RELATED_OBJECTS.put('Segment', (RelatedObjects) new SegmentRelatedParents());
		RELATED_OBJECTS.put('Litigation', (RelatedObjects) new LitigationRelatedParents());
		RELATED_OBJECTS.put('Federal_Register', (RelatedObjects) new Federal_RegisterRelatedParents());
		RELATED_OBJECTS.put('Staffing_Assignment', (RelatedObjects) new Staffing_AssignmentRelatedParents());
		RELATED_OBJECTS.put('Related_Organization', (RelatedObjects) new Related_OrganizationRelatedParents());
		selectorMap.put('Petition__c', (ADCVD_Selector) new PetitionSelector());
		selectorMap.put('Investigation__c', (ADCVD_Selector) new InvestigationSelector());
		selectorMap.put('ADCVD_Order__c', (ADCVD_Selector) new ADCVD_OrderSelector());
		selectorMap.put('Suspension_Agreement__c', (ADCVD_Selector) new Suspension_AgreementSelector());
		selectorMap.put('Segment__c', (ADCVD_Selector) new SegmentSelector());
		selectorMap.put('Federal_Register__c', (ADCVD_Selector) new FederalRegisterSelector());
		selectorMap.put('Litigation__c', (ADCVD_Selector) new ADCVD_CaseSelector());
		selectorMap.put('ADCVD_Case__c', (ADCVD_Selector) new ADCVD_CaseSelector());
	}
	//Master map of unlocked cases for execution
	public static Map<Id,ADCVD_Case__c> idToUnlockedCaseMap = new Map<Id,ADCVD_Case__c>();
	//Master map of locked cases for execution
	public static Map<Id,ADCVD_Case__c> idToAllCaseMap = new Map<Id,ADCVD_Case__c>();

	//Maps of case Ids to their child Ids
	public static Map<Id,Set<Id>> caseIdToPetitionIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToInvestigationIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToOrderIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToSuspAgrmtIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToSegmentIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToLitigationIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToFrIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToStaffingIdMap = new Map<Id,Set<Id>>();
	public static Map<Id,Set<Id>> caseIdToRelOrgIdMap = new Map<Id,Set<Id>>();

	/*
	Maps of parent objects to child objects.  If there is a specific use case,
	the name will be pre-pended with the object which uses this map
	*/
	//map of an Id to the related Ids whose FRs could affect the it's calculations. Used in the FR Mapper
	public static Map<Id,Set<Id>> fr_ParentIdToRelatedParentIds = new Map<Id,Set<Id>>();
	public ADCVD_CaseSelector(){}
	private ADCVD_CaseSelector(Set<Id> caseIdSet) {
		if (instance == null) {
			List<ADCVD_Case__c> tempList = new List<ADCVD_Case__c>();
			String queryString = Utils.soqlBuilderAllFields('ADCVD_Case__c', false);
			String petitionSubQuery = ', (SELECT Id, ADCVD_Case__c FROM Petitions__r)';
			String investigationSubQuery = ', (SELECT Id, Petition__c, ADCVD_Case__c FROM Investigations__r)';
			String adcvdOrderSubQuery = ', (SELECT Id, Investigation__c, ADCVD_Case__c FROM ADCVD_Orders__r)';
			String suspAgrmtSubQuery = ', (SELECT Id, Investigation__c, ADCVD_Case__c FROM Suspension_Agreements__r)';
			String segmentSubQuery = ', (SELECT Id, ADCVD_Order__c, Suspension_Agreement__c, ADCVD_Case__c FROM Segments__r)';
			String litigationSubQuery = ', (SELECT Id, Petition__c, Investigation__c, Segment__c, ADCVD_Case__c FROM Litigation__r)';
			String frSubQuery = ', (SELECT Id, Petition__c, Investigation__c, ADCVD_Order__c, Suspension_Agreement__c, Segment__c, ADCVD_Case__c FROM Federal_Registers__r)';
			String staffingSubQuery = ', (SELECT Id, Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Related_Organization__c, ADCVD_Case__c FROM Staffing_Assignments__r)';
			String relOrgSubQuery = ', (SELECT Id, Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Litigation__c, ADCVD_Case__c FROM Interested_Organizations__r)';
			queryString += petitionSubQuery + investigationSubQuery + adcvdOrderSubQuery +
							suspAgrmtSubQuery + segmentSubQuery + litigationSubQuery + 
							frSubQuery + staffingSubQuery + relOrgSubQuery + ' FROM ADCVD_Case__c WHERE Id IN:caseIdSet';
			System.debug(LoggingLevel.DEBUG,'queryString: ' + queryString);
			tempList = database.query(queryString);
			mapCaseIdsToMaps(tempList);
		}
	}

	private void mapCaseIdsToMaps(List<ADCVD_Case__c> caseList) {
		for (ADCVD_Case__c ac : caseList) {
			if (!ac.Locked__c) {
				idToUnlockedCaseMap.put(ac.Id, ac);
			}
			idToAllCaseMap.put(ac.Id, ac);
			setCaseIdToPetitionMap(ac.Id, ac.Petitions__r);
			setCaseIdToInvestigationMap(ac.Id, ac.Investigations__r);
			setCaseIdToOrderMap(ac.Id, ac.ADCVD_Orders__r);
			setCaseIdToSuspAgrmtMap(ac.Id, ac.Suspension_Agreements__r);
			setCaseIdToSegmentMap(ac.Id, ac.Segments__r);
			setCaseIdToFrMap(ac.Id, ac.Federal_Registers__r);
			setCaseIdToStaffingMap(ac.Id, ac.Staffing_Assignments__r);
			setCaseIdToRelOrgMap(ac.Id, ac.Interested_Organizations__r);
		}
	}
	public Set<Id> getIdSet(Id caseId, String objectName) {
		if (objectName == 'Petition__c') {
			return caseIdToPetitionIdMap.get(caseId);
		} else if (objectName == 'Investigation__c') {
			return caseIdToInvestigationIdMap.get(caseId);
		} else if (objectName == 'ADCVD_Order__c') {
			return caseIdToOrderIdMap.get(caseId);
		} else if (objectName == 'Suspension_Agreement__c') {
			return caseIdToSuspAgrmtIdMap.get(caseId);
		} else if (objectName == 'Segment__c') {
			return caseIdToSegmentIdMap.get(caseId);
		} else if (objectName == 'Federal_Register__c') {
			return caseIdToFrIdMap.get(caseId);
		} else if (objectName == 'Staffing_Assignment__c') {
			return caseIdToStaffingIdMap.get(caseId);
		} else if (objectName == 'Related_Organization__c') {
			return caseIdToRelOrgIdMap.get(caseId);
		}
		return new Set<Id>();
	}
	public void setCaseIdToPetitionMap(Id caseId, List<Petition__c> petitionList) {
		caseIdToPetitionIdMap.put(caseId, getIdSetForMaps(petitionList, 'Petition__c'));
	}
	public void setCaseIdToInvestigationMap(Id caseId, List<Investigation__c> investigationList) {
		caseIdToInvestigationIdMap.put(caseId, getIdSetForMaps(investigationList, 'Investigation__c'));
	}
	public void setCaseIdToOrderMap(Id caseId, List<ADCVD_Order__c> orderList) {
		caseIdToOrderIdMap.put(caseId, getIdSetForMaps(orderList, 'ADCVD_Order__c'));
	}
	public void setCaseIdToSuspAgrmtMap(Id caseId, List<Suspension_Agreement__c> suspAgrmtList) {
		caseIdToSuspAgrmtIdMap.put(caseId, getIdSetForMaps(suspAgrmtList, 'Suspension_Agreement__c'));
	}
	public void setCaseIdToSegmentMap(Id caseId, List<Segment__c> segmentList) {
		caseIdToSegmentIdMap.put(caseId, getIdSetForMaps(segmentList, 'Segment__c'));
	}
	public void setCaseIdToLitigationMap(Id caseId, List<Litigation__c> litigationList) {
		caseIdToLitigationIdMap.put(caseId, getIdSetForMaps(litigationList, 'Litigation__c'));
	}
	public void setCaseIdToFrMap(Id caseId, List<Federal_Register__c> frList) {
		caseIdToFrIdMap.put(caseId, getIdSetForMaps(frList, 'Federal_Register__c'));
	}
	public void setCaseIdToStaffingMap(Id caseId, List<Staffing_Assignment__c> staffingList) {
		caseIdToStaffingIdMap.put(caseId, getIdSetForMaps(staffingList, 'Staffing_Assignment__c'));
	}
	public void setCaseIdToRelOrgMap(Id caseId, List<Related_Organization__c> relOrgList) {
		caseIdToRelOrgIdMap.put(caseId, getIdSetForMaps(relOrgList, 'Related_Organization__c'));
	}

	private static Set<Id> getIdSetForMaps(List<SObject> soList, String objectName) {
		Set<Id> tempSet = new Set<Id>();
		String shortenedObjectName = objectName.removeEnd('__c');
		for (SObject so : soList) {
			Id soId = (Id) so.get('Id');
			tempSet.add(soId);
			populateRelatedIdMaps(shortenedObjectName, so, soId);
		}
		return tempSet;
	}

	private static void populateRelatedIdMaps (String shortenedObjectName, SObject so, Id soId) {
		if (FR_RELATED_PARENT_NAMES.contains(shortenedObjectName)) {
			FrRelatedParents frp = new FrRelatedParents(shortenedObjectName, so, soId);
		}
	}

	public ADCVD_CaseSelector getInstance(Set<Id> caseIdSet) {
		if (instance == null) {
			return getNewInstance(caseIdSet);
		}
		return instance;
	}

	public ADCVD_CaseSelector getNewInstance(Set<Id> caseIdSet) {
		instance = new ADCVD_CaseSelector(caseIdSet);
		selectorMap.put('ADCVD_Case__c', instance);
		return instance;
	}

	public ADCVD_CaseSelector getInstance() {
		return (ADCVD_CaseSelector) selectorMap.get('ADCVD_Case__c');
	}

	public Map<Id,SObject> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllCaseMap;
		} else {
			return idToUnlockedCaseMap;
		}
	}

	public ADCVD_Selector getSelector(String objectName) {
		return selectorMap.get(objectName);
	}

	public void putSelector(String objectName, ADCVD_Selector selector) {
		selectorMap.put(objectName, selector);
	}

	public Set<Id> getFrRelatedParents(Id soId) {
		return fr_ParentIdToRelatedParentIds.get(soId);
	}

	public class NameException extends Exception{}

	public interface RelatedObjects {
		void setRelatedIdSet(SObject so, Id soId);
	}

	public virtual class FrRelatedParents implements RelatedObjects {
		private RelatedObjects ro;
		public FrRelatedParents (){}
		public FrRelatedParents (String shortenedObjectName, SObject so, Id soId) {
			if(!RELATED_OBJECTS.containsKey(shortenedObjectName)) throw new NameException(shortenedObjectName);
			ro = RELATED_OBJECTS.get(shortenedObjectName);
			ro.setRelatedIdSet(so, soId);
		}
		//default is to add it's own id to the set
		public virtual void setRelatedIdSet(SObject so, Id soId) {
			fr_ParentIdToRelatedParentIds.put(soId, new Set<Id>{soId});
		}
		//adds soId to a specified related objects set. Useful for adding children to the parent's set
		public void addIdToRelatedSet(Id soId, Id relatedId) {
			Set<Id> relatedIdSet = new Set<Id>();
			if (fr_ParentIdToRelatedParentIds.get(relatedId) != null) {
				relatedIdSet.addAll(fr_ParentIdToRelatedParentIds.get(relatedId));
			}
			relatedIdSet.add(soId);
			fr_ParentIdToRelatedParentIds.put(relatedId, relatedIdSet);
		}
	}
	//uses default implementation
	public class PetitionRelatedParents extends FrRelatedParents {}
	public class InvestigationRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			Id petitionId = (Id) so.get('Petition__c');
			Set<Id> tempSet = new Set<Id>{soId};
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				tempSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			tempSet.add(petitionId);
			fr_ParentIdToRelatedParentIds.put(soId, tempSet);
		}
	}
	public class ADCVD_OrderRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			//get parent Id
			Id investigationId = (Id) so.get('Investigation__c');
			//initiate return set with current order Id
			Set<Id> tempSet = new Set<Id>{soId};
			//add existing related Ids
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				tempSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			//add the order Id to the parent Investigation Id Set
			addIdToRelatedSet(soId, investigationId);
			fr_ParentIdToRelatedParentIds.put(soId, tempSet);
		}
	}
	public class Suspension_AgreementRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			Set<Id> tempSet = new Set<Id>{soId};
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				tempSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			fr_ParentIdToRelatedParentIds.put(soId, tempSet);
		}
	}
	public class SegmentRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			//get parent Ids
			Id orderId = (Id) so.get('ADCVD_Order__c');
			Id suspAgrmtId = (Id) so.get('Suspension_Agreement__c');
			//initiate return set with current segment Id
			Set<Id> tempSet = new Set<Id>{soId};
			//add existing related Ids
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				tempSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			//add new related Ids
			tempSet.add(orderId);
			tempSet.add(suspAgrmtId);
			//add the segment Id to the parent Order or Suspension Agreement Id Set
			if (orderId != null) addIdToRelatedSet(soId, orderId);
			if (suspAgrmtId != null) addIdToRelatedSet(soId, suspAgrmtId);
			fr_ParentIdToRelatedParentIds.put(soId, tempSet);
		}
	}
	public class LitigationRelatedParents extends FrRelatedParents {}
	public class Federal_RegisterRelatedParents extends FrRelatedParents {}
	public class Staffing_AssignmentRelatedParents extends FrRelatedParents {}
	public class Related_OrganizationRelatedParents extends FrRelatedParents {}
}