require 'test_helper'

class AtmCardTest < ActiveSupport::TestCase

    def setup
        @user = User.create(username:"testing", name:"Test", email:"testing@gmail.com", mobile:"9999988888", dob:"1992-01-31", password:"test")
        @account = Account.create(account_type:0, balance:100000, customer_id:@user.customer_id)
        GenerateAtmCard.call(account_number: @account.account_number)
        @atm_card = @account.atm_card
    end 

    test "card should be valid" do
        assert @atm_card.valid?
    end

    test "card_number name should be present" do
        @atm_card.card_number = " "
        assert_not @atm_card.valid?
    end

    test "cvv should be present" do
        @atm_card.cvv = " "
        assert_not @atm_card.valid?
    end

    test "expiry_date should be present" do
        @atm_card.expiry_date = " "
        assert_not @atm_card.valid?
    end
end