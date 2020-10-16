@isTest
private class TEST_PayGovTCSSingleServiceCalloutTest {

    static String agencyId = 'agencyId';
    static String tcsAppId = 'tcsAppId';

    @isTest static void testProcessPCRefund() {
        insert new PaymentSettings__c(name='PAY_GOV_TCS_SINGLE_SERVICE_ENDPOINT', value__c = 'Test');
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
        Test.startTest();

        PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
        pcRefund.orig_paygov_tracking_id = 'origPayGovTrackingId';
        pcRefund.transaction_amount = 'transactionAmount';
        pcRefund.orig_agency_tracking_id = 'origAgencyTrackingId';

        PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = TEST_PayGovTCSSingleServiceCallout.processPCRefund(agencyId, tcsAppId, pcRefund);
        System.assertEquals('agencyId', pcRefundResponse.agency_id);
    }

    @isTest static void testProcessPCSale() {
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
        Test.startTest();

        PayGovTCSSingleService.PCSaleRequestType pcSale = new PayGovTCSSingleService.PCSaleRequestType();
        pcSale.agency_tracking_id = 'agencyTrackingId';
        pcSale.transaction_amount = 'transactionAmount';
        pcSale.account_number = 'accountNumber';
        pcSale.credit_card_expiration_date = 'ccExpDate';
        pcSale.business_name = 'businessName';
        pcSale.first_name = 'firstName';
        pcSale.middle_initial = 'middleInitial';
        pcSale.last_name = 'lastName';
        pcSale.card_security_code = 'cardSecurityCode';
        pcSale.credit_card_track2 = 'creditCardTrack2';
        pcSale.billing_address = 'billingAddress';
        pcSale.billing_address_2 = 'billingAddress2';
        pcSale.billing_city = 'billingCity';
        pcSale.billing_state = 'billingState';
        pcSale.billing_zip = 'billingZip';
        pcSale.billing_country = 'billingCountry';
        pcSale.order_id = 'orderId';
        pcSale.order_tax_amount = 'orderTaxAmount';
        //pcSale.order_level3_data = new PayGovTCSSingleService.order_level3();
        pcSale.custom_fields = new PayGovTCSSingleService.custom_fields();
        pcSale.account_holder_email_address = 'accountHolderEmailAddress';
        pcSale.classification = new PayGovTCSSingleService.classification();

        PayGovTCSSingleService.PCSaleResponse_element pcSaleResponse = TEST_PayGovTCSSingleServiceCallout.processPCSale(agencyId, tcsAppId, pcSale);
        System.assertEquals('agencyId', pcSaleResponse.agency_id);
    }
}
