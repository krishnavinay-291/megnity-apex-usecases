@isTest
public without sharing class DataFactory {

    public static User createUser1() {

        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'System Administrator'
        ];

        User usr1 = new User(
            Alias = 'admin1', 
            Email='adminuser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='someUniqueUserName@testorg.com'
        );

        return usr1;
    }
    public static User createUser2() {

        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'System Administrator'
        ];

        User usr1 = new User(
            Alias = 'admin2', 
            Email='adminuser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='someUniqueUserName2@testorg.com'
        );

        return usr1;
    }
}