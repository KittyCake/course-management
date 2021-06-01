class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.references :category, foreign_key: true, index: true
      t.decimal :price, precision: 20, scale: 2
      t.integer :currency
      t.boolean :for_sale, default: false, index: true
      t.integer :availability_period
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
