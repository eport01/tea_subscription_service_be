class Tea < ApplicationRecord
  has_many :tea_subscriptions
  has_many :subscriptions, through: :tea_subscriptions

  validates_presence_of :title, :temperature, :brew_time
end
