<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_ADCVD_Case_Number</fullName>
        <field>ADCVD_Case_Number__c</field>
        <formula>Name</formula>
        <name>Update ADCVD Case Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update ADCVD Case Number</fullName>
        <actions>
            <name>Update_ADCVD_Case_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update ADCVD_Case_Number__c (custom field) with value from ADCVD Case Number (standard Name field)</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
