public class captchaController {
    
    public String URL{get;set;}
    public String captchaSiteKey{get;set;}
    
    public captchaController() {
        integer lastIndex;
        list<network> networkData = new list<network>();
        networkData = [select id, name from network where name =: 'Customer Portal'];
        URL = Network.getLoginUrl(networkData[0].id);
        captchaSiteKey = System.Label.MCPCommunityreCaptchaKey;
        lastIndex = url.lastIndexOf('/');
        url = url.left(lastIndex);
        lastIndex = url.lastIndexOf('/');
        url = url.left(lastIndex);
        lastIndex = url.lastIndexOf('/');
        url = url.left(lastIndex);
    }
    
    public String getURL() {
        list<network> networkData = new list<network>();
        networkData = [select id, name from network where name =: 'Customer Portal'];
        URL = Network.getLoginUrl(networkData[0].id);
        return URL;
    }
}
