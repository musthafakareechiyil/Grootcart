class PaymentsController < ApplicationController
  def new
    @amount = params[:amount].to_i || @total_price
    @amount = @amount * 100
  end

  def create
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
    # Handle successful payment logic
    # For example, you can render a success page or redirect to a relevant URL
    render 'success'
  end
end
