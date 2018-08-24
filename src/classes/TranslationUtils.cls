Global Class TranslationUtils{

    Global static Map<String, String> getUITranslationsById(List<String> terms, Id SelectedLanguage){
        Map<String, String> output = new Map<String, String>();
        for(Translation__c translation : [SELECT id, translation__c, name FROM Translation__c WHERE Language__c = :SelectedLanguage AND name IN :terms]){
            output.put(translation.name, translation.translation__c);
        }
        return output;
    }
    
    Global static Map<String, String> getUITranslationsByIso(List<String> terms, String languageIso) {
        Map<String, String> output = new Map<String, String>();
        for(Translation__c translation : [SELECT id, translation__c, name FROM Translation__c WHERE Language__r.ISO_639_1__c = :languageIso AND name IN :terms]){
            output.put(translation.name, translation.translation__c);
        }
        return output;
    }

}