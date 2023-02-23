require 'rails_helper'

describe 'subscription endpoints' do 

  describe 'create customer subscriptions' do 
    it 'creates a new tea subscription for a customer, default status to active' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription = {
        title: "Mint",
        price: 40,
        status: "Active",
        frequency: 10
      }
      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'        
      }
      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: JSON.generate(subscription)
      
      new_subscription = Subscription.last 
      expect(response).to be_successful 

      expect(response.status).to eq(201)

      expect(new_subscription.title).to eq("Mint")
      expect(new_subscription.customer_id).to eq(customer.id)
      expect(new_subscription.price).to eq(40.0)
      expect(new_subscription.status).to eq("Active")
      expect(new_subscription.frequency).to eq(10)
      expect(customer.subscriptions.last).to eq(new_subscription)
    end

    it 'cant create a customer subscription for a customer that doesnt exist' do 
      subscription = {
        title: "Mint",
        price: 40,
        status: "Active",
        frequency: 10
      }
      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'        
      }
      post "/api/v1/customers/50/subscriptions", headers: headers, params: JSON.generate(subscription)
      
      parsed_subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status 404
      expect(parsed_subscription[:error]).to eq("unable to subscribe")
    end

    it 'cant create the same subscription for a customer more than once' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)

      subscription = {
        title: "Mint",
        price: 40,
        status: "Active",
        frequency: 10
      }
      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'        
      }
      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: JSON.generate(subscription)
    
      new_subscription = Subscription.last 
      expect(response).to be_successful 

      expect(response.status).to eq(201)

      expect(new_subscription.title).to eq("Mint")

      subscription = {
        title: "Mint",
        price: 40,
        status: "Active",
        frequency: 10
      }
      headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'        
      }
      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: JSON.generate(subscription)
    
      parsed_subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status 404
      expect(parsed_subscription[:error]).to eq("unable to subscribe")
    end


  end

  describe 'get customers active subscriptions' do 
    it 'gets the subscriptions for a customer' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_3 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Cancelled" , frequency: Faker::Number.number(digits: 2))

      get "/api/v1/customers/#{customer.id}/subscriptions"

      expect(response).to be_successful 
      
      parsed_subscriptions = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_subscriptions.count).to eq(2)

      expect(parsed_subscriptions[0][:id].to_i).to eq(subscription_1.id)
      expect(parsed_subscriptions[1][:id].to_i).to eq(subscription_2.id)


      expect(parsed_subscriptions[0][:attributes]).to have_key(:customer_id)
      expect(parsed_subscriptions[0][:attributes][:customer_id]).to eq(customer.id)

      expect(parsed_subscriptions[0][:attributes]).to have_key(:title)
      expect(parsed_subscriptions[0][:attributes][:title]).to eq(subscription_1.title)



      expect(parsed_subscriptions[0][:attributes]).to have_key(:price)
      expect(parsed_subscriptions[0][:attributes][:price]).to eq(subscription_1.price)

      expect(parsed_subscriptions[0][:attributes]).to have_key(:status)
      expect(parsed_subscriptions[0][:attributes][:status]).to eq(subscription_1.status)

      expect(parsed_subscriptions[0][:attributes]).to have_key(:frequency)
      expect(parsed_subscriptions[0][:attributes][:frequency]).to eq(subscription_1.frequency)


    end

    it 'sad path, cant get subscriptions for customer, customer doesnt exist' do 
      get "/api/v1/customers/50/subscriptions"

      parsed_subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status 404
      expect(parsed_subscription[:error]).to eq("customer doesnt exist")
    end

  end

  describe 'cancel subscription endpoint' do 
    it 'changes a customers subscription status to cancelelled' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
    
      expect(subscription_1.status).to eq("Active")
      expect(subscription_2.status).to eq("Active")

      cancel_subscription = {
        "status": "Cancelled"
      }

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription_1.id}", headers: {'CONTENT_TYPE' => 'application/json' }, params: JSON.generate(cancel_subscription)

      parsed_subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_subscription[:message]).to eq("Subscription status is now: Cancelled")

      updated_subscription_1 = customer.subscriptions.find(subscription_1.id)
      expect(updated_subscription_1.status).to eq("Cancelled")
      expect(subscription_2.status).to eq("Active")


    end

    it 'cancel subscription sadpath, subscription does not exist or cant be saved' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
    
      customer2 = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_21 = customer2.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_22 = customer2.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
    
      cancel_subscription = {
        "status": "Cancelled"
      }

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription_21.id}", headers: {'CONTENT_TYPE' => 'application/json' }, params: JSON.generate(cancel_subscription)
      
      parsed_subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status 404
      expect(parsed_subscription).to have_key(:error)
      expect(parsed_subscription).to_not have_key(:data)
      expect(parsed_subscription[:error]).to eq("unable to cancel subscription")
    end
  end

  describe 'subscription edge cases' do 
    it 'status can only be Active or Cancelled' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
          
      expect(subscription_1.status).to eq("Active")
      expect(subscription_2.status).to eq("Active")

      cancel_subscription = {
        "status": "chocolate"
      }

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription_1.id}", headers: {'CONTENT_TYPE' => 'application/json' }, params: JSON.generate(cancel_subscription)

      parsed_subscription = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_subscription).to have_key(:error)

      expect(parsed_subscription[:error]).to eq("unable to cancel subscription")

      updated_subscription_1 = customer.subscriptions.find(subscription_1.id)

      expect(updated_subscription_1.status).to eq("Active")
    end

    it 'only status can be updated' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      
      expect(subscription_1.status).to eq("Active")

      cancel_subscription = {
        "status": "Cancelled", 
        "title": "really good chocolate"
      }

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription_1.id}", headers: {'CONTENT_TYPE' => 'application/json' }, params: JSON.generate(cancel_subscription)

      parsed_subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_subscription[:message]).to eq("Subscription status is now: Cancelled")

      updated_subscription_1 = customer.subscriptions.find(subscription_1.id)
      expect(updated_subscription_1.status).to eq("Cancelled")
      expect(updated_subscription_1.title).to_not eq("really good chocolate")
      expect(updated_subscription_1.title).to eq(subscription_1.title)
    end
  end

end