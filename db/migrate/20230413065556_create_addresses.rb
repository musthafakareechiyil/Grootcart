class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :email
      t.string :phone_number
      t.string :address_type
      t.string :address
      t.string :state
      t.string :country
      t.string :postal_code

      t.timestamps
    end
  end
end
