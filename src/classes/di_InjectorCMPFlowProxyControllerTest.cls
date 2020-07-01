@isTest
private with sharing class di_InjectorCMPFlowProxyControllerTest {
    
    @isTest
    static void exerciseMethods() {
        di_InjectorComponentFlowProxyController injector = new di_InjectorComponentFlowProxyController();
        injector.FlowNameValue = 'Return_Hello_World';
        Map<Object,Object> inputs = new Map<Object,Object>{(Object)'myKey'=>(Object)'myValue'};
        injector.InputVariablesValue = inputs;
        injector.getInject();
    }

    @isTest
    private static void givenValueWhenGetInjectThenThrowException(){
        String FlowNameValue = 'AccountRecordFlow';
        Object InputVariablesValue = 'Account';
        di_InjectorComponentFlowProxyController newObj = new di_InjectorComponentFlowProxyController();
        try {
        newObj.getInject();
        } catch(Exception e){
            System.assertEquals(e.getMessage().contains('Invalid value for property name'), true, 'correct Exception is thrown');
        }
    }

}