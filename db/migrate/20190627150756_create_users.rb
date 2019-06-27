class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :enabled, default: true
      t.string :email
      t.string :user_key
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end
end
