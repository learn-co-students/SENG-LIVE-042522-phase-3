---
presentation:
  enableSpeakerNotes: true
  showNotes: false
  width: 1200
  height: 900
---

<style>
  table {
    width: 100%;
    overflow: scroll;
  }
</style>

# Intro to Databases



---

<!-- slide data-separator="^\n\n\n"
         data-separator-vertical="^\n\n" data-separator-notes="^Note:"-->

## Key Concepts for the day:

- The benefit of databases in applications
- Relationship between a database and an API
- Domain modeling
- Mapping columns and rows to classes and instances
- Basic SQL queries
- Primary Keys
- Foreign Keys




<!-- slide -->

## Agenda

- Part 1 
  - Explanation  database benefits 
  and a bit of a preview of where we're going with SQL moving forward
  - See how what we learned in homework can be applied to the Dog Walker CLI app
- Part 2 
  - Hop into Google sheets and start talking about database relationships in the context of different domains
  - practice deciding where to put foreign keys


<!-- slide -->

## Putting things in Context
Over the last few days we've been building out our CLI applications and one of the problems we've had is that the dogs that we create while we run the program only last while the program is running. We need to create them again every time the program runs.

Databases allow us to store our data outside of our code and we can do CRUD and have it persist to the next session.

<!-- slide -->

## ORM Analogy

