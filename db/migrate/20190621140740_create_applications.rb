class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :app_key
      t.string :permissions
      t.string :jwt_secret
      t.integer :tiemout

      t.timestamps
    end
  end
end
