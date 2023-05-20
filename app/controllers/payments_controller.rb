class PaymentsController < ApplicationController

  def new
    @amount = params[:amount].to_i || @total_price
    @amount = @amount * 100
    if current_user.cart_count.zero?
      redirect_to shop_path, notice: "Your cart is empty. Please add items to your cart before proceeding to checkout."
    end
  end

  def create
    if current_user.cart_count.zero?
      redirect_to shop_path, notice: "Your cart is empty. Please add items to your cart before proceeding to checkout."
    end
    amount = params[:amount].to_i

    razorpay_client = Razorpay::Client.new
    payment = razorpay_client.payment.create(
      amount: amount,
      currency: 'INR',
      receipt: 'order_receipt'
    )

    redirect_to payment[:short_url]
  end

  def callback
    razorpay_payment_id = params[:razorpay_payment_id]
    razorpay_order_id = params[:razorpay_order_id]
    razorpay_signature = params[:razorpay_signature]
    
    # Verify the signature
    razorpay_client = Razorpay::Client.new
    signature_valid = razorpay_client.utility.verify_payment_signature(
      razorpay_payment_id: razorpay_payment_id,
      razorpay_order_id: razorpay_order_id,
      razorpay_signature: razorpay_signature
    )
    
  end

  def success

    total_price = current_user.cart_total_price
    process_order(current_user, 'razorpay',total_price)

    
    # Handle successful payment logic
    # For example, you can render a success page or redirect to a relevant URL
  end

  private

  def process_order(address, payment_method, payment_id)
    if current_user.cart_count.zero?
      redirect_to shop_path, notice: "Your cart is empty. Please add items to your cart before proceeding to checkout."
    end
    total_price = current_user.cart_total_price
    order = current_user.orders.create(
      address: address,
      payment_method: payment_method,
      total_price: total_price,
      order_status: 'pending',
    )

    current_user.get_cart_products_with_qty.each do |product, qty|
      order_item = order.order_items.create(product: product, quantity: qty)
      order_item.update(price: product.price)
      product.update(stock_quantity: product.stock_quantity - qty.to_i)
    end

    current_user.remove_all_items_from_cart
  end
end
