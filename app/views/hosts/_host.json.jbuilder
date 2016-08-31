json.extract! host, :id, :hostname, :connect, :username, :password, :enable_password, :created_at, :updated_at
json.url host_url(host, format: :json)