<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Concatenated_FR_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>Commodity__c + &apos;; &apos;+ Country__c+ &apos;; &apos;+ADCVD_Case_Type__c +&apos;; &apos;+  ADCVD_Case__r.Name</formula>
        <name>Update Concatenated FR Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Short_Name_On_FR</fullName>
        <field>Product_Short_Name_Text_Value__c</field>
        <formula>Product_Short_Name__c</formula>
        <name>Update Product Short Name On FR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Text_Field_On_FR</fullName>
        <field>Product_Text_Value__c</field>
        <formula>Product__c</formula>
        <name>Update Product Text Field On FR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Federal Register Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_FR_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on Federal Register with, Commodity, Country and ADCVD Case Type.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  ADCVD_Case_Type__c  )  || ISCHANGED(  Country__c  )  || ISCHANGED(  Commodity__c  )  || ISCHANGED( ADCVD_Case__c ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Federal Register Product Short Name</fullName>
        <actions>
            <name>Update_Product_Short_Name_On_FR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product_Short_Name__c  ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Federal Register Product Text Field</fullName>
        <actions>
            <name>Update_Product_Text_Field_On_FR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product__c  ) )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
