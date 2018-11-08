<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_NTM_Region_Name_External_ID</fullName>
        <description>Populate NTM Region Name External ID from NTM Region Name field.</description>
        <field>NTMRegionNameXID__c</field>
        <formula>Name</formula>
        <name>Populate NTM Region Name External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate NTM Region Name External ID</fullName>
        <actions>
            <name>Populate_NTM_Region_Name_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will populate the NTM Region Name External ID field from the NTM Region Name field upon record creation, used for data imports.</description>
        <formula>NOT( ISBLANK( Name ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
