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
      if (c.ContactId == null) {
        //   c.addError('Contact Name cannot be blank! CaseTriggerHandler AFTER_INSERT');
        continue;
      }

      if (oldCaseMap == null) {
        contactIds.add(newContactId);
        continue;
      }

      String oldContactId = oldCaseMap.get(c.Id).ContactId;
      //   System.debug(oldContactId);
      //   System.debug(newContactId);
      if (oldContactId != newContactId) {
        contactIds.add(oldContactId);
        contactIds.add(newContactId);
      }
    }

    countCase(contactIds);
  }

  public static void countCase(Set<String> contactIds) {
    // Query cases that have contactId in the contactIds List.
    List<Case> caseList = [
      SELECT Id, ContactId
      FROM Case
      WHERE ContactId IN :contactIds
    ];

    // Count howm many Case have the particular Contact
    Map<String, Integer> contactCount = new Map<String, Integer>();
    for (Case c : caseList) {
      if (contactCount.containsKey(c.ContactId)) {
        Integer count = contactCount.get(c.ContactId) + 1;
        contactCount.put(c.contactId, count);
      } else {
        contactCount.put(c.contactId, 1);
      }
    }

    Set<String> key = contactCount.keySet();
    List<Contact> updateList = new List<Contact>();

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
