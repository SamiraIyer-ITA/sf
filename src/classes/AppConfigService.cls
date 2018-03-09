/**
 * Created by cloud on 8/14/2017.
 */

public with sharing class AppConfigService {
    private static AppConfig__c testConfig = null;


    @testvisible private static AppConfig__c getApplicationConfig()
    {
        if(Test.isRunningTest() && testconfig!=null) return testConfig;

        AppConfig__c theobject = AppConfig__c.getInstance('default');

        if(theobject==null)
        {
            theobject = new AppConfig__c();
            theobject.Name = 'default';
            theobject.AppEnabled__c = true;
            theobject.TriggersEnabled__c = true;
            if(!Test.isRunningTest()) {
                Database.Insert(theobject);

            }else {
                theobject.Name = 'testConfig';
                testConfig = theobject;
                Database.Insert(testConfig);
            }
        }
        return theobject;
    }

    public static Boolean appEnabled
    {
        get
        {
            return getApplicationConfig().AppEnabled__c;
        }
    }


    public static boolean triggerEnabled
    {
        get
        {
            return getApplicationConfig().TriggersEnabled__c;
        }
    }
    
    public static Date goLiveDate
    {
        get
        {
            return getApplicationConfig().Go_Live_Date__c;
        }
    }

}

/*	public static Boolean diagnosticsEnabled
	{
		get
		{
		return GetAppConfig().EnableDiagnostics__c;
		}
	}
*/