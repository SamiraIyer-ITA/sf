@isTest
global class ADCVD_OrderSearchTestImpl implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String body = '{"adcvdOrders":[{"segments":[{"recordType":"Expedited Review","id":"a3Xr00000008a2JEAQ","decisionSigned":"false","daysRemaining":"120","announcementType":"Preliminary","announcementDate":"6/13/2018"},{"recordType":"New Shipper Review","id":"a3Xr00000008a2KEAQ","decisionSigned":"false","daysRemaining":"120","announcementType":"Preliminary","announcementDate":"6/13/2018"},{"recordType":"Sunset Review","id":"a3Xr00000008a2MEAQ","decisionSigned":"false","daysRemaining":"0","announcementType":"Final","announcementDate":"7/13/2018"},{"recordType":"Administrative Review","id":"a3Xr00000008a2GEAQ","decisionSigned":"false","daysRemaining":"120","announcementType":"Preliminary","announcementDate":"8/17/2018"}],"productShortName":"tacos","id":"a3Nr00000001HsuEAE","htsNums":[{"id":"a3Rr00000008ya0EAA","htsNumberFormatted":"1000.00.00.00","htsNumber":"1000000000"},{"id":"a3Rr00000008ya1EAA","htsNumberFormatted":"1000.00.00.01","htsNumber":"1000000001"},{"id":"a3Rr00000008ya2EAA","htsNumberFormatted":"1000.00.00.02","htsNumber":"1000000002"},{"id":"a3Rr00000008ya3EAA","htsNumberFormatted":"1000.00.00.03","htsNumber":"1000000003"},{"id":"a3Rr00000008ya4EAA","htsNumberFormatted":"1000.00.00.04","htsNumber":"1000000004"}],"country":"United States","caseNumber":"A-111-222"}]}';
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}