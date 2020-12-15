/***********************************************************************
Description:
1. This class queries for all ADCVD Case related sObject: Petition, Investigation, ADCVD Orders,
Segments, Suspension Agreements, Litigation, Recusals, Harmonized Tariff Schedules, and Staffing Assignments.
2. For each related object it copies the data from the ADCVD Case Standard fields to their counterparts on each related object.
For example, take ADCVD Case Type from an ADCVD Case record, and copy that type into the related ADCVD_Case_Type_Text__c field down stream.
3. In the finish method, send an email to eitan.alfiya@trade.gov, and the user who initiated the process to keep track of successful updates.
4. Batch class uses Database.Stateful to keep the state of recordIdToErrorMap throughout all the batches, and use it in the finish method.
 *********************************************************************************************/

global class ADCVDStandardCaseFieldsBatch implements Database.Batchable<SObject>, Database.Stateful{

    private Set<Id> adcvdCaseIds = new Set<Id>();
    global Map<Set<Id>, String> recordIdToErrorMap = new Map<Set<Id>, String>();

    public ADCVDStandardCaseFieldsBatch(List<ADCVD_Case__c> newList){
        for(ADCVD_Case__c adcvdCase: newList){
            adcvdCaseIds.add(adcvdCase.Id);
        }
    }
    global List<ADCVD_Case__c> start(Database.BatchableContext bc) {
        ADCVD_CaseSelector newSelector = new ADCVD_CaseSelector();
        return newSelector.selectByIdWithRelations(adcvdCaseIds);
    }

    global void execute(Database.BatchableContext bc, List<ADCVD_Case__c> scope){
        //Create object maps to be used later
        Map<Id, ADCVD_Case__c> caseToIdMap = new Map<Id, ADCVD_Case__c>();
        //List for each related object
        List<Petition__c> petitionsList = new List<Petition__c>();
        List<Investigation__c> investigationsList = new List<Investigation__c>();
        List<ADCVD_Order__c> ordersList = new List<ADCVD_Order__c>();
        List<Suspension_Agreement__c> suspensionAgreementsList = new List<Suspension_Agreement__c>();
        List<Segment__c> segmentsList = new List<Segment__c>();
        List<Litigation__c> litigationsList = new List<Litigation__c>();
        List<Federal_Register__c> federalRegistersList = new List<Federal_Register__c>();
        List<Staffing_Assignment__c> staffingAssignmentsList = new List<Staffing_Assignment__c>();
        List<Related_Organization__c> relatedOrganizationsList = new List<Related_Organization__c>();
        List<Custom_Instruction__c> customInstructionsList = new List<Custom_Instruction__c>();
        List<Harmonized_Tariff_Schedule__c> harmonizedTariffSchedulesList = new List<Harmonized_Tariff_Schedule__c>();
        //Populating related objects lists
        for(ADCVD_Case__c adcvdCaseObj: scope){
            caseToIdMap.put(adcvdCaseObj.Id, adcvdCaseObj);
            petitionsList.addALL(adcvdCaseObj.Petitions__r);
            investigationsList.addALL(adcvdcaseObj.Investigations__r);
            ordersList.addALL(adcvdCaseObj.ADCVD_Orders__r);
            suspensionAgreementsList.addALL(adcvdCaseObj.Suspension_Agreements__r);
            segmentsList.addAll(adcvdCaseObj.Segments__r);
            litigationsList.addAll(adcvdCaseObj.Litigation__r);
            federalRegistersList.addAll(adcvdCaseObj.Federal_Registers__r);
            staffingAssignmentsList.addAll(adcvdCaseObj.Staffing_Assignments__r);
            relatedOrganizationsList.addAll(adcvdCaseObj.Interested_Organizations__r);
            customInstructionsList.addAll(adcvdCaseObj.Custom_Instructions__r);
            harmonizedTariffSchedulesList.addAll(adcvdCaseObj.Harmonized_Tariff_Schedules__r);
        }

        //Updating records with the getRecordsToUpdate method, dynamic method which can be used for all types of objects
        if(!petitionsList.IsEmpty()){
            Set<Id> allPetitionIds = new Set<Id>();
            for(Petition__c petition: petitionsList){
                allPetitionIds.add(petition.Id);
            }
            List<Petition__c> petitionsToUpdate = getRecordsToUpdate(petitionsList, caseToIdMap);
            //update petitionsToUpdate;
            List<Database.SaveResult> saveResults = Database.update(petitionsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allPetitionIds));
        }

        if(!investigationsList.IsEmpty()){
            Set<Id> allInvestigationIds = new Set<Id>();
            for(Investigation__c investigation: investigationsList){
                allInvestigationIds.add(investigation.Id);
            }
            List<Investigation__c> investigationsToUpdate = getRecordsToUpdate(investigationsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(investigationsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allInvestigationIds));
        }

        if(!ordersList.IsEmpty()){
            Set<Id> allOrderIds = new Set<Id>();
            for(ADCVD_Order__c order: ordersList){
                allOrderIds.add(order.Id);
            }
            List<ADCVD_Order__c> ordersToUpdate = getRecordsToUpdate(ordersList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(ordersToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allOrderIds));
        }

        if(!suspensionAgreementsList.IsEmpty()){
            Set<Id> allSuspensionAgreementIds = new Set<Id>();
            for(Suspension_Agreement__c suspensionAgreement: suspensionAgreementsList){
                allSuspensionAgreementIds.add(suspensionAgreement.Id);
            }
            List<Suspension_Agreement__c> suspensionAgreementsToUpdate = getRecordsToUpdate(suspensionAgreementsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(suspensionAgreementsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allSuspensionAgreementIds));
        }

        if(!segmentsList.IsEmpty()){
            Set<Id> allSegmentIds = new Set<Id>();
            for(Segment__c segment: segmentsList){
                allSegmentIds.add(segment.Id);
            }
            List<Segment__c> segmentsToUpdate = getRecordsToUpdate(segmentsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(segmentsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allSegmentIds));
        }

        if(!litigationsList.IsEmpty()){
            Set<Id> allLitigationIds = new Set<Id>();
            for(Litigation__c litigation: litigationsList){
                allLitigationIds.add(litigation.Id);
            }
            List<Litigation__c> litigationsToUpdate = getRecordsToUpdate(litigationsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(litigationsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allLitigationIds));
        }

        if(!federalRegistersList.IsEmpty()){
            Set<Id> allFederalRegisterIds = new Set<Id>();
            for(Federal_Register__c federalRegister: federalRegistersList){
                allFederalRegisterIds.add(federalRegister.Id);
            }
            List<Federal_Register__c> federalRegistersToUpdate = getRecordsToUpdate(federalRegistersList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(federalRegistersToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allFederalRegisterIds));
        }

        if(!staffingAssignmentsList.IsEmpty()){
            Set<Id> allStaffingAssignmentIds = new Set<Id>();
            for(Staffing_Assignment__c staffingAssignment: staffingAssignmentsList){
                allStaffingAssignmentIds.add(staffingAssignment.Id);
            }
            List<Staffing_Assignment__c> staffingAssignmentsToUpdate = getRecordsToUpdate(staffingAssignmentsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(staffingAssignmentsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allStaffingAssignmentIds));
        }

        if(!relatedOrganizationsList.IsEmpty()){
            Set<Id> allRelatedOrgIds = new Set<Id>();
            for(Related_Organization__c relatedOrganization: relatedOrganizationsList){
                allRelatedOrgIds.add(relatedOrganization.Id);
            }
            List<Related_Organization__c> relatedOrganizationsToUpdate = getRecordsToUpdate(relatedOrganizationsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(relatedOrganizationsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allRelatedOrgIds));
        }

        if(!customInstructionsList.IsEmpty()){
            Set<Id> allCustomInstructionsIds = new Set<Id>();
            for(Custom_Instruction__c customInstruction: customInstructionsList){
                allCustomInstructionsIds.add(customInstruction.Id);
            }
            List<Custom_Instruction__c> customInstructionsToUpdate = getRecordsToUpdate(customInstructionsList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(customInstructionsToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allCustomInstructionsIds));
        }
        if(!harmonizedTariffSchedulesList.IsEmpty()){
            Set<Id> allHTSIds = new Set<Id>();
            for(Harmonized_Tariff_Schedule__c hts: harmonizedTariffSchedulesList){
                allHTSIds.add(hts.Id);
            }
            List<Harmonized_Tariff_Schedule__c> harmonizedTariffSchedulesToUpdate = getRecordsToUpdate(harmonizedTariffSchedulesList, caseToIdMap);
            List<Database.SaveResult> saveResults = Database.update(harmonizedTariffSchedulesToUpdate, false);
            recordIdToErrorMap.putAll(getDmlErrors(saveResults, allHTSIds));
        }

    }

    private List<sObject> getRecordsToUpdate(List<sObject> records, Map<Id, ADCVD_Case__c> caseMap){
        if(records.isEmpty() || caseMap.isEmpty()) return null;
        //Creating a list of current sobject type
        Schema.SObjectType currentObjType = records[0].getSObjectType();
        String listType = 'List<' + currentObjType + '>';
        List<SObject> returnedRecords = (List<SObject>)Type.forName(listType).newInstance();
        for(SObject singleRecord: records){
            Object caseId = singleRecord.get('ADCVD_Case__c');
            ADCVD_Case__c relatedCase = caseMap.get((Id)caseId);
            singleRecord.put('ADCVD_Case_Number_Text__c',relatedCase.ADCVD_Case_Number__c);
            singleRecord.put('ADCVD_Case_Type_Text__c', relatedCase.ADCVD_Case_Type__c);
            singleRecord.put('Commodity_Text__c', relatedCase.Commodity__c);
            singleRecord.put('Country_Text__c', relatedCase.Country__c);
            singleRecord.put('Product_Text__c', relatedCase.Product__c);
            singleRecord.put('Product_Short_Name_Text__c', relatedCase.Product_Short_Name__c);
            singleRecord.put('CBP_Case_Number_Text__c', relatedCase.CBP_Case_Number__c);
            
            returnedRecords.add(singleRecord);
        }
        return returnedRecords;
    }

    private Map<Set<Id>, String> getDmlErrors(List<Database.SaveResult> saveResults, Set<Id> allRecordIds){
        Map<Set<Id>, String> recordIdToErrorMap = new Map<Set<Id>, String>();
        String tempErrorMessageHold = '';
        Set<Id> successfulRecordsIds = new Set<Id>();
        Set<Id> failedRecordIds = new Set<Id>();
        for(Database.SaveResult sr: saveResults){
            if(sr.success){
                successfulRecordsIds.add(sr.getId());
            }
            if(!sr.success){
                for(Database.Error error: sr.getErrors()){
                    tempErrorMessageHold+= error.getMessage()+'\n';
                }
            }
        }
        //Get failed records ids
        for(Id id: allRecordIds){
            if(!successfulRecordsIds.contains(id)) failedRecordIds.add(id);
        }
        //Put failed record ids in the returned map
        if(!failedRecordIds.isEmpty()) recordIdToErrorMap.put(failedRecordIds, tempErrorMessageHold);
        return recordIdToErrorMap;
    }

    global void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =
                :BC.getJobId()];
        //Grab email addresses from custom settings
        AppConfig__c appConfigObj = AppConfig__c.getValues('ADCVDStandardCaseFieldsBatch');
        String adcvdAdminEmail =  ((String)appConfigObj.get('ADCVD_Admin__c') != null ? (String)appConfigObj.get('ADCVD_Admin__c') : '');
        String adcvdDeveloperEmail = ((String)appConfigObj.get('ADCVD_Developer__c') != null ? (String)appConfigObj.get('ADCVD_Developer__c') : '');
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        if(String.isNotBlank(adcvdAdminEmail)) toAddresses.add(adcvdAdminEmail);
        if(String.isNotBlank(adcvdDeveloperEmail)) toAddresses.add(adcvdDeveloperEmail);
        mail.setToAddresses(toAddresses);
        mail.setSubject('Standardized ADCVD Case Field Updates ' + a.Status);
        String emailBodyString = (recordIdToErrorMap.IsEmpty() ? '' : 'Review the following records Ids and error messages: '+'\n');
        for(Set<Id> failedIds: recordIdToErrorMap.keySet()){
            emailBodyString+= failedIds +'\n'+recordIdToErrorMap.get(failedIds)+'\n';
        }
        mail.setPlainTextBody
                ('The batch Apex job processed ' + a.TotalJobItems +
                        ' batches with '+ recordIdToErrorMap.size() + ' failures.'+'\n'
                +emailBodyString);
        //Check for email deliverability before sending an email.
        Boolean emailsTurnedOn = false;
        try {
            Messaging.reserveSingleEmailCapacity(0);
            emailsTurnedOn = true;
        } catch (System.NoAccessException e) {
            System.debug(e.getMessage());
        }

        if (emailsTurnedOn) {
            // safe to send an email provided you check for limits
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }


    }
}