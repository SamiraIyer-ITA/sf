<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approve_Notification</fullName>
        <description>Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WIN_FL_Approved</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification</fullName>
        <description>Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>First_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WIN_FL_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_Manager_Email</fullName>
        <description>Send Manager Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>ed.howard@trade.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WIN_First_Line_Approval</template>
    </alerts>
    <alerts>
        <fullName>WIN_First_Approval_Step_One</fullName>
        <description>WIN First Approval Step One</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WIN_First_Line_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Email</fullName>
        <description>This field update is used to copy the Contact email ID.</description>
        <field>Copy_Contact_Email__c</field>
        <formula>Contact_Name__r.Email</formula>
        <name>Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CopyAccName</fullName>
        <description>Copys the Account Name Lookup to Text field so that in global search user can look win records based on AccountName serch.</description>
        <field>Copy_AccountName_to_Text__c</field>
        <formula>TRIM( Organization__r.Name )</formula>
        <name>CopyAccName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_WIN_Lookups</fullName>
        <description>This Field updated is used to copy the WIN record contact lookup value to a hidden text box which will be used in global search.</description>
        <field>Copy_WIN_Contact_Text__c</field>
        <formula>Contact_Name__r.FirstName+&apos; &apos;+ Contact_Name__r.LastName</formula>
        <name>Copy WIN Lookups</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Country_Picklist_Field_Update</fullName>
        <field>Related_Countries_Text__c</field>
        <formula>TEXT( Related_Countries__r.Country__c )</formula>
        <name>Country Picklist Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RejectOPAReady</fullName>
        <field>ReviewedByOPA__c</field>
        <literalValue>0</literalValue>
        <name>RejectOPAReady</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_First_Line_Approval</fullName>
        <description>Upon Recall of a Approval Process, Set &quot;First Line Approval&quot; to &quot;None&quot;, so Approval Process can be restarted(based upon initial submission entry criteria).</description>
        <field>First_Line_Approval__c</field>
        <name>Reset First Line Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_First_Line_Approval_Date</fullName>
        <description>Upon Recall of a Approval Process, Set &quot;First Line Approval Date&quot; to &quot;Null&quot;, so Approval Process can be restarted(based upon initial submission entry criteria).</description>
        <field>First_Line_Approval_Date__c</field>
        <name>Reset First Line Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_First_Line_Approver</fullName>
        <description>Upon Recall of a Approval Process, Set &quot;First Line Approver&quot; to &quot;Null&quot;, so Approval Process can be restarted(based upon initial submission entry criteria).</description>
        <field>First_Line_Approver__c</field>
        <name>Reset First Line Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFirstApproval</fullName>
        <field>Client_Verified__c</field>
        <literalValue>1</literalValue>
        <name>UpdateFirstApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOPAReady</fullName>
        <field>ReviewedByOPA__c</field>
        <literalValue>1</literalValue>
        <name>UpdateOPAReady</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FL_Approval</fullName>
        <field>First_Line_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Update FL Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FL_Approval_Rejection</fullName>
        <description>Set First Line Approval = &quot;Not Approved&quot;</description>
        <field>First_Line_Approval__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Update FL Approval Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FL_Approver_Name</fullName>
        <field>First_Line_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Update FL Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Line_Approval_Date</fullName>
        <field>First_Line_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Update FL Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Advocacy_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Advocacy_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Advocacy (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Advocacy_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Advocacy</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Advocacy (Rejected)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_C_Diplom_Approved</fullName>
        <description>Update Record Type - Commercial Diplomacy (Approved)</description>
        <field>RecordTypeId</field>
        <lookupValue>Commercial_Diplomacy_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - C Diplom (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_C_Diplom_Rejected</fullName>
        <description>Update Record Type - Commercial Diplomacy (Rejected)</description>
        <field>RecordTypeId</field>
        <lookupValue>Commercial_Diplomacy</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - C Diplom (Rejected)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Export_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Export_Promotion_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Export (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Export_P_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Export_Promotion_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Export P (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Export_P_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Export_Promotion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Export P (Rejected)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Export_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Export_Promotion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Export (Rejected)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Invest_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Investment_Promotion_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Invest (Approved)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Invest_Rejected</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Investment_Promotion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Invest (Rejected)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SL_Approval</fullName>
        <field>Final_Line_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Update SL Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SL_Approval_Date</fullName>
        <field>Final_Line_Approval_Date__c</field>
        <formula>NOW()</formula>
        <name>Update SL Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SL_Approval_Rejection</fullName>
        <field>Final_Line_Approval__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Update SL Approval Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SL_Approver_Name</fullName>
        <field>Final_Line_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Update SL Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Advocacy_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Advocacy</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WIN Advocacy Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Commercial_Diplomacy</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Commercial_Diplomacy</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WIN Commercial Diplomacy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Export_Promotion_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Export_Promotion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WIN Export Promotion Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Investment_Promotion_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Investment_Promotion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WIN Investment Promotion Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Type_Advocacy_Update</fullName>
        <description>Update record type to Advocacy from WIN type</description>
        <field>WIN_Type__c</field>
        <literalValue>Advocacy</literalValue>
        <name>WIN Type Advocacy Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Type_Commercial_Diplomacy</fullName>
        <description>Update record type to match WIN type</description>
        <field>WIN_Type__c</field>
        <literalValue>Commercial Diplomacy</literalValue>
        <name>WIN Type Commercial Diplomacy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Type_Export_Promotion_Update</fullName>
        <description>Update WIN Type to match record type.</description>
        <field>WIN_Type__c</field>
        <literalValue>Export Promotion</literalValue>
        <name>WIN Type Export Promotion Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WIN_Type_Investment_Promotion</fullName>
        <description>Update record type to match WIN type</description>
        <field>WIN_Type__c</field>
        <literalValue>Investment Promotion</literalValue>
        <name>WIN Type Investment Promotion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WIN Advocacy Record Type</fullName>
        <actions>
            <name>WIN_Advocacy_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Create Advocacy Record Type</description>
        <formula>ISPICKVAL( WIN_Type__c, &quot;Advocacy&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Advocacy update type</fullName>
        <actions>
            <name>WIN_Type_Advocacy_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WIN__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Advocacy</value>
        </criteriaItems>
        <description>Update WIN type with record type.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Commercial Diplomacy</fullName>
        <actions>
            <name>WIN_Commercial_Diplomacy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Commercial Diplomacy WINs</description>
        <formula>ISPICKVAL( WIN_Type__c, &quot;Commercial Diplomacy&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Commerical Diplomacy</fullName>
        <actions>
            <name>WIN_Type_Commercial_Diplomacy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WIN__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial Diplomacy</value>
        </criteriaItems>
        <description>Update WIN type with record type selected</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Copy Lookup to Text</fullName>
        <actions>
            <name>Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CopyAccName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_WIN_Lookups</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CreatedById</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>This rule is used to copy the lookup values to a text field so that the text field can be searched using global search.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WIN Export Promotion</fullName>
        <actions>
            <name>WIN_Type_Export_Promotion_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WIN__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Export Promotion</value>
        </criteriaItems>
        <description>Update WIN type with record type.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Export Promotion Record Type</fullName>
        <actions>
            <name>WIN_Export_Promotion_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Create WIN Export promotion record type</description>
        <formula>ISPICKVAL( WIN_Type__c, &quot;Export Promotion&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Investment Promotion</fullName>
        <actions>
            <name>WIN_Type_Investment_Promotion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Convert Record type to match</description>
        <formula>RecordType.Name = &quot;Investment Promotion&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Investment Promotion Record Type</fullName>
        <actions>
            <name>WIN_Investment_Promotion_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Create WIN Investment promotion record type</description>
        <formula>ISPICKVAL( WIN_Type__c, &quot;Investment Promotion&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WIN Related Country Copy</fullName>
        <actions>
            <name>Country_Picklist_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WIN__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>Copying the Related Country Value from Lookup to Text field so that it can be searched from Global search.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
