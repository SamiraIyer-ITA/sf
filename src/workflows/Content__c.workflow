<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Atom_Rejection_Notification</fullName>
        <description>Atom Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Atom_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Atom_Status</fullName>
        <description>Publishing Status - Online</description>
        <field>Status__c</field>
        <literalValue>Online</literalValue>
        <name>Publishing Status - Online</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Atom_Record_type</fullName>
        <description>To update the &apos;Generic Content&apos; Record Type (to mask &apos;Edit&apos; button) to &apos;Draft Generic Content&apos; Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>RichText</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Field Update - Atom Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Publishing_Status_Draft_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Draft: Submitted for Approval</literalValue>
        <name>Publishing Status - Draft: Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Publishing_Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Publishing Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Atom Record type</fullName>
        <actions>
            <name>Field_Update_Atom_Record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Content__c.Status__c</field>
            <operation>equals</operation>
            <value>Online</value>
        </criteriaItems>
        <description>To update the &apos;Draft Generic Content&apos; Record Type (to mask &apos;Edit&apos; button) to &apos;Generic Content&apos; Record Type (only &apos;Modify&apos; button)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
