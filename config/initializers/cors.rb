Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # You can restrict this in production
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
  end
end
