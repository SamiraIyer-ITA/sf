<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Oppty_Set_RT_to_Data_Customer</fullName>
        <description>Sets the Opportunity Record Type to Data Customer</description>
        <field>RecordTypeId</field>
        <lookupValue>Data_Customer_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Oppty: Set RT to Data Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Set_RT_to_Data_Partner</fullName>
        <description>Sets the Opportunity Record Type to Data Partner</description>
        <field>RecordTypeId</field>
        <lookupValue>Data_Partner_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Oppty: Set RT to Data Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Oppty_Name</fullName>
        <description>Sets Partner Oppty Name to &quot;Account&quot; - &quot;Data Set&quot;</description>
        <field>Name</field>
        <formula>Account.Name + &quot; - &quot; +  LEFT(DataSet__c,20)</formula>
        <name>Set Oppty Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Oppty%3A Set RT based on Acct Data Partner Type%3A Customer</fullName>
        <actions>
            <name>Oppty_Set_RT_to_Data_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Oppty_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.DataPartnerType__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>Sets the Opportunity Record Type to Data Customer if Account Data Partner Type is Customer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Oppty%3A Set RT based on Acct Data Partner Type%3A Partner</fullName>
        <actions>
            <name>Oppty_Set_RT_to_Data_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Oppty_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.DataPartnerType__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>Sets the Opportunity Record Type to Data Partner if Account Data Partner Type is Partner.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
