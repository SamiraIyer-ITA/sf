public class Site_Template_Controller {

    public Navigation_Group__c[] navigation {get; set;}
    public Site__c Main {get; set;}
    public NavigationGroup[] NavigationGroups {get; set;}
    public String loggedInUser{get; set;}
    public Social_Icons__c[] si{get; set;}

// Login and Register
    public String username {get; set;}
    public String password {get; set;}
//  public CustomLoginController () {}    
    public PageReference login() {
        return Site.login(username, password, null);
    } 

    public PageReference Registerredirect() {
        PageReference rr = new PageReference('/registration');
        rr.setRedirect(true);
        return rr;
    }
    public String currentBaseUrl {get { //used to return the base url of the current page
        return 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/';
    }}
//

    public class NavigationGroup{
        public Id id {get; set;}
        public string label {get; set;}
        public string url {get; set;}
        public boolean isMegaMenu {get; set;}
        public Navigation_Link__c[] links {get; set;}
    }

    public Site_Template_Controller(){
    
        map<string, string> chatterMap = new map<string, string>();
        String[] groups = new String[]{};
        Site__c[] site = [SELECT id, title__c, Site_CSS__c, site_logo__c,slogan__c,Disable_Login__c,isSearchEnabled__c, Search_URL__c, 
                            Required_Footer__c, Logo_Alt_Text__c,favicon__c,
                            GA_Domain__c, GA_Account__c, GA_Script__c,
                                (SELECT id, name, isMegaMenu__c, Chatter_Group__c, page__c, url__c, page__r.clean_url__c
                                FROM Navigation_Groups__r
                                ORDER BY sort_order__c asc nulls first), 
                                (SELECT URL__c, Name, icon__r.Alt_Text__c, icon__r.class_name__c, icon__r.name
                                  FROM Social_Icons__r
                                  Where Active__c = true
                                  ORDER BY Sort_Order__c asc nulls first LIMIT 6),
                                (SELECT id, name, url__c, icon__r.Class_Name__c from my_profile_options__r
                                  order by sort_order__c)
                            from site__c where 
                                domain__c = :URL.getSalesforceBaseUrl().getHost() 
                                or UseAsDefault__c = true 
                            order by UseAsDefault__c asc limit 1];
        if(site.size() == 1){
            this.main = site[0];
            si = this.main.Social_Icons__r;
            this.navigation = [select id, sort_order__c, name, isMegaMenu__c, chatter_group__c, page__c, page__r.clean_url__c, url__c,
                               (select id, Page__c, Name, redirect__c, page__r.clean_url__c 
                                from navigation_links__r 
                                order by sort_order__c asc nulls first) 
                               from Navigation_Group__c 
                               where site__c = :site[0].id 
                               order by sort_order__c asc nulls first];
            Id[] GroupIds = new Id[]{};
            map<id, NavigationGroup> GroupMap = new map<id, NavigationGroup>();
            for(navigation_group__c grp : this.main.navigation_groups__r){
                groups.add(grp.Chatter_Group__c);
            }
            for(CollaborationGroup chatter : [select name, id from collaborationgroup where name = :groups]){
                chatterMap.put(chatter.name, chatter.id);
            }
            for(Navigation_Group__c grp : this.main.navigation_groups__r){
                GroupIds.add(grp.id);
                NavigationGroup ng = new NavigationGroup();
                    ng.id = grp.id;
                    ng.label = grp.name;
                    ng.url = '#';
                    if(grp.chatter_group__c != null && chatterMap.get(grp.chatter_group__c) != null){
                        ng.url = '/apex/group?id='+chatterMap.get(grp.chatter_group__c);
                    }else if(grp.url__c != null){ 
                        ng.url = 'http://'+grp.url__c;
                    }else if(grp.page__c != null){
                       ng.url = '/apex/page?id='+grp.page__c;
                       if(grp.page__r.clean_url__c != null){
                           ng.url = grp.page__r.clean_url__c;
                       }
                    }else{
                       ng.url = '#'; 
                    }
                    ng.isMegaMenu = grp.isMegaMenu__c;
                    ng.links = new Navigation_Link__c[]{};
                    /*if(grp.chatter_group__c != null && chatterMap.get(grp.chatter_group__c) != null){
                        ng.url = '/apex/group?id='+chatterMap.get(grp.chatter_group__c);
                    }*/
                GroupMap.put(grp.id, ng);
            }
            Navigation_Link__c[] links = [select id, name, Navigation_Group__c, recordtype.name, page__c, redirect__c, page__r.Clean_URL__c, 
                                          (select id, page__c, name, redirect__c, page__r.clean_url__c
                                           from navigation_links__r 
                                           order by sort_order__c asc nulls first) 
                                          from navigation_link__c 
                                          where navigation_group__c = : GroupIds 
                                          order by sort_order__c asc nulls first];
            for(Navigation_Link__c link : links){
                    GroupMap.get(link.Navigation_Group__c).links.add(link);
            }
            this.NavigationGroups = new NavigationGroup[]{};
            for(id record :GroupMap.keySet()){
                this.NavigationGroups.add(GroupMap.get(record));
            }
        }
        
        if(UserInfo.getUserType() != 'Guest'){
                loggedInUser = '1';
            } else {
                loggedInUser = '0';
            }
        
    }
}