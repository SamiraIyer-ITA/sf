public class captchaController {
    
    public String URL{get;set;}
    public String captchaSiteKey{get;set;}
    
    public captchaController() {
        integer lastIndex;
        list<network> networkData = new list<network>();
        networkData = [select id, name from network where name =: 'Customer Portal'];
        URL = Network.getLoginUrl(networkData[0].id);
        List<CaptchaSettings__c> captchaSettings = CaptchaSettings__c.getAll().values();
        map<string, string> captchaSettingValues = new Map<string, string>();
        for(CaptchaSettings__c c :captchaSettings){
            captchaSettingValues.put(c.name, c.value__c);
        }
        captchaSiteKey =  captchaSettingValues.get('SITE_KEY');
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
