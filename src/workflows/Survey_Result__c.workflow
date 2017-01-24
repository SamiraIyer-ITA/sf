<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_for_Low_Score_Survey</fullName>
        <description>Send Email for Low Score Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Email_for_Notification__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Survey_Message_Low_Score_10</template>
    </alerts>
</Workflow>
