@isTest
global class TEST_PayGovTCSOnlineMockImpl implements WebServiceMock {
    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
            
            if (responseName.equals('startOnlineCollectionResponse')) {
                PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollectionResponse = new PayGovTCSOnline.StartOnlineCollectionResponse();
                startOnlineCollectionResponse.token = 'token';

                PayGovTCSOnline.StartOnlineCollectionResponseType startOnlineCollectionResponseType = new PayGovTCSOnline.StartOnlineCollectionResponseType();
                startOnlineCollectionResponseType.StartOnlineCollectionResponse = startOnlineCollectionResponse;
                response.put('response_x', startOnlineCollectionResponseType);

            } else if (responseName.equals('completeOnlineCollectionWithDetailsResponse')) {  
                PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse();
                completeOnlineCollectionWithDetailsResponse.transaction_status = 'Success';
                completeOnlineCollectionWithDetailsResponse.transaction_date = date.today();
                completeOnlineCollectionWithDetailsResponse.payment_date = date.today();
                completeOnlineCollectionWithDetailsResponse.transaction_amount = '5';

                PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType completeOnlineCollectionWithDetailsResponseType = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType();
                completeOnlineCollectionWithDetailsResponseType.completeOnlineCollectionWithDetailsResponse = completeOnlineCollectionWithDetailsResponse;

                response.put('response_x', completeOnlineCollectionWithDetailsResponseType);
            }
            
   }
}