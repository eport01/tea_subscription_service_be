class Api::V1::SubscriptionsController < ApplicationController 

  def index 
    if params[:customer_id]
      render json: SubscriptionSerializer.new(Customer.find(params[:customer_id]).subscriptions)
    end
  end
  def create 
    render json: SubscriptionSerializer.new(Subscription.create!(subscription_params)), status: 201 
  end

  private 
  def subscription_params 
    params.permit(:customer_id, :title, :price, :status, :frequency)
  end
end