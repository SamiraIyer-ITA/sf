/**
 * Created by jeffweyhrauch on 7/9/20.
 */

@isTest
global class REST_PaymentMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
        response.setBody('{"redirectUrl": "https://www.test.com/confirmation"}');
        response.setStatusCode(200);
        return response;
    }
}