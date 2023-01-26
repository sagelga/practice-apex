@isTest
public with sharing class CaseTriggerHandlerTest {
    @TestSetup
    static void makeData() {
        // Populating Contact
        List<Contact> contactList = new List<Contact>();
        contactList.add(new Contact(LastName = 'JaneDoe1'));
        contactList.add(new Contact(LastName = 'JaneDoe2'));
        contactList.add(new Contact(LastName = 'JaneDoe3'));
        contactList.add(new Contact(LastName = 'JaneDoe4'));

        // Commit Contact data
        insert contactList;

        // Populating Cases
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case());

        // Commit Cases
        insert caseList;
    }

    /* This method will test CaseTriggerHandler with insert */
    @isTest
    public static void testInsertNullContact() {
        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
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
    /* This method will test if the data is inserted and result in equal number of cases  */
    @isTest
    public static void testInsertEqualCase() {
        // Populating more Cases (in addition to setup data)
        List<Contact> contactList = [SELECT Id FROM Contact];
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[2].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));

        // Commit data
        insert caseList;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            4,
            contactRecord[0].Case_Count__c,
            'Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            4,
            contactRecord[1].Case_Count__c,
            'Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            4,
            contactRecord[2].Case_Count__c,
            'Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }

    /* This method will test if data is inserted again matches */
    @isTest
    public static void testInsertAfterInsert() {
        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
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

        // Populating more Cases
        List<Contact> contactList = [SELECT Id FROM Contact];
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[0].Id));
        caseList.add(new Case(ContactId = contactList[1].Id));
        caseList.add(new Case(ContactId = contactList[2].Id));

        Test.startTest();
        // Commit data
        insert caseList;
        Test.stopTest();

        // Query the record for checking the discrepancy
        contactRecord = [SELECT Id, Case_Count__c FROM Contact ORDER BY Id];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            6,
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

    /* This method will test CaseTriggerHandler with update */
    @isTest
    public static void testUpdateOtherField() {
        // List<Contact> contactList = [SELECT Id FROM Contact];
        List<Case> caseRecord = [SELECT Id, Status FROM Case];

        for (Case cas : caseRecord) {
            cas.Status = 'Working';
        }

        update caseRecord;

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
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
    public static void testUpdateContact() {
        // List<Contact> contactList = [SELECT Id FROM Contact];
        // List<Case> targetCaseList = [SELECT ContactId FROM Case];
        List<Case> caseRecord = [
            SELECT ContactId
            FROM Case
            WHERE Contact.LastName = 'JaneDoe1'
        ];
        String newContactId = [
            SELECT ContactId
            FROM Case
            WHERE Contact.LastName = 'JaneDoe2'
        ]
        .ContactId;

        System.debug(caseRecord);
        System.debug(newContactId);

        for (Case cas : caseRecord) {
            cas.ContactId = newContactId;
        }

        // Test by triggering CaseTriggerHandler
        Test.startTest();
        update caseRecord;
        Test.stopTest();

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            0,
            contactRecord[0].Case_Count__c,
            'Incorrect result for Jane Doe 1'
        ); // Jane Doe 1
        System.assertEquals(
            5,
            contactRecord[1].Case_Count__c,
            'Incorrect result for Jane Doe 2'
        ); // Jane Doe 2
        System.assertEquals(
            null,
            contactRecord[2].Case_Count__c,
            'Incorrect result for Jane Doe 3'
        ); // Jane Doe 3
    }

    /* This method will test CaseTriggerHander with deletion */
    @isTest
    public static void testDelete() {
        List<Case> caseRecord = [
            SELECT ContactId
            FROM Case
            WHERE Contact.LastName = 'JaneDoe1'
        ];

        System.debug(caseRecord);

        // Test by triggering CaseTriggerHandler
        Test.startTest();
        delete caseRecord;
        Test.stopTest();

        // Query the record for checking the discrepancy
        List<Contact> contactRecord = [
            SELECT Id, Case_Count__c
            FROM Contact
            ORDER BY Id
        ];
        System.debug(contactRecord);

        // Check discrepancy with the result
        System.assertEquals(
            0,
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
}
