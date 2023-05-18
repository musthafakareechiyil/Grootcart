class ChartController < ApplicationController
    before_action :authenticate_admin!
  
    def show
        # Define the date range
        start_date = Date.parse('2023-01-01')
        end_date = Date.parse('2023-12-31')
      
        # Fetch the sales data from the database for the defined date range
        monthly_data = Order.select("DATE_TRUNC('month', created_at) AS month, COALESCE(SUM(total_price), 0) AS total_price")
                            .where(created_at: start_date..end_date)
                            .group("DATE_TRUNC('month', created_at)")
                            .order("month")
      
        # Generate an array of all months in the date range
        all_months = (start_date..end_date).map { |date| date.beginning_of_month }
      
        # Fill in the sales values for each month
        chart_data = all_months.map do |month|
          data = monthly_data.find { |record| record.month == month }
          { "country" => month.strftime("%B"), "value" => (data&.total_price || 0).to_f }
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
  