require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

    def setup
        @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        @account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
        @transaction = Transaction.new(amount:100, transaction_type:0, account_number: @account.account_number, current_balance:@account.balance + 100)
    end 

    test "transaction should be valid" do
        assert @transaction.valid?
    end

    test "transaction_type should be present" do
        @transaction.transaction_type = " "
        assert_not @transaction.valid?
    end

    test "amount should be present" do
        @transaction.amount = " "
        assert_not @transaction.valid?
    end

    test "current_balance should be present" do
        @transaction.current_balance = " "
        assert_not @transaction.valid?
    end

    test "for withdrawal amount must be less than balance" do
        @transaction.transaction_type = 1
        @transaction.amount = @account.balance + 100
        assert_not @transaction.valid?
    end

end