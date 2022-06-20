/*
  @Description       : For partners, If a user is deactivated in salesforce, all the company, contact, opportunity  
                       owned by him should be shared with the other user belongs to the same company of the deactivated user 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/
trigger AssignRecords on User (after update) {
    for(User u : Trigger.New){
        if(u.IsActive == false){
            RecordsUpdatingOwner.updateOwnerFromInactive(u.Id, u.ProfileId);
        }
    }
}