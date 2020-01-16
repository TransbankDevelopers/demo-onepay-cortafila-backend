class AddExternalUniqueNumberToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :external_unique_number, :string
  end
end
