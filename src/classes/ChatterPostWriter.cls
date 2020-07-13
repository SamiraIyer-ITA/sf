/**
 * 
 *    Created by Joshua Moody & Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/
//virtual base class for the inner classes.
public virtual class ChatterPostWriter implements IChatterPostWriter {
    
    //user who sends posts from System
    private static Id adminId = [SELECT Id FROM User WHERE Name =: 'Jennifer Moats' LIMIT 1].Id;
    
    //static map of SObject specific class instances
    public static Map<String,IChatterPostWriter> chatterWriterMap;
    
    static {
        chatterWriterMap = new Map<String,IChatterPostWriter>();
        chatterWriterMap.put('Petition__c', (IChatterPostWriter)new PetitionChatterPostWriter());
        chatterWriterMap.put('Investigation__c', (IChatterPostWriter)new InvestigationChatterPostWriter());
        chatterWriterMap.put('Segment__c', (IChatterPostWriter)new SegmentChatterPostWriter());
        chatterWriterMap.put('Federal_Register__c', (IChatterPostWriter)new FederalRegisterChatterPostWriter());
    }
    
    public class ChatterPostWriterNameException extends Exception{}
    //instance of interface
    private IChatterPostWriter iWriter;
    //empty constructor of this class
    public ChatterPostWriter(){}
    //map that will hold posts that use the traditional posting method
    public static Map<Id, List<String>> idToFinishedPostMap = new Map<Id, List<String>>();
    //map that will hold posts that must be posted in two parts to set the sender
    public static Map<Id, List<String>> idToTempPostMap = new Map<Id, List<String>>();

    //method for returning either all or unlocked cases
    public Map<Id, List<String>> getMap(Boolean includeTemp) {
        if (includeTemp) {
            return idToTempPostMap;
        } else {
            return idToFinishedPostMap;
        }
    }


    //constructor used to cast the interface instance to a concrete class and call the main class method
    public ChatterPostWriter (String sObjectName, Map<Id,SObject> newMap, Map<Id,SObject> oldMap) {
        if (!chatterWriterMap.containsKey(sObjectName)) throw new ChatterPostWriterNameException(sObjectName);
        iWriter = chatterWriterMap.get(sObjectName);
        Map<Id,SObject> tempMap = newMap.clone();
        tempMap = removeBatchedRecords(tempMap, oldMap);
        //make the posts
        if (!tempMap.isEmpty()) {
            initialize(tempMap, sObjectName);
            iWriter.getChatterPosts(tempMap, oldMap);
            separatePostCall();
        }
    }
    /**
     * 
     *
     * @param newMap
     * @param oldMap
     *
     * @return
     */
    @TestVisible private Map<Id, SObject> removeBatchedRecords(Map<Id,SObject> newMap, Map<Id,SObject> oldMap) {
        //tolling update change = remove
        for (Id i : newMap.keySet()) {
            //not an insert because oldMap is populated with this SObject and Tolling_Update__c changed means this is a batch process
            if (oldMap != null && oldMap.get(i) != null && newMap.get(i).get('Tolling_Update__c') != oldMap.get(i).get('Tolling_Update__c')) {
                newMap.remove(i);
            }
        }
        return newMap;
    }
    /**
     * 
     *
     * @param sObjectName
     */
    @TestVisible private void initialize(Map<Id, SObject> newMap, String sObjectName) {
        //initialized map of all staffing assignments in scope for all parent records
        if (sObjectName != 'Federal_Register__c') {
            StaffingAssignmentsSelector.setParentIdsToStaffLists(newMap.keySet(), sObjectName);
        }
    }
    /**
     * 
     *
     * @param newMap
     * @param oldMap
     */
    public void getChatterPosts(Map<Id,SObject> newMap, Map<Id,SObject> oldMap) {
        for (Id newId : newMap.keySet()) {
            SObject newRecord = newMap.get(newId);
            SObject oldRecord = oldMap != null && oldMap.get(newId) != null ? oldMap.get(newId) : null;
            checkConditions(newRecord, oldRecord);
        }
    }
    /**
     * 
     */
    public void separatePostCall() {
        //post
        if (!Test.isRunningTest()) {
            if (!idToTempPostMap.isEmpty()) postToChatter(idToTempPostMap, true);
            if (!idToFinishedPostMap.isEmpty()) postToChatter(idToFinishedPostMap);
        }
    }
    /**
     * 
     *
     * @param postMap
     * @param tempMap
     */
    public void postToChatter(Map<Id, List<String>> postMap, Boolean tempMap) {
        if (tempMap) {
            for (Id recordId : postMap.keySet()) {
                for (String post : postMap.get(recordId)) {//up to 1 post per record if all conditions are met
                    FeedItem fi = new FeedItem(CreatedById = adminId, Body = 'Temporary Post - ChatterPostService', ParentId = recordId);
                    insert fi;
                    ConnectApi.FeedItem cafi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(Network.getNetworkId(), recordId, post, fi.Id);
                }
            }
        } else {
            postToChatter(postMap);
        }
    }
    /**
     * 
     *
     * @param postMap
     */
    public void postToChatter(Map<Id, List<String>> postMap) {
        for (Id recordId : postMap.keySet()) {
            for (String post : postMap.get(recordId)) {//up to 3 posts per record if all conditions are met
                ConnectApi.FeedItem cafi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(Network.getNetworkId(), recordId, post, '');
            }
        }
    }
    /**
     * 
     *
     * @param newRecord
     * @param oldRecord
     */
    public virtual void checkConditions(SObject newRecord, SObject oldRecord) {}
    /**
     * 
     *
     * @param sObjectName
     *
     * @return
     */
    public Map<String, Automated_Chatter_Post__mdt> getPostsMap(String sObjectName) {
        Map<String, Automated_Chatter_Post__mdt> returnMap = new Map<String, Automated_Chatter_Post__mdt>();
        for (Automated_Chatter_Post__mdt acp : CustomMetadataSelector.getPostsList(sObjectName)) {
            returnMap.put(acp.Posting_Condition__c, acp);
        }
        return returnMap;
    }
    /**
     * 
     *
     * @param fieldName
     * @param newRecord
     * @param oldRecord
     *
     * @return
     */
    public Map<String, String> fieldChanged(String fieldName, SObject newRecord, SObject oldRecord) {
        Map<String, String> fieldMap = new Map<String, String>();//return value
        String oldFieldValue = String.valueOf(oldRecord.get(fieldName) != null ? oldRecord.get(fieldName): 0);
        String newFieldValue = String.valueOf(newRecord.get(fieldName) != null ? newRecord.get(fieldName): 0);

        if(!newFieldValue.equals(oldFieldValue)) {
            fieldMap.put(newFieldValue, oldFieldValue);
        }
        return fieldMap;
    }
    /**
     * 
     *
     * @param extType
     * @param newToOldValueMap
     *
     * @return
     */
    public String addExtensionChangeToPost(String extType, Map<String, String>newToOldValueMap) {
        String oldValue = '';
        String newValue = '';
        for(String key : newToOldValueMap.keySet()) {
            newValue = key;
            oldValue = newToOldValueMap.get(key);
            break;
        }
        return '<p>' + extType + ' Extension Number of Days changed from ' + oldValue + ' to ' + newValue + '</p>';
    }
    /**
     * 
     *
     * @param fieldNameToLabelMap
     * @param newRecord
     *
     * @return
     */
    public String addExtensionResultToPost(Map<String, String> fieldNameToLabelMap, SObject newRecord) {
        String fieldName = '';
        String fieldLabel = '';
        for(String key : fieldNameToLabelMap.keySet()) {
            fieldName = key;
            fieldLabel = fieldNameToLabelMap.get(key);
            break;
        }
        return '<p>The '+ fieldLabel + ' date is: <b>' + ((Date)newRecord.get(fieldName)).format() + '</b></p>';
    }
    /**
     * 
     *
     * @param newRecord
     * @param oldRecord
     *
     * @return
     */
    public String getLitigationStateChange(SObject newRecord, SObject oldRecord) {
        //evaluation as states so if both fields change but the result is the same state, no message sent
        Boolean oldLitigationState = false;
        Boolean newLitigationState = false;
        if (oldRecord.get('Litigation_YesNo__c') == 'Yes' && oldRecord.get('Litigation_Resolved__c') != 'Yes') {
            oldLitigationState = true;
        }
        if (newRecord.get('Litigation_YesNo__c') == 'Yes' && newRecord.get('Litigation_Resolved__c') != 'Yes') {
            newLitigationState = true;
        }
        //old and new are both litigated or both not litigated/resolved
        if (oldLitigationState == newLitigationState) {return 'No Change';}
        if (!newLitigationState) {
            return ' is not being litigated.';
        } else {
            return ' is being litigated.';
        }
    }
    /**
     * 
     *
     * @param extType
     * @param newToOldValueMap
     *
     * @return
     */
    public String addAlignmentChangeToPost(Map<String, String>newToOldValueMap) {
        String oldValue = '';
        String newValue = '';
        for(String key : newToOldValueMap.keySet()) {
            newValue = key;
            oldValue = newToOldValueMap.get(key);
            break;
        }
        String changeType = newValue == null ? 'removed' : 'added';
        return 'Alignment has been ' + changeType;
    }
    /**
     * 
     *
     * @param newRecord
     * @param postTemplate
     *
     * @return
     */
    public virtual String addTemplateWithCaseInfo(SObject newRecord, Automated_Chatter_Post__mdt postTemplate) {
        String messageTemplate = postTemplate.Feed_Item_Message__c;
        String mentionedRecord = '@record';
        String updatedMessageTemplate = messageTemplate.replace(mentionedRecord, setCaseInformation(newRecord));

        return updatedMessageTemplate;
    }
    /**
     * 
     *
     * @param newRecord
     *
     * @return
     */
    public virtual String setCaseInformation(SObject newRecord) {
        return (String)newRecord.get('ADCVD_Case_Number_Text__c') + '--' + (String)newRecord.get('Name') +', '+(String)newRecord.get('Product_Short_Name_Text__c')+' from ' + (String)newRecord.get('Country_Text__c');
    }
    /**
     * 
     *
     * @param templateWithCaseInfo
     * @param detailsFromRecord
     * @param newRecord
     * @param useTempPostingMethod
     */
    public virtual void finishPost(String templateWithCaseInfo, String detailsFromRecord, SObject newRecord, Boolean useTempPostingMethod) {
        String finishedPost = templateWithCaseInfo;
        finishedPost += detailsFromRecord;
        finishedPost += addLinkToPost(newRecord);
        //replace titles mentioned in template with userIds
        finishedPost = mentionChatterRecipients(newRecord, finishedPost);
        //add finished post to map for posting
        addPostToPostMap(finishedPost, newRecord, useTempPostingMethod);
    }
    /**
     * 
     *
     * @param newRecord
     *
     * @return
     */
    public virtual String addLinkToPost(SObject newRecord) {
        return '<p>' + 'Link to record: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + (Id)newRecord.get('Id') + '</p>';//add message about changes and link
    }
    /**
     * 
     *
     * @param newRecord
     * @param post
     *
     * @return
     */
    public String mentionChatterRecipients(SObject newRecord, String post) {
        return addUserIdsToPost(
            getRoleToUserIdListMap(newRecord, post),
            post
        );
    }
    /**
     * 
     *
     * @param newRecord
     * @param post
     *
     * @return
     */
    @TestVisible private Map<String, List<Id>> getRoleToUserIdListMap(SObject newRecord, String post) {
        Id parentId = (Id) newRecord.get('Id');
        Map<String, List<Id>> returnMap = new Map<String, List<Id>>();
        if (StaffingAssignmentsSelector.parentIdsToStaffLists != null && !StaffingAssignmentsSelector.parentIdsToStaffLists.isEmpty()) {
            for (Staffing_Assignment__c sa : StaffingAssignmentsSelector.parentIdsToStaffLists.get(parentId)) {//iterate through the staff lists for each parent record
                List<Id> tempList = new List<Id>();
                if (returnMap.get(sa.Title__c) != null) {
                    tempList = returnMap.get(sa.Title__c);
                }
                if (sa.User__c != null) {
                    tempList.add(sa.User__c);
                } else {
                    post.remove('@' + sa.Title__c);
                }
                returnMap.put(sa.Title__c, tempList);
            }
        }
        if (post.contains('CurrentUser')) {
            returnMap.put('CurrentUser', new List<Id>{
                UserInfo.getUserId()
            });
        }
        return returnMap;
    }
    /**
     * 
     *
     * @param roleToUserIdListMap
     * @param post
     *
     * @return
     */
    @TestVisible private String addUserIdsToPost(Map<String, List<Id>> roleToUserIdListMap, String post) {
        for (String role : roleToUserIdListMap.keySet()) {
            //Initialize variables to search for when replacing
            String mentionedRole = '@' + role;
            String replacementUserIds = '';

            if (!post.contains(mentionedRole)) {
                continue;
            }//if that role is not present in post from metadata, skip to next role

            for (Id userId : roleToUserIdListMap.get(role)) {
                if(!String.isBlank(replacementUserIds)) {
                    replacementUserIds += ', {' + userId + '}';
                } else {
                    replacementUserIds = '{' + userId + '}';
                }
            }
            post = post.replace(mentionedRole, replacementUserIds);
        }
        return post;
    }
    /**
     * 
     *
     * @param finishedPost
     * @param newRecord
     * @param tempMap
     */
    public void addPostToPostMap(String finishedPost, SObject newRecord, Boolean tempMap) {
        Id recordId = (Id) newRecord.get('Id');
        if(tempMap) {
            List<String> tempList = new List<String>();
            if (idToTempPostMap.get(recordId) != null) {tempList.addAll(idToTempPostMap.get(recordId));}
            tempList.add(finishedPost);
            idToTempPostMap.put(recordId, tempList);
        } else {
            List<String> tempList = new List<String>();
            if (idToFinishedPostMap.get(recordId) != null) {tempList.addAll(idToFinishedPostMap.get(recordId));}
            tempList.add(finishedPost);
            idToFinishedPostMap.put(recordId, tempList);
        }
    }    
}