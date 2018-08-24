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
        <fullName>Update_Concatenated_Segment_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>Commodity__c + &apos;; &apos;+ Country__c+ &apos;; &apos;+ADCVD_Case_Type__c +&apos;; &apos;+ ADCVD_Case__r.Name</formula>
        <name>Update Concatenated Segment Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_ClosedLock_Segment_Queue</fullName>
        <description>Update Owner of Record to Segment Closed-Locked Queue</description>
        <field>OwnerId</field>
        <lookupValue>Segment_ClosedLocked_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to ClosedLock Segment Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Short_Name_On_Segment</fullName>
        <field>Product_Short_Name_Text_Value__c</field>
        <formula>Product_Short_Name__c</formula>
        <name>Update Product Short Name On Segment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Text_Field_On_Segment</fullName>
        <field>Product_Text_Value__c</field>
        <formula>Product__c</formula>
        <name>Update Product Text Field On Segment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Closed Segment</fullName>
        <actions>
            <name>Lock_Closed_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_ClosedLock_Segment_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Segment Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_Segment_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on Segment with, Commodity, Country and ADCVD Case Type.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED( ADCVD_Case_Type__c )  || ISCHANGED( Country__c )  || ISCHANGED( Commodity__c ) || ISCHANGED(  ADCVD_Case__c  ) )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Segment Product Short Name</fullName>
        <actions>
            <name>Update_Product_Short_Name_On_Segment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product_Short_Name__c  ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Segment Product Text Field</fullName>
        <actions>
            <name>Update_Product_Text_Field_On_Segment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product__c  ) )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
