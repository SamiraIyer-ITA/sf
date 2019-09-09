@isTest
public class fflibext_SObjectSelectorTest {
    @TestVisible private class fflibext_SObjectSelectorTestImpl extends fflibext_SObjectSelector {
        @TestVisible private fflibext_SObjectSelectorTestImpl(Boolean includeFieldSetFields) {
            super(includeFieldSetFields);
        }
        @TestVisible private fflibext_SObjectSelectorTestImpl(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
            super(includeFieldSetFields, enforceCRUD, enforceFLS);
        }
        @TestVisible private fflibext_SObjectSelectorTestImpl(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS, Boolean sortSelectFields) {
            super(includeFieldSetFields, enforceCRUD, enforceFLS, sortSelectFields);
        }
        @TestVisible private Schema.sObjectType getSObjectType() {
            return Account.SObjectType;
        }
        @TestVisible private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
            return new List<Schema.SObjectField>();
        }
    }
	@IsTest
	static void testBehavior() {
        fflibext_SObjectSelectorTestImpl sst1 = new fflibext_SObjectSelectorTestImpl(false);
        fflibext_SObjectSelectorTestImpl sst2 = new fflibext_SObjectSelectorTestImpl(false,false,false);
        fflibext_SObjectSelectorTestImpl sst3 = new fflibext_SObjectSelectorTestImpl(false,false,false,false);
    }
}