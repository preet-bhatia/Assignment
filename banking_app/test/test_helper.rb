ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sign_in_as(user)
    post login_path, params: { sessions: { email: user.email, password: "test"} }
  end
  def set_account(account)
    get account_url(account)
  end
end
