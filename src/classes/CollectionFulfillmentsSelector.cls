/*
	Author: Jeff Weyhrauch
	Date: 7-2-2020
	Name: CollectionFulfillmentsSelector.cls
	Purpose: The implementation of ICollectionFulfillmentsSelector. The only place Collection_Fulfillment__c queries should live.
 */
public class CollectionFulfillmentsSelector extends fflib_SObjectSelector implements ICollectionFulfillmentsSelector {

	public static ICollectionFulfillmentsSelector newInstance(){
		return (ICollectionFulfillmentsSelector) fflibext_Application.Selector.newInstance(Collection_Fulfillment__c.SObjectType);
	}

	public List<Collection_Fulfillment__c> selectById(Set<Id> idSet) {
		return (List<Collection_Fulfillment__c>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		//add more fields as appropriate
		return new List<Schema.SObjectField>{
			Collection_Fulfillment__c.Active__c,
			Collection_Fulfillment__c.Cost_Center__c,
			Collection_Fulfillment__c.Id,
			Collection_Fulfillment__c.Name,
			Collection_Fulfillment__c.Org_Code__c,
			Collection_Fulfillment__c.OwnerId, 
			Collection_Fulfillment__c.Post__c,
			Collection_Fulfillment__c.RecordTypeId
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Collection_Fulfillment__c.SObjectType;
	}

}