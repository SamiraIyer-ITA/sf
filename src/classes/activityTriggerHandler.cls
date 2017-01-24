public class activityTriggerHandler {
	//public activityTriggerHandler(){}
    
    public void afterInsert(task[] task){ 
        task[] tasksToUpdate = new task[]{};
        id[] taskid = new id[]{};  
        for(task t: task){
            taskid.add(t.ownerId);
        }
        user[] u = [select id, RH_Lev_6_Office__c,RH_Lev_7_Individual__c,RH_Lev_4_Region_1__c,RH_Lev_3_Region_2__c,RH_Lev_2_DAS_Level__c,RH_Lev_1_Top_Level__c,RH_Lev_5_Country__c
                    from user
                   where id in :taskid];
        for(task t: task){
            task taskToUpdate = new task();
            for(user nu: u){
                if(t.ownerid == nu.id){
                    taskToUpdate.id = t.id;
                    taskToUpdate.RH_Lev_6_Office__c = nu.RH_Lev_6_Office__c;
                    taskToUpdate.RH_Lev_7_Individual__c = nu.RH_Lev_7_Individual__c;
                    taskToUpdate.RH_Lev_4_Region_1__c = nu.RH_Lev_4_Region_1__c;
                    taskToUpdate.RH_Lev_3_Region_2__c = nu.RH_Lev_3_Region_2__c;
                    taskToUpdate.RH_Lev_2_DAS__c = nu.RH_Lev_2_DAS_Level__c;
                    taskToUpdate.RH_Lev_1_GM_All__c = nu.RH_Lev_1_Top_Level__c;
                    taskToUpdate.RH_Lev_5_Country__c = nu.RH_Lev_5_Country__c;
                    tasksToUpdate.add(taskToUpdate);
                }
            }  
        }update tasksToUpdate;
    }
    public void afterUpdate(map<id, Task> oldTask, task[] newTask){ 
        task[] tasksToUpdate = new task[]{};
        id[] taskid = new id[]{};  
        for (task t: newTask){
            taskid.add(t.ownerId);
        }    
        user[] u = [select id, RH_Lev_6_Office__c,RH_Lev_7_Individual__c,RH_Lev_4_Region_1__c,RH_Lev_3_Region_2__c,RH_Lev_2_DAS_Level__c,RH_Lev_1_Top_Level__c,RH_Lev_5_Country__c
                    from user
                   where id in :taskid];
        for(task t: newtask){
            task myTask = new task();
                for(user nu: u){
                    if(t.OwnerId == nu.id){
                        if(t.ownerid != oldTask.get(t.id).ownerid){
                        	myTask.id = oldTask.get(t.id).id;
                            myTask.RH_Lev_6_Office__c = nu.RH_Lev_6_Office__c; 
                            myTask.RH_Lev_7_Individual__c = nu.RH_Lev_7_Individual__c;
                    		myTask.RH_Lev_4_Region_1__c = nu.RH_Lev_4_Region_1__c;
                    		myTask.RH_Lev_3_Region_2__c = nu.RH_Lev_3_Region_2__c;
                    		myTask.RH_Lev_2_DAS__c = nu.RH_Lev_2_DAS_Level__c;
                    		myTask.RH_Lev_1_GM_All__c = nu.RH_Lev_1_Top_Level__c;
                    		myTask.RH_Lev_5_Country__c = nu.RH_Lev_5_Country__c;
                    		tasksToUpdate.add(myTask); 
                        }    
                    }     
                }
        }update tasksToUpdate;
    }
}