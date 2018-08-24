<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Researcher_checked_if_Acc_Res</fullName>
        <description>Contact: Researcher checked if Account Registration Type is Researcher</description>
        <field>ResearcherHIDDEN__c</field>
        <literalValue>1</literalValue>
        <name>Contact: Researcher checked if Acc:Res</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Set_RT_to_Partner</fullName>
        <description>Sets the Contact RT to Partner</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Contact: Set RT to Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_AccName_Lookup</fullName>
        <description>This filed is used to copy the AccountName lookup value to a text field so that in the global search user and get the contact information using the accountname.</description>
        <field>Copy_AccountName_to_Text__c</field>
        <formula>Account.Name</formula>
        <name>Copy AccName Lookup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Emails_made_dummy</fullName>
        <field>Email</field>
        <formula>Email &amp; &quot;.sfcrm&quot;</formula>
        <name>Emails made dummy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact%3A Set RT to Partner</fullName>
        <actions>
            <name>Contact_Set_RT_to_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.DataPartnerType__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the Contact Record Type if the Account Data Partner Type field has any value.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Copy Lookup Field</fullName>
        <actions>
            <name>Copy_AccName_Lookup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>This Workflow is used to copy the Lookup field to a hidden text so that it can be used in global search</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Modify email address</fullName>
        <actions>
            <name>Emails_made_dummy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>.sfdc</value>
        </criteriaItems>
        <description>Email address mod to add sfdc at end</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Researcher checked if Account Registration Type is Researcher</fullName>
        <actions>
            <name>Contact_Researcher_checked_if_Acc_Res</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Type__c</field>
            <operation>equals</operation>
            <value>Researcher</value>
        </criteriaItems>
        <description>Checks the &quot;Researcher - Hidden&quot; field on Contact if Account Registration Type is Researcher.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
