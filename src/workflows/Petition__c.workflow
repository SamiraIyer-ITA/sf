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
        <fullName>Update_Owner_to_Closed_Petition_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Petitions_ClosedLocked_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Closed Petition Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Open_Petition_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Petitions_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Open Petition Queue</name>
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
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Queue Open Petition</fullName>
        <actions>
            <name>Update_Owner_to_Open_Petition_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true,  Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
