require 'test_helper'

class CreateTransactionTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
    @account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
    @account1 = Account.create(account_type:1, balance:100000, customer_id:@user.customer_id)
    sign_in_as(@user)
    set_account(@account)
  end

  test "get deposit form and money should be credited in account" do
    get "/credit"
    assert_response :success
    assert_difference('Transaction.count', 1) do
      post credit_path, params: { transaction: { transaction_type: 'deposit', amount: 100} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "#{@account.balance + 100}", response.body
  end

  test "get withdrawl form and money should be debited from account" do
    get "/debit"
    assert_response :success
    assert_difference('Transaction.count', 1) do
      post debit_path, params: { transaction: { transaction_type: 'bank_withdrawal', amount: 100} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "#{@account.balance - 100}", response.body
  end

  test "get withdrawl form and money should not be debited from account if amount is greater than balance" do
    get "/debit"
    assert_response :success
    assert_no_difference'Transaction.count' do
      post debit_path, params: { transaction: { transaction_type: 'bank_withdrawal', amount: @account.balance + 100} }
    end
    assert_match "errors", response.body
  end

  test "get transfer form and money should be debited from account" do
    set_account(@account1)
    get "/transfer"
    assert_response :success
    assert_difference('Transaction.count', 3) do
      post debit_path, params: { transaction: { transaction_type: 'transfer', amount: 100, account_related:@account.account_number} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "successfully debited", response.body
  end

  test "get transfer form and money should not be debited from account if receiver account is invalid" do
    set_account(@account1)
    get "/transfer"
    assert_response :success
    assert_no_difference('Transaction.count') do
      post debit_path, params: { transaction: { transaction_type: 'transfer', amount: 100, account_related:1234} }
    end
    assert_match "unsuccessful", response.body
  end
end
