public class SafeDMLHandler {
	public static Boolean safeUpsert(List<sObject> sObjList, Boolean fromPage) {
		Boolean successful = true;
		try {
            upsert sObjList;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeUpsert(sObject sObj, Boolean fromPage) {
		Boolean successful = true;
		try {
            upsert sObj;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeInsert(List<sObject> sObjList, Boolean fromPage) {
		Boolean successful = true;
		try {
            insert sObjList;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeInsert(sObject sObj, Boolean fromPage) {
		Boolean successful = true;
		try {
            insert sObj;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeDelete(List<sObject> sObjList, Boolean fromPage) {
		Boolean successful = true;
		try {
            delete sObjList;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeDelete(sObject sObj, Boolean fromPage) {
		Boolean successful = true;
		try {
            delete sObj;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeUpdate(List<sObject> sObjList, Boolean fromPage) {
		Boolean successful = true;
		try {
            update sObjList;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
	public static Boolean safeUpdate(sObject sObj, Boolean fromPage) {
		Boolean successful = true;
		try {
            update sObj;
        } catch (exception e) {
        	successful = false;
        	if(fromPage) {
            	ExceptionHandler.handlePageException(e);
            }
        }
        return successful;
	}
}