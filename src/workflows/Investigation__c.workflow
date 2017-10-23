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
        <fullName>Set_Petition_ID</fullName>
        <field>This_Petition_Has_An_Investigation__c</field>
        <formula>Petition__c</formula>
        <name>Set Petition ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Closed Investigation</fullName>
        <actions>
            <name>Lock_Closed_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Petition ID</fullName>
        <actions>
            <name>Set_Petition_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false, OR(
 ISNEW(),
 ISCHANGED( This_Petition_Has_An_Investigation__c ),
 ISBLANK( This_Petition_Has_An_Investigation__c ) 
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
