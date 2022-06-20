/*
  @Description       : When an account owner is changed, update the ownership of the related contact, opportunity, quote and orders. 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/

trigger ChangeRelatedRecordsOwnership on Account (after Update, after insert) {
    if(trigger.IsAfter && trigger.IsUpdate){
        updateAccountTriggerHandler.updateOwner(Trigger.new, Trigger.oldMap);
    }
    
}