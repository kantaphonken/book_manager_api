
class Rack::Attack

  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') # Use environment variable or default
  )
  Rack::Attack.throttled_response_retry_after_header = true

  # Throttle all requests by IP (100 requests per minute)
  throttle('req/ip', limit: 100, period: 60.seconds) do |req|
    req.ip
  end

  # Throttle POST, PUT, DELETE requests to /api/books by IP (5 requests per minute)
  throttle('books/crud/ip', limit: 5, period: 60.seconds) do |req|
    if req.path.start_with?('/api/books') && ['POST', 'PUT', 'DELETE'].include?(req.request_method)
      req.ip
    end
  end
end
