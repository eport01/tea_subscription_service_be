class Customer < ApplicationRecord
  has_many :subscriptions
  validates_presence_of :first_name, :last_name, :email, :address

  #to find only active subscriptions: 
  # def active_subscriptions 
  #   subscriptions.where(status: "Active")
  # end

end
