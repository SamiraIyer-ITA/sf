/**
 * Interface for TriggerImpl
 */
public interface ITriggerImpl {

	void handleBeforeInsert();
	void handleBeforeUpdate();
	void handleBeforeDelete();
	void handleAfterInsert();
	void handleAfterUpdate();
	void handleAfterDelete();
	void handleAfterUndelete();

}