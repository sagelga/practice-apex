trigger CaseTrigger on Case (after insert, after update, after delete) {
    switch on Trigger.operationType {
            when AFTER_INSERT {
                    // System.debug('After Insert Trigger');
                    CaseTriggerHandler.updateContactCaseCountAfterChange(Trigger.new, null);
            }
            when AFTER_UPDATE {
                    // System.debug('After Update Trigger');
                    CaseTriggerHandler.updateContactCaseCountAfterChange(Trigger.new, Trigger.oldMap);
                    CaseTriggerHandler.sendEmailtoCaseContactAfterUpdate(Trigger.new);
            }
            when AFTER_DELETE {
                    // System.debug('After Delete Trigger');
                    CaseTriggerHandler.updateContactCaseCountAfterChange(Trigger.old, null);
            }
    }
}
