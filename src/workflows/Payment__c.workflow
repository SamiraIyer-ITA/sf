<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PS_Payment_Received_Only</fullName>
        <description>PS: Payment Received (Only)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_Payment_Success_and_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Privacy_Shield_Certification_Payment_Confirmation</fullName>
        <description>PS: Application Submitted/Payment Success</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_Payment_Success_and_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Privacy_Shield_Certification_Payment_Failure_Notification</fullName>
        <description>Send Privacy Shield Certification/Payment Failure Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_Payment_Certification_Failure</template>
    </alerts>
    <rules>
        <fullName>PS%3A  Application Submitted%2FPayment Success Notification</fullName>
        <actions>
            <name>Send_Privacy_Shield_Certification_Payment_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment__c.Transaction_Status__c</field>
            <operation>equals</operation>
            <value>Success</value>
        </criteriaItems>
        <description>Sends receipt of successful Privacy Shield application/payment success to Payment Owner (Community User).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PS%3A Payment Failure Notification</fullName>
        <actions>
            <name>Send_Privacy_Shield_Certification_Payment_Failure_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment__c.Transaction_Status__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <description>Sends receipt of failed Privacy Shield Payment to Payment Owner (Community User).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PS%3A Payment Received %28Only%29</fullName>
        <actions>
            <name>PS_Payment_Received_Only</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment__c.Transaction_Status__c</field>
            <operation>equals</operation>
            <value>Received</value>
        </criteriaItems>
        <description>Sends email notification when Payment has been successfully received, not when it has been processed/accepted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
