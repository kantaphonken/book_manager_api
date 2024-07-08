# app/api/v1/base.rb
module V1
  class Base < Grape::API
    helpers do
      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end

      def current_user
        token = env['api.endpoint'].headers['Authorization']&.split(' ')&.last
        User.find_by(authentication_token: token)
      end
    end

    mount ::V1::Books
    mount ::V1::Users
  end
end
