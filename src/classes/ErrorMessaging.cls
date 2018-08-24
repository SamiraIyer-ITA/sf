Global class ErrorMessaging{
    Global static String clearMessage(string msg){
        if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            String[] parts = msg.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
            string fin = parts[1].split(':')[0];
            return fin;
        }
        return msg;
    }
}