![ORM Analogy](https://res.cloudinary.com/dnocv6uwb/image/upload/v1651161995/Flatiron%20Slideshow%20images/analogy.drawio.svg)

<!-- slide -->

## Where we're headed

![The Pattern](https://raw.githubusercontent.com/learn-co-students/phase3-lecture-repo-template/04_begin_intro_to_databases/04_intro_to_databases/demo/object-method-sql-query-return.drawio.svg?token=GHSAT0AAAAAABS54V3M5DXF4WXV6T3OUTPUYTJ6M6A)

<!-- slide -->

## The Flow

At the end of the phase, we'll be building out an API that will sit between our React app and our database:

- React App
- Fetch to API
- API interacts with Database
- Sends response back to Browser
- Resolved promise from fetch leads to change in state
- React updates the DOM

<!-- slide -->

## Google Sheets
[Database Examples](https://docs.google.com/spreadsheets/d/1XV8ixdHveb2Z5aOMQknPdsNCNmo3JZvXX4criCrNXAo/edit#gid=0)
| id (primary key) | name (text) | age (text) | breed (text) | image_url (text)                                                                                             | last_walked_at (datetime) | last_fed_at (datetime) |
| :--------------- | :---------- | :--------- | :----------- | :----------------------------------------------------------------------------------------------------------- | :------------------------ | :--------------------- |
| 1                | Lennon Snow | 1 year     | Pomeranian   | https://res.cloudinary.com/dnocv6uwb/image/upload/v1609370267/dakota-and-lennon-square-compressed_hoenfo.jpg |                           |                        |
						
						
What potential problem might we have if we store the dog's age as a string in the database?				
						
<!-- slide -->

<iframe
  src="https://docs.google.com/spreadsheets/d/1XV8ixdHveb2Z5aOMQknPdsNCNmo3JZvXX4criCrNXAo/edit#gid=0"
  class="frame"
  style="width: 800px; height: 900px;"
>
</iframe>

<!-- slide -->

## Dog Walker CLI Part 4

### Key Features we're going to add to our Dog Walker CLI:

- Add persistence
  - A Read (SELECT) operation to retrieve persisted dogs
  - A Create (INSERT INTO) operation to persists dogs
  - An Update (UPDATE) operation to update a persisted dog.

<!-- slide -->

The Following Slides outline the configuration changes necessary to integrate a SQLite database into our application.
  

<!-- slide -->

## DB Config

### Add sqlite3 gem to Gemfile

```bash
bundle add sqlite3
```


<!-- slide -->

## DB Config

### Add a Database called dog_walker.db

From the demo directory in the terminal:

```bash
sqlite3 db/dog_walker.db
```

<!-- slide -->

## DB Config

#### Create the Dogs Table

```sql
CREATE TABLE dogs(
  id INTEGER PRIMARY KEY,
  name TEXT,
  age TEXT,
  breed TEXT,
  favorite_treats TEXT,
  last_fed_at DATETIME,
  last_walked_at DATETIME
);
```

<!-- slide -->

## DB Config

Run the following command to create the dogs table:

```bash
sqlite3 db/dog_walker.db < db/01_create_dogs.sql
```

And insert rows in the table by running the following sql file:

```bash
sqlite3 db/dog_walker.db < db/02_insert_dogs.sql
```


<!-- slide -->

## DB Config

#### Add database configuration to config/environment.rb

Add these lines above the `require_all "lib"`

```rb
DB = SQLite3::Database.new("db/dog_walker.db")
DB.results_as_hash = true
```

<!-- slide -->

## Tasks

- Dog class
  - **refactor your `initialize` method** 
  - **add a `.new_from_row` method** 
  - **refactor the `.all` method** to make a query to the database to retrieve all persisted dogs. Map over those dog rows and invoke `.new_from_row` passing each row in turn.
  


<!-- slide -->

## Tasks

- Dog class (continued)
  - **refactor the `#save` method** to check if there is an `id` for the object being saved before doing any SQL.
    - if there is an id, do an UPDATE on the database
    - if there isn't an id, do an INSERT on the database

<!-- slide -->

## Tasks

- In CLI
  - no need to change anything for now
  - Boot it up and try to take a dog on a walk, exit the program, and see if the last walked at time is still there!
<!-- slide -->

### Logistics

- The code for our cli will be written in the file `lib/dog_walker_cli.rb`. 
- Our class methods will be written in `lib/dog.rb` where our `Dog` class is defined.
- Again, we'll start our cli application by running the following command in our terminal:

```bash
bundle exec ./bin/run
```


<!-- slide -->

## Code Review (Initialize)

For the Dog class we need to **refactor our `initialize` method** to use keyword arguments and include default values for id, last_walked_at, and last_fed_at (so they can be reloaded from db later)
```rb
def initialize(id: nil, name:, age:, breed:, favorite_treats:,
last_walked_at: nil, last_fed_at: nil)
  # ...
end
```



<!-- slide -->

## Initializing from DB

We'll need  a **`.new_from_row` method** that:
- takes a row from the database as an argument (a hash with string keys corresponding to the column names) 
- Keyword arguments need to receive a hash with symbol keys, so we'll convert the keys to symbols within new_from_row.
- For this, we can use [transform_keys](https://ruby-doc.org/core-2.7.0/Hash.html#method-i-transform_keys)  

```rb
def self.new_from_row(row)
  row.transform_keys{|k| k.to_sym} # will convert string keys to symbols
end
```


<!-- slide -->

## Snazzy Shortcut

```rb
def self.new_from_row(row)
  row.transform_keys{|k| k.to_sym} # will convert string keys to symbols
end
```

Becomes

```rb
def self.new_from_row(row)
  row.transform_keys(&:to_sym) # will also convert string keys to symbols
end
```

the `&` operator to converts the `:to_sym` symbol (representing the `to_sym` method for converting an object to a symbol) into a [Proc](https://ruby-doc.org/core-2.7.1/Proc.html) which we can pass anywhere a block is expected.

<!-- slide -->
This is a case where using the `&` operator to convert the `:to_sym` symbol (representing the `to_sym` method for converting an object to a symbol) into a [Proc](https://ruby-doc.org/core-2.7.1/Proc.html) so we can pass it to `.transform_keys` or `.map` or any ruby method that expects to receive a block as an argument. The syntax is pretty simple and is seen frequently as a shorthand. Feel free to [read more about how it works](https://www.brianstorti.com/understanding-ruby-idiom-map-with-symbol/) if you're curious.

<!-- slide -->

## Retrieving Dogs from the Database

Let's check out a **refactored version the `.all` method** to make a query to the database to retrieve all persisted dogs. Map over those dog rows and invoke `.new_from_row` passing each row in turn.


<!-- slide -->

## Retrieving Dogs from DB
```rb
@@all = nil

# We want to be able to access the current state of the 
# stored dogs

def self.all
  # We still want to use the @@all class variable so we 
  # only have to query the database for all records the 
  # first time we invoke this method. 
  # The first call to `.all` should trigger the query and 
  # use the results to create and return a collection of 
  # dogs which we'll assign to @@all
  # The next call to the method should return the previously 
  # assigned value of @@all
  @@all ||= DB.execute("SELECT * FROM dogs").map do |row|
    self.new_from_row(row)
  end
end
```


<!-- slide -->
### Saving a Dog instance to the Database
- **refactored `#save` method** to check if there is an `id` for the object being saved before doing any SQL.
  - if there is an id, do an UPDATE on the database
  - if there isn't do an INSERT on the database
<!-- slide -->

### Saving when there is an id

- if there is an id, do an UPDATE on the database to set the *attribute* values for this dog instance as the new *column* values in the database for the row WHERE the id matches the object being saved.

```rb
# use a HEREDOC to compose a multi line query
# https://ruby-doc.org/core-2.7.4/doc/syntax/literals_rdoc.html#label-Here+Documents+-28heredocs-29
query = <<-SQL
  UPDATE dogs
  SET name = ?,
      birthdate = ?,
      breed = ?,
      image_url = ?,
      last_walked_at = ?,
      last_fed_at = ?
  WHERE
      id = ? 
SQL
```
<!-- 
add ? marks to any pieces of the query that may come from user input
these are called bind params and they're used to escape (or sanitize)
anything in this string that has syntactical meaning in SQL like:
(), "", ;, etc. The characters will appear in the QUERY string 
rather than being interpreted as SQL syntax.
https://github.com/sparklemotion/sqlite3-ruby/blob/master/faq/faq.md#how-do-i-use-placeholders-in-an-sql-statement
-->
<!-- slide -->
## Working with Times
```rb
# The database requires times to be formatted in a 
# particular way, so we're using the strftime method 
# (string format time) to convert the ruby time 
# objects for last_walked_at and last_fed_at into a 
# string format that sqlite3 expects
DB.execute(
  query,
  self.name,
  self.birthdate.strftime('%Y-%m-%d %H:%M:%S'),
  self.breed,
  self.image_url,
  self.last_walked_at && self.last_walked_at.strftime('%Y-%m-%d %H:%M:%S'),
  self.last_fed_at && self.last_fed_at.strftime('%Y-%m-%d %H:%M:%S'),
  self.id
)
```
<!-- slide -->
## Saving when there's no ID
if there isn't an id, we do an INSERT on the database to add a row storing all of that object's attributes. After the insert is complete, query the database for the [`last_insert_rowid()`](https://www.w3resource.com/sqlite/core-functions-last_insert_rowid.php) and assign that id as the value for the `@id` of that dog.

```rb
# if the dog hasn't been saved yet, we'll trigger an INSERT
query = <<-SQL
  INSERT INTO dogs 
  (name, birthdate, breed, image_url, last_walked_at, last_fed_at)
  VALUES
  (?, ?, ?, ?, ?, ?)
SQL
```
<!-- slide -->
## Inserting upon save
```rb
DB.execute(
  query,
  self.name,
  self.birthdate.strftime('%Y-%m-%d %H:%M:%S'),
  self.breed,
  self.image_url,
  self.last_walked_at && self.last_walked_at.strftime('%Y-%m-%d %H:%M:%S'),
  self.last_fed_at && self.last_fed_at.strftime('%Y-%m-%d %H:%M:%S')
)
# Since the dog's id will be assigned by the database
# we'll need to tell the dog object about the last assigned id
# we can retrieve that id from the database using the following query
@id = DB.execute("SELECT last_insert_rowid()")[0]["last_insert_rowid()"]
```



This is quite involved, and writing this from scratch would be stretching the scope of lecture, so it's already present within the starter code and we'll be discussing it and interacting with it.

<!-- slide -->
## Let's try it out!
Let's open up our CLI and try to interact with our app

```bash
bundle exec ./bin/run
```

Try walking a Dog and then checking the Database with SQLite explorer to see the updated values
