class CreateAllowedApps < ActiveRecord::Migration[5.2]
  def change
    create_table :allowed_apps do |t|
      t.belongs_to :user, index: true
      t.belongs_to :app, index: true

      t.string :permissions

      t.timestamps
    end
  end
end
