# Sinatra API Create, Update and Delete

## Today's Focus

- How to configure Create, Update and Delete routes for our API
- How to safely receive information from the client that will persist to the database
- How to handle form data that will populate more than one table in the database


In our previous lecture, we reviewed how to handle GET operations by building out the following endpoints:

- `get '/dogs'`
- `get '/walks'`
- `get '/walks/recent'`
- `get '/walks/:id'`

For this lecture, we'll be working on building out CRUD functionality for the Walks and DogWalks resources.

We'll be using this [POSTMAN workspace](https://www.postman.com/dakota27/workspace/dogwalkerapplication) to test out our API. You should be able to find it on your local postman client and use it to interact with the API.

We're interested in adding the following functionality to our API:

- We want to be able to CREATE, UPDATE & DELETE dogs via the API
- We want to be able to CREATE, UPDATE & DELETE walks via the API
- We want to be able to CREATE, UPDATE & DELETE dog_walks via the API
