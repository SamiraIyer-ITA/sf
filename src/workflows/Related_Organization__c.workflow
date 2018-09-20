<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Concatenated_IO_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>Country_Text__c + &apos;; &apos;+ ADCVD_Case_Type_Text__c</formula>
        <name>Update Concatenated IO Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Concatenated_IO_Text_Field</fullName>
        <field>Case_Concat_Text__c</field>
        <formula>Country_Text__c + &apos;; &apos;+ ADCVD_Case_Type_Text__c</formula>
        <name>Update Concatenated IO Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Interested Organizations Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_IO_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Concatenated_IO_Text_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on Interested Organizations with, Commodity, Country and ADCVD Case Type.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  ADCVD_Case_Type_Text__c )  || ISCHANGED( Country_Text__c )  )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
