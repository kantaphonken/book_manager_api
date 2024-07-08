desc "Clean up expired authentication tokens"
task :expired_token_cleanup => :environment do
  User.where("token_expires_at < ?", Time.now).update_all(authentication_token: nil, token_expires_at: nil)
end
