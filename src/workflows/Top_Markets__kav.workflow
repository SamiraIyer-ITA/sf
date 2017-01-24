<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approved_Draft_Complete</fullName>
        <description>Prepare the Draft Complete field for next version editing by unchecking the box.</description>
        <field>Draft_Complete__c</field>
        <literalValue>0</literalValue>
        <name>Approved - Draft Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Publication</fullName>
        <field>Stage__c</field>
        <literalValue>Published</literalValue>
        <name>Approved - Publication</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Stage - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Submitted_for_Approval</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Stage - Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Under_Review</fullName>
        <description>Changed the Stage from &apos;Draft&apos; to &apos;Under Review&apos;</description>
        <field>Stage__c</field>
        <literalValue>Under Review</literalValue>
        <name>Stage - Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TM_Stage_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>TM - Stage - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TM_Stage_Submitted_for_Approval</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>TM - Stage - Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Top_Markets</fullName>
        <action>PublishAsNew</action>
        <label>Publish Top Markets</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
