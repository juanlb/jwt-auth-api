class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :app_key
      t.string :permissions, default: {}.to_yaml
      t.text :jwt_rsa_private_key
      t.text :jwt_rsa_public_key
      t.integer :timeout

      t.timestamps
    end
  end
end
