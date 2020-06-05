@isTest
public class di_PlatformCacheTest {
	@isTest
    static void exerciseMethods() {
        di_Configurations__c c = new di_Configurations__c();
        c.OrgCachePartitionName__c = 'myPartitionName';
        c.UsePlatformCacheToStoreBindings__c = true;
        insert c;
        di_PlatformCache cache = di_PlatformCache.getInstance();
        di_PlatformCache.getConfig();
        di_PlatformCache.isStoringBindingInPlatformCache();
        cache.retrieveBindings('myString', Account.SObjectType);
    }
}