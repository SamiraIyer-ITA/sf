<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CampaignMember_Send_Toolkit_Marketing_Subscription_Confirmation</fullName>
        <description>CampaignMember: Send Toolkit Marketing Subscription Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Participation_App_Templates/Toolkit_Marketing_Launch_Confirmation</template>
    </alerts>
    <rules>
        <fullName>CampaignMember%3A Notify the Campaign Member</fullName>
        <actions>
            <name>CampaignMember_Send_Toolkit_Marketing_Subscription_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends notification for Toolkit Marketing Subscription Confirmation</description>
        <formula>Campaign.Program__c != null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
