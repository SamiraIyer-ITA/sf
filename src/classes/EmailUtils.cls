public with sharing class EmailUtils {

	/**
	 * Send an email using an email template.
	 *
	 * @param toRecipients List of email addresses to be emailed.
	 * @param ccRecipients List of email addresses to be CCed.
	 * @param templateApiName API Name of an email template.
	 * @param targetObjId  Id of a Contact, User, or Lead record.  Used in merge fields of template recipient.xxxx.
	 * @param targetObjectIsRecipient. If set to true, the targetObjectId (a Contact, Lead, or User) is the recipient of the email. If set to false, the targetObjectId is supplied as the WhoId field for template rendering but isn’t a recipient of the email.
	 * @param whatId Id of an SObject used in the merge fields of the template relatedTo.xxxx.
	 * @param orgWideEmailId Optional. The Id of the organization-wide email address associated with the outgoing email. The object's DisplayName field cannot be set if the setSenderDisplayName field is already set.
	 * @param saveAsActivity  Boolean of whether to save the email as activity on the targetObjId (e.g. Contact).  Note that activities can't be saved on Users.
	 * @param attachmentIds Optional. List of IDs of Document, ContentVersion, or Attachment items to attach to the email.
	 */
	public static void sendTemplatedEmail(List<String> toRecipients, List<String> ccRecipients, String templateApiName, Id targetObjId, Boolean targetObjectIsRecipient, Id whatId, Id orgWideEmailId, Boolean saveAsActivity, List<String> attachmentIds) {
		//Note that BCC is not permitted when using email templates.

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

		Id templateId;
		try {
			templateId = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = :templateApiName LIMIT 1].Id;
		} catch (Exception e) {
			throw new EmailException ('Unable to locate EmailTemplate using name: ' + templateApiName);
		}

		email.setToAddresses(toRecipients);
		email.setCcAddresses(ccRecipients);
		email.setTargetObjectId(targetObjId);
		email.setWhatId(whatId);
		email.setOrgWideEmailAddressId(orgWideEmailId);
		email.setTemplateId(templateId);
		email.setSaveAsActivity(saveAsActivity);
		email.setEntityAttachments(attachmentIds);
		email.setTreatTargetObjectAsRecipient(targetObjectIsRecipient);

		//Exceptions to the line below must be caught by the calling method
		Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
		return;
	}

	public class EmailException extends Exception {}
}