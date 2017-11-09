<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOwnerTo_OpenFederalRegisterQueue</fullName>
        <description>Update Owner of Record to Federal Register Open Queue</description>
        <field>OwnerId</field>
        <lookupValue>FederalRegister_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateOwnerTo OpenFederalRegisterQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Open Queue Federal_Register</fullName>
        <actions>
            <name>UpdateOwnerTo_OpenFederalRegisterQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
