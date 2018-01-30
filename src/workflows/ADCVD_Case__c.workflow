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
    <fieldUpdates>
        <fullName>Update_Country_Text_Field_On_ADCVD_Case</fullName>
        <field>Country_Text__c</field>
        <formula>TEXT(Country__c)</formula>
        <name>Update Country Text Field On ADCVD Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Closed_ADCVD_Case_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>ADCVD_Case_Closed_Locked</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Closed ADCVD Case Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Open_ADCVD_Case_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>ADCVD_Case_Open</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Open ADCVD Case Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADCVD Case Country Text Field</fullName>
        <actions>
            <name>Update_Country_Text_Field_On_ADCVD_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule updates the country text field, with the value selected from the country picklist field.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true,  (ISNEW()  ||  ISCHANGED(Country__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open Queue ADCVD Cases</fullName>
        <actions>
            <name>Update_Owner_to_Open_ADCVD_Case_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
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
