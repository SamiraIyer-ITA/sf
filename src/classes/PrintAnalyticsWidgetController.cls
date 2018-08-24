public class PrintAnalyticsWidgetController {
	public String query{get; set;}
    public List<String> fieldLabels {get; set;}
    public List<String> fieldNames {get; set;}
    private static Map<String,String> nextMajorDeadlineFields = new Map<String,String>{
        'Next Major Deadline' => 'Next_Major_Deadline__c',
        'Product Short Name' => 'Product_Short_Name__c',
        'Country' => 'Country__c',
        'Record Type' => 'Object_Name',
        'Next Major Deadline Type' => 'Next_Major_Deadline_Type',
        'Office' => 'Office__c'
    };
 
/* To determine the records to perform the bulk action on, extract the SAQL query */
    public PageReference init() {
        query = ApexPages.currentPage().getParameters().get('query');
        if (query.contains('Next_Major_Deadline__c')) {
            fieldLabels = new List<String>();
            fieldNames = new List<String>();
            for (String s : nextMajorDeadlineFields.keySet()) {
                fieldLabels.add(s);
                fieldNames.add(nextMajorDeadlineFields.get(s));
            }
        } else if (query.contains('Next_Due_to_DAS_Deadline__c')) {
            
        } else if (query.contains('Next_Office_Deadline__c')) {
            
        }
        return null;
    }
}