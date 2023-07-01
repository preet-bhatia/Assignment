require 'test_helper'

class AccountTest < ActiveSupport::TestCase

    def setup
        @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        @account = Account.new(account_type:0, balance:100000, customer_id:@user.customer_id)
    end 

    test "account should be valid" do
        assert @account.valid?
    end

    test "account_type should be present" do
        @account.account_type = " "
        assert_not @account.valid?
    end

    test "minimum balance for saving account" do
        @account.balance = 100
        assert_not @account.valid?
    end

    test "minimum balance for current account" do
        @account.balance = 100
        @account.account_type = 1
        assert_not @account.valid?
    end

    test "for each account user must exist" do
        @account1 = Account.new(account_type:0, balance:100000)
        assert_not @account1.valid?
    end
end