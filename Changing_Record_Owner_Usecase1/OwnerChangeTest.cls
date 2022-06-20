/*
  @Description       : When an account owner is changed, update the ownership of the related contact, opportunity, quote and orders. 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/
@isTest

public with sharing class OwnerChangeTest {
 
    @isTest public static void singleAccountOwnerChange() {
        // Data Setup
        
        User user1 = DataFactory.createUser1();
        insert user1;

        User user2 = DataFactory.createUser2();
        insert user2;

        Account a = new Account(
            Name = 'Test 1',
            OwnerId = user1.Id
        );
        insert a;

        Contact c = new Contact(
            AccountId = a.Id,
            LastName = 'Test Last Name',
            OwnerId = user1.Id
        );

        insert c;
        
        Opportunity opp = new Opportunity(
        	Name = 'Denver Opportunity',
        	StageName = 'Prospecting',
        	CloseDate = date.today(),
       		AccountId = a.Id,
        	OwnerId = user1.Id
        );
        
        insert opp;
        
        Contract contra = new Contract(
        	Status = 'Draft',
        	StartDate = date.today(),
        	AccountId = a.Id,
        	ContractTerm = 12,
        	OwnerId = user1.Id
        );
        
        insert contra;
        
        Order ord = new Order(
        	AccountId = a.Id,
            Status = 'Draft',
            ContractId = contra.Id,
            EffectiveDate = date.today(),
        	OwnerId = user1.Id
        );
        
        insert ord;

        Account aOwnerUpdate = [
            SELECT Id, Name, OwnerId,
            (SELECT Id, OwnerId FROM Contacts)
            FROM Account
            WHERE Id = :a.Id
        ];

        // Initialize Test
        Test.startTest();

        aOwnerUpdate.OwnerId = user2.Id;      
        update aOwnerUpdate;
       	Map<Id, Account> testAccount = new Map<Id, Account>();
        testAccount.put(a.Id, a);
        List<Account> accIds = new List<Account>();
        accIds.add(aOwnerUpdate);
        updateAccountTriggerHandler.updateOwner(accIds, testAccount);
        System.debug('testAccount-->  '+testAccount);
        System.debug('accId-->  '+accIds);
        Test.stopTest();

    }
}