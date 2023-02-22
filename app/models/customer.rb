class Customer < ApplicationRecord
  has_many :subscriptions
  validates_presence_of :first_name, :last_name, :email, :address
end
