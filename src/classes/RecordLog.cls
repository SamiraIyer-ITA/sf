/**
        //Example usage
        RecordLog.push('MyClass.methodA');
        RecordLog.message('Some message1');
        RecordLog.message('Another message1');
        RecordLog.push('MyClass.methodB');
        RecordLog.message('Some message2');
        RecordLog.message('Another message2');
        RecordLog.pop();
        RecordLog.push('MyClass.methodC');
        RecordLog.message('Some message3');
        RecordLog.message('Another message3');
        RecordLog.emit(relatedRecordId);
**/

/**
 * In-memory low CPU logging
 **/
public class RecordLog {

    private static LogScope current;
    private static LogScope root;
    private static final String SEPARATOR = '~';

    static {
        reset();
    }

	/**
	 * Push this named scope onto the log stack
	 **/    
    public static void push(String scope) {
		LogScope newScope = new LogScope();
        newScope.scope = scope;
		newScope.parent = RecordLog.current;
        RecordLog.current.logEntries.add(newScope);
		RecordLog.current = newScope;
    }

    /**
     * Add the given message to the scope last pushed
     **/
    public static void message(String message) {
        RecordLog.current.logEntries.add(message);
    }
    
    /**
     * Pop the current scope
     **/
    public static void pop() {
     	RecordLog.current = RecordLog.current.parent;
    }

	/**
	 * Flush the log entries and serialize 
	 **/    
    public static String flush() {
        List<String> logLines = new List<String>();
        logLines.add(RecordLog.root.scope);
        RecordLog.root.flush(logLines, 1);
        reset();
		return String.join(logLines, '/n');        
    }
    
    /**
     * Emits the current log state to the Record_Log_Event__e platform event
     **/
    public static void emit(String relatedRecordId) {
        //relatedRecordId can be a record Id or some other id, such as the agency tracking id that's used for Payments

        // RecordLog title is primarily present to allow filtering
        String title = RecordLog.root.scope;
        if(RecordLog.root.logEntries.size()>0) {
	        Object top = RecordLog.root.logEntries[0];
            if(top instanceof LogScope) {
				LogScope logScope = (LogScope) top;
                title = logScope.scope;
            } else if (top instanceof String) {
				title = (String) top;                
            }
        }
        
        // Emit the log data via Platform Events
        EventBus.publish(
            new Record_Log_Event__e(
                Title__c = title,
                Related_Record_Id__c = relatedRecordId,
                Data__c = flush()));
    }    
    
    /**
     * Resets the log state
     **/
    private static void reset() {
        root = current = new LogScope();
        DateTime now = DateTime.now();
        current.scope = now.format('M/d/yyyy h:mm:ss:SSS a', 'EST');
    }
    
    /**
     * Nested log scopes
     **/
    private class LogScope {
        
        public LogScope parent;
        public String scope;
        public List<Object> logEntries = new List<Object>();
        
        public void flush(List<String> logLines, Integer indent) {
            for(Object logEntry : logEntries) {
                if(logEntry instanceof LogScope) {
					LogScope logScope = (LogScope) logEntry;
                    logLines.add(indent+SEPARATOR+logScope.scope);
					logScope.flush(logLines, indent+1);
                } else {
					logLines.add(indent+SEPARATOR+logEntry);
                }
            }
        }
    }    
}