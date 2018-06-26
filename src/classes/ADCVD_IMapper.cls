public interface ADCVD_IMapper {
	ADCVD_IMapper getInstance();
	Map<Id,SObject> getMap(Boolean includeLocked);
}