/* Update Phone Number of all contacts under Account when Phone Number of that Account is updated.  */
public with sharing class AccountTriggerHandler {
  public static void afterUpdate(List<Account> newAccountList) {
    // Create updateList to store the Contact object that needs to be update
    List<Contact> updateList = new List<Contact>();
    Map<String, String> accountMap = new Map<String, String>();

    // Retrieve only Id to be use in search query
    List<String> accountSearchList = new List<String>();
    for (Account a : newAccountList) {
      accountSearchList.add(a.Id);
      accountMap.put(a.Id, a.Phone);
    }

    // Get all Contacts Record that have the same name as edited Account
    List<Contact> contactTarget = [
      SELECT AccountId, AssistantPhone
      FROM Contact
      WHERE AccountId IN :accountSearchList
    ];

    /*Map<String, Account> accountMap = new Map<String, Account>(
            [SELECT Id, Phone FROM Account WHERE Id IN :accountSearchList]
        );*/

    // loop through all Contact, and update every Contact's Assistant Phone
    for (Contact c : contactTarget) {
      c.AssistantPhone = accountMap.get(c.AccountId);
      updateList.add(c);
    }

    // Finally, update value in sObject
    update updateList;
  }
}
