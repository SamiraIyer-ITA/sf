<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_NTM_Country_Name_External_ID</fullName>
        <description>Populate NTM Country Name External ID field from NTM Country Name field.</description>
        <field>NTMCountryNameXID__c</field>
        <formula>Name</formula>
        <name>Populate NTM Country Name External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate NTM Country Name External ID</fullName>
        <actions>
            <name>Populate_NTM_Country_Name_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will populate the NTM Country Name External ID field from the NTM Country Name field upon record creation, used for data imports.</description>
        <formula>NOT( ISBLANK( Name ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
