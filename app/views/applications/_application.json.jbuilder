json.extract! application, :id, :name, :app_key, :permissions, :jwt_secret, :tiemout, :created_at, :updated_at
json.url application_url(application, format: :json)
