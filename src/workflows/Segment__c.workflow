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
        <fullName>Update_Owner_to_ClosedLock_Segment_Queue</fullName>
        <description>Update Owner of Record to Segment Closed-Locked Queue</description>
        <field>OwnerId</field>
        <lookupValue>Segment_ClosedLocked_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to ClosedLock Segment Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Open_Segment_Queue</fullName>
        <description>Update Owner of Record to Segment Open Queue</description>
        <field>OwnerId</field>
        <lookupValue>Segment_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Open Segment Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Closed Segment</fullName>
        <actions>
            <name>Lock_Closed_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_ClosedLock_Segment_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open Queue Segment</fullName>
        <actions>
            <name>Update_Owner_to_Open_Segment_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
