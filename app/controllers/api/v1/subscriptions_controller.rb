class Api::V1::SubscriptionsController < ApplicationController 

  def index 
    if params[:customer_id]
      render json: SubscriptionSerializer.new(Customer.find(params[:customer_id]).subscriptions)
    end
  end
  def create 
    render json: SubscriptionSerializer.new(Subscription.create!(subscription_params)), status: 201 
  end

  def update 
    # require 'pry'; binding.pry
    #first find customer 
    customer = Customer.find(params[:customer_id])
    # require 'pry'; binding.pry
    if customer.subscriptions.exists?(params[:id]) 
      render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
    else
      render json: {error: "unable to cancel subscription"}, status: 404 
    end 


    # if params[:subscription][:status] == "Active"
    #   if Subscription.exists?(params[:id]) && Customer.exists?(params[:customer_id]) && Subscription.update(params[:id], subscription_params ).save
    #     render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
    #   else
    #     render json: {error: "unable to cancel subscription"}, status: 404 
    #   end 
    # else
    #   render json: {error: "subscription already cancelled"}, status: 404
    # end
  end

  private 
  def subscription_params 
    params.permit(:customer_id, :title, :price, :status, :frequency)
  end
end