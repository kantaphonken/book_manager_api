module V1
  class Users < Base
    resource :users do
      desc 'Sign up'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
        requires :password_confirmation, type: String, desc: 'Password confirmation'
      end
      post do
        user = User.new(declared(params))
        if user.save
          user.after_database_authentication
          present user, with: Entities::User
        else
          error!(user.errors.full_messages, 422)
        end
      end

      desc 'Sign in'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post :sign_in do
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          user.after_database_authentication
          header 'Authorization', "Bearer #{user.authentication_token}"
          present user, with: Entities::User
        else
          error!('Unauthorized', 401)
        end
      end

      desc 'Sign out'
      delete :sign_out do
        authenticate!
        current_user.after_token_authentication
        status 204 # No Content
      end
    end
  end
end
