<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NTM_Key_Update</fullName>
        <description>Autopopulate NTM_Country_Import__c External ID</description>
        <field>Key__c</field>
        <formula>Product__r.Name + Country__r.Name</formula>
        <name>NTM Key Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NTM Import Key</fullName>
        <actions>
            <name>NTM_Key_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the external ID of the NTM_Country_Import__c</description>
        <formula>Key__c != Product__r.Name + Country__r.Name</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
