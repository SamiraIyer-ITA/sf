<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Country_Text_update</fullName>
        <description>Updates country text on related country record so it can be searchable.</description>
        <field>Country_Text__c</field>
        <formula>TEXT(Country__c)</formula>
        <name>Country Text update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RC Update Country Text</fullName>
        <actions>
            <name>Country_Text_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RelatedCountries__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <description>Update country text field with picklist value so it can be searched.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
