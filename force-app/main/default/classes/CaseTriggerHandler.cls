/*
This class will be used for updating the case counter in Contact.
Contact |--< Case.ContactId
*/
public class CaseTriggerHandler {
  public static void afterInsertUpdateDelete(
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

    countCase(contactIds);
  }

  public static void countCase(Set<String> contactIds) {
    // Query to retrieve Cases that have ContactId in the contactIds List.
    List<Case> caseList = [
      SELECT Id, ContactId
      FROM Case
      WHERE ContactId IN :contactIds
    ];

    // Count how many Case have the particular Contact
    Map<String, Integer> contactCount = new Map<String, Integer>();
    for (Case c : caseList) {
      if (contactCount.containsKey(c.ContactId)) {
        Integer count = contactCount.get(c.ContactId);
      } else {
        Integer count = 0;
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
}
