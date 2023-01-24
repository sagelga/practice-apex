/*
This class will be used for updating the case counter in Contact.
Contact |--< Case.ContactId
*/
public class CaseTriggerHandler {
    public static void afterInsert(List<Case> newCaseList) {
        List<String> contactIds = new List<String>();
        for (Case c : newCaseList) {
            contactIds.add(c.ContactId);
        }

        List<Case> caseList = [
            SELECT Id, ContactId
            FROM Case
            WHERE  ContactId IN :contactIds
        ];

        // Call countContact()
        Map<String, Integer> contactCount = countContact(caseList);

        Set<String> key = contactCount.keySet();
        List<Contact> updateList = new List<Contact>();
        for (String k : key) {
            Contact c = new Contact();
            c.Id = k;
            c.Case_Count__c = contactCount.get(k);
            updateList.add(c);
        }
        update updateList;
    }

    public static void afterDelete(List<Case> newCaseList) {
        List<String> contactIds = new List<String>();
        List<String> deletedCaseIds = new List<String>();
        for (Case c : newCaseList) {
            contactIds.add(c.ContactId);
            deletedCaseIds.add(c.Id);
        }

        List<Case> caseList = [
            SELECT Id, ContactId
            FROM Case
            WHERE ContactId IN :contactIds
        ];

        // Call countContact()
        Map<String, Integer> contactCount = countContact(caseList);

        Set<String> key = contactCount.keySet();
        List<Contact> updateList = new List<Contact>();
        for (String k : key) {
            Contact c = new Contact();
            c.Id = k;
            c.Case_Count__c = contactCount.get(k);
            updateList.add(c);
        }
        update updateList;
    }

    public static void afterUpdate(
        List<Case> newCaseList,
        Map<Id, Case> oldCaseList
    ) {
        List<String> newCaseId = new List<String>();
        for (Case c : newCaseList) {
            newCaseId.add(c.ContactId);
        }

        List<String> oldCaseId = new List<String>();
        for (Case c : newCaseList) {
            oldCaseId.add(oldCaseList.get(c.ContactId).ContactId);
        }

        List<Case> caseList = [
            SELECT Id, ContactId
            FROM Case
            WHERE ContactId IN :newCaseId OR ContactId IN :oldCaseId
        ];

        // Call countContact()
        Map<String, Integer> contactCount = countContact(caseList);

        Set<String> key = contactCount.keySet();
        List<Contact> updateList = new List<Contact>();
        for (String k : key) {
            Contact c = new Contact();
            c.Id = k;
            c.Case_Count__c = contactCount.get(k);
            updateList.add(c);
        }
        update updateList;
    }

     /* Creates Map of ContactId and number of cases it involves */
     public static Map<String, Integer> countContact(List<Case> caseList) {
        Map<String, Integer> contactCount = new Map<String, Integer>();
        for (Case c : caseList) {
            if (contactCount.containsKey(c.ContactId)) {
                Integer count = contactCount.get(c.ContactId) + 1;
                contactCount.put(c.contactId, count);
            } else {
                contactCount.put(c.contactId, 1);
            }
        }

        return contactCount;
    }
}