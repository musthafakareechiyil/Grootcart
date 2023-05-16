class PaymentsController < ApplicationController
  def new
    @amount = params[:amount].to_i || @total_price
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
    razorpay_client = Razorpay::Client.new

    params[:razorpay_payment_id] # Razorpay payment ID
    params[:razorpay_order_id]   # Razorpay order ID
    params[:razorpay_signature]  # Signature received from Razorpay

    # Verify the payment signature
    razorpay_client.utility.verify_payment_signature(
      order_id: params[:razorpay_order_id],
      payment_id: params[:razorpay_payment_id],
      signature: params[:razorpay_signature]
    )

    # Handle payment success or failure
    if params[:razorpay_payment_id].present?
      # Payment success
      flash[:success] = 'Payment successful!'
    else
      # Payment failure
      flash[:error] = 'Payment failed!'
    end

    redirect_to root_path
  end
end
