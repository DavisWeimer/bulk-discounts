class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :discount_percentage, precision: 5, scale: 2
      t.integer :minimum_quantity

      t.timestamps
    end
  end
end
