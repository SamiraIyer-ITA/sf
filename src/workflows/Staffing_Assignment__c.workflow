<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Concatenated_StaffingAs_Field</fullName>
        <field>Case_Concat_Text_Values__c</field>
        <formula>TEXT( Country__c)+ &apos;; &apos;+TEXT( ADCVD_Case_Type__c )</formula>
        <name>Update Concatenated StaffingAs. Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Short_Name_On_StaffingAs</fullName>
        <field>Product_Short_Name_Text_Value__c</field>
        <formula>Product_Short_Name__c</formula>
        <name>Update Product Short Name On StaffingAs.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Staff Email Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Staffing_Assignment__c.User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Staffing Assignment Concatenated Field</fullName>
        <actions>
            <name>Update_Concatenated_StaffingAs_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the concatenated text field on Staffing Assignment with, ADCVD Case Type and Country.</description>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED( ADCVD_Case_Type__c )  || ISCHANGED( Country__c )  )  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Staffing Assignment Product Short Name</fullName>
        <actions>
            <name>Update_Product_Short_Name_On_StaffingAs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.Master_Automation__c.WorkflowRulesEnabled__c == true, (IF( ISNEW() ||  ( ISCHANGED(  Product_Short_Name__c  ))  , True, False)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
