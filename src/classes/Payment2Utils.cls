public with sharing class Payment2Utils {

	/**
	 * Format User Info field values for sending to pay.gov
	 *
	 * @param userElement A value that will be passed to pay.gov.
	 * @param charLimit The character limit allowed by pay.gov.
	 */
	public static String userElementFormat(String userElement, Integer charLimit) {
		if (userElement != null) {
			userElement = userElement.length() > charLimit ? userElement.substring(0, charLimit) : userElement;
		}
		return userElement;
	}

	/**
	 * Get the current fiscal year
	 */
	public static String getCurrentFiscalYear() {
		Date currentDate = Date.today();  //Check for GMT
		Integer year = currentDate.year();
		Integer month = currentDate.month();
		if (month > 9) {
			year++;
		}
		return String.valueOf(year);
	}

	/**
	 * Get the time zone offset, which allows GMT dates to be converted to Washington DC time.
	 */
	public static Integer getTimeZoneOffset() {
		Timezone tz = Timezone.getTimeZone('America/New_York');
		// Create a date after the 2007 shift of DST into November
		DateTime dt = system.now();
		//tz.getOffset(dt)  == -18000000 (== -5 hours, which is EST)
		Integer offsetSeconds = tz.getOffset(dt)/1000*-1;  //1000 is to convert milliseconds to seconds and -1 is to add seconds instead of subtract
		return offsetSeconds;
	}

	/**
	 * Get the Remote Account Name from metadata.  This is the 'Application' name used by Pay.gov.
	 *
	 * @param accountType A type of account, which is the Order.Type field value.
	 *
	 * @return The account name according to the Payment Processor
	 */
	public static String getRemoteAccountName(String accountType) {
		//Replace spaces with underscores (e.g. Privacy Shield = Privacy_Shield)
		String accountMetaDataName = accountType.replace(' ', '_') + '_Remote_Account__c';
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings('PayGov');
		return (String) paymentSettingsMap.get(accountMetaDataName);
	}

	public static PaymentAuthenticationDetails deserializePaymentDetails(String paymentDetails) {
		//Correct the paymentDetails string prior to deserialization.
		//Remove starting and ending quotes
		paymentDetails = paymentDetails.substring(1, paymentDetails.length() - 1);
		//Remove escapes
		paymentDetails = paymentDetails.replace('\\', '');
		return (PaymentAuthenticationDetails)JSON.deserialize(paymentDetails, PaymentAuthenticationDetails.class);
	}

	public class PaymentException extends Exception {}

}