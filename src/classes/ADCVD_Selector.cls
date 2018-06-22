public interface ADCVD_Selector {
	ADCVD_Selector getInstance();
	Map<Id,SObject> getMap(Boolean includeLocked);
}