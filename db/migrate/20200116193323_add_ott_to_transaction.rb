class AddOttToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :ott, :string
  end
end
