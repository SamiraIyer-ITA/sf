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
        <fullName>Approved_Published</fullName>
        <field>Stage__c</field>
        <literalValue>Published</literalValue>
        <name>Approved - Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Stage_Published</fullName>
        <field>Stage__c</field>
        <literalValue>Published</literalValue>
        <name>SR - Stage - Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Stage_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>SR - Stage - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SR_Stage_Submitted_for_Approval</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>SR - Stage - Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Rejection</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Stage - Rejection</name>
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
        <field>Stage__c</field>
        <literalValue>Under Review</literalValue>
        <name>Stage - Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_State_Report</fullName>
        <action>PublishAsNew</action>
        <label>Publish State Report</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>Publish_State_Reports</fullName>
        <action>PublishAsNew</action>
        <label>Publish State Reports</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
