class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.new(order_params)
    @order.address = current_user.addresses.find(params[:order][:address_id])
    @order = current_user.orders.build(order_params)
  
    # Add order items to the order
    @order_items = current_user.get_cart_products_with_qty
    @order_items.each do |product, qty|
      @order.order_items.build(product: product, quantity: qty, price: product.price)
    end
  
    if @order.save
      current_user.remove_all_items_from_cart
      redirect_to order_path(@order)
    else
      flash[:error] = "There was a problem creating your order"
      redirect_to cart_path
    end
  end  
  
  def index
    @orders = current_user.orders
  end
  
  def show
    @order = current_user.orders.find(params[:id])
  end
  
  def edit
    @order = current_user.orders.find(params[:id])
  end
  
  def update
    @order = current_user.orders.find(params[:id])
    
    if @order.update(order_params)
      flash[:success] = "Your order has been updated"
      redirect_to order_path(@order)
    else
      flash[:error] = @order.errors.full_messages.join(", ")
      redirect_to edit_order_path(@order)
    end
  end
  
  def destroy
    @order = current_user.orders.find(params[:id])

    OrderItem.where(order_id: @order.id).destroy_all
    
    if @order.destroy
      flash[:success] = "Your order has been deleted"
      redirect_to orders_path
    else
      flash[:error] = "There was a problem deleting your order"
      redirect_to order_path(@order)
    end
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.order_status = 4
    
    if @order.save
      flash[:success] = "Your order has been cancelled"
    else
      flash[:error] = "There was a problem cancelling your order"
    end
    redirect_to orders_path
  end
  
  
  
  
  def history
    @orders = current_user.orders
  end

  
  
  private
  
  def order_params
    params.require(:order).permit(:address, :payment_method,:order_status)
  end
end
