class AddSourceToDevice < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :source, :integer
  end
end
