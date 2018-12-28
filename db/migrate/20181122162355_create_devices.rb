class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :deviceid
      t.string :fcmtoken

      t.timestamps
    end
  end
end
