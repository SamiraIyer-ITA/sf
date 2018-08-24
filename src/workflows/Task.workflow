<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Act_Lev_5_Country</fullName>
        <field>RH_Lev_5_Country__c</field>
        <formula>TEXT( Owner:User.RH_Lev_5_Country__c )</formula>
        <name>Act Lev 5 Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Act_RH_GM_All</fullName>
        <field>RH_Lev_1_GM_All__c</field>
        <formula>TEXT(Owner:User.RH_Lev_1_Top_Level__c)</formula>
        <name>Act RH GM All</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Act_RH_Lev_2_DAS</fullName>
        <field>RH_Lev_2_DAS__c</field>
        <formula>TEXT( Owner:User.RH_Lev_2_DAS_Level__c )</formula>
        <name>Act RH Lev 2 DAS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Act_RH_Lev_3_Region_2</fullName>
        <field>RH_Lev_3_Region_2__c</field>
        <formula>TEXT( Owner:User.RH_Lev_3_Region_2__c )</formula>
        <name>Act RH Lev 3 Region 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Act_RH_Lev_4_Region_1</fullName>
        <field>RH_Lev_4_Region_1__c</field>
        <formula>TEXT( Owner:User.RH_Lev_4_Region_1__c )</formula>
        <name>Act RH Lev 4 Region 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Act_RH_Lev_7_Individual</fullName>
        <field>RH_Lev_7_Individual__c</field>
        <formula>TEXT( Owner:User.RH_Lev_7_Individual__c )</formula>
        <name>Act RH Lev 7 Individual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RH_Lev_6_Office</fullName>
        <field>RH_Lev_6_Office__c</field>
        <formula>TEXT( Owner:User.RH_Lev_6_Office__c )</formula>
        <name>RH Lev 6 Office</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Update_Reminder_Flag_False</fullName>
        <field>IsReminderSet</field>
        <literalValue>0</literalValue>
        <name>Task Update Reminder Flag False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Act Update RH info on Task</fullName>
        <actions>
            <name>Act_Lev_5_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Act_RH_GM_All</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Act_RH_Lev_2_DAS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Act_RH_Lev_3_Region_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Act_RH_Lev_4_Region_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Act_RH_Lev_7_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RH_Lev_6_Office</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fiscal Year Task Review</fullName>
        <active>false</active>
        <formula>NOT(ISBLANK(CreatedDate))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Task Update Reminder Flag</fullName>
        <actions>
            <name>Task_Update_Reminder_Flag_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Set Reminder Flag to False as a Default Value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
