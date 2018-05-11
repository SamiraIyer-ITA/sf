/*
 * Create by Eitan Alfiya
 * on 5/9/2018
 * Mil Corporation
 */
public without sharing class RelatedOrganizationSelector {
    
    public static List<Related_Organization__c> relatedOrgsInContext = new List<Related_Organization__c>();
    
    public static List<Related_Organization__c> allRelatedOrganizations{
        get{
            if(allRelatedOrganizations == null){
                String query = Utils.soqlBuilderAllFields('Related_Organization__c', true);
                allRelatedOrganizations = database.query(query);
            }
            return allRelatedOrganizations;
        }
        set;
    }
    
    public static List<Related_Organization__c> getRelatedOrganizationsInContext(Set<Id> relatedOrgIdSet, Set<String> fields, Boolean newQuery){
        if(newQuery){
            relatedOrgsInContext = (List<Related_Organization__c>) Utils.getSObjectsInContext('Related_Organization__c', relatedOrgIdSet, fields);
        }
        return relatedOrgsInContext;
    }

}