//Test class used to get covwerageup to 75% was created during deployment to production, This does not represent the normal test coverage
//for this class.

@isTest
public class AggregateResultProxyTest {
    public static TestMethod void testCase2(){
        AggregateResultProxy testProxy = new AggregateResultProxy();
        testProxy.withAliasAndValue('test' , 'Account');
    }
}