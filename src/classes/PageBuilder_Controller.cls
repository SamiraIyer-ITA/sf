public with sharing class PageBuilder_Controller {

public string PageName {get; set;}

public map<id, Template_Page__c> templateMap {get; set;}

public Template_Page__c[] getTemplates(){
    this.templateMap = new map<id, Template_Page__c>();
    Template_Page__c[] templates = [select id, name, description__c, image__c, (select id, sort_order__c, container__c from rows__r order by sort_order__c asc),  (select id, name, container__c, row__c, recordtype.developername, Sort_Order__c from Page_Contents__r order by sort_order__c asc) from template_page__c where isActive__c = true];
    for(Template_Page__c tmp : templates){
        this.templateMap.put(tmp.id, tmp);
    }    
    return templates;
}

public pageReference buildPage(){
    if(ApexPages.currentPage().getParameters().get('template') != null){
        if(String.isEmpty(this.PageName)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide a valid Name for your page.'));
            return null;
        }
        
        Page__c page = new Page__c();
        page.name = PageName;
        page.page__c = ApexPages.currentPage().getParameters().get('template');
        insert page;
        Row__c[] rows = new Row__c[]{};
        integer i = 0;
        for(Template_Row__c r : templateMap.get(ApexPages.currentPage().getParameters().get('template')).rows__r){
            i++;
            Row__c row = new Row__c();
            row.page__c = page.id;
            row.name = page.name+' - '+i;
            row.sort_order__c = r.sort_order__c;
            row.container__c = r.container__c;
            row.row__c = r.id;
            rows.add(row);
        }
        insert rows;
        map<id, id> rowMap = new map<id, id>();
        for(row__c r : rows){
            rowMap.put(r.row__c, r.id);
        }
        Page_Content__c[] pc = new Page_Content__c[]{};
        set<string> recordTypes = new set<string>();
        for(Template_Page_Content__c tmp_content : templateMap.get(ApexPages.currentPage().getParameters().get('template')).Page_Contents__r){
            recordTypes.add(tmp_content.recordtype.developername);
        }
        system.debug(recordTypes);
        map<string, id> recordTypeMap = new map<string, id>();
        for(RecordType rt : [select id, developername from RecordType where developername = :recordTypes and sObjectType = 'Page_Content__c']){
            recordTypeMap.put(rt.developername, rt.id);
        }
        system.debug(recordTypeMap);
        for(Template_Page_Content__c tmp_content : templateMap.get(ApexPages.currentPage().getParameters().get('template')).Page_Contents__r){
            Page_Content__c content = new Page_Content__c();
            content.content_container__c = tmp_content.container__c;
            if(tmp_content.row__c != null && rowMap.get(tmp_content.row__c) != null){
                content.row__c = rowMap.get(tmp_content.row__c);
            }
            content.page__c = page.id;
            content.recordTypeId = recordTypeMap.get(tmp_content.recordtype.developername);
            content.sortorder__c = tmp_content.sort_order__c;
            pc.add(content);
        }
        insert pc;
        try{
            PageReference pg = new PageReference('/'+page.id);
            pg.setRedirect(true);
        
            return pg;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    return null;
}

}