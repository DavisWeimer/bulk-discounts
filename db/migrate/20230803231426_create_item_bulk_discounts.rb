class CreateItemBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :item_bulk_discounts do |t|
      t.references :item, null: false, foreign_key: true
      t.references :bulk_discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end
