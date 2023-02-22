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


  end

  describe 'get customer subscriptions' do 
    it 'gets the subscriptions for a customer' do 
      customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
      subscription_1 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
      subscription_2 = customer.subscriptions.create(title: Faker::Beer.brand, price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))

      get "/api/v1/customers/#{customer.id}/subscriptions"

      expect(response).to be_successful 
      
      parsed_subscriptions = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(customer.subscriptions).to eq([subscription_1, subscription_2])

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
      
      parsed_subscription = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(response). to be_successful
      expect(response.status).to eq(200)

      expect(parsed_subscription[:status]).to eq("Cancelled")
      expect(subscription_2.status).to eq("Active")

    end
  end

end