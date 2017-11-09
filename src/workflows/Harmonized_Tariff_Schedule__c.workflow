<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOwnerHarmonizedTariffScheduleQueue</fullName>
        <description>Update Owner of Record to Harmonized Tariff Schedule Open Queue</description>
        <field>OwnerId</field>
        <lookupValue>Harmonized_Tariff_Schedule_Open_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateOwnerHarmonizedTariffScheduleQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Open Queue Harmonized Tariff Schedule</fullName>
        <actions>
            <name>UpdateOwnerHarmonizedTariffScheduleQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
