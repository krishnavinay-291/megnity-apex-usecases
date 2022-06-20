/*
  @Description       : For partners, If a user is deactivated in salesforce, all the company, contact, opportunity  
                       owned by him should be shared with the other user belongs to the same company of the deactivated user 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/
public class RecordsUpdatingOwner {
    @future
    public static void updateOwnerFromInactive(String deactivatedUserId, String deactivatedUserProfileId){
        //Get next active user
        List<User> NewUser = new List<User>();
        List<Account> accountUpdate = new List <Account>();
        List<Contact> contactUpdate = new List <Contact>();
        List<Opportunity> opportunityUpdate = new List <Opportunity>();
        NewUser = [SELECT Id, Name FROM User WHERE ProfileId = :deactivatedUserProfileId AND IsActive = true LIMIT 1];
        // Assign associated Account records to active user
        // List<Account> account = [SELECT Id, OwnerId FROM Account WHERE OwnerId=:deactivatedUserId];
        for(Account accObj : [SELECT Id, OwnerId FROM Account WHERE OwnerId=:deactivatedUserId]){
            accObj.OwnerId = NewUser[0].Id;
            accountUpdate.add(accObj);
        }
        // Assign associated Contact records to active user
        // List<Contact> contact = [SELECT Id, OwnerId FROM Contact WHERE OwnerId=:deactivatedUserId];
        for(Contact conObj : [SELECT Id, OwnerId FROM Contact WHERE OwnerId=:deactivatedUserId]){
            conObj.OwnerId = NewUser[0].Id;
            contactUpdate.add(conObj);
        }
        // Assign associated Opportunity records to active user
        // List<Opportunity> opportunity = [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId=:deactivatedUserId];
        for(Opportunity oppObj : [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId=:deactivatedUserId]){
            oppObj.OwnerId = NewUser[0].Id;
            opportunityUpdate.add(oppObj);
        }
        // Assign associated Quote records to active user
        /* List<Quote> quote = [SELECT Id, OwnerId FROM Quote WHERE OwnerId=:deactivatedUserId];
        for(Quote quoteObj : quote){
            quoteObj.OwnerId = NewUser[0].Id;
            update quote;
        } */
        update accountUpdate;
        update contactUpdate;
        update opportunityUpdate;
    }
}