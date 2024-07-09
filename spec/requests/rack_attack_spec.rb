require 'rails_helper'

RSpec.describe Rack::Attack, type: :request do
  include Rack::Test::Methods

  let(:ip_address) { '127.0.0.1' }
  let(:path) { '/api/books' }

  def app
    Rack::Attack.new(Rails.application)
  end

  describe 'throttling' do
    before(:each) do
      # Clear the Rack::Attack cache before each test
      Rack::Attack.cache.store.clear

      user = create(:user, token_expires_at: 24.hour.from_now, authentication_token: SecureRandom.uuid)
      @headers = {
        'REMOTE_ADDR' => ip_address,
        'Authorization' => "Bearer #{user.authentication_token}"
      }
    end

    it 'throttles all requests by IP' do
      101.times do
        get path, headers: @headers
      end
      expect(last_response.status).to eq(429)
      expect(last_response.headers['Retry-After']).to be_present
    end

    it 'throttles book CRUD requests by IP' do
      6.times do |i|
        post path, { title: "title#{i}", author: "author#{i}", genre: "genre#{i}" }, headers: @headers
      end
      expect(last_response.status).to eq(429)
      expect(last_response.headers['Retry-After']).to be_present
    end

    it 'does not throttle GET requests to /api/books' do
      99.times do
        get path, headers: @headers
      end
      expect(last_response.status).to_not eq(429)
      expect(last_response.headers['Retry-After']).to_not be_present

    end
  end
end
