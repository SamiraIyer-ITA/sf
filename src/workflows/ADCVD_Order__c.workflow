<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Investigation_ID</fullName>
        <field>This_Investigation_has_an_Order__c</field>
        <formula>Investigation__c</formula>
        <name>Set Investigation ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Investigation ID</fullName>
        <actions>
            <name>Set_Investigation_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
 ISNEW(),
 ISBLANK( This_Investigation_has_an_Order__c ),
 ISCHANGED( This_Investigation_has_an_Order__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
