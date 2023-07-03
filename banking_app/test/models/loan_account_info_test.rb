require 'test_helper'

class LoanAccountInfoTest < ActiveSupport::TestCase

    def setup
        @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        @saving_account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
        @account = Account.create(account_type:2, balance:100000, customer_id:@user.customer_id)
        @loanaccount = LoanAccountInfo.new(loan_type:0, amount:500000, duration:2, account_number:@account.account_number)
    end 

    test "loan account should be valid" do
        assert @loanaccount.valid?
    end

    test "loan_type should be present" do
        @loanaccount.loan_type = " "
        assert_not @loanaccount.valid?
    end

    test "amount should be present" do
        @loanaccount.loan_type = " "
        assert_not @loanaccount.valid?
    end

    test "duration should be present" do
        @loanaccount.duration = " "
        assert_not @loanaccount.valid?
    end

    test "amount should be greater than minimum amount" do
        @loanaccount.amount = 100
        assert_not @loanaccount.valid?
    end

    test "duration should be greater than minimum duration" do
        @loanaccount.duration = 1
        assert_not @loanaccount.valid?
    end
end