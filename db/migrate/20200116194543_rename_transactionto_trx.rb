class RenameTransactiontoTrx < ActiveRecord::Migration[5.2]
  def change
    rename_table :transactions, :buy_transactions
  end
end
