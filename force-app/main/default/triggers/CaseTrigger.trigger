trigger CaseTrigger on Case (after insert, after update, after delete) {
    switch on Trigger.operationType {
            when AFTER_INSERT {
                    // System.debug('After Insert Trigger');
                    CaseTriggerHandler.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE {
                    // System.debug('After Update Trigger');
                    CaseTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
            }
            when AFTER_DELETE {
                    // System.debug('After Delete Trigger');
                    CaseTriggerHandler.afterDelete(Trigger.old);
            }
    }
}