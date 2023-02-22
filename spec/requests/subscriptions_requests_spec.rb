require 'rails_helper'

describe 'subscription endpoints' do 

  describe 'customer subscriptions' do 
    it 'creates a new tea subscription for a customer' do 
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

end