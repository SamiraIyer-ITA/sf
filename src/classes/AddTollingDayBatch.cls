/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 **/


public class AddTollingDayBatch implements Database.Batchable<sObject>{
private final String initialState;
private final string queryObject;
private final string latestDate;
    
@TestVisible public AppConfig__c app = AppConfig__c.getValues('default'); 

public string queryStr1A = 'SELECT Id, Tolling_Update__c FROM Petition__c WHERE Petition_Filed__c <= ';
public string queryStr1B = ' AND Petition_Outcome__c = null AND Locked__c = false';
public string queryStr2A = 'SELECT Id, Petition__r.Petition_Filed__c, Tolling_Update__c FROM Investigation__c WHERE Petition__r.Petition_Filed__c <= ';
public string queryStr2B = '  AND Investigation_Outcome__c = null AND Locked__c = false';
public string queryStr3A = 'SELECT Id, Tolling_Update__c FROM Litigation__c WHERE Actual_Final_Signature__c = null AND (Draft_Remand_Issues_Due_to_DAS__c <= ';
public string queryStr3B = ' OR Request_Filed__c <= '; 
public string queryStr3C = ') AND Locked__c = false';
public string queryStr4A = 'SELECT Id, Tolling_Update__c FROM Segment__c WHERE Segment_Outcome__c = null AND (Application_Accepted__c <= ';
public string queryStr4B = ' OR Final_Date_of_Anniversary_Month__c <= ';
public string queryStr4C = ' OR Request_Filed__c <= ';
public string queryStr4D = ' OR Calculated_Initiation_Signature__c <= ';
public string queryStr4E = ' OR Initiation_Issues_Due_to_DAS__c <= ';
public string queryStr4F = ' OR Prelim_Team_Meeting_Deadline__c <= ';
public string queryStr4G = ' OR Final_Team_Meeting_Deadline__c <= ';
public string queryStr4H = ' ) AND Locked__c = false';
string query;
public string queryString1;
public string queryString2;
public string queryString3;
public string queryString4;
public map<string,string>numToObject;
public integer emailAllowed;  
@TestVisible public Id bid;
@TestVisible public Id batchId;
@TestVisible public Id bid1;

    

    public AddTollingDayBatch(String initialState, string queryObject, string latestDate) {
        this.initialState = initialState;
        this.latestDate = latestDate;
        this.queryObject = queryObject;
        system.debug('this.initialState = ' + this.initialState);
        system.debug('this.latestDate = ' + this.latestDate);
        system.debug('this.queryObject = ' + this.queryObject);
        
        queryString1 = queryStr1A + latestDate + queryStr1B;
        queryString2 = queryStr2A + latestDate + queryStr2B;
        queryString3 = queryStr3A + latestDate + queryStr3B + latestDate + queryStr3C;
        queryString4 = queryStr4A + latestDate + queryStr4B + latestDate + queryStr4C + latestDate + queryStr4D + latestDate 
                + queryStr4E + latestDate + queryStr4F + latestDate + queryStr4G + latestDate + queryStr4H;
        system.debug('queryString1 = '+ queryString1);
        system.debug('queryString2 = '+ queryString1);
        system.debug('queryString3 = '+ queryString1);
        system.debug('queryString4 = '+ queryString1);

        getNumToObject();
        checkLimits();        
    }


    public void checkLimits(){
        Integer emailMax = limits.getLimitEmailInvocations();
        Integer emailActual = limits.getEmailInvocations();
        emailAllowed = emailMax - emailActual;
        if(emailAllowed > 2 && !Test.isRunningTest()) Messaging.reserveSingleEmailCapacity(2);
    }

    public void getNumToObject(){
        numToObject = new map<string,string>();
        numToObject.put('1','Petition__c');
        numToObject.put('2','Investigation__c');
        numToObject.put('3','Litigation__c');
        numToObject.put('4','Segment__c');      
    }


