<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">

    
    
    
    <fieldPermissions>
        <editable>false</editable>
        <field>OrderItem.ITA_Product_Code__c</field>
        <readable>true</readable>
    </fieldPermissions>
    
      <fieldPermissions>
        <editable>false</editable>
        <field>QuoteLineItem.ITA_Product_Code__c</field>
        <readable>true</readable>
    </fieldPermissions>
    
     <fieldPermissions>
        <editable>false</editable>
        <field>OpportunityLineItem.ITA_Product_Code__c</field>
        <readable>true</readable>
    </fieldPermissions>
    
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>true</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>true</modifyAllRecords>
        <object>Order</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>true</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>true</modifyAllRecords>
        <object>Opportunity</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>true</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>true</modifyAllRecords>
        <object>Quote</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
</Profile>
