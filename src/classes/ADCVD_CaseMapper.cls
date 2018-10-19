/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class ADCVD_CaseMapper implements ADCVD_IMapper {

	//the object API names without '__c' that need their related object ids mapped for 
	//correct processing of mapped Federal Registers
	public static FINAL List<String> FR_RELATED_PARENT_NAMES = new List<String>{
		'Petition', 'Investigation','ADCVD_Order', 'Suspension_Agreement', 'Segment'};
	//Map of shortened object API name to an inner class instance.  This map is used
	//to dynamically create the class types needed.
	public static FINAL Map<String,RelatedObjects> RELATED_OBJECTS;
	//The map that holds the mapper instance for the other mappers.
	//The are initialized here via empty constructors.  Those empty instances will be
	//replaced when one of the mappers is requested in a class via the mapper
	//specific implementation of getInstance()
	public static Map<String,ADCVD_IMapper> mapperMap;
	//the instance for this class
	@TestVisible private static ADCVD_CaseMapper instance = null;
	//populate maps on class initialization
	static {
		RELATED_OBJECTS = new Map<String,RelatedObjects>();
		RELATED_OBJECTS.put('Petition', (RelatedObjects) new PetitionRelatedParents());
		RELATED_OBJECTS.put('Investigation', (RelatedObjects) new InvestigationRelatedParents());
		RELATED_OBJECTS.put('ADCVD_Order', (RelatedObjects) new ADCVD_OrderRelatedParents());
		RELATED_OBJECTS.put('Suspension_Agreement', (RelatedObjects) new Suspension_AgreementRelatedParents());
		RELATED_OBJECTS.put('Segment', (RelatedObjects) new SegmentRelatedParents());
		mapperMap = new Map<String,ADCVD_IMapper>();
		mapperMap.put('Petition__c', (ADCVD_IMapper) new PetitionMapper());
		mapperMap.put('Investigation__c', (ADCVD_IMapper) new InvestigationMapper());
		mapperMap.put('ADCVD_Order__c', (ADCVD_IMapper) new ADCVD_OrderMapper());
		mapperMap.put('Suspension_Agreement__c', (ADCVD_IMapper) new Suspension_AgreementMapper());
		mapperMap.put('Segment__c', (ADCVD_IMapper) new SegmentMapper());
		mapperMap.put('Federal_Register__c', (ADCVD_IMapper) new FederalRegisterMapper());
		mapperMap.put('Litigation__c', (ADCVD_IMapper) new LitigationMapper());
		mapperMap.put('Related_Organization__c', (ADCVD_IMapper) new RelatedOrganizationMapper());
		mapperMap.put('Custom_Instruction__c', (ADCVD_IMapper) new CustomInstructionMapper());
		mapperMap.put('ADCVD_Case__c', (ADCVD_IMapper) new ADCVD_CaseMapper());
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
	public static Map<Id,Set<Id>> caseIdToCstInstIdMap = new Map<Id,Set<Id>>();

	/*
	Maps of parent objects to child objects.  If there is a specific use case,
	the name will be pre-pended with the object which uses this map
	*/
	//map of an Id to the related Ids whose FRs could affect the it's calculations. Used in the FR Mapper
	public static Map<Id,Set<Id>> fr_ParentIdToRelatedParentIds = new Map<Id,Set<Id>>();

	//empty constructor of this class
	public ADCVD_CaseMapper(){}
	//private constructor used via the getInstance() method.  Performs a query on the ADCVD_Case__c table
	//with subqueries to get the Ids of all the related records. The returned list of cases is then used to populate
	//the in class maps
	@TestVisible
	private ADCVD_CaseMapper(Set<Id> caseIdSet) {
		if (instance == null) {
			mapCaseIdsToMaps(ADCVD_CaseSelector.newInstance().selectByIdWithRelations(caseIdSet));
		}
	}

	//primary mapping method. Populates the unlocked and locked case maps and all of the
	//per object scope maps (case to petitions, etc)
	private void mapCaseIdsToMaps(List<ADCVD_Case__c> caseList) {
		for (ADCVD_Case__c ac : caseList) {
			addCaseToMap(ac);
			setCaseIdToPetitionMap(ac.Id, ac.Petitions__r);
			setCaseIdToInvestigationMap(ac.Id, ac.Investigations__r);
			setCaseIdToOrderMap(ac.Id, ac.ADCVD_Orders__r);
			setCaseIdToSuspAgrmtMap(ac.Id, ac.Suspension_Agreements__r);
			setCaseIdToSegmentMap(ac.Id, ac.Segments__r);
			setCaseIdToLitigationMap(ac.Id, ac.Litigation__r);
			setCaseIdToFrMap(ac.Id, ac.Federal_Registers__r);
			setCaseIdToStaffingMap(ac.Id, ac.Staffing_Assignments__r);
			setCaseIdToRelOrgMap(ac.Id, ac.Interested_Organizations__r);
			setCaseIdToCstInstMap(ac.Id, ac.Custom_Instructions__r);
		}
	}
	//accepts a case Id and an object name and returns the set of Ids for that case and object
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
		} else if (objectName == 'Custom_Instruction__c') {
			return caseIdToCstInstIdMap.get(caseId);
		}
		return new Set<Id>();
	}
	//methods to populate each case to set of object Ids map.
	public void setCaseIdToPetitionMap(Id caseId, List<Petition__c> petitionList) {
		caseIdToPetitionIdMap.put(caseId, getIdSetForMaps(caseIdToPetitionIdMap.get(caseId), petitionList, 'Petition__c'));
	}
	public void setCaseIdToInvestigationMap(Id caseId, List<Investigation__c> investigationList) {
		caseIdToInvestigationIdMap.put(caseId, getIdSetForMaps(caseIdToInvestigationIdMap.get(caseId), investigationList, 'Investigation__c'));
	}
	public void setCaseIdToOrderMap(Id caseId, List<ADCVD_Order__c> orderList) {
		caseIdToOrderIdMap.put(caseId, getIdSetForMaps(caseIdToOrderIdMap.get(caseId), orderList, 'ADCVD_Order__c'));
	}
	public void setCaseIdToSuspAgrmtMap(Id caseId, List<Suspension_Agreement__c> suspAgrmtList) {
		caseIdToSuspAgrmtIdMap.put(caseId, getIdSetForMaps(caseIdToSuspAgrmtIdMap.get(caseId), suspAgrmtList, 'Suspension_Agreement__c'));
	}
	public void setCaseIdToSegmentMap(Id caseId, List<Segment__c> segmentList) {
		caseIdToSegmentIdMap.put(caseId, getIdSetForMaps(caseIdToSegmentIdMap.get(caseId), segmentList, 'Segment__c'));
	}
	public void setCaseIdToLitigationMap(Id caseId, List<Litigation__c> litigationList) {
		caseIdToLitigationIdMap.put(caseId, getIdSetForMaps(caseIdToLitigationIdMap.get(caseId), litigationList, 'Litigation__c'));
	}
	public void setCaseIdToFrMap(Id caseId, List<Federal_Register__c> frList) {
		caseIdToFrIdMap.put(caseId, getIdSetForMaps(caseIdToFrIdMap.get(caseId), frList, 'Federal_Register__c'));
    }
	public void setCaseIdToStaffingMap(Id caseId, List<Staffing_Assignment__c> staffingList) {
		caseIdToStaffingIdMap.put(caseId, getIdSetForMaps(caseIdToStaffingIdMap.get(caseId), staffingList, 'Staffing_Assignment__c'));
	}
	public void setCaseIdToRelOrgMap(Id caseId, List<Related_Organization__c> relOrgList) {
		caseIdToRelOrgIdMap.put(caseId, getIdSetForMaps(caseIdToRelOrgIdMap.get(caseId), relOrgList, 'Related_Organization__c'));
	}
	public void setCaseIdToCstInstMap(Id caseId, List<Custom_Instruction__c> cstInstList) {
		caseIdToCstInstIdMap.put(caseId, getIdSetForMaps(caseIdToCstInstIdMap.get(caseId), cstInstList, 'Custom_Instruction__c'));
	}
	//This method returns the Ids from List of SObjects in a Set.  It also uses the same
	//for loop to populate the related Id Maps.  This two functions need to happen together
	//to make sure the map of Case to Id Set and the Ids in that set to their related Ids
	//stay in sync
	private static Set<Id> getIdSetForMaps(Set<Id> soIdSet, List<SObject> soList, String objectName) {
        soIdSet = soIdSet == null ? new Set<Id>() : soIdSet;
		String shortenedObjectName = objectName.removeEnd('__c');
		for (SObject so : soList) {
			Id soId = (Id) so.get('Id');
			soIdSet.add(soId);
			populateRelatedIdMaps(shortenedObjectName, so, soId);
		}
		return soIdSet;
	}
	//method to create a new instance of the inner classes
	private static void populateRelatedIdMaps (String shortenedObjectName, SObject so, Id soId) {
		if (FR_RELATED_PARENT_NAMES.contains(shortenedObjectName)) {
			FrRelatedParents frp = new FrRelatedParents(shortenedObjectName, so, soId);
		}
	}
	//primary method for getting and instance of this mapper
	public ADCVD_CaseMapper getInstance(Set<Id> caseIdSet) {
		if (instance == null) {
			return getNewInstance(caseIdSet);
		}
		return instance;
	}
	//method to get a new instance of this mapper, should be very rarely used
	public ADCVD_CaseMapper getNewInstance(Set<Id> caseIdSet) {
		instance = new ADCVD_CaseMapper(caseIdSet);
		mapperMap.put('ADCVD_Case__c', instance);
		return instance;
	}
	//method for returning this instance without providing new case Ids
	public ADCVD_CaseMapper getInstance() {
		return (ADCVD_CaseMapper) mapperMap.get('ADCVD_Case__c');
	}
	//method for returning either all or unlocked cases
	public Map<Id,SObject> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllCaseMap;
		} else {
			return idToUnlockedCaseMap;
		}
	}
	//method to return a mapper based on the Object's API name
	public ADCVD_IMapper getMapper(String objectName) {
		return mapperMap.get(objectName);
	}
	//method to update the map with an updated mapper (i.e. after inserting new records, the trigger handler will update the mapper
	//then update this map with the new one)
	public void putMapper(String objectName, ADCVD_IMapper mapper) {
		mapperMap.put(objectName, mapper);
	}
	//method to add new or updated Cases to the maps
	public void addCaseToMap(ADCVD_Case__c ac) {
		if (!ac.Locked__c) {
			idToUnlockedCaseMap.put(ac.Id, ac);
		}
		idToAllCaseMap.put(ac.id, ac);
	}
	//method to return a related set of Ids, which Ids will be returned is based on the logic in the inner classes.
	//(i.e. an investigation Id param will return a set of Ids with that investigation Id,
	//that investigation's Petition Id, and if that Investigation has an order, that investigation's order Id)
	//This method is primarily used in the FederalRegisterMapper to correctly retrieve FRs for a specific parent
	public Set<Id> getFrRelatedParents(Id soId) {
		return fr_ParentIdToRelatedParentIds.get(soId);
	}
	// extension of Exception to throw an exception when a class cannot be dynamically instantiated due to a
	// naming issue
	public class NameException extends Exception{}
	//interface for the inner classes
	public interface RelatedObjects {
		void setRelatedIdSet(SObject so, Id soId);
	}
	//virtual class for the inner classes
	public virtual class FrRelatedParents implements RelatedObjects {
		//instance of interface
		private RelatedObjects ro;
		//empty constructor of this class
		public FrRelatedParents (){}
		//constructor used to cast the interface instance to a concrete class and call the main class method
		public FrRelatedParents (String shortenedObjectName, SObject so, Id soId) {
			if(!RELATED_OBJECTS.containsKey(shortenedObjectName)) throw new NameException(shortenedObjectName);
			ro = RELATED_OBJECTS.get(shortenedObjectName);
			ro.setRelatedIdSet(so, soId);
		}
		//default is to add it's own id to the set
		public virtual void setRelatedIdSet(SObject so, Id soId) {
			Set<Id> relatedIdSet = new Set<Id>{soId};
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				relatedIdSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			fr_ParentIdToRelatedParentIds.put(soId, relatedIdSet);
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
	//Petition uses default implementation in FrRelatedParents
	public class PetitionRelatedParents extends FrRelatedParents {}
	//Investigation also adds the petition Id to it's map
	public class InvestigationRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			Id petitionId = (Id) so.get('Petition__c');
			Set<Id> relatedIdSet = new Set<Id>{soId};
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				relatedIdSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			relatedIdSet.add(petitionId);
			fr_ParentIdToRelatedParentIds.put(soId, relatedIdSet);
		}
	}
	//Order also adds it's Id to the Investigation's map
	public class ADCVD_OrderRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			//get parent Id
			Id investigationId = (Id) so.get('Investigation__c');
			//add the order Id to the parent Investigation Id Set
			addIdToRelatedSet(soId, investigationId);
			//initiate return set with current order Id
			Set<Id> relatedIdSet = new Set<Id>{soId};
			//add existing related Ids
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				relatedIdSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			fr_ParentIdToRelatedParentIds.put(soId, relatedIdSet);
		}
	}
	//Suspension Agreement uses the default implementation
	public class Suspension_AgreementRelatedParents extends FrRelatedParents {}
	//Segment adds it's own Id to it's parent (either order or suspension agreement)
	//It then add it's parent Id to it's own Set
	public class SegmentRelatedParents extends FrRelatedParents {
		public override void setRelatedIdSet(SObject so, Id soId) {
			//get parent Ids
			Id orderId = (Id) so.get('ADCVD_Order__c');
			Id suspAgrmtId = (Id) so.get('Suspension_Agreement__c');
			//add the segment Id to the parent Order or Suspension Agreement Id Set
			if (orderId != null) addIdToRelatedSet(soId, orderId);
			if (suspAgrmtId != null) addIdToRelatedSet(soId, suspAgrmtId);
			//initiate return set with current segment Id
			Set<Id> relatedIdSet = new Set<Id>{soId};
			//add existing related Ids
			if (fr_ParentIdToRelatedParentIds.get(soId) != null) {
				relatedIdSet.addAll(fr_ParentIdToRelatedParentIds.get(soId));
			}
			//add new related Ids
			if (orderId != null) relatedIdSet.add(orderId);
			if (suspAgrmtId != null) relatedIdSet.add(suspAgrmtId);
			fr_ParentIdToRelatedParentIds.put(soId, relatedIdSet);
		}
	}
}