    @TestVisible  public Database.QueryLocator start(Database.BatchableContext BC) {
        bid = Test.isRunningTest()? '707000000000000AAA': BC.getJobId();
        If(initialState == '1' && numToObject.get(initialState)=='Petition__c') query = queryString1; 
        If(initialState == '2' && numToObject.get(initialState)=='Investigation__c') query = queryString2;
        If(initialState == '3' && numToObject.get(initialState)=='Litigation__c') query = queryString3;
        If(initialState == '4' && numToObject.get(initialState)=='Segment__c') query = queryString4;       
		system.debug('query = ' + query);
        
        return Database.getQueryLocator(query);

    }


    public void execute(Database.BatchableContext BC,
        List<sObject> scope) {
        
        if(this.initialState == '1'){ 
            list<Petition__c>ToUpdate = new list<Petition__c>();
            for(sObject s : scope){Petition__c p = (Petition__c)s;
                p.Tolling_Update__c = !p.Tolling_Update__c;   
                ToUpdate.add(p);    
            }
            update toupdate;    
        } else if(this.initialState == '2'){ 
            list<Investigation__c>ToUpdate = new list<Investigation__c>();
            for(sObject s : scope){Investigation__c n = (Investigation__c)s;
                n.Tolling_Update__c=!n.Tolling_Update__c;
                ToUpdate.add(n);    
            }
            update toupdate;    
        } else if(this.initialState == '3'){ 
            list<Litigation__c>ToUpdate = new list<Litigation__c>();
            for(sObject s : scope){Litigation__c l = (Litigation__c)s;
                l.Tolling_Update__c=!l.Tolling_Update__c;
                ToUpdate.add(l);    
            }
            update toupdate;    
        }else if(this.initialState == '4'){ 
            list<Segment__c>ToUpdate = new list<Segment__c>();
            for(sObject s : scope){Segment__c g = (Segment__c)s;
                g.Tolling_Update__c=!g.Tolling_Update__c;
                ToUpdate.add(g);    
            }
            update toupdate;    
        }
                        
    }

    @TestVisible public void finish(Database.BatchableContext BC) {
        system.debug('emailAllowed = ' + emailAllowed);
        system.debug('app.Primary_Admin__c = ' + app.Primary_Admin__c);
        system.debug('app.ADCVD_Admin__c = ' + app.ADCVD_Admin__c);
        bid = Test.isRunningTest()? '707000000000000AAA': BC.getJobId();
        if(emailAllowed>1 ){
        	AsyncApexJob aaj = new AsyncApexJob();
        	if(bid != '707000000000000AAA'){
            	aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                	FROM AsyncApexJob WHERE Id = :bid ];
        	}   
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{app.Primary_Admin__c};
            string[] ccAddresses = new string[]{app.ADCVD_Admin__c}; 
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            mail.setReplyTo('noreply@trade.gov');
            mail.setSenderDisplayName('Tolling Day Batch Processing Job number ' + aaj.Id );
            mail.setSubject('Tolling Day Batch Process Completed');
            mail.setPlainTextBody('Batch Process ' + aaj.Id + ' has completed on '+ numToObject.get(initialState) + ' object records with a Status of ' + aaj.Status + 
            '. There were ' + aaj.JobItemsProcessed + ' job items processed with ' + aaj.NumberOfErrors + ' errors.'  );
            if (!Test.isRunningTest()) {Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}
        }
        
        // start next job
        if(integer.valueof(initialState)<4){
            string nextInitialState = string.valueOf(integer.valueOf(initialState) +1);
            system.debug(nextInitialState);
            string nextQueryObject = numToObject.get(nextInitialState);
            batchId = Database.executeBatch(new AddTollingDayBatch(nextInitialState, nextQueryObject, latestDate));
            System.debug('Returned batch process ID: ' + batchId);
        }
 			if(null != batchId) bid1 = batchId;
    }

}