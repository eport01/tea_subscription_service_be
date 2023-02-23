<div align="center">
  <h1>Tea Subscription Service API API</h1>
</div>

<br>

# Table of Contents

# Project Overview 

# Setup 

# Tech and Tools 

## Built With

- ![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) **2.7.2**
- ![Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) **5.2.8.1**
- <img src="images/rspec_badge.png" alt="RSpec" height="30"> **3.12.0**
- ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
- <img src="images/postman_badge.png" alt="Postman" height="30">
- ![Heroku](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white)
- <img src="images/CircleCi_logo.png" alt="Circle Ci" height="30">

## Gems Used

- [Pry](https://github.com/pry/pry-rails)
- [Capybara](https://github.com/teamcapybara/capybara)
- [RSpec](https://github.com/rspec/rspec-metagem)
- [Simple-Cov](https://github.com/simplecov-ruby/simplecov)
- [Factory Bot for Rails](https://github.com/thoughtbot/factory_bot_rails)
- [Faker](https://github.com/faker-ruby/faker)
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)


# Schema 

<img src="images/schema.png" alt="db schema" class="center" width="500" height=auto>


# Endpoints
- The exposed endpoints are detailed below and can be run locally

- Local Backend Server: http://localhost:3000

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/24609974-3d26f193-2594-4edd-b4bf-e2772db857c7?action=collection%2Ffork&collection-url=entityId%3D24609974-3d26f193-2594-4edd-b4bf-e2772db857c7%26entityType%3Dcollection%26workspaceId%3Da70ba617-8cde-4bdd-af65-e392a67fcdc0)

<details close>
<summary>Subscribe a Customer to a Tea Subscription</summary>
<br>

Request: <br>
```
POST /api/v1/customers/#{customer.id}/subscriptions 
```

Request Body: 
```json 
{
  "title": "Mint",
  "price": 40,
  "status": "Active",
  "frequency": 10
}

```

JSON Response Example:
```json 
{
    "data": {
        "id": "68",
        "type": "subscription",
        "attributes": {
            "customer_id": 1,
            "title": "Mint",
            "price": 40.0,
            "status": "Active",
            "frequency": 10
        }
    }
}


```
</details>

<details close>
<summary>Cancel a Customer's Tea Subscription</summary>
<br>

Request: <br>
```
GET 
```


JSON Response Example:
```json 



```
</details>

<details close>
<summary>Get all of a customer's subscriptions</summary>
<br>

Request: <br>
```
GET 
```


JSON Response Example:
```json 



```
</details>

# Known Issues and Future Goals 

## Contributors 