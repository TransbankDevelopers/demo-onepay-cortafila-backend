class CreateShoppingCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_carts do |t|
      t.string :occ
      t.string :ott
      t.string :external_unique_number
      t.integer :issued_at
      t.integer :amount
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
