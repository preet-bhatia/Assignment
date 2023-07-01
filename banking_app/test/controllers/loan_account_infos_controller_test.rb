require 'test_helper'

class LoanAccountInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    @saving_account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
    sign_in_as(@user)
  end

  test "should get index" do
    get loan_account_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_account_info_url
    assert_response :success
  end

  test "should create loan_account_info" do
    assert_difference('LoanAccountInfo.count', 1) do
      post loan_account_infos_url, params: { loan_account_info: { loan_type: "car", duration: 2, amount: 500000 } }
    end
    assert_redirected_to account_url(LoanAccountInfo.last.account)
  end
end
