<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Name_to_HTS_Number</fullName>
        <field>Name</field>
        <formula>HTS_Number_Formatted__c</formula>
        <name>Update Name to HTS Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set HTS Name</fullName>
        <actions>
            <name>Update_Name_to_HTS_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( Name !=  HTS_Number_Formatted__c , true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
