<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Owner_to_Open_TollingDay_Queue</fullName>
        <description>Update Owner of Record to Tolling Day Open Queue</description>
        <field>OwnerId</field>
        <lookupValue>Tolling_Day_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Open TollingDay Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Open Queue Tolling Day</fullName>
        <actions>
            <name>Update_Owner_to_Open_TollingDay_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
