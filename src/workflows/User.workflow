<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Community_New_PS_User_Welcome_email</fullName>
        <description>Community - New PS User Welcome email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Trade_Community_Welcome_Privacy_Shield</template>
    </alerts>
    <alerts>
        <fullName>Export_gov_New_User_Welcome_email</fullName>
        <description>Export.gov - New User Welcome email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Trade_Community_Welcome_Export_gov</template>
    </alerts>
    <alerts>
        <fullName>New_User_Welcome_email</fullName>
        <description>Community - New User Welcome email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Trade_Community_Welcome</template>
    </alerts>
    <alerts>
        <fullName>STOPfakes_New_User_Welcome_email</fullName>
        <description>STOPfakes - New User Welcome email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Trade_Community_Welcome_STOPfakes</template>
    </alerts>
    <alerts>
        <fullName>SelectUSA_New_User_Welcome_email</fullName>
        <description>SelectUSA - New User Welcome email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@trade.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Trade_Community/Trade_Community_Welcome_SelectUSA</template>
    </alerts>
    <alerts>
        <fullName>Send_Instructions</fullName>
        <description>Send Instructions</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Instructions_for_Login_and_SFO_New</template>
    </alerts>
    <alerts>
        <fullName>Send_SFO_instructions</fullName>
        <description>Send SFO instructions</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_SFO_Instructions</template>
    </alerts>
    <fieldUpdates>
        <fullName>PopulateADUserId</fullName>
        <field>AD_User_Id__c</field>
        <formula>Email</formula>
        <name>PopulateADUserId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_SFO_email_send</fullName>
        <field>OutlookInstructionsSent__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck SFO email send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email</fullName>
        <field>AD_User_Id__c</field>
        <formula>Email</formula>
        <name>Update Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SFO_Field_on_User</fullName>
        <description>Updates SFO field so the instructions email is sent only once</description>
        <field>OutlookInstructionsSent__c</field>
        <literalValue>1</literalValue>
        <name>Update SFO Field on User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>deactivate_users</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>deactivate users</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Export%2Egov - New User Welcome</fullName>
        <actions>
            <name>Export_gov_New_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;, IsActive == true, Registered_Domain__c = &apos;Export.gov&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PopulateADUserIdWhenUserCreatedManually</fullName>
        <actions>
            <name>PopulateADUserId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.AD_User_Id__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Privacy Shield - New User Welcome</fullName>
        <actions>
            <name>Community_New_PS_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;,  IsActive  == true, Registered_Domain__c = &apos;Privacy Shield&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>STOPfakes - New User Welcome</fullName>
        <actions>
            <name>STOPfakes_New_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;, IsActive == true, Registered_Domain__c = &apos;STOPfakes&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SelectUSA - New User Welcome</fullName>
        <actions>
            <name>SelectUSA_New_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;, IsActive == true, Registered_Domain__c = &apos;SelectUSA&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Activation Email</fullName>
        <actions>
            <name>Send_Instructions</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_SFO_email_send</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.OutlookInstructionsSent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trade - Deactivate Users</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Customer Trade Community User</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>deactivate_users</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.CreatedDate</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>User.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Trade - New PS User Welcome</fullName>
        <actions>
            <name>Community_New_PS_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;,  IsActive  == true,  Contact.site__r.Name == &apos;Privacy Shield&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trade - New User Welcome</fullName>
        <actions>
            <name>New_User_Welcome_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Profile.Name == &apos;Customer Trade Community User&apos;, IsActive == true, Contact.site__r.Name != &apos;Privacy Shield&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
