<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldPermissions>
        <editable>false</editable>
        <field>OrderItem.isPrimary__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>OrderItem.Accounting_Code__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Product2.Accounting_Code__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Payment2__c.Receipt_Ready__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Payment2__c.Receipt_Sent_To__c</field>
        <readable>true</readable>
    </fieldPermissions>
	<recordTypeVisibilities>
		<default>false</default>
		<recordType>Payment2__c.Bank_Transfer_Payment</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<recordTypeVisibilities>
		<default>false</default>
		<recordType>Payment2__c.Cash_Payment</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<recordTypeVisibilities>
		<default>false</default>
		<recordType>Payment2__c.Check_Payment</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<recordTypeVisibilities>
		<default>false</default>
		<recordType>Payment2__c.Credit_Card_Refund</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<recordTypeVisibilities>
		<default>true</default>
		<personAccountDefault>true</personAccountDefault>
		<recordType>Payment2__c.Credit_Card_or_ACH_Payment</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<recordTypeVisibilities>
		<default>false</default>
		<recordType>Payment2__c.NIST_Issued_Refund</recordType>
		<visible>true</visible>
	</recordTypeVisibilities>
	<custom>true</custom>
    <layoutAssignments>
        <layout>Case-Transaction Management Support</layout>
        <recordType>Case.Transaction_Management_Support</recordType>
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
		<layout>Payment2__c-Credit Card or ACH Payment</layout>
		<recordType>Payment2__c.Credit_Card_or_ACH_Payment</recordType>
	</layoutAssignments>
	<layoutAssignments>
		<layout>Payment2__c-Credit Card Refund</layout>
		<recordType>Payment2__c.Credit_Card_Refund</recordType>
	</layoutAssignments>
	<layoutAssignments>
		<layout>Payment2__c-NIST-Issued Refund</layout>
		<recordType>Payment2__c.NIST_Issued_Refund</recordType>
    </layoutAssignments>
</Profile>
