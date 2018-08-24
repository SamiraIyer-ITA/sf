/* Can be used as an extension or controller so that it can be called from javascript or controllers
 * to implement as javascript - please see in footer. 
 */
public without sharing class PageMessaging {
	public PageMessaging () {

	}
	public String severity {get; set;}
	public String message {get; set;}
	/* JavaScript Implementation 

	Add this controller as an extension then include the following action function to the page: 

	    <apex:actionFunction name="addMessage" reRender="pm" action="{!addMessage}" > <!-- pm is the ID of the PageMessages component --> 
	    	<apex:param name="severity" assignTo="{!severity}" />
	    	<apex:param name="message" assignTo="{!message}" />
	    </apex:actionFunction>

	It can then be called from JavaScript like this: 
	    addMessage('Info', 'You forgot to fill out your name');

	*/
	public PageReference addMessage() {
		string s = severity.toUpperCase();
		ApexPages.Severity apSev;
		if(s == 'INFO') { 
			apSev = ApexPages.Severity.INFO;
		} else if (s == 'ERROR') {
			apSev = ApexPages.Severity.ERROR;
		} else if (s == 'CONFIRM') {
			apSev = ApexPages.Severity.CONFIRM;
		} else if (s == 'FATAL') {
			apSev = ApexPages.Severity.FATAL;
		} else if (s == 'WARNING') { 
			apSev = ApexPages.Severity.WARNING;
		} else {
			apSev = ApexPages.Severity.INFO;
		}
		ApexPages.addMessage(new ApexPages.Message(apSev, message));
		return null;
	}
	public PageReference doNothing() {
		return null;
	}

}