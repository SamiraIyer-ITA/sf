<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Asset_Send_PS_Re_Certification_Reminder_Email_1_Month_before_Usage_End_Date</fullName>
        <description>Asset: Send PS Re-Certification Reminder Email 1 Month before Usage End Date</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_ReCertification_Due_in_1_Month</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_PS_Re_Certification_Reminder_Email_1_Week_before_Usage_End_Date</fullName>
        <description>Asset: Send PS Re-Certification Reminder Email 2 Weeks before Usage End Date</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_ReCertification_Due_in_2_Weeks</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expire_Asset</fullName>
        <field>Status</field>
        <literalValue>Expired</literalValue>
        <name>Expire Asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Asset%3A PS Send Reminder Emails Before Due Date</fullName>
        <active>true</active>
        <description>Sends our Re-Certification reminder emails 1 month and 2 weeks before Asset&apos;s Usage End Date.</description>
        <formula>AND(ISPICKVAL(Status,&apos;Installed&apos;), UsageEndDate &lt;= TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Asset_Send_PS_Re_Certification_Reminder_Email_1_Month_before_Usage_End_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Asset_Send_PS_Re_Certification_Reminder_Email_1_Week_before_Usage_End_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deactivate in 12 months</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Asset.UsageEndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expire_Asset</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
