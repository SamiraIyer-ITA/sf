<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_Market_Intelligence_Approval</fullName>
        <description>Notification - Market Intelligence - Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Processes/Market_Intelligence_Approval</template>
    </alerts>
    <alerts>
        <fullName>Notification_Market_Intelligence_Article_Go_Live</fullName>
        <description>Notification - Market Intelligence Article - Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Processes/Market_Intelligence_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notification_Market_Intelligence_Rejected</fullName>
        <description>Notification - Market Intelligence - Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Processes/Market_Intelligence_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notification_Market_Intelligence_Submitted</fullName>
        <description>Notification - Market Intelligence - Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Processes/Market_Intelligence_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>MI_Stage_Published</fullName>
        <description>MI - Stage - Published</description>
        <field>Stage__c</field>
        <literalValue>Published</literalValue>
        <name>MI - Stage - Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MI_Stage_Rejected</fullName>
        <description>MI - Stage - Rejected</description>
        <field>Stage__c</field>
        <literalValue>Rejected</literalValue>
        <name>MI - Stage - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MI_Stage_Submitted_for_Approval</fullName>
        <description>MI - Stage - Submitted for Approval</description>
        <field>Stage__c</field>
        <literalValue>Draft: Submitted for Approval</literalValue>
        <name>MI - Stage - Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Article_Expiration_Date</fullName>
        <description>Update Article Expiration Datel when creating a record</description>
        <field>Expiration_Date__c</field>
        <formula>DATE( YEAR( TODAY())+2, MONTH( TODAY()), DAY( TODAY() ) )</formula>
        <name>Update Article Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publishing_Market_Intelligence</fullName>
        <action>PublishAsNew</action>
        <description>Publishing Market Intelligence</description>
        <label>Publishing Market Intelligence</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>Market Intelligence Default Expiration Date</fullName>
        <actions>
            <name>Update_Article_Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Market_Intelligence__kav.Expiration_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Market_Intelligence__kav.Expiration_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Default the Expiration Date to null when creating a new record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
