<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PS_Payment_Refunded</fullName>
        <description>PS: Payment Refunded</description>
        <protected>false</protected>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Refund_Template</template>
    </alerts>
    <rules>
        <fullName>PS%3A Payment Refunded</fullName>
        <actions>
            <name>PS_Payment_Refunded</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email notification when a Privacy Shield Refund has been completed.</description>
        <formula>AND(ISPICKVAL(Status__c,&apos;Completed&apos;), ISPICKVAL( Payment__r.Application__c, &apos;Privacy Shield&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
