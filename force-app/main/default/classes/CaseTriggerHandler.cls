/*
This class will run when CaseTrigger gets triggered after insert, update, and delete.
*/
public class CaseTriggerHandler {
    /*
      This method count how many Cases each Contact have.
      Triggered when there is a Case got created, edited and deleted.
      Contact |--< Case.ContactId
    */
    public static void updateContactCaseCountAfterChange(
        List<Case> newCaseList,
        Map<Id, Case> oldCaseMap
    ) {
        Set<String> contactIds = new Set<String>();

        for (Case c : newCaseList) {
            String newContactId = c.ContactId;
            // When the record get updated, and there is no related ContactId at all
            if (c.ContactId == null) {
                // c.addError('Contact Name cannot be blank! CaseTriggerHandler AFTER_INSERT');
                continue;
            }

            // If the Trigger was triggered by AFTER_INSERT or AFTER_DELETE, oldCaseMap will be null
            if (oldCaseMap == null) {
                contactIds.add(newContactId);
                continue;
            }

            String oldContactId = oldCaseMap.get(c.Id).ContactId;
            // System.debug(oldContactId);
            // System.debug(newContactId);
            if (oldContactId != newContactId) {
                contactIds.add(oldContactId);
                contactIds.add(newContactId);
            }
        }

        // Query to retrieve Cases that have ContactId in the contactIds List.
        List<Case> caseList = [
            SELECT Id, ContactId
            FROM Case
            WHERE ContactId IN :contactIds
        ];

        // Count how many Case have the particular Contact
        Map<String, Integer> contactCount = new Map<String, Integer>();
        for (Case c : caseList) {
            Integer count = 0;
            if (contactCount.containsKey(c.ContactId)) {
                count = contactCount.get(c.ContactId);
            }

            contactCount.put(c.contactId, count + 1);
        }

        Set<String> key = contactCount.keySet();
        List<Contact> updateList = new List<Contact>();

        // Make sure that Contact that have no Case gets updated,
        // since the query will not show any result (since there is no Case).
        for (String contactId : contactIds) {
            if (!key.contains(contactId)) {
                Contact c = new Contact();
                c.Id = contactId;
                c.Case_Count__c = 0;
                updateList.add(c);
            }
        }

        for (String k : key) {
            Contact c = new Contact();
            c.Id = k;
            c.Case_Count__c = contactCount.get(k);
            updateList.add(c);
        }
        update updateList;
    }

    /* This method will send an email to the Case owner (Contact) when the Case is 'Closed' */
    public static void sendEmailtoCaseContactAfterUpdate(
        List<Case> newCaseList
    ) {
        // Existed Case.Status option: 'New', 'Working','Escalated', 'Closed'.

        List<String> updateList = new List<String>();
        for (Case cas : newCaseList) {
            // Filter to get only Case.Status as 'Closed' to be processed.
            if (cas.Status == 'Closed') {
                updateList.add(cas.Id);
            }
        }

        // Get Contact list that have this following Case.
        Map<String, Contact> contactMap = new Map<String, Contact>([
            SELECT Id, Email
            FROM Contact
            WHERE Id IN :updateList
        ]);

        // Reserve/Limit emails sent via this txn
        Messaging.reserveSingleEmailCapacity(2);

        // For each Contact, get the email and send the email to that email address.
        // https://curious-raccoon-fvgaf1-dev-ed.trailblaze.lightning.force.com/lightning/r/Case/5002w00000dcjDhAAI/view
        for (Case case : newCaseList){

          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(contactMap.get(case.ContactId));
          mail.setSenderDisplayName('Salesforce Support');
          mail.setSubject('New Case Created : ' + case.Id);
          mail.setPlainTextBody('Your Case: ' + case.Id + ' has been created.');
        String caseUrl =
        'https://curious-raccoon-fvgaf1-dev-ed.trailblaze.lightning.force.com/lightning/r/Case/' +
        case.Id +
        '/view';
        mail.setHtmlBody(
          'Your case:<b> ' +
          case.Id +
          ' </b>has been created.<p>' +
          'To view your case <a href=' +
          caseUrl +
          '</a>'
          );
        }

          Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        }
}
