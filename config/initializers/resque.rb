require 'resque/server'

Resque.redis = "redis://localhost:6379"

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "phonebook"
end
