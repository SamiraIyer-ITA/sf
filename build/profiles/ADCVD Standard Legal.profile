<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldPermissions>
        <editable>false</editable>
        <field>Tolling_Day__c.Petition__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>Tolling_Day__c.Investigation__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>Tolling_Day__c.Segment__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <layoutAssignments>
        <layout>Tolling_Day__c-Toll By Specific Record</layout>
        <recordType>Tolling_Day__c.Toll_By_Specific_Record</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Tolling_Day__c-Tolling Day Layout</layout>
        <recordType>Tolling_Day__c.Standard_Tolling</recordType>
    </layoutAssignments>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Tolling_Day__c.Standard_Tolling</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>false</default>
        <recordType>Tolling_Day__c.Toll_By_Specific_Record</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
</Profile>