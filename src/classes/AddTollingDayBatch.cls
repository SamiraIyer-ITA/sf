/**
 *
 *    Created by Cal Smith
 *    on 10/26/2017
 *    MIL Corporation
 *
 **/


public class AddTollingDayBatch implements Database.Batchable<sObject>{
    private final String initialState;
    private final String queryObject;
    private final String latestDate;
    public Id ADRecordType = Schema.SObjectType.Investigation__c.getRecordTypeInfosByDeveloperName().get('AD').getRecordTypeId();
    public Id CVDRecordType = Schema.SObjectType.Investigation__c.getRecordTypeInfosByDeveloperName().get('CVD').getRecordTypeId();

    public AppConfig__c app = AppConfig__c.getValues('default');

    public String queryStr1A = 'SELECT Id, Tolling_Update__c FROM Petition__c WHERE Petition_Filed__c <= ';
    public String queryStr1B = ' AND Petition_Outcome__c = null AND Locked__c = false';
    public String queryStr2A = 'SELECT Id, Petition__r.Petition_Filed__c, Tolling_Update__c FROM Investigation__c WHERE Petition__r.Petition_Filed__c <= ';
    public String queryStr2B = '  AND Investigation_Outcome__c = null AND RecordTypeId = :ADRecordType AND Locked__c = false';
    public String queryStr3A = 'SELECT Id, Petition__r.Petition_Filed__c, Tolling_Update__c FROM Investigation__c WHERE Petition__r.Petition_Filed__c <= ';
    public String queryStr3B = '  AND Investigation_Outcome__c = null AND RecordTypeId = :CVDRecordType AND Locked__c = false';
    public String queryStr4A = 'SELECT Id, Tolling_Update__c FROM Litigation__c WHERE Actual_Final_Signature__c = null AND (Draft_Remand_Issues_Due_to_DAS__c <= ';
    public String queryStr4B = ' OR Request_Filed__c <= ';
    public String queryStr4C = ') AND Locked__c = false';
    public String queryStr5A = 'SELECT Id, Tolling_Update__c FROM Segment__c WHERE Segment_Outcome__c = null AND (Application_Accepted__c <= ';
    public String queryStr5B = ' OR Final_Date_of_Anniversary_Month__c <= ';
    public String queryStr5C = ' OR Request_Filed__c <= ';
    public String queryStr5D = ' OR Calculated_Initiation_Signature__c <= ';
    public String queryStr5E = ' OR Initiation_Issues_Due_to_DAS__c <= ';
    public String queryStr5F = ' OR Prelim_Team_Meeting_Deadline__c <= ';
    public String queryStr5G = ' OR Final_Team_Meeting_Deadline__c <= ';
    public String queryStr5H = ' OR Notice_of_Intent_to_Participate__c <= ';
    public String queryStr5I = ' ) AND Locked__c = false';
    public String queryString1;
    public String queryString2;
    public String queryString3;
    public String queryString4;
    public String queryString5;
    public Map<String,String>numToObject;
    public Integer emailAllowed;
    public Id bid;
    public Id batchId;
    public Id bid1;
    @TestVisible private String query;

        public AddTollingDayBatch(String initialState, String queryObject, String latestDate) {
            this.initialState = initialState;
            this.latestDate = latestDate;
            this.queryObject = queryObject;
            System.debug('this.initialState = ' + this.initialState);
            System.debug('this.latestDate = ' + this.latestDate);
            System.debug('this.queryObject = ' + this.queryObject);

            queryString1 = queryStr1A + latestDate + queryStr1B;
            queryString2 = queryStr2A + latestDate + queryStr2B;
            queryString3 = queryStr3A + latestDate + queryStr3B;
            queryString4 = queryStr4A + latestDate + queryStr4B + latestDate + queryStr4C;
            queryString5 = queryStr5A + latestDate + queryStr5B + latestDate + queryStr5C + latestDate + queryStr5D + latestDate
                    + queryStr5E + latestDate + queryStr5F + latestDate + queryStr5G + latestDate + queryStr5H + latestDate + queryStr5I;
            System.debug('queryString1 = '+ queryString1);
            System.debug('queryString2 = '+ queryString2);
            System.debug('queryString3 = '+ queryString3);
            System.debug('queryString4 = '+ queryString4);
            System.debug('queryString5 = '+ queryString5);

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
            numToObject = new Map<String,String>();
            numToObject.put('1','Petition__c');
            numToObject.put('2','Investigation__c');
            numToObject.put('3','Investigation__c');
            numToObject.put('4','Litigation__c');
            numToObject.put('5','Segment__c');
        }


