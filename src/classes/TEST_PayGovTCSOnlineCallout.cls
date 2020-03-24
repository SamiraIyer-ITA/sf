public class TEST_PayGovTCSOnlineCallout {

	public static PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollection() {

		PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest = new PayGovTCSOnline.StartOnlineCollectionRequest();
		startOnlineCollectionRequest.tcs_app_id = 'tcs_app_id';
		startOnlineCollectionRequest.agency_tracking_id = 'agency_tracking_id';
		startOnlineCollectionRequest.transaction_type = 'Sale';
		startOnlineCollectionRequest.transaction_amount = '5.00';
		startOnlineCollectionRequest.language = 'en';
		startOnlineCollectionRequest.url_success = 'http://www.cnn.com';
		startOnlineCollectionRequest.url_cancel = 'http://www.foxnews.com';
		PayGovTCSOnline.CustomCollectionFields custom_fields = new PayGovTCSOnline.CustomCollectionFields();
		custom_fields.custom_field_1 = '55:0023:2016:SAFH232:000:35-05-0001-01-00-00-00:05-20-00-00:5.00::::::::';
		startOnlineCollectionRequest.custom_fields = custom_fields;

		PayGovTCSOnline.classification classification = new PayGovTCSOnline.classification();
		PayGovTCSOnline.classificationData classification_data = new PayGovTCSOnline.classificationData();
		classification_data.classification_id = 'Id';
		classification_data.amount = '5.00';
		startOnlineCollectionRequest.classification = classification;

		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new  PayGovTCSOnline.TCSOnlineServicePort();
		return payGovOnline.startOnlineCollection(startOnlineCollectionRequest, 'paymentId');
	}

	public static PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetails() {

		PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest();
		completeOnlineCollectionWithDetailsRequest.tcs_app_id = 'tcs_app_id';
		completeOnlineCollectionWithDetailsRequest.token = 'token';

		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new  PayGovTCSOnline.TCSOnlineServicePort();
		return payGovOnline.completeOnlineCollectionWithDetails(completeOnlineCollectionWithDetailsRequest, 'paymentId');
	}
}