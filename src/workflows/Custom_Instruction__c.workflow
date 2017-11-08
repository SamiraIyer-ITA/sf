<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOwner_OpenCustomsInstructionQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>Customs_Instructions_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateOwner-OpenCustomsInstructionQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Queue Open Customs Instruction</fullName>
        <actions>
            <name>UpdateOwner_OpenCustomsInstructionQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true,  Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
