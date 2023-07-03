require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    @account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
    sign_in_as(@user)
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count', 1) do
      post accounts_url, params: { account: { account_type:"saving", balance: 50000 } }
    end
    assert_redirected_to account_url(Account.last)
  end

  test "should show account" do
    get account_url(@account)
    assert_response :success
  end
end
