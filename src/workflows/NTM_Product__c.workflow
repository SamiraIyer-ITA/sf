<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_NTM_Product_Name_External_ID</fullName>
        <description>Populate NTM Product Name External ID from NTM Product Name field.</description>
        <field>NTMProductNameXID__c</field>
        <formula>Name</formula>
        <name>Populate NTM Product Name External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate NTM Product Name External ID</fullName>
        <actions>
            <name>Populate_NTM_Product_Name_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will populate the NTM Product Name External ID field from the NTM Product Name field upon record creation, used for data imports.</description>
        <formula>NOT( ISBLANK( Name ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
