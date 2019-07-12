json.extract! user, :id, :name, :enabled, :email, :user_key, :encrypted_password, :salt, :created_at, :updated_at
json.url user_url(user, format: :json)
