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
        <fullName>Set_Investigation_ID</fullName>
        <field>This_Investigation_has_an_Order__c</field>
        <formula>Investigation__c</formula>
        <name>Set Investigation ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOwnerTo_ClosedLockADCVD_OrderQueue</fullName>
        <description>Update Owner of Record to ADCVD Order Closed-Locked Queue</description>
        <field>OwnerId</field>
        <lookupValue>ADCVD_Order_ClosedLocked_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateOwnerTo ClosedLockADCVD-OrderQueue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Concatenated_ADCVD_Order_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>Commodity__c + &apos;; &apos;+ Country__c + &apos;; &apos;+  ADCVD_Case_Type__c</formula>
        <name>Update Concatenated ADCVD Order Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Short_Name_On_ADCVD_Order</fullName>
        <field>Product_Short_Name_Text_Value__c</field>
        <formula>Product_Short_Name__c</formula>
        <name>Update Product Short Name On ADCVD Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Text_Field_On_ADCVD_Order</fullName>
        <field>Product_Text_Value__c</field>
        <formula>Product__c</formula>
        <name>Update Product Text Field On ADCVD Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Revoked-Complete ADCVD Order</fullName>
        <actions>
            <name>Lock_Closed_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateOwnerTo_ClosedLockADCVD_OrderQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  ISPICKVAL(Status__c , &apos;Revoked-Complete&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ADCVD Order Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_ADCVD_Order_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on ADCVD Order with, Commodity, Country and ADCVD Case Type.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED( ADCVD_Case_Type__c )  || ISCHANGED( Country__c )  || ISCHANGED( Commodity__c ) )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ADCVD Order Product Short Name</fullName>
        <actions>
            <name>Update_Product_Short_Name_On_ADCVD_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product_Short_Name__c  ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ADCVD Order Product Text Field</fullName>
        <actions>
            <name>Update_Product_Text_Field_On_ADCVD_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product__c  ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Investigation ID</fullName>
        <actions>
            <name>Set_Investigation_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, Locked__c == false,  OR( ISNEW(), ISCHANGED( This_Investigation_has_an_Order__c ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
