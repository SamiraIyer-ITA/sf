<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Petition_ID</fullName>
        <field>This_Petition_Has_An_Investigation__c</field>
        <formula>Petition__c</formula>
        <name>Set Petition ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Petition ID</fullName>
        <actions>
            <name>Set_Petition_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
 ISNEW(),
 ISCHANGED( This_Petition_Has_An_Investigation__c ),
 ISBLANK( This_Petition_Has_An_Investigation__c ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