        @TestVisible  public Database.QueryLocator start(Database.BatchableContext BC) {
            bid = Test.isRunningTest()? '707000000000000AAA': BC.getJobId();
            if(initialState == '1' && numToObject.get(initialState)=='Petition__c') query = queryString1;
            if(initialState == '2' && numToObject.get(initialState)=='Investigation__c') query = queryString2;
            if(initialState == '3' && numToObject.get(initialState)=='Investigation__c') query = queryString3;
            if(initialState == '4' && numToObject.get(initialState)=='Litigation__c') query = queryString4;
            if(initialState == '5' && numToObject.get(initialState)=='Segment__c') query = queryString5;
            System.debug('query = ' + query);

            return Database.getQueryLocator(query);

        }

        public void execute(Database.BatchableContext BC,
            List<sObject> scope) {

            if(this.initialState == '1'){
                List<Petition__c>toUpdate = new List<Petition__c>();
                for(sObject s : scope){Petition__c p = (Petition__c)s;
                    p.Tolling_Update__c = !p.Tolling_Update__c;
                    toUpdate.add(p);
                }
                update toUpdate;
            } else if(this.initialState == '2'){
                List<Investigation__c>toUpdate = new List<Investigation__c>();
                for(sObject s : scope){Investigation__c n = (Investigation__c)s;
                    n.Tolling_Update__c=!n.Tolling_Update__c;
                    toUpdate.add(n);
                }
                update toUpdate;
            } else if(this.initialState == '3') {
                List<Investigation__c>toUpdate = new List<Investigation__c>();
                for (sObject s : scope) {
                    Investigation__c n = (Investigation__c) s;
                    n.Tolling_Update__c = !n.Tolling_Update__c;
                    toUpdate.add(n);
                }
                update toUpdate;
            } else if(this.initialState == '4'){
                List<Litigation__c>toUpdate = new List<Litigation__c>();
                for(sObject s : scope){Litigation__c l = (Litigation__c)s;
                    l.Tolling_Update__c=!l.Tolling_Update__c;
                    toUpdate.add(l);
                }
                update toUpdate;
            } else if(this.initialState == '5'){
                List<Segment__c>ToUpdate = new List<Segment__c>();
                for(sObject s : scope){Segment__c g = (Segment__c)s;
                    g.Tolling_Update__c=!g.Tolling_Update__c;
                    toUpdate.add(g);
                }
                update toUpdate;
            }
        }

        @TestVisible public void finish(Database.BatchableContext BC) {
            System.debug('emailAllowed = ' + emailAllowed);
            System.debug('app.Primary_Admin__c = ' + app.Primary_Admin__c);
            System.debug('app.ADCVD_Admin__c = ' + app.ADCVD_Admin__c);
            bid = Test.isRunningTest()? '707000000000000AAA': BC.getJobId();
            if(emailAllowed>1 ){
                AsyncApexJob aaj = new AsyncApexJob();
                if(bid != '707000000000000AAA'){
                    aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                        FROM AsyncApexJob WHERE Id = :bid ];
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{app.Primary_Admin__c};
                String[] ccAddresses = new String[]{app.ADCVD_Admin__c};
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
            if(Integer.valueof(initialState)<5){
                String nextInitialState = String.valueOf(Integer.valueOf(initialState) +1);
                System.debug(nextInitialState);
                String nextQueryObject = numToObject.get(nextInitialState);
                batchId = Database.executeBatch(new AddTollingDayBatch(nextInitialState, nextQueryObject, latestDate), 10);
                System.debug('Returned batch process ID: ' + batchId);
            }
                if(null != batchId) bid1 = batchId;
        }

}