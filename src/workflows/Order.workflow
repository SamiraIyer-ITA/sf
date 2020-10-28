<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PS_Application_Submitted_Order_Success</fullName>
        <description>PS: Application Submitted/Order Success</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
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
        <template>Trade_Community/Order_Submitted</template>
    </alerts>
    <alerts>
        <fullName>PS_Order_Submitted_Paid</fullName>
        <description>PS: Order Submitted (Paid)</description>
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
        <template>Trade_Community/Order_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Order_Status_Paid</fullName>
        <description>Order Status updates to Paid</description>
        <field>Status</field>
        <literalValue>Paid</literalValue>
        <name>Order Status Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Organization_Contact</fullName>
        <description>Update the Organization Contact field on Order</description>
        <field>Organization_Contact__c</field>
        <formula>Participant__r.Organization_Contact__c</formula>
        <name>Organization Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Organization_Corporate_Officer</fullName>
        <description>Update the Organization Corporate Officer field on Order</description>
        <field>Organization_Corporate_Officer__c</field>
        <formula>Participant__r.Organization_Corporate_Officer__c</formula>
        <name>Organization Corporate Officer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <actions>
            <name>Organization_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Organization_Corporate_Officer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When an Order is paid, send the user an email receipt.</description>
        <formula>and( Order_Paid__c, contains(Participant__r.Program__r.Name, &apos;Privacy Shield&apos;), or(isNew(), ISCHANGED(Order_Paid__c), Participant__r.Program__r.Name = &apos;Privacy Shield&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Payment Status Sync</fullName>
        <actions>
            <name>Order_Status_Paid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order.Order_Paid__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update the Order Status to &quot;Paid&quot; when the Order Paid checkbox is updated to &quot;true&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
