class ChartController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    # Define the date range
    start_date = Date.parse('2023-01-01')
    end_date = Date.parse('2023-12-31')

    # Fetch the sales data from the database for the defined date range
    daily_data = Order.select("DATE_TRUNC('day', created_at) AS date,
                              COALESCE(SUM(CASE WHEN order_status = 6 THEN total_price - refund_amount ELSE total_price END), 0) AS total_sales,
                              COALESCE(SUM(CASE WHEN order_status = 6 THEN total_refunds + total_price ELSE total_refunds END), 0) AS total_refunds")
                      .where(created_at: start_date..end_date)
                      .group("DATE_TRUNC('day', created_at)")
                      .order("date")

    # Generate an array of all days in the date range
    all_days = (start_date..end_date).to_a

    # Fill in the sales values for each day
    chart_data = all_days.map do |day|
      data = daily_data.find { |record| record.date.to_date == day }
      { "country" => day.strftime("%B %d"),
         "value" => (data&.total_sales || 0).to_f,
         "total_refunds" => (data&.total_refunds || 0).to_f }
    end

    @chart_data = chart_data.to_json
  end

  private

  def authenticate_admin!
    unless current_user && current_user.admin?
      flash[:error] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
