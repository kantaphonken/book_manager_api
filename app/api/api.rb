require 'grape'

class API < Grape::API
  prefix 'api'
  format :json

  mount ::V1::Base  # Mount the V1 API version
end
