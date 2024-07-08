require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:json) { JSON.parse(response.body) }
  describe 'POST /api/users/sign_in' do
    context 'when the request is valid' do
      before { post '/api/users/sign_in', params: { email: user.email, password: user.password } , headers: headers }

      it 'returns the user' do
        expect(json['email']).to eq(user.email)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/users/sign_in', params: { email: user.email, password: 'wrong_password' }, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(response.body).to include("Unauthorized")
      end
    end
  end

  # Sign Up (POST /api/users)
  describe 'POST /api/users' do
    let(:valid_attributes) { { email: 'newuser@example.com', password: 'password', password_confirmation: 'password'  } }
    let(:invalid_attributes) { { email: 'invalid_email', password: 'password', password_confirmation: 'password' } }

    context 'when the request is valid' do
      before { post '/api/users', params: valid_attributes, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/users', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Email is invalid/)
      end
    end
  end

  # Sign Out (DELETE /api/users/sign_out)
  describe 'DELETE /api/users/sign_out' do
    before do
      post '/api/users/sign_in', params: { email: user.email, password: user.password } , headers: headers
    end
    context 'when authenticated user signing out' do
        before do
          delete "/api/users/sign_out", headers: { 'Authorization' => response.headers['authorization'] }
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(:no_content)
        end

        it 'clears the authentication token' do
          user.reload
          expect(user.authentication_token).to be_nil
        end
      end
      context 'when unauthenticated user signing out' do
        before { delete "/api/users/sign_out" }

        it 'returns status code 401' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          expect(response.body).to match(/Unauthorized/)
        end
      end
  end
end
