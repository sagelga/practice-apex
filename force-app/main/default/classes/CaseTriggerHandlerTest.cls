@isTest
public with sharing class CaseTriggerHandlerTest {
    @TestSetup
    static void makeData() {
    }

    /* This method will test CaseTriggerHandler with insert */
    @isTest
    public static void testInsertZeroCase() {
        // Populating contact
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName = 'JaneDoe1'));
        contactList.add(new Contact(LastName = 'JaneDoe2'));
        contactList.add(new Contact(LastName = 'JaneDoe3'));

        // Commit data
        insert contactList;

        // Populating case
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [SELECT Id, Case_Count__c FROM Contact];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            4,
            contactRecord[0].Case_Count__c,
            'Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            1,
            contactRecord[1].Case_Count__c,
            'Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            null,
            contactRecord[2].Case_Count__c,
            'Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }

    @isTest
    public static void testInsertEqualCase() {
        // Populating contact
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName = 'JaneDoe1'));
        contactList.add(new Contact(LastName = 'JaneDoe2'));
        contactList.add(new Contact(LastName = 'JaneDoe3'));

        // Commit data
        insert contactList;

        // Populating case
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[2].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [SELECT Id, Case_Count__c FROM Contact];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            2,
            contactRecord[0].Case_Count__c,
            'Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            2,
            contactRecord[1].Case_Count__c,
            'Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            2,
            contactRecord[2].Case_Count__c,
            'Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }

    @isTest
    public static void testInsertUnequalCase() {
        // Populating contact
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName = 'JaneDoe1'));
        contactList.add(new Contact(LastName = 'JaneDoe2'));
        contactList.add(new Contact(LastName = 'JaneDoe3'));

        // Commit data
        insert contactList;

        // Populating case
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));
        System.debug(caseList);

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [SELECT Id, Case_Count__c FROM Contact];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            2,
            contactRecord[0].Case_Count__c,
            'Insert1 Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            1,
            contactRecord[1].Case_Count__c,
            'Insert1 Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            1,
            contactRecord[2].Case_Count__c,
            'Insert1 Incorrect result for Jane Doe 3'
        ); // Jane Doe 3

        // Populating more Cases
        caseList.clear(); // since prev. Case has been inserted, thus you cannot insert it again.
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        contactRecord = [SELECT Id, Case_Count__c FROM Contact];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            4,
            contactRecord[0].Case_Count__c,
            'Insert2 Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            2,
            contactRecord[1].Case_Count__c,
            'Insert2 Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            1,
            contactRecord[2].Case_Count__c,
            'Insert2 Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }

    @isTest
    public static void testInsertNullContact() {
        // Populating contact
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName = 'JaneDoe1'));
        contactList.add(new Contact(LastName = 'JaneDoe2'));
        contactList.add(new Contact(LastName = 'JaneDoe3'));

        // Commit data
        insert contactList;

        // Populating case
        List<Case> caseList = new List<Case>();
        caseList.add(new Case());
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case());
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case());

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [SELECT Id, Case_Count__c FROM Contact];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            2,
            contactRecord[0].Case_Count__c,
            'Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            1,
            contactRecord[1].Case_Count__c,
            'Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            null,
            contactRecord[2].Case_Count__c,
            'Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }
    /* This method will test CaseTriggerHandler with update */
    @isTest
    public static void testUpdate() {
    }

    /* This method will test CaseTriggerHander with deletion */
    @isTest
    public static void testDelete() {
    }
}
