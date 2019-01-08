global class PrepareSandbox implements SandboxPostCopy 
{
	global void runApexClass(SandboxContext context)
	{
		System.debug('Org ID: ' + context.organizationId());
		System.debug('Sandbox ID: ' + context.sandboxId());
		System.debug('Sandbox Name: ' + context.sandboxName());
		String sandboxName = context.sandboxName();

		Database.executeBatch( new RevertUserEmailsBatchable() );
	}

}