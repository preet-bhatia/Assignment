require 'test_helper'

class CreateAccountTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    sign_in_as(@user)
  end

  test "get new account form and create account" do
    get "/accounts/new"
    assert_response :success
    assert_difference('Account.count', 1) do
      post accounts_path, params: { account: { account_type:"saving", balance: 50000} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "#{Account.last.account_number}", response.body
  end

  test "get new account form and not able to create account if balance is less than minimum" do
    get "/accounts/new"
    assert_response :success
    assert_no_difference'Account.count' do
      post accounts_path, params: { account: { account_type:"saving", balance: 500} }
    end
    assert_match "errors", response.body
  end
end
