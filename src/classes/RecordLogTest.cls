@IsTest
private class RecordLogTest {

    @IsTest
    public static void logTest() {
        RecordLog.push('MyClass.methodA');
        insert new Account(Name = 'Test');
        RecordLog.push('MyClass.methodB');
        RecordLog.message('Doing something');
        insert new Account(Name = 'Test');
        RecordLog.pop();
        List<Account> accounts = [select Id from Account];
        RecordLog.message('Doing something more');
        RecordLog.pop();
	}
}