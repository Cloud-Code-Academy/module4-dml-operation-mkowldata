/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author May Keam
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myAccount0 = new Account();
        // Set some fields on the Account
        myAccount0.Name = 'BumbleBee2';
        myAccount0.Phone = '123-556-7890';
        myAccount0.AccountNumber = 'B924887650';
        // Insert the Account into the database
        database.insert(myAccount0, accessLevel.USER_MODE);
        // Return the Id of the newly created Account
        return myAccount0.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account myAccount2 = new Account(Name = name, Industry = industry);
        // Insert the Account
        Database.insert(myAccount2, accessLevel.USER_MODE);
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact contact1 = new Contact();
        // Set some fields on the Contact
        contact1.LastName = 'Doe';
        contact1.FirstName = 'John';
        // Set the AccountId field to the given accountId
        contact1.AccountId = accountId;
        // Insert the Contact into the database
        Database.insert(contact1, accessLevel.USER_MODE);
        // Return the Id of the newly created Contact
        return contact1.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact updateContact = [SELECT Id
                                 FROM Contact 
                                 WHERE Id = :contactId WITH SECURITY_ENFORCED];
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        // Update the Contact's last name
        updateContact.LastName = newLastName;
        // Update the Contact in the database
        Database.update(updateContact, accessLevel.USER_MODE);
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity updateOpportunityStage = [SELECT Id 
                                              FROM Opportunity 
                                              WHERE Id = :oppID WITH SECURITY_ENFORCED];
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        // Update the Opportunity's stage
        updateOpportunityStage.StageName = newStage;
        // Update the Opportunity in the database
        Database.update(updateOpportunityStage, accessLevel.USER_MODE);
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account updateAccount = [SELECT Id 
                                 FROM Account 
                                 WHERE Id = :accountId WITH SECURITY_ENFORCED];
        // [SELECT Id FROM Account WHERE Id = :accountId]
        // Update the Account with the given Id with the new name and industry
        updateAccount.Name = newName;
        updateAccount.Industry = newIndustry;
        Database.update(updateAccount, accessLevel.USER_MODE);
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        List<Opportunity> oppList = new List <Opportunity>(opportunities);
        for( Opportunity opp : oppList ){
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000.00;
        }
        Database.upsert(oppList, accessLevel.USER_MODE);
        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        // Upsert the opportunities List so that records are either updated or created
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Account acct;               
        //query account to see if it exists
        List <Account> listOfAccounts = [SELECT Id, Name
                                         FROM Account
                                         WHERE Name = :accountName WITH SECURITY_ENFORCED];
        //if account doesn't exist - create the account
        if( !listOfAccounts.isEmpty()){
            acct = listOfAccounts[0];
        }
        else {
            acct = new Account(Name = accountName);
            Database.insert(acct, accessLevel.USER_MODE);
        }
        //Map opp name to opportunities so that you can put the accountid in the new opportunity
        Map <String, Opportunity> currentOpps = new Map <String, Opportunity>();
            for(Opportunity opp : [SELECT Id, Name 
                                   FROM Opportunity 
                                   WHERE Name IN :oppNames AND AccountId = :acct.Id WITH SECURITY_ENFORCED]){
                currentOpps.put(opp.Name, opp);
            }        
        //create a list to put new opportunities in
        List <Opportunity> listOfOpps = new List <Opportunity>(); 
        for( String oppName : oppNames ) {
            if( currentOpps.containsKey(oppName)){
                listOfOpps.add(currentOpps.get(oppName));
                }
                else {
                    Opportunity newOpp = new Opportunity(
                    Name = oppName,
                    AccountId = acct.Id,
                    StageName = 'Closed Won',
                    CloseDate = Date.today()
                    );
                    listOfOpps.add(newOpp);
                }
            }
            Database.upsert(listOfOpps, accessLevel.USER_MODE);
        }        
            // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
        
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName){
		// Query for the Account
        Account newAcct;
		List<Account> accounts = [SELECT Id, Name, Description 
                                  FROM Account 
                                  WHERE Name = :accountName WITH SECURITY_ENFORCED];
        if( !accounts.isEmpty()){
            newAcct = accounts[0];
        }
        else {
            newAcct = new Account(Name = accountName, Description = 'New Account');
            database.insert(newAcct, accessLevel.USER_MODE);
        }
        for( Account acct : accounts ){
            if( acct.Name == accountName){
                acct.Description = 'Updated Account';
            }
            else {
                newAcct = new Account(
                    Name = accountName,
                    Description = 'New Account'
                );
            }
        }
        database.upsert(newAcct, accessLevel.USER_MODE);
		// if the Account exists, update the description
        // otherwise, create a new Account and set the description
		// Upsert the Account
		return newAcct;
    }

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts 
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
       
        //create list, Map and Set to hold data to store the accounts that need to be upserted to database
        List <Account> accountsToUpsert = new List<Account>();
        // Loop through each Contact to compile a Set collection of unique lastnames(of data type string) from the list of contactsToUpsert 
        Set <String> lastNames = new Set <String>();
        for( Contact cont : contactsToUpsert ){
            if(cont.LastName != null){
                lastNames.add(cont.LastName);
            }
        }
        // Get a list of existing Accounts where the Contact LastNames in the Set of last names = Account Name
        List <Account> existingAccts = [SELECT Id, Name
                                        FROM Account
                                        WHERE Name IN :lastNames WITH SECURITY_ENFORCED];
        // For each account in this list of accounts, add the account to a Map collection for lookup
        Map <String, Account> lastNameToAccountMap = new Map <String, Account>();
        for ( Account acct : existingAccts ){
            lastNameToAccountMap.put(acct.Name, acct);
        }
		// Extract the Contact's LastName for the Account Name
        for( Contact cont : contactsToUpsert ){
            String lastName = cont.LastName;
            if(lastName == null){
                continue;
            }
            // If account is not in the Map collection, create a new account and add it to the database and add it to the Map collection 
            if(!lastNameToAccountMap.containsKey(lastName)){
                Account newAcct = new Account(Name = lastName);
                accountsToUpsert.add(newAcct);
                lastNameToAccountMap.put(lastName, newAcct);
            }
            // // Get the account based on the name and Link the Contact to its Account using the Account Id
            cont.AccountId = lastNameToAccountMap.get(lastName).Id;
        }
        // Upsert the Contacts
        Database.upsert(accountsToUpsert, accessLevel.USER_MODE);
    }
    
    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List <Lead> leadsToProcess = new List <Lead>();
        // Loop through each Lead name
        for (String lead : leadNames ){
            Lead newLead = new Lead (
                LastName = lead, 
                Company = 'Lead Company', 
                Status = 'Open - Not Contacted'
                );
            leadsToProcess.add(newLead);
        }
        // Insert the Leads
        Database.insert(leadsToProcess, accessLevel.USER_MODE);

        // Delete the Leads
        Database.delete(leadsToProcess, accessLevel.USER_MODE);
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List <Case> casesToProcess = new List <Case>();
        // Insert the cases
        for( Integer i = 0; i < numOfCases; i++ ){
            Case newCase = new Case (
                AccountId = accountId,
                Status = 'New',
                Origin = 'Web'
                );
            casesToProcess.add(newCase);
        }
        Database.insert(casesToProcess, accessLevel.USER_MODE);
        // Delete the cases
        Database.delete(casesToProcess, accessLevel.USER_MODE);
    }
}