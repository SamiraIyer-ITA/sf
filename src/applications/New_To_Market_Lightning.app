<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>NTM_Search_Log_Record_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>NTM_Search_Log__c</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>NTM_App_Home_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0070D2</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Application for managing New to Market data.</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>New To Market App</label>
    <navType>Standard</navType>
    <tabs>standard-home</tabs>
    <tabs>NTM_Country__c</tabs>
    <tabs>NTM_Region__c</tabs>
    <tabs>NTM_Product__c</tabs>
    <tabs>NTM_Country_Import__c</tabs>
    <tabs>NTM_Search_Region__c</tabs>
    <tabs>NTM_Search_Log__c</tabs>
    <tabs>standard-report</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>New_To_Market_App_UtilityBar</utilityBar>
</CustomApplication>
