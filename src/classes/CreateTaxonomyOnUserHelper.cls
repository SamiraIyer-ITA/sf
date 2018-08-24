public class CreateTaxonomyOnUserHelper {

    public Static void createTaxonomy(list<User> Users)
    {
        list<String> offices = new list<String>();
        Map<String, Department_Taxonomy__c> DTMap = new Map<String, Department_Taxonomy__c>();
        list<Department_Taxonomy__c> taxonomy = new list<Department_Taxonomy__c>();
        for(User usr : Users){
            if(usr.ITA_Office__c != null){
                offices.add(usr.ITA_Office__c);
            }
        }
        if(offices.size() > 0){
            taxonomy = [Select Id, Level_0__c, All__c, Country__c, DAS__c, Office__c, Region_1__c, Region_2__c, Old_Office_Name__c from Department_Taxonomy__c where Old_Office_Name__c in : offices];
        }
        if(taxonomy.size() > 0){
            for(Department_Taxonomy__c dt : taxonomy) {
                DTMap.put(dt.Old_Office_Name__c, dt);
            }
        }
        for(User usr : Users){
            if(usr.ITA_Office__c != null){
                if(DTMap.get(usr.ITA_Office__c) != null) {
                    usr.RH_Lev_7_Individual__c = DTMap.get(usr.ITA_Office__c).Level_0__c;
                    usr.RH_Lev_1_Top_Level__c = DTMap.get(Usr.ITA_Office__c).All__c;
                    usr.RH_Lev_2_DAS_Level__c = DTMap.get(Usr.ITA_Office__c).DAS__c;
                    usr.RH_Lev_3_Region_2__c = DTMap.get(Usr.ITA_Office__c).Region_2__c;
                    usr.RH_Lev_4_Region_1__c = DTMap.get(Usr.ITA_Office__c).Region_1__c;
                    usr.RH_Lev_5_Country__c = DTMap.get(Usr.ITA_Office__c).Country__c;
                    usr.RH_Lev_6_Office__c = DTMap.get(Usr.ITA_Office__c).Old_Office_Name__c;
                }
            }
        }
    }
}