global class CP_LightningForgotPasswordController {
    
    public CP_LightningForgotPasswordController() {
        
    }
    
    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        system.debug('firing off password');
        try {
            Site.forgotPassword(username);
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            if(!Site.isValidUsername(username)) {
                return Label.Site.invalid_email;
            }
            aura.redirect(checkEmailRef);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }
    
    @AuraEnabled
    global static String setExperienceId(String expId) {    
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                if(TEST.isRunningTest()){
                    system.debug('REPORT MESSAGE TO COMMINITY PAGE!');
                    return expId;
                }
                else
                {
                    Site.setExperienceId(expId); 
                }
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
}