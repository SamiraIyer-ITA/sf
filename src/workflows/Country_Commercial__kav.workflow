<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approved_Draft_Complete</fullName>
        <description>Prepare the Draft Complete field for next version editing by unchecking the box.</description>
        <field>Daft_Complete__c</field>
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
        <fullName>Final_Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected</name>
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
        <field>Stage__c</field>
        <literalValue>Under Review</literalValue>
        <name>Stage - Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Community_Access</fullName>
        <field>IsVisibleInCsp</field>
        <literalValue>1</literalValue>
        <name>Update Community Access</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Country_Commercial</fullName>
        <action>PublishAsNew</action>
        <label>Publish Country Commercial</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>Update Community Access</fullName>
        <actions>
            <name>Update_Community_Access</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Country_Commercial__kav.IsVisibleInPkb</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Country_Commercial__kav.IsVisibleInCsp</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
