json.extract! app, :id, :name, :app_key, :permissions, :jwt_secret, :tiemout, :created_at, :updated_at
json.url app_url(app, format: :json)
