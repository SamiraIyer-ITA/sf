public class QuoteLineItemSObjectMapper {
    
    public class NewServicesOrderItem extends SObjectsFieldMapper {
        
        public override Schema.SObjectType targetSObjectType() {
            return OrderItem.SObjectType;
        }
        
        public override Map<String, String> targetFieldsBySourceFields() {
            return new Map<String, String>{
                'Id'                => 'QuoteLineItemId',
                'Description'       => 'Description',
                'ListPrice'         => 'ListPrice',
                'Product2Id'        => 'Product2Id',
                'PricebookEntryId'  => 'PricebookEntryId',
                'Quantity'          => 'Quantity',
                'ServiceDate'       => 'ServiceDate',
                'UnitPrice'         => 'UnitPrice'
            };
        }
    }
    
    public class UpdateServicesOrderItem extends SObjectsFieldMapper {
        
        public override Schema.SObjectType targetSObjectType() {
            return OrderItem.SObjectType;
        }
        
        public override Map<String, String> targetFieldsBySourceFields() {
            return new Map<String, String>{
                'Description'       => 'Description',
                'Quantity'          => 'Quantity',
                'ServiceDate'       => 'ServiceDate',
                'UnitPrice'         => 'UnitPrice'
            };
        }
    }
}