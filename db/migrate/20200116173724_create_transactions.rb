class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :status
      t.string :response_code
      t.string :description
      t.string :occ
      t.string :authorizationCode
      t.datetime :issuedAt
      t.string :signature
      t.integer :amount
      t.string :transactionDesc
      t.integer :installmentsAmount
      t.integer :installmentsNumber
      t.string :buyOrder
      t.references :ShoppingCart

      t.timestamps
    end
  end
end
