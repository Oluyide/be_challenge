**Project Setup**

1. cd app
2. Install dependencies with mix deps.get
3. Create and migrate your database with mix ecto.setup
4. Install Node.js dependencies with cd assets && npm install
5. Start Phoenix endpoint with mix phx.server
Now you can visit localhost:4000 from your browser


**Asumption**
I am not sure if it is wrong to assume on this Task,
If Assumptions can be forgiven , I assumed PART_NUMBER  are unique.

**If given More Time, I would like to**

1. Make it a single page app, with a separate BE and separate Front end and also work more on the front end for more appealling view.
2. To check several failure points,(e.g missing column, separator is not a pipe | in a datarow, ), which will lead to writing more test, as test are limited at the moment and the only failure point tested now is invalid file type.
3. Deploy to Heroku and build a CI/CD pipeline
4. Refactor the create function in the page controller like splitting it up to smaller modules
5. creating an acceptance testing using white bread and Hund
6. I may want to know the intervals at which this kind of data arrive and also, if file is been uploaded on a FTP server, and the system can now be automated in a way of checking the FTP server at off peak hours, process and trasform the data.
7. Logging and Application monitoring (using Elixometer).
8 Datavisualization: creating charts for better visulization.







Interview task :)
===============================

If something is not clear or you need help - just ask :smile:. Nobody knows everything!

1. Read the task
2. Create a project
3. Please implement the project according to your own best standards, possibly
   - Tests, tdd
   - Code guidelines
   - Structure / architecture
   - Refactoring
   - Conventions
4. For the layout bootstrap or plain design is enough.
5. Make sure to commit frequently and feel free to stop working on it after 2-4 hours
6. Provide an overview which points you would improve if you had more time to work on the project

N.B.: Please do not make the repo publicly accessible. Send an archive of your repo to us instead.

Scenario - Product Import via File Upload
---------------------------

Story: A new kloeckner US branch needs to be onboarded, for this we got a new feature request from our product owner.

The user should be able to upload a csv to import products into the database. This data should then be shown in a list.

The upload should work multiple times and always update the corresponding products.
Bonus Feature: Products that are not in the CSV get deleted (can be enabled via checkbox)

Lines in the CSV represent steel products.

An example CSV is in the repo.
Here is some help to understand the CSV structure:

PART_NUMBER = identifier for a product
BRANCH_ID = which kloeckner branch produces the product (TUC = tucson, CIN = cincinnati)
PART_PRICE = price in USD
SHORT_DESC = short description text about the product

Have fun!
