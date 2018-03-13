/**
 * Created by cloud on 8/15/2017.
 */

@IsTest
private class AppConfigServiceTest {
    static testMethod void nullTestConfig() {
        User testUser = TestUtils.createAdminUser(true, 'testrunner@trade.gov', 1);

        System.RunAs(testUser) {

            Test.startTest();

            system.assert(Test.isRunningTest(), true);

            AppConfig__c appConfiguration = AppConfigService.getApplicationConfig();

            Boolean triggerState = AppConfigService.triggerEnabled;

            Boolean appState = AppConfigService.appEnabled;

            Test.stopTest();

            system.assertEquals(appConfiguration.Name, 'testConfig');

            system.assertEquals(appState, true);

            system.assertEquals(triggerState, true);

            system.assertEquals(appConfiguration.AppEnabled__c, true);

            system.assertEquals(appConfiguration.TriggersEnabled__c, true);

            system.debug(Test.isRunningTest());

            system.assertEquals(Test.isRunningTest(), true);

        }
    }

     static testMethod void triggersOff() {
         User testUser = TestUtils.createAdminUser(true, 'testrunner@trade.gov', 1);

         System.RunAs(testUser) {

             Test.startTest();

             system.assert(Test.isRunningTest(), true);

             AppConfig__c appConfiguration1 = new AppConfig__c(Name = 'default', AppEnabled__c = true, TriggersEnabled__c = false);

             Insert appConfiguration1;

             AppConfig__c appConfiguration = AppConfigService.getApplicationConfig();

             Boolean triggerState = AppConfigService.triggerEnabled;

             Boolean appState = AppConfigService.appEnabled;

             Test.stopTest();

             system.debug(appConfiguration.Name);

             system.assertEquals(appConfiguration.Name, appConfiguration1.Name);

             system.assertEquals(appState, true);

             system.assertEquals(triggerState, false);

             system.debug(appConfiguration.AppEnabled__c);

             system.assertEquals(appConfiguration.AppEnabled__c, appConfiguration1.AppEnabled__c);

             system.debug(appConfiguration.TriggersEnabled__c);

             system.assertEquals(appConfiguration.TriggersEnabled__c, appConfiguration1.TriggersEnabled__c );

             system.debug(Test.isRunningTest());

             system.assertEquals(Test.isRunningTest(), true);

         }
     }

    static testMethod void triggersOn() {
        User testUser = TestUtils.createAdminUser(true, 'testrunner@trade.gov', 1);

        System.RunAs(testUser) {

            Test.startTest();

            system.assert(Test.isRunningTest(), true);

            AppConfig__c appConfiguration2 = new AppConfig__c(Name = 'default', AppEnabled__c = true, TriggersEnabled__c = true);

            Insert appConfiguration2;

            AppConfig__c appConfiguration = AppConfigService.getApplicationConfig();

            Boolean triggerState = AppConfigService.triggerEnabled;

            Boolean appState = AppConfigService.appEnabled;

            Test.stopTest();

            system.debug(appConfiguration.Name);

            system.assertEquals(appState, true);

            system.assertEquals(triggerState, true);

            system.assertEquals(appConfiguration.Name, appConfiguration2.Name);

            system.debug(appConfiguration.AppEnabled__c);

            system.assertEquals(appConfiguration.AppEnabled__c, appConfiguration2.AppEnabled__c);

            system.debug(appConfiguration.TriggersEnabled__c);

            system.assertEquals(appConfiguration.TriggersEnabled__c, appConfiguration2.TriggersEnabled__c );

        }
    }

    static testMethod void usingTestConfig() {
        User testUser = TestUtils.createAdminUser(true, 'testrunner@trade.gov', 1);

        System.RunAs(testUser) {

            Test.startTest();

            system.assert(Test.isRunningTest(), true);

            AppConfig__c testConfig = new AppConfig__c(Name = 'testConfig', AppEnabled__c = true, TriggersEnabled__c = true);

            Insert testConfig;

            AppConfig__c appConfiguration = AppConfigService.getApplicationConfig();

            Boolean triggerState = AppConfigService.triggerEnabled;

            Boolean appState = AppConfigService.appEnabled;

            Test.stopTest();

            system.debug(appConfiguration.Name);

            system.assertEquals(appState, true);

            system.assertEquals(triggerState, true);

            system.assertEquals(appConfiguration.Name, testConfig.Name);

            system.debug(appConfiguration.AppEnabled__c);

            system.assertEquals(appConfiguration.AppEnabled__c, testConfig.AppEnabled__c);

            system.debug(appConfiguration.TriggersEnabled__c);

            system.assertEquals(appConfiguration.TriggersEnabled__c, testConfig.TriggersEnabled__c );

        }
    }

}