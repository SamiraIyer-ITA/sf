/*
Name: MyOrdersComponentController
Author: Dan Kelner
Date Created: 09/23/16
Purpose: Controller for MyOrdersComponent, a VF component designed for use in Privacy Shield
*/

public class MyOrdersComponentController {
    
    public List<Order> orders {get; set;}    //Require the following: EffectiveDate, OrderNumber, Participant__c, AccountID, 
                                         //                       OrderItems subquery (with Pricebookentry.Product2.Name), 
                                         //                       Payments__r subquery (with Transaction_Date__c, Pay_Gov_Tracking_Id__c, 
                                         //                       Transaction_Amount__c, and Total_Refunds__c)
    


    public string getMonth(integer month){
        map<integer, string> months = new map<integer, string>();
            months.put(1, 'January');
            months.put(2, 'February');
            months.put(3, 'March');
            months.put(4, 'April');
            months.put(5, 'May');
            months.put(6, 'June');
            months.put(7, 'July');
            months.put(8, 'August');
            months.put(9, 'September');
            months.put(10, 'October');
            months.put(11, 'November');
            months.put(12, 'December');
        return months.get(month);
    }
    
    public void MyOrdersComponentController(){

    }
    
    public map<id, EcommOrder> getOrderMap(){
        map<id, EcommOrder> output = new map<id, EcommOrder>();        
        List<Id> orderIds = new List<Id>();
        List<Id> productIds = new List<Id>();
        id AccountId = null;
        for(Order order : this.orders){
            orderIds.add(order.id);
            AccountId = order.accountId;
        }
            //@@TODO:  handle the following query errors gracefully.
        Account account = [select id, (select id, UsageEndDate, product2Id from Assets) from Account where id = :AccountId limit 1];
        
        List<Refund__c> refunds = [select id, payment__r.order__c, pay_gov_tracking_id__c, transaction_date__c, transaction_amount__c, transaction_status__c from refund__c where payment__r.order__c = :orderIds];
        for(order order : this.orders){
            EcommOrder tmpOrder = new EcommOrder();
                tmpOrder.orderNumber = order.orderNumber;
                tmpOrder.orderDate = getMonth(order.CreatedDate.Month())+' '+order.CreatedDate.Day()+', '+order.CreatedDate.Year();
                tmpOrder.Products = new map<id, EcommProduct>();
                tmpOrder.Transactions = new map<string, EcommTransaction>();
            for(OrderItem orderItem : order.orderItems){
                EcommProduct tmpProduct = new EcommProduct();
                    tmpProduct.name = orderItem.Pricebookentry.Product2.Name;
                    for(Asset asset : account.assets){
                        if(asset.product2Id == OrderItem.Pricebookentry.product2Id){
                            tmpProduct.NextCertification = asset.UsageEndDate.Month()+'/'+asset.UsageEndDate.Day()+'/'+asset.UsageEndDate.Year();
                        }
                    }
                tmpOrder.Products.put(orderItem.Pricebookentry.product2Id, tmpProduct);
            }
            for(Payment__c payment : order.payments__r){
                if(payment.transaction_date__c != null){
                EcommTransaction tmpTransaction = new EcommTransaction();
                    tmpTransaction.TransactionDate = '' + payment.transaction_date__c.month() + 
                        '/'+payment.transaction_date__c.day() + 
                        '/'+payment.transaction_date__c.year()+
                        ' '+(payment.transaction_date__c.hour() >= 12 ? payment.transaction_date__c.hour() - 12 : payment.transaction_date__c.hour())+
                        ':'+payment.transaction_date__c.minute()+
                        ':'+payment.transaction_date__c.second();
                        if(payment.transaction_date__c.hour() >= 12){
                            tmpTransaction.TransactionDate += 'PM';
                        }else{
                            tmpTransaction.TransactionDate += 'AM';
                        }
                    tmpTransaction.Amount = '$ '+payment.transaction_amount__c+' USD';
                    tmpTransaction.Status = payment.transaction_status__c;
                    tmpTransaction.Type = 'Payment';
                tmpOrder.Transactions.put(payment.pay_gov_tracking_id__c, tmpTransaction);
                }
            }
            for(Refund__c refund : refunds){
                if(refund.payment__r.order__c == order.id){
                    if(refund.transaction_date__c != null){
                    EcommTransaction tmpTransaction = new EcommTransaction();
                        tmpTransaction.TransactionDate = '' + refund.transaction_date__c.month() + 
                            '/'+refund.transaction_date__c.day() + 
                            '/'+refund.transaction_date__c.year()+
                            ' '+(refund.transaction_date__c.hour() >= 12 ? refund.transaction_date__c.hour() - 12 : refund.transaction_date__c.hour())+
                            ':'+refund.transaction_date__c.minute()+
                            ':'+refund.transaction_date__c.second();
                            if(refund.transaction_date__c.hour() >= 12){
                                tmpTransaction.TransactionDate += 'PM';
                            }else{
                                tmpTransaction.TransactionDate += 'AM';
                            }
                        tmpTransaction.Amount = '$ '+refund.transaction_amount__c+' USD';
                        tmpTransaction.Status = refund.transaction_status__c;
                        tmpTransaction.Type = 'Refund';
                    tmpOrder.Transactions.put(refund.pay_gov_tracking_id__c, tmpTransaction);     
                    }           
                }
            }
            if(order.orderItems.size() != 0){
                output.put(order.id, tmpOrder);
            }
        }
        return output;
    }
    
    public class EcommOrder {
        public string orderNumber {get; set;}
        public string orderDate {get; set;}
        public map<id, EcommProduct> Products {get; set;}
        public map<string, EcommTransaction> Transactions {get; set;}
    }

    public class EcommProduct {
        public string Name {get; set;}
        public string NextCertification {get; set;}
    }
    
    public class EcommTransaction{
        public string TransactionDate {get; set;}
        public string Amount {get; set;}
        public string Status {get; set;}
        public string Type {get; set;}
    }
}