<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
  <fieldPermissions>
        <editable>true</editable>
        <field>Sys_Picklist_Values__c.Contact_Us_Country__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Sys_Picklist_Values__c.Contact_Us_Request_Reason__c</field>
        <readable>true</readable>
  </fieldPermissions>
  <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>false</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>false</modifyAllRecords>
        <object>Sys_Picklist_Values__c</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
   <recordTypeVisibilities>
        <default>true</default>
        <recordType>Sys_Picklist_Values__c.ContactRequest</recordType>
        <visible>true</visible>
  </recordTypeVisibilities>
</Profile>
