
class CartsController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  def checkout
    @order = Order.create(user: current_user)
    @cart.items.each do |item|
      OrderItem.create(
        order: @order,
        product: item.product,
        quantity: item.quantity
      )
    end
    @cart.empty!
    redirect_to @order
  end  
  
  def show
    if current_user.cart_total_price == 0
      flash[:notice] = "Your cart is empty!"
      redirect_to shop_path
    else
      @cart_products_with_qty = current_user.get_cart_products_with_qty.reject { |_, qty| qty.to_i.zero? }
      @cart_total = current_user.cart_total_price
    end
  end
  
  
  def add
    product = Product.find(params[:product_id])
    if current_user.add_to_cart(product.id)
      flash[:notice] = "Product added to cart successfully."
    else
      flash[:alert] = "Failed to add product to cart."
    end
    redirect_to shop_path
  end
  
  
  def remove
    current_user.remove_from_cart(params[:product_id])
    redirect_to cart_path
  end
  
  def removeone
    current_user.remove_one_from_cart(params[:product_id])
    redirect_to cart_path
  end
  
end