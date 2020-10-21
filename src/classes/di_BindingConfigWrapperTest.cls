@isTest
public class di_BindingConfigWrapperTest {

    @isTest
    static void exerciseMethods() {
        di_BindingConfigWrapper dbc = new di_BindingConfigWrapper(
            'qualifiedAPIName'
            , 'developerName'
            , 'namespacePrefix'
            , 'type'
            , 'to'
            , 'bindingObject'
            , 'bindingObjectQualifiedApiName'
            , 'bindingObjectAlternate'
            , 10.0);
  
        dbc = new di_BindingConfigWrapper(new di_Binding__mdt());
    }
}