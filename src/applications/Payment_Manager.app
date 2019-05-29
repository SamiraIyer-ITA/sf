<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Admin_Payment_Record_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Payment__c</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Asset_LPL</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Asset</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0070D2</headerColor>
        <logo>PaymentAppLogo</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Allows for the Management of Payments</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>Payment Manager</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Admin_Payment_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Payment__c</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Data Team Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Admin_Payment_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Payment__c</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <tabs>Participation__c</tabs>
    <tabs>standard-Order</tabs>
    <tabs>Payment__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Payment_Manager_UtilityBar</utilityBar>
</CustomApplication>
