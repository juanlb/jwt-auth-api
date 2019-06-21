json.extract! app, :id, :name, :app_key, :permissions, :jwt_secret, :timeout, :created_at, :updated_at
json.url app_url(app, format: :json)
