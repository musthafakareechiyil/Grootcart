class AddRefundConfirmedToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :refund_amount, :decimal, precision: 10, scale: 2
    add_column :orders, :refund_confirmed, :boolean
  end
end
