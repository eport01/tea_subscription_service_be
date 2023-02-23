class Api::V1::SubscriptionsController < ApplicationController 
  before_action :find_customer 
  
  def index 
    if Customer.exists?(params[:customer_id])
      render json: SubscriptionSerializer.new(@customer.active_subscriptions)
    else  
      render json: {error: "customer doesnt exist"}, status: 404 
    end
  end
  def create 
    render json: SubscriptionSerializer.new(@customer.subscriptions.create(subscription_params)), status: 201 
  end

  def update 
    if @customer.subscriptions.exists?(params[:id]) && @customer.subscriptions.find(params[:id]).update(update_params) 
      subscription = @customer.subscriptions.find(params[:id])
      render json: {message: "Subscription status is now: #{subscription.status}"}, status: 200  
    else
      render json: {error: "unable to cancel subscription"}, status: 404 
    end 
  end

  private 

  def find_customer
    if Customer.exists?(params[:customer_id])
      @customer = Customer.find(params[:customer_id])
    else 
      @customer = nil 
    end 
  end

  def subscription_params 
    params.permit(:customer_id, :title, :price, :status, :frequency)
  end

  def update_params 
    params.permit(:status)
  end
end