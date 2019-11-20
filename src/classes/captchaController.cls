public class captchaController {
    
    public String URL{get;set;}
    public String captchaSiteKey{get;set;}
    
    public captchaController() {
        integer lastIndex;
        list<network> networkData = new list<network>();
        networkData = [select id, name from network where name =: 'MCP-Community'];
        URL = Network.getLoginUrl(networkData[0].id);
        captchaSiteKey = System.Label.MCPCommunityreCaptchaKey;
        lastIndex = url.lastIndexOf('/');
        system.debug('last index ' + lastIndex + '  ; ' + url);
        url = url.left(lastIndex);
        lastIndex = url.lastIndexOf('/');
        url = url.left(lastIndex);
        lastIndex = url.lastIndexOf('/');
        url = url.left(lastIndex);
    }
    
    public String getURL() {
        list<network> networkData = new list<network>();
        networkData = [select id, name from network where name =: 'MCP-Community'];
        system.debug('NetworkID' + [select id, name from network where name =: 'MCP-Community']);
        system.debug('URL??? ' + Network.getLoginUrl(networkData[0].id));
        System.debug('test : ' + System.URL.getSalesforceBaseUrl().getHost().remove('-api'));
        URL = Network.getLoginUrl(networkData[0].id);
        return URL;
    }
}