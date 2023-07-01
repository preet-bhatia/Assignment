require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    @account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
    sign_in_as(@user)
    set_account(@account)
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get deposit" do
    get credit_url
    assert_response :success
  end

  test "should get withdrawal" do
    get debit_url
    assert_response :success
  end

  test "should get transfer" do
    get transfer_url
    assert_response :success
  end

  test "should create deposit transaction" do
    assert_difference('Transaction.count', 1) do
      post credit_url, params: { transaction: { transaction_type: 'deposit', amount: 100} }
    end
    assert_redirected_to account_url(Transaction.last.account)
  end

  test "should create withdrawal transaction" do
    assert_difference('Transaction.count', 1) do
      post debit_url, params: { transaction: { transaction_type: 'bank_withdrawal', amount: 100} }
    end
    assert_redirected_to account_url(Transaction.last.account)
  end
end
