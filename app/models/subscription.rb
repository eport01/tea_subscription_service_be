class Subscription < ApplicationRecord
  has_many :tea_subscriptions
  has_many :teas, through: :tea_subscriptions
  belongs_to :customer
  validates_presence_of :title, :price, :status, :frequency


  
end
