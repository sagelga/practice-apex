trigger CaseTrigger on Case (after insert, after update, after delete) {
    switch on Trigger.operationType {
            when AFTER_INSERT {
                    // System.debug('After Insert Trigger');
                    CaseTriggerHandler.afterInsertUpdateDelete(Trigger.new, null);
            }
            when AFTER_UPDATE {
                    // System.debug('After Update Trigger');
                    CaseTriggerHandler.afterInsertUpdateDelete(Trigger.new, Trigger.oldMap);
            }
            when AFTER_DELETE {
                    // System.debug('After Delete Trigger');
                    CaseTriggerHandler.afterInsertUpdateDelete(Trigger.old, null);
            }
    }
}
