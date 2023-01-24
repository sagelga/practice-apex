trigger AccountTrigger on Account(after update) {
	AccountTriggerHandler.afterUpdate(Trigger.new);
}
