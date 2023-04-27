class CheckoutController < ApplicationController
    before_action :authenticate_user!

    def checkout
      @addresses = current_user.addresses
    end
  
    def purchase
      address = current_user.addresses.find(params[:address_id])
      payment_method = params[:payment_method]

      total_price = current_user.cart_total_price
    
      order = current_user.orders.create(address: address, payment_method: payment_method,total_price: total_price, order_status: 'pending')
      current_user.get_cart_products_with_qty.each do |product, qty|
        order_item = order.order_items.create(product: product, quantity: qty)
        order_item.update(price: product.price) # set the price of the order item to the price of the product
      end
      current_user.remove_all_items_from_cart
    
      redirect_to order_path(order)
    end
    
  end
  