<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PS_Application_Submitted_Order_Success</fullName>
        <description>PS: Application Submitted/Order Success</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Order_Submitted</template>
    </alerts>
    <alerts>
        <fullName>PS_Order_Submitted_Paid</fullName>
        <description>PS: Order Submitted (Paid)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Order_Submitted</template>
    </alerts>
    <rules>
        <fullName>PS%3A Application Submitted%2FOrder Success Notification</fullName>
        <actions>
            <name>PS_Application_Submitted_Order_Success</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PS_Order_Submitted_Paid</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When an Order is paid, send the user an email receipt.</description>
        <formula>and( Order_Paid__c, contains(Participant__r.Program__r.Name, &apos;Privacy Shield&apos;), or(isNew(), ISCHANGED(Order_Paid__c), Participant__r.Program__r.Name = &apos;Privacy Shield&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
