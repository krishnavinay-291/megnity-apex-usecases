/*
  @Description       : When an account owner is changed, update the ownership of the related contact, opportunity, quote and orders. 
  @Author            : Krishna Vinay Tadinada
  @last modified on  : 06-14-2022
  @last modified by  : Krishna Vinay Tadinada
*/
public class updateAccountTriggerHandler {
    public static void updateOwner(List<Account> accList, Map<Id, Account> oldmap){
        System.debug(accList);
        System.debug(oldmap);
        Set<Id> accIds = new Set<Id>();
        Map<Id, String> oldOwnerIds = new Map<Id, String>();
        Map<Id, String> newOwnerIds = new Map<Id, String>();
        Contact[] relatedContactUpdate = new Contact[0];
        Opportunity[] relatedOpportunityUpdate = new Opportunity[0];
        Quote[] relatedQuoteUpdate = new Quote[0];
        Order[] relatedOrderUpdate = new Order[0];
        System.debug('Started');
        
        for(Account acc : accList){
            System.debug(acc.OwnerId);
            System.debug(oldMap.get(acc.Id).OwnerId);
            if(acc.OwnerId != oldMap.get(acc.Id).OwnerId){
                oldOwnerIds.put(acc.Id, oldMap.get(acc.Id).OwnerId);
                newOwnerIds.put(acc.Id, acc.OwnerId);
                accIds.add(acc.Id);
            }
        }
        
        //If accIds not empty, query related contact and update Owner ID in Contact
        if(!accIds.isEmpty()){
            // Contact conta = [SELECT Id, OwnerId FROM Contact LIMIT 1];
            System.debug('conta');
            for (Account accts : [SELECT Id, (SELECT Id, OwnerId FROM Contacts) FROM Account WHERE Id in :accIds]){
                System.debug(accts);
                String newConOwnerId = newOwnerIds.get(accts.Id);
                String oldConOwnerId = oldOwnerIds.get(accts.Id);
                for(Contact con : accts.Contacts){
                    if(con.OwnerId == oldConOwnerId){
                        Contact updatedContact = new Contact(OwnerId = newConOwnerId, Id = con.Id);
                        relatedContactUpdate.add(updatedContact);
                    }
                }
            }
            for (Account accts : [SELECT Id, (SELECT Id, OwnerId FROM Opportunities) FROM Account WHERE Id in :accIds]){
                String newOppOwnerId = newOwnerIds.get(accts.Id);
                String oldOppOwnerId = oldOwnerIds.get(accts.Id);
                for(Opportunity opp : accts.Opportunities){
                    if(opp.OwnerId == oldOppOwnerId){
                        Opportunity updatedOpportunity = new Opportunity(OwnerId = newOppOwnerId, Id = opp.Id);
                        relatedOpportunityUpdate.add(updatedOpportunity);
                        /* for (Opportunity opps : [SELECT Id, (SELECT Id, OwnerId FROM Quotes) FROM Opportunity WHERE Id = :opp.Id]){
                            String newQuoteOwnerId = newOwnerIds.get(opps.Id);
                            String oldQuoteOwnerId = oldOwnerIds.get(opps.Id);
                            for(Quote quote : opps.Quotes){
                                System.debug(quote.OwnerId);
                                System.debug(oldQuoteOwnerId);
                                System.debug(oldQuoteOwnerId);
                                if(quote.OwnerId == oldQuoteOwnerId){
                                    Quote updatedQuote = new Quote(OwnerId = newQuoteOwnerId, Id = quote.Id);
                                    relatedQuoteUpdate.add(updatedQuote);
                                }
                            }
                        }*/
                    }
                }
            }
            /* for (Opportunity opps : [SELECT Id, (SELECT Id, OwnerId FROM Quotes) FROM Opportunity WHERE AccountId in :accIds]){
                String newQuoteOwnerId = newOwnerIds.get(opps.AccountId);
                System.debug(newQuoteOwnerId);
                String oldQuoteOwnerId = oldOwnerIds.get(opps.AccountId);
                for(Quote quote : opps.Quotes){
                    System.debug(quote.OwnerId);
                    System.debug(oldQuoteOwnerId);
                    System.debug(newQuoteOwnerId);
                    if(quote.OwnerId == oldQuoteOwnerId){
                        Quote updatedQuote = new Quote(OwnerId = newQuoteOwnerId, Id = quote.Id);
                        relatedQuoteUpdate.add(updatedQuote);
                    }
                }
            } */
            for (Account accts : [SELECT Id, (SELECT Id, OwnerId FROM Orders) FROM Account WHERE Id in :accIds]){
                String newOrderOwnerId = newOwnerIds.get(accts.Id);
                String oldOrderOwnerId = oldOwnerIds.get(accts.Id);
                for(Order ord : accts.Orders){
                    if(ord.OwnerId == oldOrderOwnerId){
                        Order updatedOrder = new Order(OwnerId = newOrderOwnerId, Id = ord.Id);
                        relatedOrderUpdate.add(updatedOrder);
                    }
                }
            }
        }
        update relatedContactUpdate;
        update relatedOpportunityUpdate;
        update relatedQuoteUpdate;
        update relatedOrderUpdate;
    }
}