<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Translation</fullName>
        <field>Translation__c</field>
        <formula>Translation_Forms_Access__c</formula>
        <name>Update Translation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Translation Text</fullName>
        <actions>
            <name>Update_Translation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>or(ISCHANGED(Translation_Forms_Access__c), isNew(),  and(ISBLANK(Translation__c), not(isBlank(Translation_Forms_Access__c)))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
