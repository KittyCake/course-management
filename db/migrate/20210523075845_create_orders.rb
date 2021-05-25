class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true
      t.decimal :price, precision: 20, scale: 2
      t.datetime :expiration_date
      t.string :credit_card_number
      t.integer :credit_card_valid_thru_y
      t.integer :credit_card_valid_thru_m
      t.integer :credit_card_verification

      t.timestamps
    end
  end
end
