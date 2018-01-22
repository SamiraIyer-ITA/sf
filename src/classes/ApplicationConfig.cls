global class ApplicationConfig {

/**
*
*		Created by Cal Smith on 12/26/17
*
*		This class creates a Unit of Work Factory, a Selector Factory,
*		a Domain Factory, and a Callouts Factory for the ADCVD Application
*		along with an ApplicationException class. Its purpose is to 
*		configure the fflib classes for the ADCVD Application.
*		
*
**/

    
    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
        new fflib_Application.UnitOfWorkFactory(
                new List<SObjectType> {
                    ADCVD_Order__c.SObjectType,
                    Federal_Register__c.SObjectType,
                    Harmonized_Tariff_Schedule__c.SObjectType,
                    Investigation__c.SObjectType,
                    Litigation__c.SObjectType,
                    Petition__c.SObjectType,
                    Recusal__c.SObjectType,
                    Related_Organization__c.SObjectType,
                    Segment__c.SObjectType,
                    Staffing_Assignment__c.SObjectType,
                    Suspension_Agreement__c.SObjectType,
                    Tolling_Day__c.SObjectType,
                    User.SObjectType
                    });
    /*              
    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service = 
        new ApplicationConfig.ServiceFactory( 
            new Map<Type, Type> {
                    ADCVDService.class => ADCVDServiceImpl.class });
                    
*/    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector = 
        new fflib_Application.SelectorFactory(
            // Map SObjectType to Selector Class
            new Map<SObjectType, Type> {
            //      ADCVD_Order__c.SObjectType => ADCVD_OrdersSelector.class,
            //      Federal_Register__c.SObjectType => Federal_RegistersSelector.class,
            //      Harmonized_Tariff_Schedule__c.SObjectType => Harmonized_Tariff_SchedulesSelector.class,
            //      Investigation__c.SObjectType => InvestigationsSelector.class,
            //      Litigation__c.SObjectType => LitigationsSelector.class,
            //      Petition__c.SObjectType => PetitionsSelector.class,
                    Recusal__c.SObjectType => RecusalsSelector.class,
                    Related_Organization__c.SObjectType => RelatedOrganizationsSelector.class 
            //      ,
            //      Segment__c.SObjectType => SegmentsSelector.class,
            //      Staffing_Assignment__c.SObjectType => Staffing_AssignmentsSelector.class,
            //      Suspension_Agreement__c.SObjectType => Suspension_AgreementsSelector.class,
            //      Tolling_Day__c.SObjectType => TollingDaysSelector.class,
                    });
                    
    // Configure and create the DomainFactory for this Application
    public static final fflib_Application.DomainFactory Domain = 
        new fflib_Application.DomainFactory(
            Selector,
            // originally above was Application.Selector but wouldn't compile
            // Map SObjectType to Domain Class Constructors 
            new Map<SObjectType, Type> {
            //      ADCVD_Order__c.SObjectType => Orders.Constructor.class,
            //      Federal_Register__c.SObjectType => Federal_Registers.Constructor.class,
            //      Harmonized_Tariff_Schedule__c.SObjectType => Harmonized_Tariff_Schedules.Constructor.class,
            //      Investigation__c.SObjectType => Investigations.Constructor.class,
            //      Litigation__c.SObjectType => Litigations.Constructor.class,
            //      Petition__c.SObjectType => Petitions.Constructor.class,
            //      Recusal__c.SObjectType => Recusals.Constructor.class,
            //      Related_Organization__c.SObjectType => RelatedOrganizations.Constructor.class
            //      ,
            //      Segment__c.SObjectType => Segments.Constructor.class,
            //      Staffing_Assignment__c.SObjectType => Staffing_Assignments.Constructor.class,
            //      Suspension_Agreement__c.SObjectType => Suspension_Agreements.Constructor.class,
            //      Tolling_Day__c.SObjectType => Tolling_Day.Constructor.class,
                    }
            );
                    
    // Create an instance of the Callouts factory
    public static final CalloutFactory Callouts = new CalloutFactory();
           
    // Customised Service factory to support developer overrides via Custom Metadata (see Chapter 5)      
    private class ServiceFactory extends fflib_Application.ServiceFactory {
        
        private Map<String, String> servicesByClassName = new Map<String, String>();
        
        public ServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType) {
            super(serviceInterfaceTypeByServiceImplType);
            
            // Map of overriden services defined by the developer in this org
            for(SService__mdt serviceOverride : 
                    [select DeveloperName, NamespacePrefix, ApexClass__c from SService__mdt]) {
                servicesByClassName.put(
                    serviceOverride.NamespacePrefix + '.' + serviceOverride.DeveloperName, 
                    serviceOverride.ApexClass__c);                
            } 
        }
        
        // public override Object newInstance(Type serviceInterfaceType) {
            
            // Has the developer overriden the Service implementaiton in their org?
        /*    if(!Test.isRunningTest() && servicesByClassName.containsKey(serviceInterfaceType.getName())) {
                String overridenServiceImpl = servicesByClassName.get(serviceInterfaceType.getName());
                return Type.forName(overridenServiceImpl).newInstance();
            }
            
       // problem here -->>     // Default Service Factory returns mocked or registered default implementation
            return super.newInstance(serviceInterfaceType);    
        } */       
    }

    /**
     * Simple factory class around the Callouts Custom Metadata type 
     **/    
    public class CalloutFactory {
        
        private Map<Type, Type> calloutsByInterface = new Map<Type, Type>();
        
        /**
         * Returns the registered implementation of the given interface
         **/
        public Object newInstance(Type interfaceType) {
            if(calloutsByInterface==null) {
                calloutsByInterface = new CalloutsSelector().selectAllCallouts();                
            }
            return calloutsByInterface.get(interfaceType);
        }
    } 
    
    global enum ExceptionCode
    {
        NotImplemented,
        ComplianceFailure,
        UnableToVerifyCompliance
    }       

    global virtual class ApplicationException extends Exception 
    {
        global ExceptionCode ExceptionCode {get; private set;}

        public ApplicationException(ExceptionCode exceptionCode, String message)
        {
            this(message);
            this.exceptionCode = exceptionCode;
        }
    }       
}
