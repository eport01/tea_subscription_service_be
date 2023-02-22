# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 5.times do 
#   customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
#   tea = Tea.create(title: Faker::Beer.brand , temperature: Faker::Number.number(digits: 3), brew_time: Faker::Number.number(digits: 2))
#   5.times do 
#     subscription = Subscription.create(customer_id: customer.id, tea_id: tea.id, title: Faker::Beer.brand , price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
#   end
# end


5.times do 
  tea = Tea.create(title: Faker::Beer.brand , temperature: Faker::Number.number(digits: 3), brew_time: Faker::Number.number(digits: 2))
  customer = Customer.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, address: Faker::Address.full_address)
  5.times do 
    subscription = customer.subscriptions.create(customer_id: customer.id, title: Faker::Beer.brand , price: Faker::Number.decimal(l_digits: 2, r_digits: 2), status: "Active" , frequency: Faker::Number.number(digits: 2))
    tea.tea_subscriptions.create(tea_id: tea.id, subscription_id: subscription.id)
  end
end
