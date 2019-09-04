<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <layoutAssignments>
        <layout>ADCVD_Case__c-ADCVD Case Layout</layout>
        <recordType>ADCVD_Case__c.Private</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>ADCVD_Case__c-ADCVD Case Layout</layout>
        <recordType>ADCVD_Case__c.Self_Initiated</recordType>
    </layoutAssignments>
    <fieldPermissions>
        <editable>true</editable>
        <field>Petition__c.A0803PrivateCaseRequiresPrivatePetition__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Petition__c.This_ADCVD_Case_Has_a_Petition__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <recordTypeVisibilities>
        <default>false</default>
        <recordType>ADCVD_Case__c.Private</recordType>
        <visible>false</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <personAccountDefault>true</personAccountDefault>
        <recordType>ADCVD_Case__c.Filed</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
</Profile>
