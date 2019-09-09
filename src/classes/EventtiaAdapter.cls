/**
 * Valence Adapter designed to interact with the Eventtia v3 API.
 */
global with sharing class EventtiaAdapter implements valence.SourceAdapterForPull, valence.SchemaAdapter, valence.NamedCredentialAdapter, valence.ChainFetchAdapter {

    /** The named credential we're going to use (supplied by Valence) */
    private String namedCredential = null;

    /** Token issued by Eventtia upon logging in **/
    private String authToken = null;

    /** Placeholder we use to track our progress towards fetching a series of records */
    private APIContext apiContext = null;

    public static final Set<String> ENDPOINTS_THAT_FILTER_ON_EVENT = new Set<String>{'attendee_types', 'business_conferences'};
    public static final Set<String> ENDPOINTS_THAT_FILTER_ON_EVENT_AND_CONFERENCE = new Set<String>{'business_conference_participants', 'business_conference_meetings'};

    // since we have to make so many API calls, we may group multiple callouts against the same table into the Valence batch
    public static final Integer MAX_CALLOUTS_PER_BATCH = 19; // save 1 for the auth call to get the token

    private Integer calloutsMade = 0;

    private Set<String> businessConferenceErrorIds = new Set<String>();

    // --------------------------------------------
    // ---- NamedCredentialAdapter methods --------
    // --------------------------------------------

    /**
     * Gives you the NamedCredential name that you will need in order to do an Apex callout or get information about
     * the endpoint the User would like to talk to using your adapter.
     *
     * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_named_credentials.htm
     *
     * @param namedCredentialsName The API name of a NamedCredential defined in this Salesforce org
     */
    public void setNamedCredential(String namedCredentialName) {
        namedCredential = namedCredentialName;
    }

    // --------------------------------------------
    // ---- SchemaAdapter methods -----------------
    // --------------------------------------------

    /**
     * We will interrogate your adapter and ask it what tables can be interacted with.
     *
     * @return A List of Table definitions that will be provided to Users.
     */
    public List<valence.Table> getTables() {

        /*
         * Eventtia doesn't have any sort of discovery endpoint for tables, so we've hardcoded them here.
         */
        return new List<valence.Table>{
                valence.Table.create('events').withLabel('Event').build(),
                valence.Table.create('business_conferences').withLabel('Business Conference').build(),
                valence.Table.create('business_conference_participants').withLabel('Participant').build(),
                valence.Table.create('business_conference_meetings').withLabel('Meeting').build(),
                valence.Table.create('attendee_types').withLabel('Attendee Type').build()
        };
    }

    /**
     * A natural follow-on from getTables, we will interrogate your adapter to find out which fields can be interacted with.
     *
     * @param tableApiName The specific table a User is interested in, comes from your list returned by getTables()
     *
     * @return A List of Field definitions that will be provided to Users for consideration.
     */
    public List<valence.Field> getFields(String tableApiName) {

        List<valence.Field> fields = new List<valence.Field>();

        // Eventtia currently does not expose field definitions dynamically, so we leave this empty and allow Valence to discover them dynamically

        return fields;
    }

    // --------------------------------------------
    // ---- SourceAdapterForPull methods ----------
    // --------------------------------------------

    /**
     * This method helps you to scale seamlessly to fetch large numbers of records. We do this by splitting requests
     * out into separate execution contexts, if need be.
     *
     * Valence will call planFetch() on your Adapter first, and then start calling fetchRecords(). The number of times
     * fetchRecords() is called depends on what you return from planFetch(). Every call to fetchRecords() will be in
     * its own execution context with a new instance of your Adapter, so you'll lose any state you have in your class.
     *
     * @param context Information about this Link and the current execution of it.
     *
     * @return
     */
    public valence.FetchStrategy planFetch(valence.LinkContext context) {
        return valence.FetchStrategy.immediate();
    }

    /**
     * Second, we will call this method sequentially with scopes you gave us in response to planPush(). We give you your
     * scope back so you can use it as needed.
     *
     * If you need to mark errors as failed or warning, use the addError() and addWarning() methods on RecordInFlight.
     *
     * @param context Information about this Link and the current execution of it.
     * @param scope A single scope instance from the List of scopes returned by planFetch()
     *
     * @return All of the records that have been updated since the timestamp passed inside LinkContext.
     */
    public List<valence.RecordInFlight> fetchRecords(valence.LinkContext context, Object scope) {

        apiContext = (APIContext)scope;

        // if null, this is our first fetch and we need to set up our queue of remaining fetches
        if(apiContext == null) {
            businessConferenceErrorIds = new Set<String>();
            apiContext = new APIContext(buildUrlFragments(context));
        }

        String fragmentsDebug = '';
        for(String fragment : apiContext.urlFragments) {
            fragmentsDebug += '\n' + fragment;
        }
        System.debug(LoggingLevel.WARN, 'urlFragments: ' + fragmentsDebug);


        List<valence.RecordInFlight> records = new List<valence.RecordInFlight>();

        while(calloutsMade < MAX_CALLOUTS_PER_BATCH && !apiContext.urlFragments.isEmpty()) {
            records.addAll(fetchNextRecordSet(context.linkSourceName));
            calloutsMade++;
        }

        if(!businessConferenceErrorIds.isEmpty()) {
            dispatchWarningForDeletedBusinessConference(context.linkSourceName);
        }

        return records;
    }

    /**
     * Make a callout to get some records using our next urlFragment from our running queue.
     *
     * @return
     */
    private List<valence.RecordInFlight> fetchNextRecordSet(String tableName) {

        /*
         * Get the next URL fragment to process
         */
        String currentUrlFragment = apiContext.urlFragments.remove(0);

        /*
         * Call the Eventtia API
         */
        valence.JSONParse result = callEndpoint(currentUrlFragment);
        if(result == null) {
            provideWarningForDeletedBusinessConference(currentUrlFragment);
            return new List<valence.RecordInFlight>();
        }

        /*
         * Check for another page of records; if found, stick it at the front of our queue.
         */
        String nextPage = result.get('links.next').getStringValue();
        if(String.isNotBlank(nextPage)) {
            if(apiContext.urlFragments.isEmpty())
                apiContext.urlFragments.add(nextPage.substringAfter('/v3/'));
            else
                    apiContext.urlFragments.add(0, nextPage.substringAfter('/v3/'));
        }

        /*
         * Unmarshall the data we received.
         */
        List<valence.RecordInFlight> records = new List<valence.RecordInFlight>();

        // for the participants endpoint we extra included items into a keyed map by type and id
        Map<String, valence.JSONParse> includedItems = new Map<String, valence.JSONParse>();
        if('business_conference_participants'.equalsIgnoreCase(tableName)) {
            Object includedNodeList = ((Map<String,Object>)result.getValue()).get('included');
            if(includedNodeList != null) {
                for(valence.JSONParse includedItemNode : result.get('included').asList()) {
                    includedItems.put(includedItemNode.get('type').getStringValue() + '_' + includedItemNode.get('id').getStringValue(), includedItemNode);
                }
            }
        }

        for(valence.JSONParse dataNode : result.get('data').asList()) {
            records.add(unmarshall(tableName, dataNode, includedItems));
        }

        return records;

    }

    /**
     * Provides a warning if a Business Conference appears to have been deleted in Eventtia
     *
     * @return
     */
    private void provideWarningForDeletedBusinessConference(String urlFrag) {
        String warningText = 'An business conference may have been deleted in Eventtia.';
        if(urlFrag != null && urlFrag.split('/').size() > 3) {
            String deletedId = urlFrag.split('/')[3];
            businessConferenceErrorIds.add(deletedId);
        }
    }

    private void dispatchWarningForDeletedBusinessConference(String linkSourceName) {
        if(linkSourceName == 'business_conference_meetings') {
            //the same errors that fire for attendees fire for meetings, so prevent email dupes by not firing for meetings
            return;
        }

        String warningTextIds = '';

        for(String s : businessConferenceErrorIds) {
            if(!String.isBlank(warningTextIds)) {
                warningTextIds += ', ';
            }
            warningTextIds += s;
        }

        String warningText = 'Eventtia Sync Warning: Networking Tracks with the following Eventtia Ids may have been deleted in Eventtia but still remain in Salesforce: '+warningTextIds;

        AppConfig__c appConfigObj = AppConfig__c.getValues('default');
        String adcvdAdminEmail = ((String) appConfigObj.get('ADCVD_Admin__c') != null ? (String) appConfigObj.get('ADCVD_Admin__c') : '');
        String adcvdDeveloperEmail = ((String) appConfigObj.get('ADCVD_Developer__c') != null ? (String) appConfigObj.get('ADCVD_Developer__c') : '');
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        if (String.isNotBlank(adcvdAdminEmail)) toAddresses.add(adcvdAdminEmail);
        if (String.isNotBlank(adcvdDeveloperEmail)) toAddresses.add(adcvdDeveloperEmail);
        mail.setToAddresses(toAddresses);
        mail.setSubject(warningText);
        mail.setPlainTextBody(warningText);
        Boolean emailsTurnedOn = false;

        try {
            Messaging.reserveSingleEmailCapacity(0);
            emailsTurnedOn = true;
        } catch (System.NoAccessException e) {
            System.debug(e.getMessage());
        }

        if (emailsTurnedOn) {
            // safe to send an email provided you check for limits
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                    mail
            });
        }
    }

    /**
     * Generates a series of endpoints we will have to hit in order to get a "full" set of records from Eventtia.
     *
     * We have three flavors of Eventtia API endpoints:
     * 1) no filter
     * 2) filtered by event
     * 3) filtered by event and business conference
     *
     * We actually don't want to filter, so we have to negate these filters by generating batches for every permutation.
     *
     * @param context
     *
     * @return A collection of endpoints that cover the full spectrum of what we want to hit
     */
    private List<String> buildUrlFragments(valence.LinkContext context) {

        List<String> fragments = new List<String>();

        // 1) no filter
        if('events'.equalsIgnoreCase(context.linkSourceName)) {
            return new List<String>{
                    'events'
            };
        }

        // everything from here needs at least event, so let's grab all eventtia event ids out of the Salesforce database
        Map<String, List<String>> eventsToConferences = new Map<String, List<String>>();
        for(Campaign event : [SELECT EventtiaURI__c FROM Campaign WHERE EventtiaURI__c != NULL]) {
            if(String.isNotBlank(event.EventtiaURI__c)) {
                eventsToConferences.put(event.EventtiaURI__c, new List<String>());
            }
        }

        // 2) filtered by event
        if(ENDPOINTS_THAT_FILTER_ON_EVENT.contains(context.linkSourceName)) {
            for(String eventUri : eventsToConferences.keySet()) {
                fragments.add('events/' + eventUri + '/' + context.linkSourceName);
            }
            return fragments;
        }

        // 2) filtered by event and business conference
        if(ENDPOINTS_THAT_FILTER_ON_EVENT_AND_CONFERENCE.contains(context.linkSourceName)) {

            // now we need to query for all the business conferences in the Salesforce database related to these events
            Set<String> eventUris = eventsToConferences.keySet();
            for(Business_Conference__c conference : [SELECT Campaign__r.EventtiaURI__c, EventtiaID__c FROM Business_Conference__c WHERE EventtiaID__c != NULL AND Campaign__r.EventtiaURI__c IN :eventUris]) {
                if(String.isNotBlank(conference.EventtiaID__c)) {
                    eventsToConferences.get(conference.Campaign__r.EventtiaURI__c).add(conference.EventtiaID__c);
                }
            }

            for(String eventId : eventsToConferences.keySet()) {
                for(String conferenceId : eventsToConferences.get(eventId)) {
                    fragments.add('events/' + eventId + '/business_conferences/' + conferenceId + '/' + context.linkSourceName);
                }
            }
            return fragments;
        }

        // if we got this far, we missed something
        throw new valence.AdapterException('Received a source table we did not understand: ' + context.linkSourceName);
    }

    /**
     * Turn Eventtia record structure into something Valence can understand.
     *
     * @param tableName the name of the source table
     * @param dataNode A record from Eventtia
     * @param included A map of additional records we may be interested in
     *
     * @return A record Valence can use
     */
    private valence.RecordInFlight unmarshall(String tableName, valence.JSONParse dataNode, Map<String, valence.JSONParse> included) {

        //System.debug(LoggingLevel.WARN, '-- DATA NODE --');
        //System.debug(LoggingLevel.WARN, '\n' + dataNode.toStringPretty());

        valence.RecordInFlight record = new valence.RecordInFlight(new Map<String, Object>());
        Map<String, Object> properties = record.getOriginalProperties();
        properties.put('id', dataNode.get('id').getValue());

        properties.putAll(extractAttributes(dataNode));

        /*System.debug(LoggingLevel.WARN, '-- PROPERTIES W/ ATTRIBUTES ('+properties.size()+') --');
        for(String key : properties.keySet())
            System.debug(LoggingLevel.WARN, key + ': ' + properties.get(key));
        System.debug(LoggingLevel.WARN, '-- INCLUDED --');
        for(String key : included.keySet())
            System.debug(LoggingLevel.WARN, key + ': ' + included.get(key).get('id').getValue() + ' (' + included.get(key).get('type').getValue() + ')');*/

        // extract any 1:N relationship ids
        Map<String, valence.JSONParse> relationships = dataNode.get('relationships').asMap();
        for(String field : relationships.keySet()) {
            if(relationships.get(field).get('data').isObject()) {
                properties.put(field + '_id', relationships.get(field).get('data.id').getStringValue());
            }
        }

        /*System.debug(LoggingLevel.WARN, '-- AFTER RELATIONSHIPS ('+properties.size()+') --');
        for(String key : properties.keySet())
            System.debug(LoggingLevel.WARN, key + ': ' + properties.get(key));*/

        // extra behavior for the participants endpoint
        if('business_conference_participants'.equalsIgnoreCase(tableName)) {

            // System.debug(LoggingLevel.WARN, 'Additional details about this Participant/Attendee\n' + included.get('attendees_' + properties.get('attendee_id')).toStringPretty());

            // take all the attendee data and merge it into this participant
            properties.putAll(extractAttributes(included.get('attendees_' + properties.get('attendee_id'))));

            /*System.debug(LoggingLevel.WARN, '-- AFTER ATTENDEE DATA ('+properties.size()+') --');
            for(String key : properties.keySet())
                System.debug(LoggingLevel.WARN, key + ': ' + properties.get(key));*/

            // to be nice, replace eventtia custom field numbers with friendlier names
            for(String field : properties.keySet()) {

                try {

                    if(field.startsWith('fields_')) {
                        String friendlyField = included.get('attendee_type_custom_fields_' + field.substring(7)).get('attributes.name').getStringValue();
                        //System.debug(LoggingLevel.WARN, 'Turning ' + field + ' => ' + friendlyField);
                        properties.put(friendlyField, properties.remove(field));
                    }

                    if(field.startsWith('profile_extra_fields_')) {
                        String friendlyField = included.get('business_conference_profile_fields_' + field.substring(21)).get('attributes.name').getStringValue();
                        //System.debug(LoggingLevel.WARN, 'Turning ' + field + ' => ' + friendlyField);
                        properties.put(friendlyField, properties.remove(field));
                    }

                }
                catch(Exception e) {
                    record.addWarning('Failed to swap out key [' + field + '] to friendly key.', e);
                }
            }
        }

        /*System.debug(LoggingLevel.WARN, '-- ALL DONE ('+properties.size()+') --');
        for(String key : properties.keySet())
            System.debug(LoggingLevel.WARN, key + ': ' + properties.get(key));*/

        return record;
    }

    /**
     * Takes an Eventtia API record shape and flattens its attributes down into a simple map.
     *
     * @param record A record in the eventtia API structure
     *
     * @return A flat map of keys and values
     */
    private Map<String, Object> extractAttributes(valence.JSONParse record) {

        Map<String, Object> properties = new Map<String, Object>();

        // iterate through all the attributes
        Map<String, valence.JSONParse> attributes = record.get('attributes').asMap();
        for(String field : attributes.keySet()) {

            if(attributes.get(field).isObject()) {
                Map<String, valence.JSONParse> innerNode = attributes.get(field).asMap();
                for(String innerField : innerNode.keySet()) {
                    properties.put(field + '_' + innerField, innerNode.get(innerField).getValue());
                }
            }
            else {
                properties.put(field, attributes.get(field).getValue());
            }
        }

        return properties;
    }

    // --------------------------------------------
    // ---- ChainFetchAdapter methods -------------
    // --------------------------------------------

    /**
     * @return A scope object that will be passed back to you on the next call to FetchRecords.
     */
    public Object getNextScope() {

        // when our queue is exhausted, return null to stop the chain
        return apiContext.urlFragments.isEmpty() ? null : apiContext;
    }

    // --------------------------------------------
    // ---- Helper methods ------------------------
    // --------------------------------------------

    /**
     * Make a callout to fetch some data from the API.
     *
     * @param urlFragment
     *
     * @return The response payload
     */
    private valence.JSONParse callEndpoint(String urlFragment) {

        if(String.isBlank(authToken)) {
            /*
             * First we will hit the login endpoint and get a session id.
             */
            HttpResponse authRes = new Http().send(buildLoginRequest());

            // check for an error response
            if(200 != authRes.getStatusCode()) {
                throw new valence.AdapterException(authRes.getStatusCode() + ': ' + authRes.getStatus());
            }

            /*
             * Extract our token from the login response.
             */
            authToken = new valence.JSONParse(authRes.getBody()).get('auth_token').getStringValue();
        }

        /*
         * Now that we have a token, hit our real endpoint that we want to talk to.
         */
        HttpResponse res = new Http().send(buildNormalRequest(urlFragment));

        // check for an error response
        if(200 != res.getStatusCode()) {
            try {
                throw new valence.AdapterException(res.getStatusCode() + ': ' + res.getStatus() + '[' + urlFragment + ']');
            } catch(valence.AdapterException e) {
                return null;
            }
        }

        return new valence.JSONParse(res.getBody());
    }

    /**
     * Constructs an HTTPRequest that knows how to handle the authentication and obtain an auth token.
     *
     * @return A pre-built request with the login details filled in, ready to send
     */
    private HttpRequest buildLoginRequest() {

        HttpRequest req = buildRequest('auth');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"email":"{!HTMLENCODE($Credential.Username)}","password":"{!HTMLENCODE($Credential.Password)}"}');
        return req;
    }

    /**
     * Constructs an HttpRequest object designed to talk to normal API endpoints.
     *
     * @param urlFragment The specific endpoint to hit
     *
     * @return A request ready to send to the API
     */
    private HttpRequest buildNormalRequest(String urlFragment) {

        HttpRequest req = buildRequest(urlFragment);
        req.setHeader('Authorization', 'Bearer ' + authToken);
        return req;
    }

    /**
     * Constructs the starting shell of an API request.
     *
     * @param urlFragment The specific endpoint to hit
     *
     * @return A request with endpoint, method, and headers filled in; you'll need to fill in the body
     */
    private HttpRequest buildRequest(String urlFragment) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:' + namedCredential + '/' + urlFragment);
        req.setTimeout(120000);
        return req;
    }

    // --------------------------------------------
    // ---- Helper classes ------------------------
    // --------------------------------------------

    /**
     * This is a container object for a queue of Eventtia API endpoints we still need to hit before we're done
     * fetching data. Because every fetch is a GET, we can track pending fetches as a simple list of partial URLs.
     */
    private class APIContext {

        List<String> urlFragments;

        private APIContext(List<String> fragments) {
            urlFragments = fragments;
        }
    }
}