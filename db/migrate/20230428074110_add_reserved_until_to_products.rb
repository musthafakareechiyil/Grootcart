class AddReservedUntilToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :reserved_until, :datetime
  end
end
