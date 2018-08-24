<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IndustryTextFieldUpdate</fullName>
        <field>Industry_Text__c</field>
        <formula>TEXT(Industry__c)</formula>
        <name>IndustryTextFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sector_FieldUpdate</fullName>
        <field>Sector_Text__c</field>
        <formula>TEXT( Sector__c )</formula>
        <name>Sector FieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Sector</fullName>
        <field>Sub_Sector_Text__c</field>
        <formula>TEXT(Sub_Sector__c)</formula>
        <name>Sub-Sector</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Industry Hierarchy FieldUpdate Rule</fullName>
        <actions>
            <name>IndustryTextFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sector_FieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Sector</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Industry__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Industry__c.LastModifiedById</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
