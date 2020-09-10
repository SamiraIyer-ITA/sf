<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Failure_to_Comply</fullName>
        <description>Asset: Send Notification That PS Inactive Status Reason is Failure to Comply</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/PS_Inactive_Status_Failure_to_Comply</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Lapsed</fullName>
        <description>Asset: Send Notification That PS Inactive Status Reason is Lapsed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/PS_Inactive_Status_Lapsed</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Withdrawal</fullName>
        <description>Asset: Send Notification That PS Inactive Status Reason is Withdrawal</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/PS_Inactive_Status_Withdrawal</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_PS_ReCertification_Reminder_Email_1_Day_Before_Usage_End_Date</fullName>
        <description>Asset: Send PS Re-Certification Reminder Email 1 Day Before Usage End Date</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_ReCertification_Due_in_2_Weeks_and_Day_Before</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_PS_ReCertification_Reminder_Email_1_Month_before_Usage_End_Date</fullName>
        <description>Asset: Send PS Re-Certification Reminder Email 1 Month before Usage End Date</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/PS_Re_Certification_Due_in_1_Month</template>
    </alerts>
    <alerts>
        <fullName>Asset_Send_PS_ReCertification_Reminder_Email_2_Weeks_before_Usage_End_Date</fullName>
        <description>Asset: Send PS Re-Certification Reminder Email 2 Weeks before Usage End Date</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Organization_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Organization_Corporate_Officer__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Shield_Templates/Privacy_Shield_ReCertification_Due_in_2_Weeks_and_Day_Before</template>
    </alerts>
    <alerts>
        <fullName>Notify_Related_Contact</fullName>
        <description>Notify Related Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Order_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expire_Asset</fullName>
        <description>Marks Asset&apos;s Status to Inactive.</description>
        <field>Status</field>
        <literalValue>Inactive</literalValue>
        <name>Expire Asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Asset%3A PS Send Inactive Status Reason is Lapsed Email</fullName>
        <actions>
            <name>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Lapsed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email notification will be sent if Inactive Status Reason is Lapse</description>
        <formula>OR(AND(Inactive_Status_Reason__r.Name = &quot;Lapse&quot;, Product2.Name = &apos;EU-US Certification&apos;),AND(Inactive_Status_Reason__r.Name = &quot;Lapse&quot;, Product2.Name = &apos;SW-US Certification&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Asset%3A PS Send Inactive Status Reason is Persistent Failure to Comply Email</fullName>
        <actions>
            <name>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Failure_to_Comply</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email notification will be sent if Inactive Status Reason is Persistent Failure to Comply</description>
        <formula>OR(AND(Inactive_Status_Reason__r.Name = &quot;Persistent Failure to Comply&quot;, Product2.Name = &apos;EU-US Certification&apos;),AND(Inactive_Status_Reason__r.Name = &quot;Persistent Failure to Comply&quot;, Product2.Name = &apos;SW-US Certification&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Asset%3A PS Send Inactive Status Reason is Withdrawal Email</fullName>
        <actions>
            <name>Asset_Send_Notification_That_PS_Inactive_Status_Reason_is_Withdrawal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email notification will be sent if Inactive Status Reason is Withdrawal</description>
        <formula>OR(AND(Inactive_Status_Reason__r.Name = &quot;Withdrawal&quot;, Product2.Name = &apos;EU-US Certification&apos;),AND(Inactive_Status_Reason__r.Name = &quot;Withdrawal&quot;, Product2.Name = &apos;SW-US Certification&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Asset%3A PS Send Reminder Emails Before Due Date</fullName>
        <active>true</active>
        <description>Privacy Shield Re-Certification reminder emails 1 month, 2 weeks and 1 day before Asset&apos;s Usage End Date.</description>
        <formula>OR(AND(ISPICKVAL(Status,&apos;Active&apos;), Product2.Name = &apos;EU-US Certification&apos;),AND(ISPICKVAL(Status,&apos;Active&apos;), Product2.Name = &apos;SW-US Certification&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Asset_Send_PS_ReCertification_Reminder_Email_1_Day_Before_Usage_End_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Asset_Send_PS_ReCertification_Reminder_Email_1_Month_before_Usage_End_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Asset_Send_PS_ReCertification_Reminder_Email_2_Weeks_before_Usage_End_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deactivate in 12 months</fullName>
        <active>false</active>
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
    <rules>
        <fullName>Deactivate in 12 months %2B 30</fullName>
        <active>true</active>
        <description>Sets the Asset Status to Expired after 1 year and 31 days, and notifies related Contact.</description>
        <formula>OR(AND(NOT(ISBLANK(UsageEndDate)),ISPICKVAL(Status, &apos;active&apos;), Product2.Name = &apos;EU-US Certification&apos;),AND(NOT(ISBLANK(UsageEndDate)),ISPICKVAL(Status, &apos;active&apos;), Product2.Name = &apos;SW-US Certification&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expire_Asset</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Asset.UsageEndDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
