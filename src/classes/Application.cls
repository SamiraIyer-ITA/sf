Global class Application{
    /*
    This class provides over-all support of an Application for a specific user's Organization and the provided Program.
    */

    public Set<String> getStandardFields(){
        Set<String> output = new Set<String>(new String[]{'Organization__c', 'Id', 'Name', 'Public_Display_Name__c', 'City__c', 'Street__c', 'State__c', 'Postal_Code__c'});           
        return output;
    }

    private User getCurrentUser(){
        return [SELECT 
            id, firstname, lastname, email, phone, fax,
            contactid, contact.accountid, contact.account.name, contact.account.billingcity, contact.account.billingstatecode, contact.account.billingstate, 
            contact.account.billingstreet, contact.account.billingpostalcode 
            FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
    }
    
    public Participation__c getApplicationById(Set<string> fields, ID Application){
        String query = 'SELECT ';
        query += this.getQueryFields(fields);
        query += ' FROM Participation__c WHERE Id = \''+Application+'\' limit 1';
        system.debug(query);
        try{
            return database.query(query);
        }catch(exception e){
            system.debug(e);
        }
        return null;
    }
    
    private String getQueryFields(set<string> fields){
        List<string> fieldList = new list<String>(fields); 
        String output = ''; 
        output += String.join(fieldList, ', ');        
        return output;
    }
    
    public Participation__c getApplication(Set<string> fields, Id Program){
    //The field list needs to be an iterable List, but each field must be unique in the list.
    //To resolve this, the parameter 'fields' must be a set, and then the list.addAll method converts the set to a new list.
        String query = 'SELECT ';
        query += getQueryFields(fields);
        query += ' FROM Participation__c WHERE program__c = \''+Program+'\' AND Organization__c = \''+this.getCurrentUser().Contact.AccountId+'\' limit 1';
        system.debug(query);
        try{
            return database.query(query);
        }catch(exception e){
            system.debug(e);
        }
        return null;
    }
    
    public List<Order> getOrders(Id ApplicationId, List<String> Status){
        //Get a list of Orders and their Order Items for the specified application.
        return [select id, Program__c, Order_Paid__c, Status, (select id, unitprice, product2id from orderItems) from order where participant__c = :ApplicationId AND Status IN :Status];
    }

    public Order createOrder(Id Application, Id Program, Id Pricebook){
        try{
            Order order = new Order(
                Program__c = Program,
                Participant__c = Application,
                Status = 'In Progress',
                effectivedate = Date.today(),
                AccountId = this.getCurrentUser().contact.accountid,
                Pricebook2Id = Pricebook
            );
            insert order;
            return order;
        }catch(Exception e){
            system.debug(e);
        }
        return null;        
    }

    Public Order createOrder(Id Application, Id Program){
        try{
            Order order = new Order(
                Program__c = Program,
                Participant__c = Application,
                Status = 'In Progress',
                effectivedate = Date.today(),
                AccountId = this.getCurrentUser().contact.accountid
            );
            insert order;
            return order;
        }catch(Exception e){
            system.debug(e);
        }
        return null;    
    }

    public List<Order> getOrders(Id ApplicationId, String Status){
        //Get a list of Orders and their Order Items for the specified application.
        return [select id, Program__c, Order_Paid__c, (select id, unitprice, product2id from orderItems) from order where participant__c = :ApplicationId AND Status = :Status];
    }

    public List<Order> getOrders(Id ApplicationId){
        //Get a list of Orders and their Order Items for the specified application.
        return [select id, status, Program__c, Order_Paid__c, (select id, unitprice, product2id from orderItems) from order where participant__c = :ApplicationId];
    }

    public List<Asset> getAssets(Id ApplicationId, String Status){
        return [select id, product2.name, product2Id, Inactive_Status_Reason__c, Inactive_Status_Reason__r.Name, Inactive_Status_Reason__r.Description__c from Asset where Participant__c = :ApplicationId AND Status = :Status];
    }

    public List<Asset> getAssets(Id ApplicationId, List<String> Status){
        return [select id, status, product2.name, product2Id, Inactive_Status_Reason__c, Inactive_Status_Reason__r.Name, Inactive_Status_Reason__r.Description__c from Asset where Participant__c = :ApplicationId AND Status IN :Status];
    }
    
    public List<Asset> getAssets(Id ApplicationId){
        return [select id, Status,  product2.name, product2Id, Inactive_Status_Reason__c, Inactive_Status_Reason__r.Name, Inactive_Status_Reason__r.Description__c from Asset where Participant__c = :ApplicationId];
    }
    
    public Participation__c createApplication(Id Program){
        Participation__c app = new Participation__c(
            name = this.getCurrentUser().contact.account.name,
            public_display_name__c = this.getCurrentUser().contact.account.name,
            organization__c = this.getCurrentUser().contact.accountId,
            program__c = Program,
            city__c = this.getCurrentUser().contact.account.billingcity,
            street__c = this.getCurrentUser().contact.account.billingstreet,            
            state__c = this.getCurrentUser().contact.account.billingstate,
            postal_code__c = this.getCurrentUser().contact.account.billingpostalcode  
        );
        
/*        try{
            insert app;
        }catch(Exception e){
            system.debug(e);
        }*/
        return app;
    }
    
    Public PageReference findFormPage(Id Form, Boolean hasApplication){
        if(hasApplication){
            PageReference destination = Page.Form;
            destination.getParameters().put('id', Form);
            destination.setRedirect(true);
            return destination;
        }else{
            PageReference destination = Page.Form_Start;
            destination.getParameters().put('id', Form);
            destination.setRedirect(true);
            return destination;
        }
        return null;
    }
    
    public pageReference submit(Order order, id application, id account, string subject, string recordtypename, string description, string redirect){
        boolean showError = false;
        if([select id from orderItem where orderid = :order.id limit 10].size() != 0){
            order.order_paid__c = true;
            order.status = 'Paid';
            try{
                update order;
            }Catch(Exception e){
                showError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ErrorMessaging.clearMessage(e.getMessage())));
            }
        }else if(order.id != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'You must select at least 1 product/service that you provide.'));
            showError = true;
        }
        if(!showError){
            Id recordType = [select id from recordtype where sobjecttype = 'Case' and DeveloperName = :recordtypename limit 1].id;        
            Case c = new Case(subject = subject, order__c = order.id, participation_profile__c = application, recordtypeid = recordtype, accountid = account, description = description);
            Database.DMLOptions dmo = new Database.DMLOptions();        
                dmo.assignmentRuleHeader.useDefaultRule = true;     
            c.setOptions(dmo);
            try{
                insert c;
            }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.fatal, ErrorMessaging.clearMessage(e.getMessage())));
            showError = true;            
            }
        }

        if(showError){
            return null;
        }

        PageReference pr = new PageReference(redirect);
        pr.setRedirect(true);

        return pr;
    }
    
}