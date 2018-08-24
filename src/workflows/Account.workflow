<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Record_Creator_if_Merging</fullName>
        <description>Contact Record Creator if Merging</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Verification_Merge</template>
    </alerts>
    <alerts>
        <fullName>Send_Owner_Validation_Results</fullName>
        <description>Send Owner Validation Results</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Organization_Validated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Acct_Set_Partner_Account_RT</fullName>
        <description>Sets Account Record Type to Partner</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Acct: Set Partner Account RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verification_Un_Validated</fullName>
        <field>Validated__c</field>
        <literalValue>0</literalValue>
        <name>Verification Un-Validated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verification_Validated</fullName>
        <description>update validated checkbox to positive.</description>
        <field>Validated__c</field>
        <literalValue>1</literalValue>
        <name>Verification Validated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Acct%3A Set Partner Account RT</fullName>
        <actions>
            <name>Acct_Set_Partner_Account_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.DataPartnerType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Data Partner Type has a value, set Account Record Type to Partner.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Alert Creator Merge</fullName>
        <actions>
            <name>Contact_Record_Creator_if_Merging</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Verification_Status__c</field>
            <operation>equals</operation>
            <value>To Be Merged</value>
        </criteriaItems>
        <description>Alerts the creator of the organization if account is merged by data team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Dummy Zip lookup</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ZIPforPB</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates ZIPforPB</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update validation when unverified</fullName>
        <actions>
            <name>Verification_Un_Validated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Verification_Status__c</field>
            <operation>equals</operation>
            <value>Unverified</value>
        </criteriaItems>
        <description>Updates validation checkbox to false when data admin has unverified the account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update validation when verified</fullName>
        <actions>
            <name>Send_Owner_Validation_Results</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Verification_Validated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Verification_Status__c</field>
            <operation>equals</operation>
            <value>Verified</value>
        </criteriaItems>
        <description>Updates validation checkbox when data admin has verified the account.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
