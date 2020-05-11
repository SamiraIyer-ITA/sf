<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldPermissions>
        <editable>false</editable>
        <field>Order.Payment2__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>Order.Refunded_Amount__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <layoutAssignments>
        <layout>Order-Services Layout</layout>
        <recordType>Order.Services</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Bank Transfer Payment</layout>
        <recordType>Payment2__c.Bank_Transfer_Payment</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Cash Payment</layout>
        <recordType>Payment2__c.Cash_Payment</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Check Payment</layout>
        <recordType>Payment2__c.Check_Payment</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Credit Card Refund</layout>
        <recordType>Payment2__c.Credit_Card_Refund</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Credit Card or ACH Payment</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-Credit Card or ACH Payment</layout>
        <recordType>Payment2__c.Credit_Card_or_ACH_Payment</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Payment2__c-NIST-Issued Refund</layout>
        <recordType>Payment2__c.NIST_Issued_Refund</recordType>
    </layoutAssignments>
</Profile>
