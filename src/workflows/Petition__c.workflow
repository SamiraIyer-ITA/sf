<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lock_Closed_Record</fullName>
        <field>Locked__c</field>
        <literalValue>1</literalValue>
        <name>Lock Closed Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Concatenated_Petition_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>TEXT(Commodity__c) + &apos;; &apos;+ TEXT( Country__c)+ &apos;; &apos;+TEXT( ADCVD_Case_Type__c )</formula>
        <name>Update Concatenated Petition Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Text_Field_on_Petition</fullName>
        <field>Country_Text__c</field>
        <formula>TEXT(Country__c )</formula>
        <name>Update Country Text Field on Petition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Closed_Petition_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Petitions_ClosedLocked_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Closed Petition Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Closed Petition</fullName>
        <actions>
            <name>Lock_Closed_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_Closed_Petition_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Closed&apos;),  ISNULL(Next_Announcement_Date__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Petition Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_Petition_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on Petition with, Commodity, Country and ADCVD Case Type.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  ADCVD_Case_Type__c  )  || ISCHANGED(  Country__c  )  || ISCHANGED(  Commodity__c  ) )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
