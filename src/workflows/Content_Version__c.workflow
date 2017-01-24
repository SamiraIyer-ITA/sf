<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AV_RT_FU</fullName>
        <description>To update the &apos;Content Version&apos; Record Type (to mask &apos;Edit&apos; button) to &apos;Published Content Version&apos; Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Published_Content_Version</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to Published Content Version</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Publishing_Status_Pending</fullName>
        <description>Publishing Status - Draft Submitted for approval</description>
        <field>Publishing_Status__c</field>
        <literalValue>Draft: Submitted for Approval</literalValue>
        <name>Publishing Status - Draft Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Publishing_Status_Rejected</fullName>
        <description>Upon Rejection</description>
        <field>Publishing_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Publishing Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Field_Update</fullName>
        <field>Publishing_Status__c</field>
        <literalValue>Online</literalValue>
        <name>Publishing Status - Online</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Atom Version Record type</fullName>
        <actions>
            <name>AV_RT_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Content_Version__c.Publishing_Status__c</field>
            <operation>equals</operation>
            <value>Online</value>
        </criteriaItems>
        <description>To update the &apos;Content Version&apos; Record Type (to mask &apos;Edit&apos; button) to &apos;Published Content Version&apos; Record Type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
