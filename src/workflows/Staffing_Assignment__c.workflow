<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOwnerToOpenStaffingAssignmentQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>Staffing_Assignments_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateOwnerToOpenStaffingAssignmentQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Queue Open Staffing Assignment</fullName>
        <actions>
            <name>UpdateOwnerToOpenStaffingAssignmentQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Staff Email Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Staffing_Assignment__c.User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
