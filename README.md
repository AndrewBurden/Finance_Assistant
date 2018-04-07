<b>Finance Assistant</b>

Created By Andrew Burden & Paul Ervin 12/1/2016



<b>Purpose</b>

Finance is an iOS application that keeps track of the user’s financial transactions.  These transactions are divided into two types: income and expenses.  Each of these transaction types is further divided into categories; income might come from multiple sources, and expenses can be put into preset or custom categories such as food, gas, bills, and so on.  This allows the user to keep track of their cash flow and spending habits so that they are aware of where they might be spending too much money, which will hopefully allow the user to budget themselves more appropriately.

<b>Functionality</b>

The app allows user’s to:

•	View a weekly, biweekly, monthly, or yearly summary of their income, expenses, and account balances, utilizing text and charts.

•	Enter financial transactions, specifying the amount, account, date, vendor (if applicable), and any other relevant notes to be stored in the database.

•	Create and edit custom categories in which to store their transactions in the database.

•	Create multiple accounts within the database to correspond with their real life bank accounts.


<b>User Interface</b>

The main user interface will be controlled by a Tab Bar Controller. The Tab Bar Controller will have four tabs: Home, Transactions, Categories, and Settings.  The Home tab will display a summary of the user's finances over a specified period of time using labels and charts.  The Transactions tab will display the user's previous transactions over the specified time period in a table and will also allow the user to input new transactions using buttons and text fields.  The Categories tab will allow the user to create new categories and edit existing ones for organizing their transactions.  The categories will be listed in a table.  The Settings tab will allow the user to specify minor preferences about the app’s operation.

<b>Uncovered Techniques</b>

The app will use SQLite to persist data concerning the user's transactions, categories, and accounts.  The Summary tab in the Tab Bar Controller will use the Charts API to display summary charts divided into categories.

