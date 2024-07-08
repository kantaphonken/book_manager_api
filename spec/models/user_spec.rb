# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value("example@email.com").for(:email) } # Valid email
    it { should_not allow_value("invalidemail").for(:email) } # Invalid email
  end

  describe 'password validation' do
    let(:user) { build(:user) }  # use build to create a user without saving it

    it 'is invalid without a password' do
      user.password = nil
      user.password_confirmation = nil
      expect(user).not_to be_valid
    end

    it 'is invalid without a password confirmation' do
      user.password_confirmation = "12212"
      expect(user).not_to be_valid
    end

    it 'is invalid with a password shorter than 6 characters' do
      user.password = 'short'
      user.password_confirmation = 'short'
      expect(user).not_to be_valid
    end
  end

  describe '#after_database_authentication' do
    let(:user) { create(:user, authentication_token: nil) } # Create user without token initially

    it 'generates and updates the authentication token' do
      user.after_database_authentication
      expect(user.authentication_token).to be_present
    end
  end

  describe '#after_token_authentication' do
    let(:user) { create(:user) }

    it 'clears the authentication token' do
      user.after_token_authentication
      expect(user.authentication_token).to be_nil
    end
  end

  describe '#generate_authentication_token' do
    let(:user) { create(:user) }

    it 'generates a unique authentication token' do
      token = user.send(:generate_authentication_token)
      expect(token).to be_a(String)
    end
  end
end
