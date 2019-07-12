class CreateRefreshTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.belongs_to :allowed_app, index: true

      t.timestamps
    end
  end
end
