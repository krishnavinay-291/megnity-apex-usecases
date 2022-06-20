/*
  @Description       : For partners, If a user is deactivated in salesforce, all the company, contact, opportunity  
                       owned by him should be shared with the other user belongs to the same company of the deactivated user 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/
@isTest
public class AssignActiveUserRecordsTest {
    @testSetup public static void TestNewlyAssignedRecords(){
        // Create User
        User usr = new User(alias = 'utest', email='krishnavinay1993@gmail.com',
                            emailencodingkey='UTF-8', firstName='First', lastname='Last', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = '00e5g000003Mpv6AAC',
                            timezonesidkey='Europe/London', username='krishnavinay19938@gmail.com', IsActive=true
                           );
        insert usr;
        // Create Account
        Account a = new Account();
        a.Name = 'Denver Steels';
        a.OwnerId = usr.Id;
        insert a;
        // Create Contact
        Contact c = new Contact();
        c.FirstName = 'Stephen';
        c.LastName = 'George';
        c.OwnerId = usr.Id;
        insert c;
        // ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Denver Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = date.today();
        opp.OwnerId = usr.Id;
        insert opp;
        // Create Quote
        Quote q = new Quote();
        q.Name = 'Selected Product';
        q.OpportunityId = opp.Id;
        // q.Pricebook2Id = 'selectedPriceBook';
        q.ExpirationDate = date.today()+90;
        q.OwnerId = opp.OwnerId;
        insert q;  
    }
    // Using a different method to deactivate the newly created user because 
    //"dml operation on setup object is not permitted after you have updated a non-setup object"
    @isTest public static void TestNewlyAssignedRecords1(){
        User NewUser = [SELECT Id, IsActive, ProfileId FROM User WHERE username='krishnavinay19938@gmail.com' LIMIT 1];
        NewUser.IsActive = false;
        update NewUser;
        Test.startTest();
        RecordsUpdatingOwner.updateOwnerFromInactive(NewUser.Id, NewUser.ProfileId);
        Test.stopTest();
    }
}