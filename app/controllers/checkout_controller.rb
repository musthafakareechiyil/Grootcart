class CheckoutController < ApplicationController
    before_action :authenticate_user!

    def checkout
      @addresses = current_user.addresses
      @total_price = current_user.cart_total_price

      if session[:coupon_discount].present?
        @total_price -= session[:coupon_discount].to_f
      end

      @coupon_applied = session[:coupon_code].present? # Check if a coupon is applied

      if current_user.cart_count.zero?
        redirect_to shop_path, notice: "Your cart is empty. Please add items to your cart before proceeding to checkout."
      end
    end
  
    def purchase
      payment_method = params[:payment_method]
      total_price = current_user.cart_total_price

      if session[:coupon_discount].present?
        total_price -= session[:coupon_discount].to_f
      end

      if payment_method == 'cod'
        process_order(current_user.addresses.find(params[:address_id]), payment_method, total_price)
        redirect_to codsuccess_show_path
      else
        redirect_to payments_new_path(amount: total_price)
      end
    end

    def apply_coupon
      coupon = Coupon.find_by(code: params[:coupon_code])
  
      if coupon.nil?
        redirect_to checkout_path, notice: "Invalid coupon code."
        return
      end
  
      if coupon_expired?(coupon) || coupon_minimum_purchase_amount_unmet?(coupon)
        redirect_to checkout_path, notice: "Coupon is not applicable."
        return
      end
  
      apply_coupon_discount(coupon)
  
      redirect_to checkout_path, notice: "Coupon applied successfully."
    end

    def remove_coupon
      session[:coupon_code] = nil
      session[:coupon_discount] = nil
      redirect_to checkout_path, notice: "Coupon removed successfully."
    end  

    private

    def process_order(address, payment_method, total_price)
      order = current_user.orders.create(
        address: address,
        payment_method: payment_method,
        total_price: total_price,
        order_status: 'pending'
      )
  
      current_user.get_cart_products_with_qty.each do |product, qty|
        order_item = order.order_items.create(product: product, quantity: qty)
        order_item.update(price: product.price)
        product.update(stock_quantity: product.stock_quantity - qty.to_i)
      end
  
      current_user.remove_all_items_from_cart

      session[:coupon_code] = nil
      session[:coupon_discount] = nil
    end

    def coupon_expired?(coupon)
      coupon.valid_until.present? && coupon.valid_until < Date.today
    end
  
    def coupon_minimum_purchase_amount_unmet?(coupon)
      current_user.cart_total_price < coupon.minimum_purchase_amount
    end
  
    def apply_coupon_discount(coupon)
      discount_amount = calculate_discount_amount(coupon)
      session[:coupon_code] = coupon.code
      session[:coupon_discount] = discount_amount
    end
  
    def calculate_discount_amount(coupon)
      case coupon.discount_type
      when "percentage"
        (current_user.cart_total_price * coupon.discount_value / 100).round(2)
      when "fixed_amount"
        coupon.discount_value
      end
    end
end
  